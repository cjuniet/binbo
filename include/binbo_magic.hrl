%% Copyright (c) 2019, Sergei Semichev <chessvegas@chessvegas.com>. All Rights Reserved.
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%    http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.

%%%------------------------------------------------------------------------------
%%%   Magic shift
%%%------------------------------------------------------------------------------

-define(MAGIC_BISHOP_SHIFT, {
	58, 59, 59, 59, 59, 59, 59, 58,
	59, 59, 59, 59, 59, 59, 59, 59,
	59, 59, 57, 57, 57, 57, 59, 59,
	59, 59, 57, 55, 55, 57, 59, 59,
	59, 59, 57, 55, 55, 57, 59, 59,
	59, 59, 57, 57, 57, 57, 59, 59,
	59, 59, 59, 59, 59, 59, 59, 59,
	58, 59, 59, 59, 59, 59, 59, 58
}).

-define(MAGIC_ROOK_SHIFT, {
	52, 53, 53, 53, 53, 53, 53, 52,
	53, 54, 54, 54, 54, 54, 54, 53,
	53, 54, 54, 54, 54, 54, 54, 53,
	53, 54, 54, 54, 54, 54, 54, 53,
	53, 54, 54, 54, 54, 54, 54, 53,
	53, 54, 54, 54, 54, 54, 54, 53,
	53, 54, 54, 54, 54, 54, 54, 53,
	52, 53, 53, 53, 53, 53, 53, 52
}).

%%%------------------------------------------------------------------------------
%%%   Magic numbers
%%%------------------------------------------------------------------------------
%%
%% Magic numbers for bishop and rook were copy-pasted from the console output
%% generated by compiled 'find_magics.c' file.
%% It ships with binbo (just in case) and can be found in 'priv' directory.
%%

-define(MAGIC_BISHOP_NUMBER, {
	16#100420000431024,
	16#280800101073404,
	16#42000a00840802,
	16#ca800c0410c2,
	16#81004290941c20,
	16#400200450020250,
	16#444a019204022084,
	16#88610802202109a,
	16#11210a0800086008,
	16#400a08c08802801,
	16#1301a0500111c808,
	16#1280100480180404,
	16#720009020028445,
	16#91880a9000010a01,
	16#31200940150802b2,
	16#5119080c20000602,
	16#242400a002448023,
	16#4819006001200008,
	16#222c10400020090,
	16#302008420409004,
	16#504200070009045,
	16#210071240c02046,
	16#1182219000022611,
	16#400c50000005801,
	16#4004010000113100,
	16#2008121604819400,
	16#c4a4010000290101,
	16#404a000888004802,
	16#8820c004105010,
	16#28280100908300,
	16#4c013189c0320a80,
	16#42008080042080,
	16#90803000c080840,
	16#2180001028220,
	16#1084002a040036,
	16#212009200401,
	16#128110040c84a84,
	16#81488020022802,
	16#8c0014100181,
	16#2222013020082,
	16#a00100002382c03,
	16#1000280001005c02,
	16#84801010000114c,
	16#480410048000084,
	16#21204420080020a,
	16#2020010000424a10,
	16#240041021d500141,
	16#420844000280214,
	16#29084a280042108,
	16#84102a8080a20a49,
	16#104204908010212,
	16#40a20280081860c1,
	16#3044000200121004,
	16#1001008807081122,
	16#50066c000210811,
	16#e3001240f8a106,
	16#940c0204030020d4,
	16#619204000210826a,
	16#2010438002b00a2,
	16#884042004005802,
	16#a90240000006404,
	16#500d082244010008,
	16#28190d00040014e0,
	16#825201600c082444
}).

-define(MAGIC_ROOK_NUMBER, {
	16#2080020500400f0,
	16#28444000400010,
	16#20000a1004100014,
	16#20010c090202006,
	16#8408008200810004,
	16#1746000808002,
	16#2200098000808201,
	16#12c0002080200041,
	16#104000208e480804,
	16#8084014008281008,
	16#4200810910500410,
	16#100014481c20400c,
	16#4014a4040020808,
	16#401002001010a4,
	16#202000500010001,
	16#8112808005810081,
	16#40902108802020,
	16#42002101008101,
	16#459442200810c202,
	16#81001103309808,
	16#8110000080102,
	16#8812806008080404,
	16#104020000800101,
	16#40a1048000028201,
	16#4100ba0000004081,
	16#44803a4003400109,
	16#a010a00000030443,
	16#91021a000100409,
	16#4201e8040880a012,
	16#22a000440201802,
	16#30890a72000204,
	16#10411402a0c482,
	16#40004841102088,
	16#40230000100040,
	16#40100010000a0488,
	16#1410100200050844,
	16#100090808508411,
	16#1410040024001142,
	16#8840018001214002,
	16#410201000098001,
	16#8400802120088848,
	16#2060080000021004,
	16#82101002000d0022,
	16#1001101001008241,
	16#9040411808040102,
	16#600800480009042,
	16#1a020000040205,
	16#4200404040505199,
	16#2020081040080080,
	16#40a3002000544108,
	16#4501100800148402,
	16#81440280100224,
	16#88008000000804,
	16#8084060000002812,
	16#1840201000108312,
	16#5080202000000141,
	16#1042a180880281,
	16#900802900c01040,
	16#8205104104120,
	16#9004220000440a,
	16#8029510200708,
	16#8008440100404241,
	16#2420001111000bd,
	16#4000882304000041
}).