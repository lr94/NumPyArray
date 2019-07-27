(* ::Package:: *)

(* MIT License - Copyright (c) 2019 Luca Robbiano *)

BeginPackage["NumPyArray`"]

Unprotect @@ Names["NumPyArray`*"]
ClearAll @@ Names["NumPyArray`*"]

ReadNumPyArray::usage = 
  "ReadNumPyArray[fileName] loads a NumPy array saved in a .npy file. Only \
numeric data types are supported"
ReadNumPyArray::invalidFile = "`1` is not a valid NPY file"
ReadNumPyArray::invalidVersion = "NPY version `1`.`2` not supported"
ReadNumPyArray::invalidDType = "Invalid dtype `1`"
ReadNumPyArray::fortranOrder = "Fortran order is not supported"

Begin["Private`"]

ReadNumPyArray[file_] := Module[{fs, formatVersion, headerLength, retVal},
   fs = OpenRead[file, BinaryFormat -> True];
   If[fs === $Failed, fs,
   
    (* Check magic string *)
    retVal = 
     If[BinaryReadList[fs, "Character8", 6] == 
       Join[{FromCharacterCode[147]}, Characters["NUMPY"]],
      formatVersion = BinaryReadList[fs, "Byte", 2];
      (* Check format version *)
      If[formatVersion == {1, 0},

       (* Read header *) 
       headerLength = 
        BinaryRead[fs, "UnsignedInteger16", ByteOrdering -> -1];
       header = 
        StringJoin[BinaryReadList[fs, "Character8", headerLength]];
       headerDic = ParseDic[header];
       dtype = headerDic[["descr"]];
       fortranOrder = headerDic[["fortran_order"]];
       shape = headerDic[["shape"]];

       (* Fortran order is not supported *)
       If[! fortranOrder,

        (* Endianness *)
        byteOrder = 
         Switch[StringTake[dtype, 1], "<", -1, ">", 1, _, $ByteOrdering];

        (* Data type *)
        pyType = StringTake[dtype, {2, -1}];
        mathematicaDataType = Switch[pyType,
          "b1", "Integer8",
          "B1", "UnsignedInteger8",
          "i1", "Integer8",
          "u1", "UnsignedInteger8",
          "i2", "Integer16",
          "u2", "UnsignedInteger16",
          "i4", "Integer32",
          "u4", "UnsignedInteger32",
          "i8", "Integer64",
          "u8", "UnsignedInteger64",
          "i16", "Integer128",
          "u16", "UnsignedInteger128",
          "f4", "Real32",
          "f8", "Real64",
          (* "f16", "Real128", *)
          "c8", "Complex64",
          "c16", "Complex128",
          (* "c32", "Complex256", *)
           _, Message[ReadNumPyArray::invalidDType, pyType]; "Unknown"
          ];

        (* Read data *)
        If[mathematicaDataType == "Unknown", $Failed,
         data = 
          BinaryReadList[fs, mathematicaDataType, 
           ByteOrdering -> byteOrder];
         ArrayReshape[data, shape]
         ]
        , Message[ReadNumPyArray::fortranOrder]; $Failed]
       , Message[ReadNumPyArray::invalidVersion, formatVersion[[1]], 
        formatVersion[[2]]]; $Failed]
      , Message[ReadNumPyArray::invalidFile, file]; $Failed];
    Close[fs];
    retVal
    ]
   ]

ParseDic[dicString_] := Module[{table},
   table = 
    StringCases[dicString, 
     RegularExpression[
       "('.*?(?<!\\\\)')\\s*:\\s*('.*?(?<!\\\\)'|True|False|\\((?:\\d+\
,?\\s*)*\\)|\\d+)"] -> {"$1", "$2"}];
   table = 
    MapAt[If[StringMatchQ[#, "'" ~~ __ ~~ "'"], 
       StringReplace[StringTake[#, {2, -2}], "\\'" -> "'"], #] &, 
     table, {All, All}];
   table = 
    MapAt[If[# == "True" || # == "False", ToExpression[#], #] &, 
     table, {All, All}];
   table = 
    MapAt[If[StringQ[#] && StringMatchQ[#, "(" ~~ __ ~~ ")"], 
       ToExpression[
        StringReplace[
         StringReplace[#, 
          RegularExpression[",\\s*\\)"] -> ")"], {"(" -> "{", 
          ")" -> "}"}]], #] &, table, {All, All}];
   AssociationThread[table[[All, 1]], table[[All, 2]]]
   ]

End[]
EndPackage[]


(* ::InheritFromParent:: *)
(*"NumPyArray`"*)
