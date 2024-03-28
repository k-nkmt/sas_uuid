proc fcmp outlib = work.funcs.myfunc ;

  function uuid(version, ns $, name $) $36 ;
/*  
    Generate a UUID(version 3, 5).

    This function is available in SAS 9.4M6 (TS1M6) and later releases. 
    It is based on Python's uuid module. Due to the limitations of bitwise functions in SAS, 
     modify the binary representation directly to set the variant and version.
    
    Parameters:
        version (int): The version of the UUID, either 3 or 5.
        ns (str): The Namespace. Can be 'DNS', 'URL', 'OID', 'X500' or you can specify the namespace directly.
        name (str): The input string used to generate the UUID.
    
    Returns:
        The generated UUID.
    
    Usage:
        uuid(5, "DNS","sas.com")
          28104995-0a79-5524-89ee-7ceeb8e5b2db
        uuid(5, "6ba7b810-9dad-11d1-80b4-00c04fd430c8","sas.com")
          28104995-0a79-5524-89ee-7ceeb8e5b2db
*/

  /* Check Version */
    select(version) ;
      when(5) method = "sha1" ;
      when(3) method = "md5" ;
      otherwise return("Unsupported UUID version.") ;
    end ;
  /* Check Namespace */
    select(upcase(ns)) ;
      when("DNS")  namespace = "6ba7b810-9dad-11d1-80b4-00c04fd430c8" ;
      when("URL")  namespace = "6ba7b811-9dad-11d1-80b4-00c04fd430c8" ;
      when("OID")  namespace = "6ba7b812-9dad-11d1-80b4-00c04fd430c8" ;
      when("X500") namespace = "6ba7b814-9dad-11d1-80b4-00c04fd430c8" ;
      otherwise do ;
        /* Direct input  */
        if prxmatch("/[\da-f]{32}/i", compress(ns, "-")) > 0 then namespace = ns ;
        else return("Unsupported namespace.") ;
      end ;
    end ;
  
    _bytes = cats(input(compress(namespace, "-"), $hex32.), unicodec(name,'utf8')) ;
    _hash = input(hashing(method, trim(_bytes)), $hex32.) ;
    
    bin = put(_hash, $binary128.) ;
    /* Set the variant to RFC 4122. */
    substr(bin, 65, 2) = "10" ;
    /* Set the version number. */
    substr(bin, 49, 4) = put(version, binary4.) ;

    hex = lowcase(put(input(bin, $binary128.), $hex32.)) ;
    uuid = prxchange("s/(.{8})(.{4})(.{4})(.{4})(.{12})/$1-$2-$3-$4-$5/", -1, hex) ;

    return(uuid) ;
  endfunc ;
run ;

options cmplib = work.funcs ;