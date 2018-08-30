package Repetition::Interval;

use Moo;
use strictures 2;
use Types::Standard qw(Num Int);
use POSIX qw(round);
use namespace::clean;

# ABSTRACT: A library to calculate intervals for spaced repetition memorization

=head1 SYNOPSIS

  use 5.014;

  use Repitition::Interval;

  my $sched = Repetition::Interval->new();
  my $new_avg = $sched->calculate_new_mean(4, 1, undef);
  my $next_review = $sched->schedule_next_review(4, 1, $new_avg);

  # the interval is 2
  say "this item should be reviewed again in $next_review days"

=head1 OVERVIEW

This library uses a spaced repetition algorithm to schedule review periods for
items you wish to memorize. The basic idea is you assign a grade between 0-5 to
items you're reviewing. These grades should be based on how difficult it was
for you to recall the item from memory. Lower grades will cause the algorithm
to schedule the item more frequently, and higher scores will cause the item to
scheduled at longer and longer intervals.

The algorithm implemented here is based on the algorithm described in the
L<ssrf|https://github.com/AdamDz/ssrf-python> python project.

=cut

=attr default_avg_grade

This attribute describes the default average grade. Adjusting this number will
impact the initial review period. It is read-only and must be a natural number.
The default value is 2.5.

=cut
has default_avg_grade => (
    is => 'ro',
    isa => Num,
    default => sub { 2.5; }
);

=attr priority

This value affects how long or short intervals are calculated. The higher the number
the smaller the intervals between reviews. (That is, the item is scheduled more
frequently.) This is a read-only value. It must be an integer. The default value
is 4.

=cut
has priority => (
    is => 'ro',
    isa => Int,
    default => sub { 4; }
);

=method new

The object constructor. You may pass values for the object attributes in during
initialization if you wish.

=method calculate_new_mean

Required parameters are:

=over 4

=item * current grade (as an integer)

=item * number of reviews for this item (as an integer)

=item * previous mean (as a float)

=back

This method calculates a new mean of the grades for this item. This is a value
you will need to persist since it directly affects scheduling frequency. It
returns a float.

=cut

sub calculate_new_mean {
    my ($self, $current_grade, $review_cnt, $prev_mean) = @_;

    return ($self->default_avg_grade() + $current_grade) / 2 if $review_cnt == 1;

    return (($prev_mean*$review_cnt)/($review_cnt + 1)) + ($current_grade / ($review_cnt + 1));
}

=method schedule_next_review

This method calculates the next review interval expressed in days from "now"
whatever that might mean in your application context.

Required parameters are:

=over 4

=item * current grade (as an integer)

=item * number of reviews for this item (as an integer)

=item * the mean of all grades for this item including the current review grade (float)

=back

This method returns an integer representing "days"

=cut

sub schedule_next_review {
    my ($self, $current_grade, $review_cnt, $mean_of_grades) = @_;

    return round(1 + exp($current_grade - $self->priority())*$review_cnt**($mean_of_grades/2));
}

=method schedule_next_review_seconds

Syntactic sugar to express the interval in seconds so that calculating the next
date using UNIX epoch seconds is much easier.

It has exactly the same parameters as the call above: current grade, the review
count, and the mean of all grades for all reviews.

=cut

sub schedule_next_review_seconds {
    my $self = shift;
    return ($self->schedule_next_review(@_))*86_400;
}

1;
