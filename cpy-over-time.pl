#!/usr/bin/perl

require "./stats/tag2date.pm";

sub num {
    my ($t)=@_;
    if($t =~ /^curl-(\d)_(\d+)_(\d+)/) {
        return 10000*$1 + 100*$2 + $3;
    }
    elsif($t =~ /^curl-(\d)_(\d+)/) {
        return 10000*$1 + 100*$2;
    }
}


sub sortthem {
    return num($a) <=> num($b);
}

@alltags= `git tag -l`;

foreach my $t (@alltags) {
    chomp $t;
    if($t =~ /^curl-([0-9_]*[0-9])\z/) {
        push @releases, $t;
    }
}

sub cpyuse {
    my ($tag, $path) = @_;

    # Get source files to count
    my @files;
    open(G, "git ls-tree -r --name-only $tag -- $path 2>/dev/null|");
    while(<G>) {
        chomp;
        if($_ =~ /[ch]\z/) {
            push @files, $_;
        }
    }
    close(G);

    my $cmd;
    for(@files) {
        $cmd .= "$tag:$_ ";
    }

    my $count;
    my $alloc;

    open(G, "git show $cmd 2>/dev/null| grep -E ' (mem|str|strn)cpy\\('|");
    while(<G>) {
        $count++;
    }
    close(G);

    # the .* is here to work with typecast results
    open(G, "git show $cmd 2>/dev/null| grep -E '\=.*\\W(Curl_safere|re|m|c)alloc\\('|");
    while(<G>) {
        $alloc++;
    }
    close(G);

    my $blanks, $comments, $code;
    open(G, "git show $cmd 2>/dev/null| cloc --force-lang=C --csv -|");
    while(<G>) {
        if($_ =~ /^1,SUM,(\d*),(\d*),(\d*)/) {
            ($blanks, $comments, $code)=($1, $2, $3);
            last;
        }
    }
    close(G);

    return ($count, $alloc, $code);
}

