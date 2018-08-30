# NAME

Repetition::Interval - A library to calculate intervals for spaced repetition memorization

# VERSION

version 0.001

# SYNOPSIS

    use 5.014;

    use Repitition::Interval;

    my $sched = Repetition::Interval->new();
    my $new_avg = $sched->calculate_new_mean(4, 1, undef);
    my $next_review = $sched->schedule_next_review(4, 1, $new_avg);

    # the interval is 2
    say "this item should be reviewed again in $next_review days"

# OVERVIEW

This library uses a spaced repetition algorithm to schedule review periods for
items you wish to memorize. The basic idea is you assign a grade between 0-5 to
items you're reviewing. These grades should be based on how difficult it was
for you to recall the item from memory. Lower grades will cause the algorithm
to schedule the item more frequently, and higher scores will cause the item to
scheduled at longer and longer intervals.

The algorithm implemented here is based on the algorithm described in the
[ssrf](https://github.com/AdamDz/ssrf-python) python project.

# ATTRIBUTES

## default\_avg\_grade

This attribute describes the default average grade. Adjusting this number will
impact the initial review period. It is read-only and must be a natural number.
The default value is 2.5.

## priority

This value affects how long or short intervals are calculated. The higher the number
the smaller the intervals between reviews. (That is, the item is scheduled more
frequently.) This is a read-only value. It must be an integer. The default value
is 4.

# METHODS

## new

The object constructor. You may pass values for the object attributes in during
initialization if you wish.

## calculate\_new\_mean

Required parameters are:

- current grade (as an integer)
- number of reviews for this item (as an integer)
- previous mean (as a float)

This method calculates a new mean of the grades for this item. This is a value
you will need to persist since it directly affects scheduling frequency. It
returns a float.

## schedule\_next\_review

This method calculates the next review interval expressed in days from "now"
whatever that might mean in your application context.

Required parameters are:

- current grade (as an integer)
- number of reviews for this item (as an integer)
- the mean of all grades for this item including the current review grade (float)

This method returns an integer representing "days"

## schedule\_next\_review\_seconds

Syntactic sugar to express the interval in seconds so that calculating the next
date using UNIX epoch seconds is much easier.

It has exactly the same parameters as the call above: current grade, the review
count, and the mean of all grades for all reviews.

# AUTHOR

Mark Allen <mallen@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2018 by Mark Allen.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
