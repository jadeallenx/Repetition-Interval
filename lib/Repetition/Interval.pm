package Repetition::Interval;

use Moo;
use strictures 2;
use Types::Standard qw(Num Int);
use POSIX qw(round);
use namespace::clean;

# ABSTRACT: A library to calculate intervals for spaced repetition memorization

=head1 SYNOPSIS

=head1 OVERVIEW

=cut

has default_avg_grade => (
    is => 'ro',
    isa => Num,
    default => sub { 2.5; }
);

has priority => (
    is => 'ro',
    isa => Int,
    default => sub { 4; }
);

sub calculate_new_mean {
    my ($self, $current_grade, $review_cnt, $prev_mean) = @_;

    return ($self->default_avg_grade() + $current_grade) / 2 if $review_cnt == 1;

    return (($prev_mean*$review_cnt)/($review_cnt + 1)) + ($current_grade / ($review_cnt + 1));
}

sub schedule_next_review {
    my ($self, $current_grade, $review_cnt, $mean_of_grades) = @_;

    return round(1 + exp($current_grade - $self->priority())*$review_cnt**($mean_of_grades/2));
}

sub schedule_next_review_seconds {
    my $self = shift;
    return ($self->schedule_next_review(@_))*86_400;
}

1;
