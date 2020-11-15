function [J0, NCases, TCases, fullcases]=covid_Data()

J0=18;   % period between generations Belgium, russia, netherlands, morocco (J0=14)

pays=3; %netherland=1 / belgium=2 / morocco=3 / russia=4

NCases_morocco=[1	0	0	1	0	0	0	0	1	3	0	2	10	10	9	7	10	9	23	10	19	28	27	55	50	58	69	77	77	61	37	54	83	128	102	99	64	91	99	74	97	116 102 125 136 259 281 121 135 191 163 237 122 190 139 168 55 132 69 102 146 160 174 150 166 189 140 163 199 153 218 137 94 95 45 89 129 82 71 110 78 121 74 27 99 45 24 42 71 66 27  26  33 56 81 68 80 73 78 135 71 29 73 82 101 92 46 66 77 206];% from 2-mars to 19-june

NCases_belgium=[8 27 59 60 31 39 28 47 85 160 130 197 172 185 243 309 462 558 586 342 526 668 1298 1049 1850 1702 1063 876 1189 1384 1422 1661 1260 1123 1380 1209 1580 1684 1351 1629 942 530 2454 1236 1329 1045 1313 1487 973 933 908 1496 1032 809 553 647 525 660 513 485 389 361 242 272 639 591 585 485 368 330 202 307 356 345 291 279 232 192 252 276 299 282 250 113 137 257 212 125];% from 2-mars to 30-mai * 55 days

NCases_italy=[58 78 72 94 147 185 234 239 573 335 466 587 769 778 1247 1492 1797 977 2313 2651 2547 3497 3590 3233 3526 4207 5322 5986 6557 5560 4789 5249 5210 6203 5909 5974 5217 4050 4053 4782 4668 4585 4805 4316 3599 3039 3836 4204 3951 4694 4092 3153 2972 2667 3786 3493 3491 3047 2256 2729 3370 2646 3021 2357 2324 1739 2091 2086 1872];% from 22-feb to 3-mai * 64 days

NCases_russia=[30 21 33 52 54 53 61 71 57 163 182 196 228 270 302 501 440 771 601 582 658 954 1154 1175 1459 1786 1667 2186 2558 2774 3388 3448 4070 4785 6060 4268 5642 5236 4774 5849 5966 6361 6198 6411 5841 7099 7933 9623 10633 10581 10102 10559 11231 10699 10817 11012 11656 10899 10028 9974 10598 9200 9709 8926 9263 8764 8849 8894 9434 8599 8946 8915 8338 8371 8572 8952];% from 16-mars to 30-mai * 64 days

NCases_netherlands=[5 0 8 5 15 44 46 60 77 56 61 121 111 190 155 176 278 292 346 409 534 637 573 545 811 852 1019 1172 1159 1104 884 845 1019 1083 1026 904 1224 952 777 969 1213 1335 1316 1174 964 868 734 1061 1235 1140 1066 750 729 708 887 806 655 655 400 171 386 514 475 445 335 199 317 232 455 319 289 245 161 196 227 270 200 189 125 146 108 198 253 188 176 172 209 133 190 182 176];% from 29-feb to 30-mai * 63 days

NCases_morocco_Index_first=1;% from 2-mars 
NCases_morocco_Index_last=35;% to 15-avril
% (ParamexpCoef_1 =0.9872 ParamexpCoef_2 =0.2918) 23 include no control measures sans confinement
% (ParamexpCoef_1 =0.9868 ParamexpCoef_2 =0.3031) 30 include 2 control measures sans confinement
% 35 include 3 control measures apres confinement
NCases_morocco_Index_Natural_first=1; % to from 2-mars 
NCases_morocco_Index_Natural_last=20; % to 30-mars

NCases_belgium_Index_first=1;% from 5-mars 
NCases_belgium_Index_last=36;% to 25-mars
% ( ParamexpCoef_1 =0.9596 ParamexpCoef_2 =0.3244) 30 restauranr ecoles cafes fermes le 13-mars confinement
% 35 apres confinement
NCases_belgium_Index_Natural_first=1; % to from 5-mars
NCases_belgium_Index_Natural_last=29; % to 2-avril

NCases_italy_Index_first=J0;% from 
NCases_italy_Index_last=43;% to 
NCases_italy_Index_Natural_first=1; % to from  
NCases_italy_Index_Natural_last=29; % to 

NCases_russia_Index_first=1;% from 
NCases_russia_Index_last=28;% to 
NCases_russia_Index_Natural_first=1; % from  
NCases_russia_Index_Natural_last=29; % to 

NCases_netherlands_Index_first=1;% from 
NCases_netherlands_Index_last=35;% to 
NCases_netherlands_Index_Natural_first=1; % from  
NCases_netherlands_Index_Natural_last=29; % to 
% ( 0.9713) 30 restauranr ecoles cafes fermes le 16-mars confinement
% 32 apres confinement

if pays==1
NCases=NCases_netherlands(NCases_netherlands_Index_first:NCases_netherlands_Index_last);fullcases=NCases_netherlands;
elseif pays==2
NCases=NCases_belgium(NCases_belgium_Index_first:NCases_belgium_Index_last);fullcases=NCases_belgium;
elseif pays==3
NCases=NCases_morocco(NCases_morocco_Index_first:NCases_morocco_Index_last);fullcases=NCases_morocco;
elseif pays==4
NCases=NCases_russia(NCases_russia_Index_first:NCases_russia_Index_last);fullcases=NCases_russia;
elseif pays==5
NCases=NCases_italy(NCases_italy_Index_first:NCases_italy_Index_last);fullcases=NCases_italy;
end
NVectSize=size(NCases);days=NVectSize(2);
TCases(1)=NCases(1);
for n  = 2:days
	TCases(n)=TCases(n-1)+NCases(n);
end