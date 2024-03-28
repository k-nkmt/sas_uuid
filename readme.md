# SAS単体でUUID(バージョン3,5)を生成する処理

UUIDの仕様からSAS単体でできそうに思ったので作成してみました。
動作はSAS 9.4M6以降になります。

詳細は[example.ipynb](example.ipynb)を確認してください。


## Generate UUID (Version 3,5) in SAS.
This works with SAS 9.4M6 and later versions.

Compatible code in Python with and without the UUID library is available in [example.ipynb](example.ipynb).


## Example 
```sas
%include "uuid.sas" ;

data _null_ ;
  uuid = uuid(5, "DNS","sas.com") ;
  put uuid ;
run ;

/* 28104995-0a79-5524-89ee-7ceeb8e5b2db */
```