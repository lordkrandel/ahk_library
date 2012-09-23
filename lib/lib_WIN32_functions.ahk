Win32.functions := { "MessageBoxW"            : [ "Uint",   "Str",   "Str",   "Uint"  ]
                   , "GetStdHandle"           : [ "Int",    "Ptr"                     ]
                   , "Ws2_32\WSAAsyncSelect"  : [ "UInt",   "UInt",  "UInt",  "Int"   ]
                   , "Ws2_32\WSAGetLastError" : [                                     ]
                   , "Ws2_32\WSAStartup"      : [ "Ushort", "Uint"                    ]
                   , "Ws2_32\WSACleanup"      : [                                     ]
                   , "Ws2_32\socket"          : [ "Int",    "Int",   "Int"            ]
                   , "Ws2_32\CloseSocket"     : [ "Uint"                              ]
                   , "Ws2_32\send"            : [ "Uint",   "Str",   "UInt",  "UInt"  ]
                   , "Ws2_32\recv"            : [ "Uint",   "Uint",  "Int",   "Int"   ]
                   , "Ws2_32\htons"           : [ "Uint"                              ]
                   , "Ws2_32\inet_addr"       : [ "Str"                               ]
                   , "Ws2_32\inet_ntoa"       : [ "Uint"                              ]
                   , "FormatMessage"          : [ "Uint",   "Uint",  "UInt",  "UInt", "Uint",  "Uint",  "Uint"]
                   , "Ws2_32\connect"         : [ "Uint",   "Uint",  "Int"            ] }


