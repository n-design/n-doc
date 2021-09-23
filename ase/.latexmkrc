@default_files = ('ase.tex');

open( my $fh, '<', "../common/latexmkrc" ) or die "Can't open file: $!";
while ( my $line = <$fh> ) {
    eval $line
}
close $fh;

add_cus_dep( 'acn', 'acr', 0, 'makeglossaries' );
add_cus_dep( 'glo', 'gls', 0, 'makeglossaries' );
$clean_ext .= " acr acn alg glo gls glg";

sub makeglossaries {
    my ($base_name, $path) = fileparse( $_[0] );
    pushd $path;
    my $return = system "makeglossaries", $base_name;
    popd;
    return $return;
}