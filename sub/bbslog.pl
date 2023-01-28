#! /usr/local/bin/perl

#
#	�����͂�����Ղ� Rev.0.1 Preview 9 (2000.9.3)
#	 (�ߋ����O�r���[�A�[)
#	
#	�����O���l����� Getlog Ver0.3b4.0921 (�ʏ�ŋy�ь��P�ʕۑ����O�Ή���)
#	  �̉����łł�
#


###############################################################################
#  �_�E�����[�h�@�\�g�p�ۃ`�F�b�N
###############################################################################

sub dlchk {
	
	my ( $ver, $uos, $isie, $iever, $ismac );
	
	$ENV{'HTTP_USER_AGENT'} =~ m#^Mozilla/(\S+)\s(.+)#;
	$ver = $1;
	$uos = $2;
	if ( $uos =~ /MSIE (\S)/ ) {
		$isie = 1;
		$iever = $1;
	} else {
		$isie = 0;
	}
	if ( $uos =~ /Mac/ ) {
		$ismac = 1;
	} else {
		$ismac = 0;
	}
	
	if ( ( $ver >= 4 && !$isie ) || ( $ver >= 4 && $isie && $iever >= 5 && !$ismac ) ) {
		return 1;
	} else {
		return 0;
	}
}


###############################################################################
#  �ߋ����O���X�g�\��
###############################################################################

sub oldloglist {
	
	my ( @files, @check, $ftitle, $fsize, $ftime, @fgmtime, $dsptopic, $dspqmsg, $dspgzip, $dspdown );
	
	if ( $oldlogfmt && $oldlogbtn ) {
		$dspqmsg = <<EOF;
                <INPUT type="checkbox" name="btn" value="checked">���p�@�\\�g�p
EOF
	} else {
		$dspqmsg = '&nbsp;';
	}
	
	if ( $gzip ) {
		$dspgzip = <<EOF;
                <INPUT type="checkbox" name="g" value="checked" $S_gzchk[$gzipu]>gzip���k�]��
EOF
	} else {
		$dspgzip = '&nbsp;';
	}
	
	if ( &dlchk ) {
		$dspdown = '1">�_�E�����[�h';
	} else {
		$dspdown = '2">�S���\��';
	}
	
	opendir ( DIR, $oldlogfiledir ) || &prterror ( '�f�B���N�g�����J���܂���ł���' );
	@files = readdir ( DIR );
	closedir ( DIR );
	@files = sort { $a <=> $b; } @files;
	
	&prthtmlhead ( "$bbstitle �ߋ����O�����E�_�E�����[�h" );
	print <<EOF;
<P align="center"><STRONG><FONT size="+1">$bbstitle �ߋ����O�ꗗ</FONT></STRONG></P>

<FORM method="GET" action="$cgiurl">
  <CENTER>
    <TABLE border="0">
      <TR>
        <TD>
          <HR size="2">
          <TABLE border="0" width="100%">
            <TR>
              <TD colspan="5">�ߋ����O�ꗗ</TD>
            </TR>
