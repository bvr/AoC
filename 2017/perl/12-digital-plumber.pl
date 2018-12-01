
use 5.16.3;
use Test::More;
use Function::Parameters;
use Data::Dump;

my $example = <<END;
0 <-> 2
1 <-> 1
2 <-> 0, 3, 4
3 <-> 2, 4
4 <-> 2, 3, 6
5 <-> 6
6 <-> 4, 5
END

is_deeply find_reachable(create_graph($example), 0), [0, 2 .. 6], 'Example run';

my $input = do { local $/; <DATA> };
my $graph = create_graph($input);
is scalar @{ find_reachable($graph, 0) }, 306, 'Number of programs with group - part 1';
my %nodes = map { $_ => 1 } @{ $graph->{nodes} };
my $groups = 0;
while(%nodes) {
    my $node = (keys %nodes)[0];
    delete @nodes{ @{ find_reachable($graph, $node) } };
    $groups++;
}
is $groups, 200, "Number of groups found - part 2";

done_testing;

fun create_graph($input) {
    my $g = { nodes => [], edges => {} };
    for my $line (split /\n/, $input) {
        if(my ($fm, $to) = $line =~ /(\d+) <-> ([\d, ]+)/) {
            push @{ $g->{nodes} }, $fm;
            $g->{edges}{$fm} = [ split /, /, $to ];
        }
    }
    return $g;
}

fun find_reachable($graph, $node) {
    my %reachable = ();
    my @process = ($node);
    my %seen = ();
    while(defined (my $n = shift @process)) {
        next if $seen{$n};
        $seen{$n}++;
        my @targets = @{ $graph->{edges}{$n} };
        @reachable{@targets} = ();
        push @process, @targets;
    }
    return [ sort keys %reachable ];
}

=head1 ASSIGNMENT

http://adventofcode.com/2017/day/12

=head2 --- Day 12: Digital Plumber ---

Walking along the memory banks of the stream, you find a small village that is
experiencing a little confusion: some programs can't communicate with each
other.

Programs in this village communicate using a fixed system of pipes. Messages
are passed between programs using these pipes, but most programs aren't
connected to each other directly. Instead, programs pass messages between each
other until the message reaches the intended recipient.

For some reason, though, some of these messages aren't ever reaching their
intended recipient, and the programs suspect that some pipes are missing. They
would like you to investigate.

You walk through the village and record the ID of each program and the IDs with
which it can communicate directly (your puzzle input). Each program has one or
more programs with which it can communicate, and these pipes are bidirectional;
if 8 says it can communicate with 11, then 11 will say it can communicate with
8.

You need to figure out how many programs are in the group that contains program
ID 0.

For example, suppose you go door-to-door like a travelling salesman and record
the following list:

    0 <-> 2
    1 <-> 1
    2 <-> 0, 3, 4
    3 <-> 2, 4
    4 <-> 2, 3, 6
    5 <-> 6
    6 <-> 4, 5

In this example, the following programs are in the group that contains program ID 0:

    Program 0 by definition.
    Program 2, directly connected to program 0.
    Program 3 via program 2.
    Program 4 via program 2.
    Program 5 via programs 6, then 4, then 2.
    Program 6 via programs 4, then 2.

Therefore, a total of 6 programs are in this group; all but program 1, which
has a pipe that connects it to itself.

How many programs are in the group that contains program ID 0?

Your puzzle answer was 306.

--- Part Two ---

There are more programs than just the ones in the group containing program ID
0. The rest of them have no way of reaching that group, and still might have no
way of reaching each other.

A group is a collection of programs that can all communicate via pipes either
directly or indirectly. The programs you identified just a moment ago are all
part of the same group. Now, they would like you to determine the total number
of groups.

In the example above, there were 2 groups: one consisting of programs
0,2,3,4,5,6, and the other consisting solely of program 1.

How many groups are there in total?

Your puzzle answer was 200.

Both parts of this puzzle are complete! They provide two gold stars: **

=cut