print <<CACHE
2000-03-14;4.765;41;2.441;21
2000-03-21;4.787;41;2.452;21
2000-03-21;4.787;41;2.452;21
2000-08-21;4.908;46;2.561;24
2000-08-30;4.880;46;2.546;24
2000-09-28;4.893;53;2.954;32
2000-10-16;4.902;54;3.177;35
2000-12-04;4.672;52;3.144;35
2001-01-05;4.645;52;3.127;35
2001-01-27;4.630;52;3.116;35
2001-02-13;4.472;52;3.010;35
2001-03-22;4.203;52;3.152;39
2001-04-04;4.354;54;3.145;39
2001-04-23;4.329;54;3.127;39
2001-05-07;4.286;54;3.095;39
2001-06-07;4.234;54;3.058;39
2001-08-20;4.078;51;3.358;42
2001-09-25;4.194;56;3.520;47
2001-11-04;4.269;59;3.400;47
2001-12-05;4.275;61;3.504;50
2002-01-23;4.028;62;3.833;59
2002-02-05;4.083;63;3.888;60
2002-03-07;4.065;64;3.811;60
2002-04-15;3.971;63;3.656;58
2002-05-13;3.967;64;3.843;62
2002-06-13;3.912;64;3.851;63
2002-10-01;3.798;65;3.681;63
2002-10-11;3.784;65;3.667;63
2002-11-18;3.878;67;3.704;64
2003-01-14;3.956;69;3.669;64
2003-04-02;4.184;67;3.997;64
2003-05-19;4.334;71;4.090;67
2003-07-28;4.454;79;3.947;70
2003-08-15;4.316;79;3.879;71
2003-11-01;4.265;80;3.892;73
2004-01-22;4.123;79;3.810;73
2004-03-18;3.950;80;3.851;78
2004-04-26;3.826;79;3.923;81
2004-06-02;3.634;81;3.634;81
2004-08-10;3.254;73;3.432;77
2004-10-18;3.391;78;3.348;77
2004-12-20;3.277;78;3.277;78
2005-02-01;3.213;77;3.255;78
2005-03-04;3.239;81;3.159;79
2005-04-05;3.270;82;3.230;81
2005-05-16;3.186;82;3.186;82
2005-09-01;3.182;83;3.221;84
2005-10-13;3.147;84;3.184;85
2005-12-06;3.120;84;3.194;86
2006-02-27;3.058;83;3.168;86
2006-03-20;3.056;83;3.167;86
2006-06-12;3.149;91;3.115;90
2006-08-07;3.138;92;3.104;91
2006-10-29;3.111;94;3.111;94
2007-01-29;3.228;102;3.196;101
2007-04-11;3.112;103;3.142;104
2007-06-25;3.167;108;3.138;107
2007-07-10;3.213;111;3.126;108
2007-09-13;2.994;106;3.022;107
2007-10-29;3.005;109;3.171;115
2008-01-28;3.100;114;3.209;118
2008-03-30;3.090;114;3.198;118
2008-06-04;3.056;114;3.163;118
2008-09-01;3.058;116;3.163;120
2008-11-05;3.249;126;3.455;134
2008-11-13;3.255;126;3.436;133
2009-01-19;3.196;124;3.196;124
2009-03-02;3.797;153;3.400;137
2009-05-18;3.781;153;3.336;135
2009-08-12;3.891;159;3.328;136
2009-11-04;3.825;158;3.292;136
2010-02-09;3.488;156;3.264;146
2010-04-14;3.447;156;3.226;146
2010-06-16;3.354;163;3.190;155
2010-08-11;3.387;166;3.142;154
2010-10-12;3.403;168;3.140;155
2010-12-15;3.370;168;3.109;155
2011-02-17;3.326;169;3.208;163
2011-04-17;3.283;169;3.166;163
2011-04-22;3.278;169;3.162;163
2011-06-23;3.260;168;3.124;161
2011-09-13;3.205;167;3.071;160
2011-11-14;3.196;168;3.063;161
2011-11-17;3.196;168;3.063;161
2012-01-24;3.153;168;3.021;161
2012-03-22;3.162;169;3.012;161
2012-05-24;3.173;171;3.025;163
2012-07-27;3.143;179;3.020;172
2012-10-10;3.105;179;3.001;173
2012-11-20;3.093;179;2.989;173
2013-02-06;3.044;177;2.993;174
2013-04-12;3.099;184;2.981;177
2013-06-22;3.114;187;3.014;181
2013-08-11;3.071;191;2.975;185
2013-10-13;2.888;181;2.967;186
2013-12-16;2.877;182;2.940;186
2014-01-29;2.861;182;2.939;187
2014-03-26;3.103;201;2.964;192
2014-05-20;3.105;203;2.906;190
2014-07-16;3.100;204;2.948;194
2014-09-10;3.103;208;2.983;200
2014-11-05;3.083;206;3.038;203
2015-01-07;3.156;218;3.055;211
2015-02-25;3.234;220;3.102;211
2015-04-22;3.231;220;3.099;211
2015-04-28;3.231;220;3.099;211
2015-06-17;3.207;220;3.047;209
2015-08-11;3.248;224;3.103;214
2015-10-07;3.246;224;3.072;212
2015-12-01;3.236;226;3.050;213
2016-01-27;3.241;227;3.069;215
2016-02-08;3.241;227;3.070;215
2016-03-23;3.231;227;3.060;215
2016-05-17;3.186;228;3.032;217
2016-05-30;3.182;228;3.043;218
2016-07-21;3.158;227;3.019;217
2016-08-03;3.157;227;3.018;217
2016-09-07;3.145;227;3.034;219
2016-09-14;3.144;227;3.019;218
2016-11-02;3.117;225;3.020;218
2016-12-20;3.092;227;2.997;220
2016-12-22;3.092;227;2.997;220
2017-02-22;3.092;228;3.038;224
2017-02-24;3.092;228;3.038;224
2017-04-19;3.065;227;2.984;221
2017-06-14;3.105;231;2.998;223
2017-08-09;3.116;232;2.995;223
2017-08-13;3.113;232;2.992;223
2017-10-04;3.197;244;3.027;231
2017-10-23;3.184;244;3.015;231
2017-11-29;3.163;245;3.021;234
2018-01-23;3.095;247;2.995;239
2018-03-13;3.103;249;2.979;239
2018-05-15;3.094;251;3.007;244
2018-07-11;3.092;252;2.993;244
2018-09-04;3.084;252;3.011;246
2018-10-30;3.054;257;2.971;250
2018-12-12;3.051;256;2.980;250
2019-02-06;3.079;259;2.972;250
2019-03-27;3.076;261;2.970;252
2019-05-22;3.026;256;2.956;250
2019-06-04;3.024;256;2.953;250
2019-07-17;3.024;256;2.953;250
2019-07-19;3.025;256;2.954;250
2019-09-10;3.025;264;2.945;257
2019-11-05;3.052;267;2.961;259
2020-01-08;3.142;278;2.973;263
2020-03-04;3.118;279;2.939;263
2020-03-11;3.110;279;2.932;263
2020-04-29;3.174;288;2.964;269
2020-06-23;3.064;281;2.650;243
2020-06-30;3.075;282;2.660;244
2020-08-19;3.064;282;2.662;245
2020-10-14;3.055;282;2.643;244
2020-12-09;3.041;282;2.653;246
2021-02-03;2.952;280;2.657;252
2021-03-31;2.889;276;2.648;253
2021-04-14;2.888;276;2.637;252
2021-05-26;2.903;279;2.643;254
2021-07-21;2.964;286;2.664;257
2021-09-14;2.914;282;2.656;257
2021-09-22;2.924;283;2.655;257
2021-11-10;2.927;285;2.650;258
2022-01-05;2.961;290;2.644;259
2022-03-05;2.939;284;2.639;255
2022-04-27;2.956;289;2.639;258
2022-05-11;2.963;290;2.636;258
2022-06-27;2.960;292;2.656;262
2022-08-31;2.962;294;2.650;263
2022-10-26;2.953;296;2.504;251
2022-12-21;2.908;296;2.534;258
2023-02-15;2.768;292;2.559;270
2023-02-20;2.767;292;2.558;270
2023-03-20;2.688;285;2.490;264
2023-03-20;2.688;285;2.490;264
2023-05-17;2.558;281;2.458;270
2023-05-23;2.558;281;2.458;270
2023-05-30;2.560;281;2.460;270
2023-07-19;2.547;281;2.448;270
2023-07-26;2.547;281;2.448;270
2023-09-13;2.577;279;2.476;268
2023-10-11;2.591;280;2.489;269
2023-12-06;2.591;282;2.471;269
2024-01-31;2.219;247;2.174;242
2024-03-27;2.093;237;2.120;240
2024-03-27;2.093;237;2.120;240
2024-05-22;2.018;233;2.053;237
2024-07-24;2.007;236;2.024;238
2024-07-31;2.005;236;2.022;238
2024-09-11;2.029;241;2.012;239
2024-09-18;2.027;241;2.010;239
CACHE
    ;

sub show {
    my ($t, $d) = @_;
    my ($cpy, $alloc, $code) = cpyuse($t, "lib");
    printf "$d;%.3f;%u;%.3f;%u\n", $cpy * 1000 / $code, $cpy, $alloc * 1000 / $code, $alloc;
}

foreach my $t (sort sortthem @releases) {
    if(num($t) <= 81001) {
        next;
    }
    my $d = tag2date($t);
    show($t, $d);
}

$t=`git describe`;
chomp $t;

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
    localtime(time);
my $d = sprintf "%04d-%02d-%02d", $year + 1900, $mon + 1, $mday;

show($t, $d);
