use v6;

class RPGCharacter {
    has Int $.hit-point;
    has Int $.damage;
    has Int $.mana;
}

sub MAIN {
    my $boss = RPGCharacter.new( :hit-point(51), :damage(9), :mana(0) );
    my $player = RPGCharacter.new( :hit-point(100), :damage(0), :mana(250) );
    say $boss;
}
