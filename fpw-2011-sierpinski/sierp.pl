use Test;

class Node {
    has @.parents;
}

sub dump(Node $s) {
    my %color;
    my $index = 0;
    my @result;

    sub visit(Node $n) {
        return if %color.exists($n);
        %color{$n} = "being visited";
        for $n.parents.flat -> $p {
            visit($p);
        }
        %color{$n} = ++$index;
        my $parents = $n.parents
                        ?? "(" ~ join(" ", %color{$n.parents.list}.sort) ~ ")"
                        !! "";
        push @result, $index ~ $parents;
    }

    visit($s);
    return join " ", @result;
}

sub sierp(Int $size, Node $u = Node.new) {
    if $size <= 1 {
        return $u, $u;
    }

    my ($lp1, $lp2, $r) = chipped($size, $u);
    my $l = Node.new(:parents($lp1, $lp2));

    return $l, $r;
}

sub chipped(Int $size, Node $u, $rp1?, $rp2?) {
    if $size <= 2 {
        my $r = defined($rp1) ?? Node.new(:parents($u, $rp1, $rp2))
                              !! Node.new(:parents($u));
        return $u, $r, $r;
    }

    my ($Ul, $Ur)          = sierp($size - 1, $u);
    my ($Rlp1, $Rlp2, $Rr) = chipped($size - 1, $Ur);
    my ($Llp1, $Llp2, $Lr) = chipped($size - 1, $Ul, $Rlp1, $Rlp2);

    return $Llp1, $Llp2, $Rr;
}

{
    my ($s) = sierp(1);
    is dump($s), "1", "sierp triangle of size 1";
}

{
    my ($s) = sierp(2);
    is dump($s), "1 2(1) 3(1 2)", "sierp triangle of size 2";
}

{
    my ($s) = sierp(3);
    is dump($s), "1 2(1) 3(1 2) 4(2) 5(2 3 4) 6(3 5)",
                 "sierp triangle of size 3";
}

{
    my ($s) = sierp(4);
    is dump($s), "1 2(1) 3(1 2) 4(2) 5(2 3 4) 6(3 5) 7(6) 8(6 7) 9(7) 10(7 8 9) 11(8 10)",
                 "sierp triangle of size 4";
}
