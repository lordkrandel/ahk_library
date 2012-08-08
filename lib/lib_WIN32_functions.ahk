    Win32.functions := {}
    Win32.functions["MessageBoxW"]            := [ "Uint",   "Str",   "Str",   "Uint"  ]
    Win32.functions["GetStdHandle"]           := [ "Int",    "Ptr"                     ]
    Win32.functions["Ws2_32\WSAAsyncSelect"]  := [ "UInt",   "UInt",  "UInt",  "Int"   ]
    Win32.functions["Ws2_32\WSAGetLastError"] := [                                     ]
    Win32.functions["Ws2_32\WSAStartup"]      := [ "Ushort", "Uint"                    ]
    Win32.functions["Ws2_32\WSACleanup"]      := [                                     ]
    Win32.functions["Ws2_32\socket"]          := [ "Int",    "Int",   "Int"            ]
    Win32.functions["Ws2_32\CloseSocket"]     := [ "Uint"                              ]
    Win32.functions["Ws2_32\send"]            := [ "Uint",   "Str",   "UInt",  "UInt"  ]
    Win32.functions["Ws2_32\recv"]            := [ "Uint",   "Uint",  "Int",   "Int"   ]
    Win32.functions["Ws2_32\htons"]           := [ "Uint",   "Uint"                    ]
    Win32.functions["Ws2_32\inet_addr"]       := [ "Str",    "Uint"                    ]
    Win32.functions["Ws2_32\inet_ntoa"]       := [ "Uint"                              ]
    Win32.functions["FormatMessage"]          := [ "Uint",   "Uint",  "UInt",  "UInt", "Uint",  "Uint",  "Uint" ]
    Win32.functions["Ws2_32\connect"]         := [ "Uint",   "Uint",  "Int"            ]