__DATA__
0 <-> 950, 1039
1 <-> 317, 904, 923
2 <-> 2
3 <-> 870
4 <-> 361
5 <-> 5
6 <-> 305, 842, 1932
7 <-> 438, 1509
8 <-> 985
9 <-> 425
10 <-> 121, 1532
11 <-> 285, 1242, 1753
12 <-> 632, 762, 829
13 <-> 662, 1429
14 <-> 215, 1155, 1523
15 <-> 43, 238, 1552
16 <-> 1050
17 <-> 275
18 <-> 26, 256
19 <-> 1656
20 <-> 1907
21 <-> 608, 1493, 1587, 1646
22 <-> 1748, 1774
23 <-> 723, 871
24 <-> 244, 624
25 <-> 25
26 <-> 18, 490, 545, 1123, 1958
27 <-> 27
28 <-> 832, 1227
29 <-> 285
30 <-> 223, 1317, 1773
31 <-> 283
32 <-> 921
33 <-> 395, 1772
34 <-> 1170
35 <-> 471, 885, 1119
36 <-> 936, 1831
37 <-> 263, 678, 1356, 1683, 1714
38 <-> 1238
39 <-> 167
40 <-> 804, 1127, 1419
41 <-> 365
42 <-> 1632, 1788
43 <-> 15, 403, 866
44 <-> 497, 503, 1305
45 <-> 130, 881, 1158
46 <-> 46, 744
47 <-> 867, 1391, 1630
48 <-> 48, 1363
49 <-> 1286
50 <-> 1687, 1966
51 <-> 138, 454, 1105
52 <-> 1647
53 <-> 762
54 <-> 54
55 <-> 340, 1913
56 <-> 100, 720
57 <-> 547, 1417, 1501, 1785
58 <-> 138, 402, 1593
59 <-> 1620, 1915
60 <-> 896, 982
61 <-> 61, 1666
62 <-> 1157
63 <-> 1423, 1484
64 <-> 64, 400
65 <-> 1323
66 <-> 1437
67 <-> 1390, 1535
68 <-> 1597
69 <-> 414
70 <-> 173, 527, 743, 1806, 1958
71 <-> 393, 1585, 1680
72 <-> 391, 1863
73 <-> 73, 1571
74 <-> 537, 1861
75 <-> 138, 714
76 <-> 554, 1582
77 <-> 611
78 <-> 1452, 1706, 1804
79 <-> 1618
80 <-> 290, 1925
81 <-> 81, 315
82 <-> 1420, 1865
83 <-> 734, 1794
84 <-> 84, 343, 948
85 <-> 1161
86 <-> 971
87 <-> 270, 1024, 1541, 1688, 1903
88 <-> 931, 1024
89 <-> 378
90 <-> 954, 1519
91 <-> 276
92 <-> 342
93 <-> 615, 1667, 1745
94 <-> 747, 973, 1010
95 <-> 95
96 <-> 1299, 1924
97 <-> 463
98 <-> 1988
99 <-> 1417
100 <-> 56, 1924
101 <-> 148
102 <-> 807, 1177
103 <-> 103
104 <-> 248, 593, 895
105 <-> 113, 1090
106 <-> 410, 1114, 1557
107 <-> 107
108 <-> 1367
109 <-> 416, 705
110 <-> 1296, 1837
111 <-> 311, 1895
112 <-> 112, 668, 1720
113 <-> 105, 629, 1786
114 <-> 1221
115 <-> 151
116 <-> 368, 725, 1889
117 <-> 567, 1502
118 <-> 136, 461, 804
119 <-> 915, 1821
120 <-> 1342, 1826
121 <-> 10
122 <-> 1421, 1532
123 <-> 843, 1837
124 <-> 124
125 <-> 1679
126 <-> 126
127 <-> 1777, 1836
128 <-> 128
129 <-> 968
130 <-> 45, 251, 804, 1078
131 <-> 995
132 <-> 1420, 1498
133 <-> 776, 1300
134 <-> 134, 467
135 <-> 1176
136 <-> 118, 1509
137 <-> 207
138 <-> 51, 58, 75
139 <-> 680, 708, 1717, 1808
140 <-> 445, 1732
141 <-> 441
142 <-> 1280, 1787
143 <-> 216, 468, 1180, 1695
144 <-> 532, 996, 1794
145 <-> 145, 507
146 <-> 146
147 <-> 1871
148 <-> 101, 751, 793, 1601, 1603
149 <-> 1401, 1883
150 <-> 453, 999
151 <-> 115, 205, 496, 535
152 <-> 521, 1037
153 <-> 298, 760, 803, 1664
154 <-> 1888
155 <-> 1524
156 <-> 1138, 1146, 1335
157 <-> 1373, 1771, 1859
158 <-> 1020
159 <-> 1102
160 <-> 1265, 1274, 1660
161 <-> 1602, 1936
162 <-> 162, 171, 1173
163 <-> 293, 500, 960
164 <-> 777, 1147, 1192
165 <-> 1022, 1377
166 <-> 166, 508, 523, 825, 1259
167 <-> 39, 1626
168 <-> 1988
169 <-> 740
170 <-> 170, 571, 696, 859
171 <-> 162
172 <-> 1183
173 <-> 70, 295
174 <-> 517, 573
175 <-> 635
176 <-> 455, 457, 712, 1386, 1639
177 <-> 638, 1102
178 <-> 1802
179 <-> 862, 876, 1633
180 <-> 588
181 <-> 367, 1219
182 <-> 1370
183 <-> 799, 1489
184 <-> 377, 1415, 1642
185 <-> 185
186 <-> 459, 493
187 <-> 1524
188 <-> 367, 686, 930, 1643
189 <-> 1433
190 <-> 1312, 1351, 1723
191 <-> 375
192 <-> 989, 1088, 1096, 1891
193 <-> 193, 1405
194 <-> 1974
195 <-> 439, 1193, 1875
196 <-> 563
197 <-> 1981
198 <-> 1385
199 <-> 471
200 <-> 752, 783, 1346
201 <-> 201, 1023
202 <-> 399, 582
203 <-> 318, 1011
204 <-> 628, 1351, 1606
205 <-> 151
206 <-> 653
207 <-> 137, 328
208 <-> 250
209 <-> 357, 766, 853
210 <-> 810
211 <-> 1047, 1754
212 <-> 601
213 <-> 1660
214 <-> 214, 282, 1166, 1341, 1751
215 <-> 14
216 <-> 143, 1481, 1897
217 <-> 602
218 <-> 1325, 1581
219 <-> 426, 739, 1209
220 <-> 1854
221 <-> 614, 811
222 <-> 542, 963, 1841
223 <-> 30, 1237
224 <-> 335, 1911
225 <-> 1374, 1751
226 <-> 226, 1969
227 <-> 274, 966
228 <-> 230, 1207, 1739
229 <-> 944, 978, 1567
230 <-> 228, 273, 277, 1252
231 <-> 419, 763, 1579
232 <-> 232, 1893
233 <-> 436, 747
234 <-> 1884
235 <-> 980, 1694
236 <-> 236
237 <-> 1468, 1934
238 <-> 15
239 <-> 239, 362
240 <-> 396
241 <-> 1084, 1634
242 <-> 353
243 <-> 769, 1455
244 <-> 24
245 <-> 1528, 1605, 1905
246 <-> 1327
247 <-> 1457, 1550
248 <-> 104
249 <-> 987, 1041, 1949
250 <-> 208, 818
251 <-> 130, 484, 882
252 <-> 619, 1709
253 <-> 616
254 <-> 1092, 1288, 1328
255 <-> 1392
256 <-> 18, 648
257 <-> 360, 581, 1658
258 <-> 660, 905
259 <-> 287, 941, 1141, 1262
260 <-> 919
261 <-> 261, 425, 526, 646
262 <-> 418, 634
263 <-> 37, 964
264 <-> 484, 618
265 <-> 265, 1520
266 <-> 576, 609
267 <-> 762, 1807
268 <-> 515, 1172
269 <-> 458
270 <-> 87, 619, 775, 1157
271 <-> 1214
272 <-> 1175, 1697
273 <-> 230, 1875
274 <-> 227, 274, 1592
275 <-> 17, 615, 827, 1013
276 <-> 91, 313, 328, 1799
277 <-> 230
278 <-> 513, 1449
279 <-> 785, 996, 1375
280 <-> 1889
281 <-> 1501
282 <-> 214
283 <-> 31, 1239
284 <-> 1109, 1730
285 <-> 11, 29
286 <-> 974
287 <-> 259, 1030
288 <-> 288, 808, 1187
289 <-> 956, 1044
290 <-> 80, 1744, 1880
291 <-> 1142, 1376
292 <-> 314, 918, 1025
293 <-> 163, 387, 1845
294 <-> 547
295 <-> 173, 463
296 <-> 296, 1318
297 <-> 1141
298 <-> 153, 622
299 <-> 1225
300 <-> 1032, 1462
301 <-> 1299
302 <-> 391, 724
303 <-> 1301, 1599
304 <-> 304, 937
305 <-> 6, 1442
306 <-> 392, 828, 963
307 <-> 1127, 1618
308 <-> 727, 1620
309 <-> 387
310 <-> 1436, 1696, 1784
311 <-> 111
312 <-> 1156
313 <-> 276, 313, 596
314 <-> 292
315 <-> 81, 1360, 1817
316 <-> 1095
317 <-> 1, 476
318 <-> 203
319 <-> 906, 1008, 1989
320 <-> 1401
321 <-> 646, 1265, 1877
322 <-> 928, 1935
323 <-> 687
324 <-> 324
325 <-> 552, 783, 984
326 <-> 512
327 <-> 761, 1240, 1789
328 <-> 207, 276
329 <-> 1167, 1569
330 <-> 595, 1059
331 <-> 556
332 <-> 943, 1103, 1995
333 <-> 732
334 <-> 365
335 <-> 224, 335, 971, 1838
336 <-> 1052
337 <-> 401
338 <-> 338, 757, 1058
339 <-> 1481
340 <-> 55, 651
341 <-> 341, 637
342 <-> 92, 1116, 1749
343 <-> 84, 1087, 1266
344 <-> 384
345 <-> 1062
346 <-> 1318, 1659
347 <-> 355
348 <-> 753
349 <-> 1602
350 <-> 721
351 <-> 437
352 <-> 1478
353 <-> 242, 513
354 <-> 1476
355 <-> 347, 461, 471, 679
356 <-> 839, 1432
357 <-> 209, 1448
358 <-> 617, 1132, 1904
359 <-> 359, 1016, 1202
360 <-> 257
361 <-> 4, 1333
362 <-> 239, 1766
363 <-> 363
364 <-> 595, 663, 1091, 1174
365 <-> 41, 334, 958, 969, 1066, 1421
366 <-> 919, 1870
367 <-> 181, 188, 367, 1100, 1109, 1594
368 <-> 116, 583, 1206
369 <-> 1759
370 <-> 1928
371 <-> 1806
372 <-> 376
373 <-> 1335
374 <-> 1632
375 <-> 191, 456
376 <-> 372, 1997
377 <-> 184, 978
378 <-> 89, 771, 1831
379 <-> 588, 1941
380 <-> 1148, 1301
381 <-> 477, 1043, 1735, 1831
382 <-> 1222, 1388
383 <-> 568
384 <-> 344, 578
385 <-> 1752
386 <-> 1099, 1225
387 <-> 293, 309
388 <-> 1073, 1203, 1689
389 <-> 1799
390 <-> 606, 1631
391 <-> 72, 302, 751, 1705
392 <-> 306, 429, 1883, 1909
393 <-> 71, 1846
394 <-> 394, 585
395 <-> 33, 395
396 <-> 240, 1316
397 <-> 506, 677, 991, 1938
398 <-> 689, 826, 1435
399 <-> 202
400 <-> 64, 1190
401 <-> 337, 1707
402 <-> 58, 515, 985, 1691
403 <-> 43
404 <-> 509
405 <-> 1343, 1491, 1915
406 <-> 941
407 <-> 450, 534
408 <-> 967, 1816
409 <-> 1687
410 <-> 106, 1304
411 <-> 1351
412 <-> 485, 682
413 <-> 1029, 1873
414 <-> 69, 1998
415 <-> 1559
416 <-> 109, 1757
417 <-> 865, 1461
418 <-> 262, 729
419 <-> 231, 1465
420 <-> 1062, 1574
421 <-> 1177, 1920
422 <-> 533, 1435
423 <-> 540
424 <-> 1060, 1570
425 <-> 9, 261
426 <-> 219, 1424
427 <-> 643
428 <-> 481, 1705, 1942
429 <-> 392, 1324
430 <-> 1653, 1790
431 <-> 1815
432 <-> 782
433 <-> 667, 1355
434 <-> 1163, 1500
435 <-> 725, 1595, 1832, 1965
436 <-> 233
437 <-> 351, 1825
438 <-> 7
439 <-> 195
440 <-> 1686
441 <-> 141, 1900
442 <-> 1525
443 <-> 531
444 <-> 916
445 <-> 140, 715
446 <-> 1164, 1499, 1991
447 <-> 1516
448 <-> 1264, 1889
449 <-> 982
450 <-> 407, 1395
451 <-> 1506
452 <-> 452
453 <-> 150, 479, 1907
454 <-> 51, 1025
455 <-> 176, 1053
456 <-> 375, 681, 1544
457 <-> 176
458 <-> 269, 889, 1869
459 <-> 186, 490, 656, 698, 1261
460 <-> 1696
461 <-> 118, 355
462 <-> 777
463 <-> 97, 295, 1933
464 <-> 1075
465 <-> 1036, 1979
466 <-> 1277
467 <-> 134
468 <-> 143
469 <-> 1636
470 <-> 470, 555, 1068, 1130, 1298, 1748
471 <-> 35, 199, 355
472 <-> 1396
473 <-> 1651
474 <-> 704, 1504
475 <-> 610
476 <-> 317
477 <-> 381, 636
478 <-> 478, 1267, 1384
479 <-> 453
480 <-> 1303, 1797
481 <-> 428
482 <-> 735
483 <-> 1481, 1813
484 <-> 251, 264, 484, 1186
485 <-> 412, 501, 914
486 <-> 641, 647
487 <-> 666
488 <-> 1771
489 <-> 536, 812, 989
490 <-> 26, 459
491 <-> 1188
492 <-> 749
493 <-> 186
494 <-> 494, 1188
495 <-> 1918
496 <-> 151
497 <-> 44, 784, 868
498 <-> 498, 932, 1269, 1675, 1686
499 <-> 946, 1006
500 <-> 163, 1810
501 <-> 485, 1633
502 <-> 1405
503 <-> 44
504 <-> 599, 1604
505 <-> 613, 752
506 <-> 397, 1075, 1936
507 <-> 145
508 <-> 166
509 <-> 404, 758, 1280
510 <-> 864, 1719
511 <-> 886
512 <-> 326, 1433
513 <-> 278, 353
514 <-> 663, 1284, 1685
515 <-> 268, 402
516 <-> 516
517 <-> 174, 1665
518 <-> 1092
519 <-> 1850, 1966
520 <-> 655, 1434, 1501
521 <-> 152, 612, 709, 753
522 <-> 657, 774, 1733
523 <-> 166
524 <-> 1594
525 <-> 1778
526 <-> 261
527 <-> 70
528 <-> 1018, 1955
529 <-> 643
530 <-> 860, 1208
531 <-> 443, 599
532 <-> 144, 869, 1257
533 <-> 422, 738, 1872
534 <-> 407
535 <-> 151, 1467
536 <-> 489, 927
537 <-> 74, 755, 1756
538 <-> 1592
539 <-> 1771
540 <-> 423, 1356
541 <-> 1771
542 <-> 222, 1506
543 <-> 543
544 <-> 1366, 1504
545 <-> 26
546 <-> 546, 1926
547 <-> 57, 294
548 <-> 1031, 1517, 1741
549 <-> 1648, 1978
550 <-> 624, 1901, 1993
551 <-> 1132
552 <-> 325, 1292, 1348
553 <-> 791, 1295
554 <-> 76, 1245
555 <-> 470
556 <-> 331, 820, 1562
557 <-> 727, 1368
558 <-> 1739
559 <-> 1134
560 <-> 1633
561 <-> 577
562 <-> 593, 652
563 <-> 196, 1009
564 <-> 694, 1400, 1641, 1797
565 <-> 675, 1233
566 <-> 945, 1882
567 <-> 117
568 <-> 383, 828, 1614
569 <-> 782
570 <-> 1108
571 <-> 170, 890, 1884
572 <-> 659
573 <-> 174
574 <-> 710, 1906
575 <-> 603, 1015
576 <-> 266, 780, 1051
577 <-> 561, 1287
578 <-> 384, 718, 1138, 1776
579 <-> 1361
580 <-> 1034, 1536
581 <-> 257, 1197
582 <-> 202, 812
583 <-> 368, 782
584 <-> 986, 1677
585 <-> 394
586 <-> 1014, 1555
587 <-> 780, 899, 1591
588 <-> 180, 379, 1462
589 <-> 589
590 <-> 590, 1092
591 <-> 1625, 1748
592 <-> 592, 1834
593 <-> 104, 562, 593
594 <-> 1666
595 <-> 330, 364, 784
596 <-> 313, 1133
597 <-> 1776
598 <-> 1497
599 <-> 504, 531, 613, 1263, 1957
600 <-> 613, 800
601 <-> 212, 1992
602 <-> 217, 1014, 1335
603 <-> 575, 1428, 1914
604 <-> 1693
605 <-> 1375
606 <-> 390, 1745
607 <-> 607
608 <-> 21, 1824
609 <-> 266
610 <-> 475, 610
611 <-> 77, 1073, 1571, 1950
612 <-> 521
613 <-> 505, 599, 600, 746
614 <-> 221, 1182, 1456
615 <-> 93, 275, 683
616 <-> 253, 630, 1458
617 <-> 358
618 <-> 264, 645, 1184
619 <-> 252, 270, 1622
620 <-> 1171, 1725
621 <-> 1148
622 <-> 298, 1474
623 <-> 1486, 1623
624 <-> 24, 550, 1798
625 <-> 776, 1536, 1982
626 <-> 1785
627 <-> 752
628 <-> 204, 847
629 <-> 113, 1731
630 <-> 616, 1861
631 <-> 1566
632 <-> 12
633 <-> 1051, 1792
634 <-> 262, 1111, 1126, 1149
635 <-> 175, 938, 1971
636 <-> 477
637 <-> 341
638 <-> 177, 1704
639 <-> 1100
640 <-> 1527
641 <-> 486, 641
642 <-> 1192
643 <-> 427, 529, 1301
644 <-> 1342
645 <-> 618
646 <-> 261, 321
647 <-> 486
648 <-> 256, 877, 1981
649 <-> 904
650 <-> 1378
651 <-> 340
652 <-> 562, 1984
653 <-> 206, 999
654 <-> 654
655 <-> 520, 1394
656 <-> 459
657 <-> 522, 875
658 <-> 1713, 1917
659 <-> 572, 1241
660 <-> 258, 1396
661 <-> 883
662 <-> 13
663 <-> 364, 514
664 <-> 1168, 1945
665 <-> 1462
666 <-> 487, 696
667 <-> 433
668 <-> 112, 1553
669 <-> 815, 1394, 1522
670 <-> 1372
671 <-> 1929, 1989
672 <-> 945
673 <-> 1760
674 <-> 870, 1409
675 <-> 565, 1805
676 <-> 697, 1036
677 <-> 397, 764
678 <-> 37
679 <-> 355, 1201
680 <-> 139
681 <-> 456, 854
682 <-> 412
683 <-> 615, 1250
684 <-> 1609
685 <-> 1011
686 <-> 188
687 <-> 323, 687
688 <-> 1067, 1692
689 <-> 398, 1079
690 <-> 1485, 1995
691 <-> 691
692 <-> 692
693 <-> 1398, 1925
694 <-> 564
695 <-> 1427
696 <-> 170, 666, 1992
697 <-> 676
698 <-> 459, 749, 1124
699 <-> 1966
700 <-> 1682
701 <-> 1285, 1736
702 <-> 1401
703 <-> 703, 1106
704 <-> 474, 908, 1439
705 <-> 109, 1083
706 <-> 706, 1398
707 <-> 766, 949, 1439
708 <-> 139, 1600, 1654
709 <-> 521, 1742
710 <-> 574
711 <-> 811
712 <-> 176
713 <-> 1512, 1586
714 <-> 75
715 <-> 445, 815, 1231
716 <-> 1659
717 <-> 830, 1738
718 <-> 578
719 <-> 1600
720 <-> 56, 827
721 <-> 350, 1157, 1271, 1716
722 <-> 1225, 1301
723 <-> 23, 723
724 <-> 302, 1333
725 <-> 116, 435, 1651
726 <-> 858
727 <-> 308, 557
728 <-> 1597
729 <-> 418
730 <-> 778, 947, 1162, 1253, 1425
731 <-> 869
732 <-> 333, 1296
733 <-> 1276, 1947
734 <-> 83
735 <-> 482, 1245
736 <-> 1241, 1331, 1820
737 <-> 1816
738 <-> 533
739 <-> 219
740 <-> 169, 964
741 <-> 741
742 <-> 1376
743 <-> 70, 1276
744 <-> 46
745 <-> 851
746 <-> 613, 1094, 1997
747 <-> 94, 233, 1332
748 <-> 748
749 <-> 492, 698
750 <-> 1973
751 <-> 148, 391
752 <-> 200, 505, 627, 1564
753 <-> 348, 521, 769, 1638
754 <-> 771
755 <-> 537
756 <-> 1031
757 <-> 338
758 <-> 509
759 <-> 1010
760 <-> 153, 873, 1313, 1864
761 <-> 327
762 <-> 12, 53, 267, 1869
763 <-> 231, 1606
764 <-> 677, 1117
765 <-> 822, 864, 1040
766 <-> 209, 707, 798, 1649
767 <-> 767, 1445
768 <-> 1723
769 <-> 243, 753
770 <-> 1228
771 <-> 378, 754
772 <-> 917
773 <-> 1565
774 <-> 522
775 <-> 270
776 <-> 133, 625
777 <-> 164, 462, 879, 1890
778 <-> 730
779 <-> 838, 869, 1545
780 <-> 576, 587, 1531
781 <-> 826, 1700
782 <-> 432, 569, 583
783 <-> 200, 325, 1072
784 <-> 497, 595, 1343, 1982
785 <-> 279, 1935
786 <-> 1603
787 <-> 834, 1277, 1534
788 <-> 1478
789 <-> 789, 1871
790 <-> 1342, 1464
791 <-> 553, 1344
792 <-> 1141, 1746, 1757
793 <-> 148
794 <-> 1408, 1867
795 <-> 795, 1693
796 <-> 1819
797 <-> 818, 1960
798 <-> 766, 1428
799 <-> 183
800 <-> 600
801 <-> 1228
802 <-> 1644
803 <-> 153, 806
804 <-> 40, 118, 130, 1025, 1319, 1977
805 <-> 805, 1065
806 <-> 803, 1707
807 <-> 102, 807, 969
808 <-> 288
809 <-> 1734
810 <-> 210, 1758, 1824
811 <-> 221, 711
812 <-> 489, 582
813 <-> 1447, 1626
814 <-> 1103, 1514, 1729, 1900
815 <-> 669, 715
816 <-> 1636
817 <-> 817
818 <-> 250, 797
819 <-> 916, 1471
820 <-> 556
821 <-> 1079, 1521, 1712
822 <-> 765, 1853
823 <-> 823
824 <-> 1533
825 <-> 166, 841, 1290, 1994
826 <-> 398, 781, 1548
827 <-> 275, 720, 827, 1403
828 <-> 306, 568
829 <-> 12, 1998
830 <-> 717, 889, 1047
831 <-> 1227
832 <-> 28, 1427, 1576
833 <-> 1024, 1048, 1974
834 <-> 787
835 <-> 1019
836 <-> 1480, 1589, 1682
837 <-> 1221
838 <-> 779
839 <-> 356, 874
840 <-> 1925
841 <-> 825, 927
842 <-> 6, 1907
843 <-> 123, 1419, 1661, 1678
844 <-> 1310, 1557
845 <-> 887, 1180
846 <-> 846, 1020
847 <-> 628, 933
848 <-> 1949
849 <-> 849
850 <-> 850, 965, 1537
851 <-> 745, 1414, 1541
852 <-> 923, 1821
853 <-> 209
854 <-> 681, 854, 1152
855 <-> 990
856 <-> 1686
857 <-> 1293, 1412, 1983
858 <-> 726, 1796, 1843
859 <-> 170
860 <-> 530
861 <-> 1562
862 <-> 179
863 <-> 1789
864 <-> 510, 765, 922
865 <-> 417, 896, 1362
866 <-> 43
867 <-> 47
868 <-> 497, 1230, 1629
869 <-> 532, 731, 779
870 <-> 3, 674
871 <-> 23, 1543
872 <-> 1976
873 <-> 760
874 <-> 839, 1028
875 <-> 657, 1573
876 <-> 179, 876, 1703
877 <-> 648, 1676
878 <-> 1911
879 <-> 777
880 <-> 1001, 1970
881 <-> 45
882 <-> 251, 883
883 <-> 661, 882
884 <-> 1361
885 <-> 35
886 <-> 511, 1057
887 <-> 845
888 <-> 888
889 <-> 458, 830, 1370
890 <-> 571, 1715
891 <-> 891
892 <-> 1383
893 <-> 1884
894 <-> 1222
895 <-> 104
896 <-> 60, 865, 1575, 1756
897 <-> 1091
898 <-> 1805
899 <-> 587, 1949
900 <-> 903, 1147
901 <-> 901, 1648, 1888
902 <-> 1301, 1433
903 <-> 900
904 <-> 1, 649, 1497
905 <-> 258
906 <-> 319, 1927
907 <-> 1561, 1752
908 <-> 704, 1752
909 <-> 1587
910 <-> 1388, 1393
911 <-> 1713
912 <-> 1877
913 <-> 1813
914 <-> 485, 1081
915 <-> 119
916 <-> 444, 819
917 <-> 772, 1169, 1822
918 <-> 292, 1795
919 <-> 260, 366
920 <-> 1181
921 <-> 32, 1658
922 <-> 864, 1725
923 <-> 1, 852, 1206, 1528
924 <-> 1344, 1531, 1777
925 <-> 973
926 <-> 934, 1535, 1856
927 <-> 536, 841, 1908
928 <-> 322, 1297, 1644
929 <-> 1196, 1650
930 <-> 188
931 <-> 88
932 <-> 498
933 <-> 847, 1064
934 <-> 926, 1488
935 <-> 1918
936 <-> 36, 1577
937 <-> 304
938 <-> 635, 1478, 1505
939 <-> 1279
940 <-> 1283
941 <-> 259, 406, 1458, 1542, 1986
942 <-> 1357
943 <-> 332, 1150, 1513
944 <-> 229, 1727
945 <-> 566, 672
946 <-> 499, 1239, 1301
947 <-> 730
948 <-> 84
949 <-> 707
950 <-> 0, 1856
951 <-> 1010, 1336
952 <-> 1461, 1655
953 <-> 982, 1586
954 <-> 90, 1001
955 <-> 978
956 <-> 289
957 <-> 1655
958 <-> 365
959 <-> 1352, 1423
960 <-> 163
961 <-> 1765, 1824
962 <-> 1878
963 <-> 222, 306
964 <-> 263, 740
965 <-> 850
966 <-> 227
967 <-> 408, 1605
968 <-> 129, 1203
969 <-> 365, 807
970 <-> 970
971 <-> 86, 335
972 <-> 1723
973 <-> 94, 925, 1821
974 <-> 286, 1870
975 <-> 1736
976 <-> 976
977 <-> 1882
978 <-> 229, 377, 955
979 <-> 1096, 1526
980 <-> 235, 980
981 <-> 1950
982 <-> 60, 449, 953
983 <-> 1185
984 <-> 325
985 <-> 8, 402
986 <-> 584, 986, 1160
987 <-> 249, 1471, 1912
988 <-> 1844
989 <-> 192, 489, 1279
990 <-> 855, 990
991 <-> 397, 1961
992 <-> 992, 1921
993 <-> 993
994 <-> 994
995 <-> 131, 995, 1099
996 <-> 144, 279
997 <-> 1829
998 <-> 998
999 <-> 150, 653
1000 <-> 1862
1001 <-> 880, 954, 1809
1002 <-> 1239, 1477
1003 <-> 1206, 1339, 1737
1004 <-> 1876
1005 <-> 1912
1006 <-> 499, 1377
1007 <-> 1839, 1917
1008 <-> 319
1009 <-> 563, 1926
1010 <-> 94, 759, 951, 1656
1011 <-> 203, 685, 1011
1012 <-> 1538, 1894
1013 <-> 275
1014 <-> 586, 602
1015 <-> 575
1016 <-> 359
1017 <-> 1017
1018 <-> 528, 1326, 1329
1019 <-> 835, 1142
1020 <-> 158, 846
1021 <-> 1021
1022 <-> 165, 1371
1023 <-> 201, 1610
1024 <-> 87, 88, 833, 1322
1025 <-> 292, 454, 804, 1200
1026 <-> 1026
1027 <-> 1027, 1198, 1289
1028 <-> 874
1029 <-> 413, 1029, 1885
1030 <-> 287
1031 <-> 548, 756
1032 <-> 300, 1519
1033 <-> 1662
1034 <-> 580, 1038, 1118
1035 <-> 1859
1036 <-> 465, 676, 1212
1037 <-> 152, 1919
1038 <-> 1034, 1490
1039 <-> 0, 1451
1040 <-> 765
1041 <-> 249
1042 <-> 1791
1043 <-> 381
1044 <-> 289, 1702
1045 <-> 1334, 1985
1046 <-> 1115
1047 <-> 211, 830, 1217, 1365
1048 <-> 833
1049 <-> 1049, 1876
1050 <-> 16, 1151
1051 <-> 576, 633, 1404, 1972
1052 <-> 336, 1346, 1515
1053 <-> 455
1054 <-> 1054
1055 <-> 1595
1056 <-> 1237
1057 <-> 886, 1122, 1554
1058 <-> 338
1059 <-> 330
1060 <-> 424, 1554
1061 <-> 1695
1062 <-> 345, 420, 1476
1063 <-> 1063
1064 <-> 933
1065 <-> 805
1066 <-> 365, 1350
1067 <-> 688
1068 <-> 470
1069 <-> 1162
1070 <-> 1197, 1714
1071 <-> 1624
1072 <-> 783
1073 <-> 388, 611
1074 <-> 1251
1075 <-> 464, 506
1076 <-> 1863
1077 <-> 1077
1078 <-> 130
1079 <-> 689, 821, 1189
1080 <-> 1179, 1751
1081 <-> 914
1082 <-> 1917
1083 <-> 705
1084 <-> 241, 1527, 1692
1085 <-> 1910
1086 <-> 1751
1087 <-> 343
1088 <-> 192
1089 <-> 1448
1090 <-> 105
1091 <-> 364, 897
1092 <-> 254, 518, 590, 1470
1093 <-> 1131, 1225
1094 <-> 746
1095 <-> 316, 1095
1096 <-> 192, 979
1097 <-> 1097, 1294
1098 <-> 1098
1099 <-> 386, 995, 1581
1100 <-> 367, 639
1101 <-> 1228
1102 <-> 159, 177, 1205
1103 <-> 332, 814
1104 <-> 1138
1105 <-> 51
1106 <-> 703
1107 <-> 1730
1108 <-> 570, 1614
1109 <-> 284, 367
1110 <-> 1807
1111 <-> 634
1112 <-> 1112, 1213, 1426, 1761
1113 <-> 1425
1114 <-> 106
1115 <-> 1046, 1115
1116 <-> 342
1117 <-> 764
1118 <-> 1034, 1232, 1760
1119 <-> 35, 1990
1120 <-> 1120
1121 <-> 1890
1122 <-> 1057, 1710
1123 <-> 26
1124 <-> 698
1125 <-> 1125
1126 <-> 634, 1387, 1916
1127 <-> 40, 307, 1697
1128 <-> 1854
1129 <-> 1615
1130 <-> 470
1131 <-> 1093
1132 <-> 358, 551, 1212
1133 <-> 596
1134 <-> 559, 1298
1135 <-> 1820
1136 <-> 1136
1137 <-> 1219
1138 <-> 156, 578, 1104, 1912
1139 <-> 1854
1140 <-> 1221, 1591
1141 <-> 259, 297, 792, 1575, 1847
1142 <-> 291, 1019
1143 <-> 1328
1144 <-> 1402, 1823
1145 <-> 1728
1146 <-> 156
1147 <-> 164, 900
1148 <-> 380, 621
1149 <-> 634, 1513
1150 <-> 943, 1818
1151 <-> 1050, 1151
1152 <-> 854, 1437, 1528, 1609, 1764
1153 <-> 1153, 1964
1154 <-> 1419
1155 <-> 14, 1616
1156 <-> 312, 1208
1157 <-> 62, 270, 721, 1968
1158 <-> 45
1159 <-> 1159, 1549, 1747
1160 <-> 986
1161 <-> 85, 1878
1162 <-> 730, 1069, 1600
1163 <-> 434, 1176, 1814, 1900
1164 <-> 446
1165 <-> 1181
1166 <-> 214, 1529
1167 <-> 329
1168 <-> 664
1169 <-> 917, 1208
1170 <-> 34, 1987
1171 <-> 620
1172 <-> 268
1173 <-> 162
1174 <-> 364
1175 <-> 272, 1246
1176 <-> 135, 1163
1177 <-> 102, 421, 1778, 1791
1178 <-> 1804
1179 <-> 1080
1180 <-> 143, 845, 1933
1181 <-> 920, 1165, 1542
1182 <-> 614, 1592
1183 <-> 172, 1455, 1538, 1910, 1996
1184 <-> 618
1185 <-> 983, 1185
1186 <-> 484
1187 <-> 288
1188 <-> 491, 494, 1216, 1711
1189 <-> 1079
1190 <-> 400
1191 <-> 1403
1192 <-> 164, 642
1193 <-> 195, 1195
1194 <-> 1194
1195 <-> 1193
1196 <-> 929, 1691
1197 <-> 581, 1070, 1483
1198 <-> 1027
1199 <-> 1907
1200 <-> 1025
1201 <-> 679
1202 <-> 359
1203 <-> 388, 968
1204 <-> 1265
1205 <-> 1102
1206 <-> 368, 923, 1003
1207 <-> 228, 1802, 1833
1208 <-> 530, 1156, 1169, 1389
1209 <-> 219, 1880
1210 <-> 1210, 1223
1211 <-> 1517, 1569, 1843
1212 <-> 1036, 1132, 1629, 1953
1213 <-> 1112
1214 <-> 271, 1555
1215 <-> 1746
1216 <-> 1188
1217 <-> 1047, 1386
1218 <-> 1330, 1608
1219 <-> 181, 1137
1220 <-> 1673
1221 <-> 114, 837, 1140
1222 <-> 382, 894, 1439
1223 <-> 1210
1224 <-> 1386
1225 <-> 299, 386, 722, 1093
1226 <-> 1226, 1849
1227 <-> 28, 831, 1227
1228 <-> 770, 801, 1101, 1594
1229 <-> 1703
1230 <-> 868, 1397
1231 <-> 715, 1302
1232 <-> 1118
1233 <-> 565
1234 <-> 1918
1235 <-> 1235
1236 <-> 1236
1237 <-> 223, 1056
1238 <-> 38, 1624
1239 <-> 283, 946, 1002, 1999
1240 <-> 327, 1240
1241 <-> 659, 736
1242 <-> 11
1243 <-> 1755
1244 <-> 1435
1245 <-> 554, 735, 1617
1246 <-> 1175, 1899
1247 <-> 1337, 1739, 1954
1248 <-> 1477, 1699
1249 <-> 1249
1250 <-> 683
1251 <-> 1074, 1251, 1641
1252 <-> 230, 1252, 1406
1253 <-> 730, 1579
1254 <-> 1449, 1452, 1896
1255 <-> 1984
1256 <-> 1256
1257 <-> 532
1258 <-> 1706
1259 <-> 166, 1668
1260 <-> 1436
1261 <-> 459
1262 <-> 259
1263 <-> 599
1264 <-> 448
1265 <-> 160, 321, 1204, 1615
1266 <-> 343
1267 <-> 478
1268 <-> 1641
1269 <-> 498
1270 <-> 1584, 1640, 1721
1271 <-> 721
1272 <-> 1333, 1801
1273 <-> 1522
1274 <-> 160, 1282
1275 <-> 1722
1276 <-> 733, 743
1277 <-> 466, 787, 1277
1278 <-> 1301, 1468
1279 <-> 939, 989
1280 <-> 142, 509
1281 <-> 1869, 1987
1282 <-> 1274
1283 <-> 940, 1652
1284 <-> 514, 1459
1285 <-> 701, 1379, 1596
1286 <-> 49, 1286, 1511
1287 <-> 577, 1882
1288 <-> 254
1289 <-> 1027
1290 <-> 825
1291 <-> 1509
1292 <-> 552, 1548
1293 <-> 857
1294 <-> 1097, 1619
1295 <-> 553
1296 <-> 110, 732
1297 <-> 928
1298 <-> 470, 1134, 1462, 1557
1299 <-> 96, 301, 1356
1300 <-> 133
1301 <-> 303, 380, 643, 722, 902, 946, 1278
1302 <-> 1231
1303 <-> 480
1304 <-> 410, 1560
1305 <-> 44, 1682
1306 <-> 1628
1307 <-> 1978
1308 <-> 1308, 1613
1309 <-> 1309, 1736, 1886
1310 <-> 844, 1410, 1976
1311 <-> 1423
1312 <-> 190, 1787
1313 <-> 760
1314 <-> 1862
1315 <-> 1507, 1675
1316 <-> 396, 1789
1317 <-> 30, 1350
1318 <-> 296, 346
1319 <-> 804
1320 <-> 1779
1321 <-> 1533, 1727
1322 <-> 1024
1323 <-> 65, 1619
1324 <-> 429
1325 <-> 218
1326 <-> 1018
1327 <-> 246, 1507
1328 <-> 254, 1143
1329 <-> 1018, 1329, 1495
1330 <-> 1218
1331 <-> 736, 1866
1332 <-> 747
1333 <-> 361, 724, 1272
1334 <-> 1045, 1334, 1546
1335 <-> 156, 373, 602
1336 <-> 951, 1931
1337 <-> 1247
1338 <-> 1743
1339 <-> 1003
1340 <-> 1502, 1883
1341 <-> 214
1342 <-> 120, 644, 790
1343 <-> 405, 784
1344 <-> 791, 924, 1626
1345 <-> 1345, 1547, 1942
1346 <-> 200, 1052
1347 <-> 1926
1348 <-> 552
1349 <-> 1646
1350 <-> 1066, 1317, 1478
1351 <-> 190, 204, 411, 1854
1352 <-> 959
1353 <-> 1780, 1983
1354 <-> 1478
1355 <-> 433, 1575
1356 <-> 37, 540, 1299
1357 <-> 942, 1357
1358 <-> 1358
1359 <-> 1703
1360 <-> 315
1361 <-> 579, 884, 1777
1362 <-> 865
1363 <-> 48
1364 <-> 1413, 1999
1365 <-> 1047, 1410, 1582, 1663
1366 <-> 544
1367 <-> 108, 1899
1368 <-> 557, 1381
1369 <-> 1545
1370 <-> 182, 889
1371 <-> 1022, 1372, 1823
1372 <-> 670, 1371, 1734
1373 <-> 157
1374 <-> 225, 1539
1375 <-> 279, 605, 1750
1376 <-> 291, 742, 1554
1377 <-> 165, 1006
1378 <-> 650, 1913
1379 <-> 1285
1380 <-> 1441, 1527, 1855
1381 <-> 1368
1382 <-> 1613
1383 <-> 892, 1916
1384 <-> 478, 1980
1385 <-> 198, 1775
1386 <-> 176, 1217, 1224, 1961
1387 <-> 1126
1388 <-> 382, 910
1389 <-> 1208, 1389
1390 <-> 67, 1583
1391 <-> 47
1392 <-> 255, 1645
1393 <-> 910
1394 <-> 655, 669
1395 <-> 450, 1419
1396 <-> 472, 660, 1921
1397 <-> 1230
1398 <-> 693, 706
1399 <-> 1482
1400 <-> 564, 1518, 1828
1401 <-> 149, 320, 702, 1401
1402 <-> 1144
1403 <-> 827, 1191, 1948
1404 <-> 1051
1405 <-> 193, 502
1406 <-> 1252, 1903
1407 <-> 1407, 1698, 1913
1408 <-> 794, 1918
1409 <-> 674, 1409
1410 <-> 1310, 1365
1411 <-> 1411
1412 <-> 857, 1682
1413 <-> 1364
1414 <-> 851
1415 <-> 184
1416 <-> 1674
1417 <-> 57, 99, 1486
1418 <-> 1589
1419 <-> 40, 843, 1154, 1395
1420 <-> 82, 132
1421 <-> 122, 365
1422 <-> 1958
1423 <-> 63, 959, 1311
1424 <-> 426
1425 <-> 730, 1113, 1590
1426 <-> 1112
1427 <-> 695, 832
1428 <-> 603, 798
1429 <-> 13, 1429, 1928
1430 <-> 1430
1431 <-> 1431
1432 <-> 356, 1552
1433 <-> 189, 512, 902
1434 <-> 520, 1755
1435 <-> 398, 422, 1244, 1889
1436 <-> 310, 1260
1437 <-> 66, 1152
1438 <-> 1483
1439 <-> 704, 707, 1222, 1862
1440 <-> 1558
1441 <-> 1380
1442 <-> 305, 1545
1443 <-> 1753
1444 <-> 1928
1445 <-> 767
1446 <-> 1545
1447 <-> 813
1448 <-> 357, 1089
1449 <-> 278, 1254, 1553
1450 <-> 1605
1451 <-> 1039, 1484
1452 <-> 78, 1254
1453 <-> 1879
1454 <-> 1455
1455 <-> 243, 1183, 1454
1456 <-> 614
1457 <-> 247
1458 <-> 616, 941
1459 <-> 1284
1460 <-> 1914
1461 <-> 417, 952
1462 <-> 300, 588, 665, 1298
1463 <-> 1690
1464 <-> 790
1465 <-> 419, 1672
1466 <-> 1562, 1940
1467 <-> 535, 1950
1468 <-> 237, 1278
1469 <-> 1469, 1874
1470 <-> 1092
1471 <-> 819, 987
1472 <-> 1472
1473 <-> 1677
1474 <-> 622, 1830
1475 <-> 1955
1476 <-> 354, 1062, 1739
1477 <-> 1002, 1248, 1867
1478 <-> 352, 788, 938, 1350, 1354
1479 <-> 1479
1480 <-> 836
1481 <-> 216, 339, 483
1482 <-> 1399, 1633
1483 <-> 1197, 1438, 1922
1484 <-> 63, 1451
1485 <-> 690, 1892
1486 <-> 623, 1417
1487 <-> 1588
1488 <-> 934
1489 <-> 183, 1544
1490 <-> 1038, 1669, 1670
1491 <-> 405, 1923
1492 <-> 1843
1493 <-> 21, 1731
1494 <-> 1769
1495 <-> 1329, 1679
1496 <-> 1694
1497 <-> 598, 904
1498 <-> 132
1499 <-> 446
1500 <-> 434
1501 <-> 57, 281, 520
1502 <-> 117, 1340
1503 <-> 1503
1504 <-> 474, 544, 1811, 1827
1505 <-> 938, 1991
1506 <-> 451, 542
1507 <-> 1315, 1327
1508 <-> 1508
1509 <-> 7, 136, 1291
1510 <-> 1510, 1879
1511 <-> 1286
1512 <-> 713
1513 <-> 943, 1149
1514 <-> 814, 1514
1515 <-> 1052
1516 <-> 447, 1640
1517 <-> 548, 1211
1518 <-> 1400
1519 <-> 90, 1032, 1962
1520 <-> 265, 1608
1521 <-> 821
1522 <-> 669, 1273, 1939
1523 <-> 14, 1842
1524 <-> 155, 187, 1797
1525 <-> 442, 1754
1526 <-> 979
1527 <-> 640, 1084, 1380
1528 <-> 245, 923, 1152, 1674
1529 <-> 1166
1530 <-> 1530
1531 <-> 780, 924, 1783
1532 <-> 10, 122, 1566
1533 <-> 824, 1321
1534 <-> 787
1535 <-> 67, 926, 1663
1536 <-> 580, 625
1537 <-> 850
1538 <-> 1012, 1183
1539 <-> 1374
1540 <-> 1637
1541 <-> 87, 851
1542 <-> 941, 1181, 1973
1543 <-> 871
1544 <-> 456, 1489
1545 <-> 779, 1369, 1442, 1446
1546 <-> 1334
1547 <-> 1345, 1784, 1878, 1975
1548 <-> 826, 1292
1549 <-> 1159
1550 <-> 247, 1799
1551 <-> 1551
1552 <-> 15, 1432, 1552
1553 <-> 668, 1449
1554 <-> 1057, 1060, 1376, 1864
1555 <-> 586, 1214, 1927
1556 <-> 1918
1557 <-> 106, 844, 1298
1558 <-> 1440, 1558
1559 <-> 415, 1935
1560 <-> 1304, 1646
1561 <-> 907, 1961
1562 <-> 556, 861, 1466, 1810
1563 <-> 1563
1564 <-> 752
1565 <-> 773, 1976
1566 <-> 631, 1532, 1870
1567 <-> 229, 1567
1568 <-> 1793, 1846
1569 <-> 329, 1211
1570 <-> 424
1571 <-> 73, 611
1572 <-> 1858
1573 <-> 875
1574 <-> 420
1575 <-> 896, 1141, 1355, 1628
1576 <-> 832
1577 <-> 936
1578 <-> 1606
1579 <-> 231, 1253
1580 <-> 1958
1581 <-> 218, 1099
1582 <-> 76, 1365, 1704
1583 <-> 1390
1584 <-> 1270
1585 <-> 71
1586 <-> 713, 953
1587 <-> 21, 909
1588 <-> 1487, 1698
1589 <-> 836, 1418, 1681
1590 <-> 1425
1591 <-> 587, 1140
1592 <-> 274, 538, 1182
1593 <-> 58
1594 <-> 367, 524, 1228
1595 <-> 435, 1055
1596 <-> 1285
1597 <-> 68, 728, 1597
1598 <-> 1846
1599 <-> 303
1600 <-> 708, 719, 1162
1601 <-> 148
1602 <-> 161, 349
1603 <-> 148, 786
1604 <-> 504, 1627
1605 <-> 245, 967, 1450
1606 <-> 204, 763, 1578, 1761
1607 <-> 1616
1608 <-> 1218, 1520
1609 <-> 684, 1152
1610 <-> 1023, 1835
1611 <-> 1611
1612 <-> 1971
1613 <-> 1308, 1382
1614 <-> 568, 1108
1615 <-> 1129, 1265
1616 <-> 1155, 1607, 1616
1617 <-> 1245
1618 <-> 79, 307
1619 <-> 1294, 1323
1620 <-> 59, 308, 1858
1621 <-> 1621, 1826
1622 <-> 619, 1687
1623 <-> 623, 1843
1624 <-> 1071, 1238, 1725
1625 <-> 591
1626 <-> 167, 813, 1344
1627 <-> 1604
1628 <-> 1306, 1575
1629 <-> 868, 1212
1630 <-> 47, 1827
1631 <-> 390
1632 <-> 42, 374, 1947
1633 <-> 179, 501, 560, 1482
1634 <-> 241, 1634
1635 <-> 1636, 1831
1636 <-> 469, 816, 1635, 1647
1637 <-> 1540, 1976
1638 <-> 753
1639 <-> 176
1640 <-> 1270, 1516
1641 <-> 564, 1251, 1268
1642 <-> 184
1643 <-> 188
1644 <-> 802, 928, 1819
1645 <-> 1392, 1645
1646 <-> 21, 1349, 1560
1647 <-> 52, 1636, 1723
1648 <-> 549, 901
1649 <-> 766
1650 <-> 929
1651 <-> 473, 725
1652 <-> 1283, 1652, 1662
1653 <-> 430
1654 <-> 708, 1657
1655 <-> 952, 957
1656 <-> 19, 1010
1657 <-> 1654
1658 <-> 257, 921
1659 <-> 346, 716, 1768
1660 <-> 160, 213
1661 <-> 843, 1684
1662 <-> 1033, 1652
1663 <-> 1365, 1535
1664 <-> 153, 1824
1665 <-> 517, 1724
1666 <-> 61, 594
1667 <-> 93
1668 <-> 1259
1669 <-> 1490
1670 <-> 1490, 1930
1671 <-> 1881, 1960
1672 <-> 1465
1673 <-> 1220, 1758
1674 <-> 1416, 1528
1675 <-> 498, 1315
1676 <-> 877
1677 <-> 584, 1473
1678 <-> 843
1679 <-> 125, 1495, 1951
1680 <-> 71, 1901
1681 <-> 1589
1682 <-> 700, 836, 1305, 1412
1683 <-> 37
1684 <-> 1661
1685 <-> 514
1686 <-> 440, 498, 856
1687 <-> 50, 409, 1622, 1857
1688 <-> 87
1689 <-> 388
1690 <-> 1463, 1910, 1911
1691 <-> 402, 1196, 1721
1692 <-> 688, 1084
1693 <-> 604, 795
1694 <-> 235, 1496, 1763
1695 <-> 143, 1061
1696 <-> 310, 460
1697 <-> 272, 1127
1698 <-> 1407, 1588
1699 <-> 1248, 1944
1700 <-> 781, 1743
1701 <-> 1820, 1853
1702 <-> 1044, 1702
1703 <-> 876, 1229, 1359
1704 <-> 638, 1582
1705 <-> 391, 428
1706 <-> 78, 1258
1707 <-> 401, 806, 1972
1708 <-> 1896
1709 <-> 252
1710 <-> 1122, 1882
1711 <-> 1188
1712 <-> 821
1713 <-> 658, 911
1714 <-> 37, 1070, 1810
1715 <-> 890
1716 <-> 721
1717 <-> 139
1718 <-> 1862
1719 <-> 510
1720 <-> 112
1721 <-> 1270, 1691
1722 <-> 1275, 1840, 1921
1723 <-> 190, 768, 972, 1647
1724 <-> 1665, 1794
1725 <-> 620, 922, 1624
1726 <-> 1891
1727 <-> 944, 1321
1728 <-> 1145, 1728
1729 <-> 814
1730 <-> 284, 1107
1731 <-> 629, 1493
1732 <-> 140
1733 <-> 522, 1950
1734 <-> 809, 1372
1735 <-> 381
1736 <-> 701, 975, 1309
1737 <-> 1003
1738 <-> 717
1739 <-> 228, 558, 1247, 1476
1740 <-> 1740
1741 <-> 548, 1895
1742 <-> 709
1743 <-> 1338, 1700
1744 <-> 290
1745 <-> 93, 606
1746 <-> 792, 1215
1747 <-> 1159
1748 <-> 22, 470, 591
1749 <-> 342, 1959, 1994
1750 <-> 1375
1751 <-> 214, 225, 1080, 1086
1752 <-> 385, 907, 908, 1825
1753 <-> 11, 1443, 1916
1754 <-> 211, 1525
1755 <-> 1243, 1434
1756 <-> 537, 896, 1898
1757 <-> 416, 792
1758 <-> 810, 1673
1759 <-> 369, 1830
1760 <-> 673, 1118
1761 <-> 1112, 1606
1762 <-> 1762, 1781
1763 <-> 1694
1764 <-> 1152
1765 <-> 961
1766 <-> 362
1767 <-> 1932, 1967
1768 <-> 1659
1769 <-> 1494, 1785
1770 <-> 1969
1771 <-> 157, 488, 539, 541, 1771
1772 <-> 33
1773 <-> 30
1774 <-> 22
1775 <-> 1385, 1775
1776 <-> 578, 597
1777 <-> 127, 924, 1361
1778 <-> 525, 1177
1779 <-> 1320, 1779
1780 <-> 1353
1781 <-> 1762
1782 <-> 1782
1783 <-> 1531
1784 <-> 310, 1547
1785 <-> 57, 626, 1769
1786 <-> 113
1787 <-> 142, 1312
1788 <-> 42
1789 <-> 327, 863, 1316
1790 <-> 430, 1920
1791 <-> 1042, 1177
1792 <-> 633
1793 <-> 1568
1794 <-> 83, 144, 1724
1795 <-> 918
1796 <-> 858
1797 <-> 480, 564, 1524
1798 <-> 624
1799 <-> 276, 389, 1550, 1815
1800 <-> 1823
1801 <-> 1272
1802 <-> 178, 1207
1803 <-> 1935
1804 <-> 78, 1178
1805 <-> 675, 898
1806 <-> 70, 371
1807 <-> 267, 1110
1808 <-> 139
1809 <-> 1001
1810 <-> 500, 1562, 1714
1811 <-> 1504
1812 <-> 1923
1813 <-> 483, 913, 1813
1814 <-> 1163
1815 <-> 431, 1799
1816 <-> 408, 737
1817 <-> 315, 1956
1818 <-> 1150, 1952
1819 <-> 796, 1644
1820 <-> 736, 1135, 1701
1821 <-> 119, 852, 973, 1868
1822 <-> 917
1823 <-> 1144, 1371, 1800
1824 <-> 608, 810, 961, 1664
1825 <-> 437, 1752
1826 <-> 120, 1621
1827 <-> 1504, 1630
1828 <-> 1400
1829 <-> 997, 1829
1830 <-> 1474, 1759
1831 <-> 36, 378, 381, 1635
1832 <-> 435
1833 <-> 1207
1834 <-> 592
1835 <-> 1610
1836 <-> 127
1837 <-> 110, 123
1838 <-> 335
1839 <-> 1007
1840 <-> 1722
1841 <-> 222
1842 <-> 1523
1843 <-> 858, 1211, 1492, 1623
1844 <-> 988, 1932
1845 <-> 293
1846 <-> 393, 1568, 1598, 1846
1847 <-> 1141
1848 <-> 1848
1849 <-> 1226
1850 <-> 519
1851 <-> 1851, 1860
1852 <-> 1852
1853 <-> 822, 1701
1854 <-> 220, 1128, 1139, 1351
1855 <-> 1380
1856 <-> 926, 950
1857 <-> 1687
1858 <-> 1572, 1620
1859 <-> 157, 1035
1860 <-> 1851
1861 <-> 74, 630
1862 <-> 1000, 1314, 1439, 1718
1863 <-> 72, 1076
1864 <-> 760, 1554
1865 <-> 82, 1865
1866 <-> 1331, 1866
1867 <-> 794, 1477
1868 <-> 1821
1869 <-> 458, 762, 1281
1870 <-> 366, 974, 1566
1871 <-> 147, 789
1872 <-> 533
1873 <-> 413
1874 <-> 1469
1875 <-> 195, 273
1876 <-> 1004, 1049
1877 <-> 321, 912
1878 <-> 962, 1161, 1547
1879 <-> 1453, 1510
1880 <-> 290, 1209
1881 <-> 1671, 1881, 1887, 1902
1882 <-> 566, 977, 1287, 1710
1883 <-> 149, 392, 1340
1884 <-> 234, 571, 893
1885 <-> 1029
1886 <-> 1309
1887 <-> 1881
1888 <-> 154, 901
1889 <-> 116, 280, 448, 1435
1890 <-> 777, 1121, 1890
1891 <-> 192, 1726
1892 <-> 1485
1893 <-> 232
1894 <-> 1012
1895 <-> 111, 1741, 1919
1896 <-> 1254, 1708
1897 <-> 216
1898 <-> 1756
1899 <-> 1246, 1367
1900 <-> 441, 814, 1163
1901 <-> 550, 1680
1902 <-> 1881
1903 <-> 87, 1406
1904 <-> 358
1905 <-> 245
1906 <-> 574, 1906
1907 <-> 20, 453, 842, 1199
1908 <-> 927
1909 <-> 392
1910 <-> 1085, 1183, 1690
1911 <-> 224, 878, 1690
1912 <-> 987, 1005, 1138
1913 <-> 55, 1378, 1407
1914 <-> 603, 1460
1915 <-> 59, 405
1916 <-> 1126, 1383, 1753
1917 <-> 658, 1007, 1082, 1917
1918 <-> 495, 935, 1234, 1408, 1556
1919 <-> 1037, 1895
1920 <-> 421, 1790
1921 <-> 992, 1396, 1722
1922 <-> 1483
1923 <-> 1491, 1812
1924 <-> 96, 100
1925 <-> 80, 693, 840
1926 <-> 546, 1009, 1347
1927 <-> 906, 1555
1928 <-> 370, 1429, 1444
1929 <-> 671
1930 <-> 1670
1931 <-> 1336
1932 <-> 6, 1767, 1844
1933 <-> 463, 1180
1934 <-> 237
1935 <-> 322, 785, 1559, 1803
1936 <-> 161, 506
1937 <-> 1937
1938 <-> 397
1939 <-> 1522
1940 <-> 1466
1941 <-> 379
1942 <-> 428, 1345
1943 <-> 1943
1944 <-> 1699
1945 <-> 664, 1945
1946 <-> 1946
1947 <-> 733, 1632
1948 <-> 1403
1949 <-> 249, 848, 899
1950 <-> 611, 981, 1467, 1733
1951 <-> 1679
1952 <-> 1818
1953 <-> 1212
1954 <-> 1247
1955 <-> 528, 1475
1956 <-> 1817
1957 <-> 599
1958 <-> 26, 70, 1422, 1580
1959 <-> 1749
1960 <-> 797, 1671
1961 <-> 991, 1386, 1561
1962 <-> 1519
1963 <-> 1963
1964 <-> 1153
1965 <-> 435
1966 <-> 50, 519, 699
1967 <-> 1767
1968 <-> 1157
1969 <-> 226, 1770
1970 <-> 880
1971 <-> 635, 1612
1972 <-> 1051, 1707
1973 <-> 750, 1542
1974 <-> 194, 833
1975 <-> 1547
1976 <-> 872, 1310, 1565, 1637
1977 <-> 804
1978 <-> 549, 1307
1979 <-> 465
1980 <-> 1384
1981 <-> 197, 648
1982 <-> 625, 784
1983 <-> 857, 1353, 1983
1984 <-> 652, 1255
1985 <-> 1045
1986 <-> 941
1987 <-> 1170, 1281
1988 <-> 98, 168, 1988
1989 <-> 319, 671
1990 <-> 1119
1991 <-> 446, 1505
1992 <-> 601, 696
1993 <-> 550
1994 <-> 825, 1749
1995 <-> 332, 690
1996 <-> 1183
1997 <-> 376, 746
1998 <-> 414, 829
1999 <-> 1239, 1364