EOF
	
	$check[@files - 1] = 'checked';
	for ( $i = 0 ; $i < @files ; $i++ ) {
		if ( $files[$i] ne '.' && $files[$i] ne '..' ) {
			( $j, $j, $j, $j, $j, $j, $j, $fsize, $j, $ftime, $j, $j, $j ) = stat ( "$oldlogfiledir$files[$i]" );
			@fgmtime = gmtime ( $ftime + 32400 + $difftime );
			@fgmtime[4]++;
			$ftime = sprintf ( "%02d/%02d %02d:%02d:%02d", $fgmtime[4], $fgmtime[3], $fgmtime[2], $fgmtime[1], $fgmtime[0] );
			if ( !$oldlogsavesw ) {
				$files[$i] =~ /(\d\d\d\d)(\d\d)(\d\d)\.(\w+)/;
				$ftitle = "$1/$2/$3";
			} else {
				$files[$i] =~ /(\d\d\d\d)(\d\d)\.(\w+)/;
				$ftitle = "$1/$2";
			}
			if ( $oldlogfmt ) {
				$dsptopic = <<EOF;
              <TD align="right"><FONT size="-1"><A href="$cgiurl?m=l&e=$files[$i]">�g�s�b�N�ꗗ</A></FONT></TD>
EOF
			} else {
				$dsptopic = '';
			}
			
			print <<EOF;
            <TR>
              <TD><INPUT type="checkbox" name="chk$files[$i]" value="checked" $check[$i]></TD>
              <TD><A href="$cgiurl?m=g&e=$files[$i]">$ftitle</A></TD>
              <TD align="right"><FONT size="-1">$ftime</FONT></TD>
              <TD align="right"><FONT size="-1">$fsize bytes</FONT></TD>
              $dsptopic
              <TD align="right"><FONT size="-1"><A href="$cgiurl?m=g&e=$files[$i]&dl=$dspdown</A></FONT></TD>
            </TR>
EOF
		}
	}
	print <<EOF;
          </TABLE>
        </TD>
      </TR>
      <TR>
        <TD>
          <HR size="2">
          <TABLE border="0">
            <TR>
              <TD colspan="3">
                �L�[���[�h�w��
              </TD>
            </TR>
            <TR>
              <TD colspan="3">
                <INPUT type="text" name="kwd" size="40" maxlength="255">
                <INPUT type="submit" value="   ��   ��   ">
              </TD>
            </TR>
            <TR>
              <TD>
                <FONT size="-1">�����w��</FONT>
              </TD>
              <TD>
                <FONT size="-1">�_����</FONT>
              </TD>
              <TD>
                <FONT size="-1">�����Ώ�</FONT>
              </TD>
            </TR>
            <TR>
              <TD><FONT size="-1">
EOF
	if ( !$oldlogsavesw ) {
		print <<EOF;
                <SELECT name="s1" size="1">
                  <OPTION value="0">0</OPTION>
                  <OPTION value="1">1</OPTION>
                  <OPTION value="2">2</OPTION>
                  <OPTION value="3">3</OPTION>
                  <OPTION value="4">4</OPTION>
                  <OPTION value="5">5</OPTION>
                  <OPTION value="6">6</OPTION>
                  <OPTION value="7">7</OPTION>
                  <OPTION value="8">8</OPTION>
                  <OPTION value="9">9</OPTION>
                  <OPTION value="10">10</OPTION>
                  <OPTION value="11">11</OPTION>
                  <OPTION value="12">12</OPTION>
                  <OPTION value="13">13</OPTION>
                  <OPTION value="14">14</OPTION>
                  <OPTION value="15">15</OPTION>
                  <OPTION value="16">16</OPTION>
                  <OPTION value="17">17</OPTION>
                  <OPTION value="18">18</OPTION>
                  <OPTION value="19">19</OPTION>
                  <OPTION value="20">20</OPTION>
                  <OPTION value="21">21</OPTION>
                  <OPTION value="22">22</OPTION>
                  <OPTION value="23">23</OPTION>
                </SELECT> ��
                <SELECT name="e1" size="1">
                  <OPTION value="0">00</OPTION>
                  <OPTION value="5">05</OPTION>
                  <OPTION value="10">10</OPTION>
                  <OPTION value="15">15</OPTION>
                  <OPTION value="20">20</OPTION>
                  <OPTION value="25">25</OPTION>
                  <OPTION value="30">30</OPTION>
                  <OPTION value="35">35</OPTION>
                  <OPTION value="40">40</OPTION>
                  <OPTION value="45">45</OPTION>
                  <OPTION value="50">50</OPTION>
                  <OPTION value="55">55</OPTION>
                </SELECT> ������ 
                <SELECT name="s2" size="1">
                  <OPTION value="24">24</OPTION>
                  <OPTION value="0">0</OPTION>
                  <OPTION value="1">1</OPTION>
                  <OPTION value="2">2</OPTION>
                  <OPTION value="3">3</OPTION>
                  <OPTION value="4">4</OPTION>
                  <OPTION value="5">5</OPTION>
                  <OPTION value="6">6</OPTION>
                  <OPTION value="7">7</OPTION>
                  <OPTION value="8">8</OPTION>
                  <OPTION value="9">9</OPTION>
                  <OPTION value="10">10</OPTION>
                  <OPTION value="11">11</OPTION>
                  <OPTION value="12">12</OPTION>
                  <OPTION value="13">13</OPTION>
                  <OPTION value="14">14</OPTION>
                  <OPTION value="15">15</OPTION>
                  <OPTION value="16">16</OPTION>
                  <OPTION value="17">17</OPTION>
                  <OPTION value="18">18</OPTION>
                  <OPTION value="19">19</OPTION>
                  <OPTION value="20">20</OPTION>
                  <OPTION value="21">21</OPTION>
                  <OPTION value="22">22</OPTION>
                  <OPTION value="23">23</OPTION>
                </SELECT> ��
                <SELECT name="e2" size="1">
                  <OPTION value="0">00</OPTION>
                  <OPTION value="5">05</OPTION>
                  <OPTION value="10">10</OPTION>
                  <OPTION value="15">15</OPTION>
                  <OPTION value="20">20</OPTION>
                  <OPTION value="25">25</OPTION>
                  <OPTION value="30">30</OPTION>
                  <OPTION value="35">35</OPTION>
                  <OPTION value="40">40</OPTION>
                  <OPTION value="45">45</OPTION>
                  <OPTION value="50">50</OPTION>
                  <OPTION value="55">55</OPTION>
                </SELECT> ���܂�</FONT>
EOF
	} else {
		print <<EOF;
                <SELECT name="s1" size="1">
                  <OPTION value="1">1</OPTION>
                  <OPTION value="2">2</OPTION>
                  <OPTION value="3">3</OPTION>
                  <OPTION value="4">4</OPTION>
                  <OPTION value="5">5</OPTION>
                  <OPTION value="6">6</OPTION>
                  <OPTION value="7">7</OPTION>
                  <OPTION value="8">8</OPTION>
                  <OPTION value="9">9</OPTION>
                  <OPTION value="10">10</OPTION>
                  <OPTION value="11">11</OPTION>
                  <OPTION value="12">12</OPTION>
                  <OPTION value="13">13</OPTION>
                  <OPTION value="14">14</OPTION>
                  <OPTION value="15">15</OPTION>
                  <OPTION value="16">16</OPTION>
                  <OPTION value="17">17</OPTION>
                  <OPTION value="18">18</OPTION>
                  <OPTION value="19">19</OPTION>
                  <OPTION value="20">20</OPTION>
                  <OPTION value="21">21</OPTION>
                  <OPTION value="22">22</OPTION>
                  <OPTION value="23">23</OPTION>
                  <OPTION value="24">24</OPTION>
                  <OPTION value="25">25</OPTION>
                  <OPTION value="26">26</OPTION>
                  <OPTION value="27">27</OPTION>
                  <OPTION value="28">28</OPTION>
                  <OPTION value="29">29</OPTION>
                  <OPTION value="30">30</OPTION>
                  <OPTION value="31">31</OPTION>
                </SELECT> �� 
                <SELECT name="e1" size="1">
                  <OPTION value="0">0</OPTION>
                  <OPTION value="1">1</OPTION>
                  <OPTION value="2">2</OPTION>
                  <OPTION value="3">3</OPTION>
                  <OPTION value="4">4</OPTION>
                  <OPTION value="5">5</OPTION>
                  <OPTION value="6">6</OPTION>
                  <OPTION value="7">7</OPTION>
                  <OPTION value="8">8</OPTION>
                  <OPTION value="9">9</OPTION>
                  <OPTION value="10">10</OPTION>
                  <OPTION value="11">11</OPTION>
                  <OPTION value="12">12</OPTION>
                  <OPTION value="13">13</OPTION>
                  <OPTION value="14">14</OPTION>
                  <OPTION value="15">15</OPTION>
                  <OPTION value="16">16</OPTION>
                  <OPTION value="17">17</OPTION>
                  <OPTION value="18">18</OPTION>
                  <OPTION value="19">19</OPTION>
                  <OPTION value="20">20</OPTION>
                  <OPTION value="21">21</OPTION>
                  <OPTION value="22">22</OPTION>
                  <OPTION value="23">23</OPTION>
                </SELECT> �� ����
                <SELECT name="s2" size="1">
                  <OPTION value="1">1</OPTION>
                  <OPTION value="2">2</OPTION>
                  <OPTION value="3">3</OPTION>
                  <OPTION value="4">4</OPTION>
                  <OPTION value="5">5</OPTION>
                  <OPTION value="6">6</OPTION>
                  <OPTION value="7">7</OPTION>
                  <OPTION value="8">8</OPTION>
                  <OPTION value="9">9</OPTION>
                  <OPTION value="10">10</OPTION>
                  <OPTION value="11">11</OPTION>
                  <OPTION value="12">12</OPTION>
                  <OPTION value="13">13</OPTION>
                  <OPTION value="14">14</OPTION>
                  <OPTION value="15">15</OPTION>
                  <OPTION value="16">16</OPTION>
                  <OPTION value="17">17</OPTION>
                  <OPTION value="18">18</OPTION>
                  <OPTION value="19">19</OPTION>
                  <OPTION value="20">20</OPTION>
                  <OPTION value="21">21</OPTION>
                  <OPTION value="22">22</OPTION>
                  <OPTION value="23">23</OPTION>
                  <OPTION value="24">24</OPTION>
                  <OPTION value="25">25</OPTION>
                  <OPTION value="26">26</OPTION>
                  <OPTION value="27">27</OPTION>
                  <OPTION value="28">28</OPTION>
                  <OPTION value="29">29</OPTION>
                  <OPTION value="30">30</OPTION>
                  <OPTION value="31" selected>31</OPTION>
                </SELECT> ��
                <SELECT name="e2" size="1">
                  <OPTION value="24">24</OPTION>
                  <OPTION value="0">0</OPTION>
                  <OPTION value="1">1</OPTION>
                  <OPTION value="2">2</OPTION>
                  <OPTION value="3">3</OPTION>
                  <OPTION value="4">4</OPTION>
                  <OPTION value="5">5</OPTION>
                  <OPTION value="6">6</OPTION>
                  <OPTION value="7">7</OPTION>
                  <OPTION value="8">8</OPTION>
                  <OPTION value="9">9</OPTION>
                  <OPTION value="10">10</OPTION>
                  <OPTION value="11">11</OPTION>
                  <OPTION value="12">12</OPTION>
                  <OPTION value="13">13</OPTION>
                  <OPTION value="14">14</OPTION>
                  <OPTION value="15">15</OPTION>
                  <OPTION value="16">16</OPTION>
                  <OPTION value="17">17</OPTION>
                  <OPTION value="18">18</OPTION>
                  <OPTION value="19">19</OPTION>
                  <OPTION value="20">20</OPTION>
                  <OPTION value="21">21</OPTION>
                  <OPTION value="22">22</OPTION>
                  <OPTION value="23">23</OPTION>
                </SELECT> �� �܂�</FONT>
EOF
	}
	print <<EOF;
              </TD>
              <TD><FONT size="-1">
                <SELECT name="ao">
                  <OPTION value="a">AND����</OPTION>
                  <OPTION value="o">OR����</OPTION>
                </SELECT></FONT>
              </TD>
              <TD><FONT size="-1">
                <SELECT name="tt">
                  <OPTION value="a">�S��</OPTION>
                  <OPTION value="u">���e�Җ�</OPTION>
                  <OPTION value="t">�薼</OPTION>
                </SELECT></FONT>
              </TD>
            </TR>
          </TABLE>
        </TD>
      </TR>
      <TR>
        <TD>
          <TABLE border="0" width="100%">
            <TR>
              <TD width="50%"><FONT size="-1">
                <INPUT type="checkbox" name="alp" value="checked" checked>�啶�����������ꎋ<BR>
                $dspqmsg</FONT>
              </TD>
              <TD width="50%"><FONT size="-1">
                <INPUT type="checkbox" name="j" value="checked">jcode.pl�g�p<BR>
                $dspgzip</FONT>
              </TD>
            </TR>
          </TABLE>
        </TD>
      </TR>
      <TR>
        <TD>
          <HR size="2">
        </TD>
      </TR>
    </TABLE>
  </CENTER>
  <INPUT type="hidden" name="m" value="g">
  <INPUT type="hidden" name="k" value="��">
  <INPUT type="hidden" name="sv" value="on">
</FORM>
<P align="center"><A href="$cgiurl">�f����</A></P>
<H4 align="right">Getlog Ver0.3b4.0921<BR>
�i�����͂�����ՂƑg�ݍ��݃o�[�W�����j</H4>
</BODY>
</HTML>
EOF
}


###############################################################################
#  �ߋ����O�\��
###############################################################################

sub prtoldlog {
	
	my (
	  @oldlog, 
	  @prtbuf, 
	  @msgline,
	  %MPTR,
	  @keyword, 
	  $wmon,
	  $wday,
	  $whor,
	  $wmin,
	  $top,
	  $btm,
	  $hit, 
	  $hitcount
	  );
	
	open ( OLDLOG, "$oldlogfiledir$FORM{'e'}" ) || &prterror ( "$FORM{'e'}���J���܂���ł���" );
	eval 'flock ( OLDLOG, 1 )';
	seek ( OLDLOG, 0, 0 );
	@oldlog = <OLDLOG>;
	eval 'flock ( OLDLOG, 8 )';
	close ( OLDLOG );
	
	$hitcount = 0;
	@keyword = split ( /\ /, $FORM{'kwd'} );
	foreach ( @keyword ) {
		$_ = quotemeta $_;
	}
	
	$FORM{'e'} =~ /.*\.(.*)/;
	if ( $1 =~ /htm/ ) {
		
		# HTML�`���̉ߋ����O
		if ( $FORM{'sv'} ) {
			print "<H1>$FORM{'e'}</H1><HR>";
			
			$tmpl_msg =~ s/(\$[A-Za-z0-9\'\{\}]+)/\(.*\)/g;
			$tmpl_msg =~ s/\+/\\\+/g;
			@msgline = split ( /\n/, $tmpl_msg );
			$MPTR{'title'}	= 1;
			$MPTR{'user'}	= 2;
			$MPTR{'wdate'}	= 3;
			$MPTR{'mstart'}	= 5;
			$MPTR{'mend'}	= @msgline - 5;
			$top = 0;
			$btm = 0;
			
			$k = '';
			for ( $i = 0 ; $i < @oldlog ; $i++ ) {
				
				if ( $oldlog[$i] =~ /^<!-- \d+ -->/ ) {
					# ���b�Z�[�W�u���b�N�̐擪
					$top = $i;
				} elsif ( $oldlog[$i] =~ /^<!-- -->/ ) {
					# ���b�Z�[�W�u���b�N�̖���
					$btm = $i;
				}
				
				if ( $top > 0 ) {
					#
					#  0 : �^�[�~�l�[�^�[������
					#  1 : �薼
					#  2 : ���e�Җ�
					#  3 : ���e����
					#  5 �` @msgline - 5 : ���b�Z�[�W
					# @msgline - 1 : �^�[�~�l�[�^�[������
					# ���b�Z�[�W�u���b�N���̏���
					if ( $oldlog[$i] =~ /$msgline[$MPTR{'user'}]/ ) {
						# ���e��
						if ( ( $FORM{'tt'} eq 'u' ) || ( $FORM{'tt'} eq 'a' ) ) {
							$k .= $1
						}
					} elsif ( $oldlog[$i] =~ /^$msgline[$MPTR{'title'}]$/ ) {
						# �薼
						if ( ( $FORM{'tt'} eq 't' ) || ( $FORM{'tt'} eq 'a' ) ) {
							$k .= $2
						}
					} elsif ( $oldlog[$i] =~ /^$msgline[$MPTR{'wdate'}]$/ ) {
						$1 =~ m#\d+/(\d+)/(\d+)\D+(\d+)\D+(\d+)\D+\d+\D+#;
						$wmon = $1;
						$wday = $2;
						$whor = $3;
						$wmin = $4;
						if ( ( $FORM{'s1'} < $whor || ( $FORM{'s1'} == $whor && $FORM{'e1'} <= $wmin ) ) &&
						  ( $FORM{'s2'} > $whor || ( $FORM{'s2'} == $whor && $FORM{'e2'} >= $wmin ) ) ) {
							$hit = 1;
						} else {
							$hit = 0;
						}
					} elsif ( $oldlog[$i] =~ /^$msgline[$MPTR{'mstart'}]$/ ) {
						$msg = $i;
					} elsif ( $oldlog[$i] =~ /^$msgline[$MPTR{'mend'}]$/ ) {
						$msg = 0;
					} elsif ( $msg > 0 ) {
						if ( $FORM{'tt'} eq 'a' ) {
							$k .= $oldlog[$i];
						}
					}
					
					push ( @prtbuf, $oldlog[$i] );
					
					if ( $btm > 0 ) {
						if ( $hit > 0 ) {
							$hit = 0;
							$j = 0;
							if ( $FORM{'ao'} eq 'o' ) {			# OR����
								while ( $j < @keyword && !$hit ) {
									if ( ( $FORM{'alp'} && $k =~ /$keyword[$j]/i ) ||
									  ( $k =~ /$keyword[$j]/ ) ) {
										$hit++;
									} else {
										$j++;
									}
								}
							} else {
								while ( $j < @keyword ) {		# AND����
									if ( ( $FORM{'alp'} && $k =~ /$keyword[$j]/i ) ||
									  ( $k =~ /$keyword[$j]/ ) ) {
										$hit++;
									}
									$j++;
								}
								if ( $hit != @keyword ) {
									$hit = 0;
								}
							}
							if ( !$FORM{'kwd'} || ( $hit > 0 ) ) {
								$hitcount++;
								print @prtbuf;
							}
						}
						undef @prtbuf;
						$k = '';
						$top = 0;
						$btm = 0;
					}
				}
				
			} # for
			
			if ( $FORM{'kwd'} ) {
				if ( $hitcount > 0 ) {
					print "<H3>$hitcount��������܂����B</H3>";
				} else {
					print "<H3>�w�肳�ꂽ�L�[���[�h�ɊY�����郁�b�Z�[�W�͌�����܂���ł����B</H3>";
				}
			}
			
		} else {
			
			# �S���b�Z�[�W�\��
			foreach ( @oldlog ) {
				print;
			}
		}
		
	} else {
		
		# �V�o�[�W�����̉ߋ����O
		if ( $FORM{'btn'} ) {
			$FORM{'btn'} = 1;
		} else {
			$FORM{'btn'} = 2;
		}
		
		print "<H1>$FORM{'e'}</H1><HR>";
		$i = 0;
		if ( $FORM{'sv'} ) {
			while ( $i < @oldlog ) {
				&getmessage ( $oldlog[$i] );
				if (
				 ( !$oldlogsavesw &&
				 ( ( $FORM{'s1'} < $hour || ( $FORM{'s1'} == $hour && $FORM{'e1'} <= $min ) ) &&
				   ( $FORM{'s2'} > $hour || ( $FORM{'s2'} == $hour && $FORM{'e2'} >= $min ) ) ) ) ||
				 ( $oldlogsavesw &&
				 ( ( $FORM{'s1'} < $mday || ( $FORM{'s1'} == $mday && $FORM{'e1'} <= $hour ) ) &&
				   ( $FORM{'s2'} > $mday || ( $FORM{'s2'} == $mday && $FORM{'e2'} >= $hour ) ) ) ) ) {
					if ( !$FORM{'kwd'} ) {
						print &prtmessage ( $FORM{'btn'}, "$FORM{'e'}" );
					} else {
						$j = 0;
						$hit = 0;
						$k = '';
						if ( ( $FORM{'tt'} eq 'u' ) || ( $FORM{'tt'} eq 'a' ) ) {
							$k .= $user;
						}
						if ( ( $FORM{'tt'} eq 't' ) || ( $FORM{'tt'} eq 'a' ) ) {
							$k .= $title;
						}
						if ( $FORM{'tt'} eq 'a' ) {
							$k .= $msg;
						}
						if ( $FORM{'ao'} eq 'o' ) {
							while ( $j < @keyword && !$hit ) {
								if ( ( $FORM{'alp'} && $k =~ /$keyword[$j]/i ) ||
								  ( $k =~ /$keyword[$j]/ ) ) {
									$hit++;
								} else {
									$j++;
								}
							}
						} else {
							while ( $j < @keyword ) {
								if ( ( $FORM{'alp'} && $k =~ /$keyword[$j]/i ) ||
								  ( $k =~ /$keyword[$j]/ ) ) {
									$hit++;
								}
								$j++;
							}
							if ( $hit != @keyword ) {
								$hit = 0;
							}
						}
						if ( $hit > 0 ) {
							print &prtmessage ( $FORM{'btn'} );
							$hitcount++;
						}
					}
				}
				$i++;
			} # while
			
			if ( $FORM{'kwd'} ) {
				if ( $hitcount > 0 ) {
					print "<H3>$hitcount��������܂����B</H3>";
				} else {
					print "<H3>�w�肳�ꂽ�L�[���[�h�ɊY�����郁�b�Z�[�W�͌�����܂���ł����B</H3>";
				}
			}
			
		} else {
			# �S���b�Z�[�W�\��
			while ( $i < @oldlog ) {
				&getmessage ( $oldlog[$i] );
				print &prtmessage ( $FORM{'btn'} );
				$i++;
			}
		}
		print "\n</BODY>\n</HTML>\n";
	}
}


###############################################################################
#  Getlog ���C������
###############################################################################

sub getlog {
	
	my ( $sendfile, $fcount );
	
	$FORM{'e'} =~ /^([\w.]*)$/;
	$FORM{'e'} = $1;
	
	if ( $FORM{'e'} || $FORM{'sv'} ) {
		$FORM{'kwd'} =~ s/\0/\,/g;
		
		if ( !$FORM{'e'} ) {
			
			&prthtmlhead ( "$bbstitle �ߋ����O" );
			$fcount = 0;
			foreach ( sort keys %FORM ) {
				if ( $_ =~ /^chk([\w.]+)$/ && $FORM{$_} eq 'checked' ) {
					$FORM{'e'} = $1;
					&prtoldlog;
					$fcount++;
				}
			}
			if ( !$fcount ) {
				&prterror ( '�\������t�@�C�����w�肵�Ă��������B' );
			}
			
		} else {
			
			if ( $FORM{'dl'} eq '1' ) {
				$sendfile = $FORM{'e'};
				$sendfile =~ /(.+\.)(.+)/;
				if ( $2 =~ /dat/ ) {
					$sendfile =~ s/dat/html/;
				}
				print <<EOF;
Content-type: application/octet-stream
Content-Disposition: attachment; filename="$sendfile"

<HTML>
<HEAD>
<TITLE>$bbstitle �ߋ����O</TITLE>
<META http-equiv="Content-Type" content="text/html; charset=Shift_JIS">
</HEAD>

$body
EOF
			} else {
				&prthtmlhead ( "$bbstitle �ߋ����O $FORM{'e'}" );
			}
			&prtoldlog;
		}
		
	} else {
		&oldloglist;
	}
}



1;


__END__
