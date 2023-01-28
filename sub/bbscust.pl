#! /usr/bin/perl

#
#	くずはすくりぷと Rev.0.1 Preview 9 (2000.9.3)
#	 (個人用環境設定画面用関数群)
#


###############################################################################
#  環境設定画面表示
###############################################################################

sub prtcustom {
	
	my ( @follow, @reload );
	$follow[$followwin] = 'checked';
	$reload[$reltype] = 'checked';
	
	&prthtmlhead ( "$bbstitle Personal Settings" );
	print <<EOF;
<H3>$bbstitle Personal Settings</H3><BR>
<FORM method="post" action="$cgiurl">
  <INPUT type="hidden" name="m" value="c">
  <INPUT type="hidden" name="nm" value="$FORM{'m'}">
  <UL>
    <LI><STRONG>Table Settings</STRONG><BR> <BR>
    <TABLE border="0" cellspacing="0" cellpadding="0">
      <TR>
        <TD>Text color　　　</TD>
        <TD><INPUT type="text" name="tc" size="7" value="$CC{'text'}"></TD>
        <TD>　Background color</TD>
        <TD><INPUT type="text" name="bc" size="7" value="$CC{'bg'}"></TD>
      </TR>
      <TR>
        <TD>Link color</TD>
        <TD><INPUT type="text" name="lc" size="7" value="$CC{'link'}"></TD>
        <TD>　V-Link color </TD>
        <TD><INPUT type="text" name="vc" size="7" value="$CC{'vlink'}"></TD>
      </TR>
      <TR>
        <TD>Quoted text color (greentext)</TD>
        <TD><INPUT type="text" name="qc" size="7" value="$CC{'qmsgc'}"></TD>
        <TD>　</TD>
        <TD>　</TD>
      </TR>
    </TABLE>
  </UL>
  <UL>
    <LI><STRONG>Additional Function Settings</STRONG><BR> <BR>
    G-zip compressed transfer <INPUT type="checkbox" name="g" value="checked" $S_gzchk[$gzipu]><BR>
    Automatic URL linking <INPUT type="checkbox" name="a" value="checked" $S_alchk[$autolink]><BR>
  </UL>
  <UL>
    <LI><STRONG>Follow-up screen table method</STRONG><BR> <BR>
    <INPUT type="radio" name="fw" value="0" $follow[0]>Open a new window and display the table<BR>
    <INPUT type="radio" name="fw" value="1" $follow[1]>Displaying a table without opening a new window<BR>
  </UL>
  <UL>
    <LI><STRONG>How to display messages when reloading nothing</STRONG><BR> <BR>
    <INPUT type="radio" name="rt" value="0" $reload[0]>Standard（Posting time descending table\示）<BR>
    <INPUT type="radio" name="rt" value="1" $reload[1]>Reversed（Posting time ascending table）<BR>
  </UL>
  <BR>
  Bookmark the URL displayed after pressing "Register". <BR>
  You can visit the bulletin board with the above settings. <BR> <BR>
  <INPUT type="submit" value="Register">
  <INPUT type="reset" value="Reset">
  <INPUT type="submit" name="cr" value="Return to default value">
  <INPUT type="submit" name="cdc" value="Cookie Erasure">
</FORM>
</BODY>
</HTML>
EOF
}


###############################################################################
#  環境設定結果画面表示
###############################################################################

sub setcustom {
	
	my ( $p1, $p2, $p3, $nm, %alchk, %gzchk );
	
	if ( !$FORM{'cr'} ) {
		$alchk{'checked'} = 1;
		$gzchk{'checked'} = 1;
		$p1 = sprintf ( "%x", $alchk{"$FORM{'a'}"} + $FORM{'fw'} * 2 + $FORM{'rt'} * 4 + $gzchk{"$FORM{'g'}"} * 8 );
		$p2 = 0;
		$p3 = 0;
		if ( $FORM{'nm'} eq 'op' ) {
			$nm = 'm=o&';
		} else {
			$nm = '';
		}
		$FORM{'c'} = "$FORM{'tc'}$FORM{'bc'}$FORM{'lc'}$FORM{'vc'}$FORM{'qc'}$p1$p2$p3";
	} else {
		$FORM{'c'} = '';
	}
	
	if ( $FORM{'cdc'} ) {
		&putcookie ( $S_cexp - 2 );
	} else {
		&putcookie ( 0 ) if ( $cookie );
	}
	print "Location: $cgiurl?${nm}c=$FORM{'c'}\n\n";
}


1;


__END__
