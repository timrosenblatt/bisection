# Practice repo for `git bisect`

`git bisect` is a [great tool](https://git-scm.com/docs/git-bisect) but sometimes it helps to have a practice repo to test with.

This repo contains a small amount of code and specs. Our specs are passing, but it turns out there's a bug. `./walk_the_dogs.rb` is an executable script that makes a `Walker` walk `Dog`s, and it is crashing. We know it worked before, so we've got a regression on our hands.

There are over 200 commits in this repo, both our own work, and other people's. All we know is that the code used to work, and now doesn't. We could spend time reading the code and tracing through the issue...or we can use `bisect` to find the commit where the bug showed up, and see the code (and commit) that caused it. It's like `git blame` but instead of tracing down a line of code, you can trace actual functionality.

The gist is that you find a SHA where the code is good, and one where it is bad. Git will find a commit around the middle and check it out, giving you the opportunity to decide if it is good or not. If it's good, we go forward in time to find the bug. If it's bad, we go farther back in time to look for another good commit. We'll zig and zag back and forth through the code until we hit the first commit where the behavior shows up.

For this demo, let's just search every commit since the beginning of time. In reality, you can almost always use good judgement to find a SHA that's closer to `HEAD` before the bug showed up.

Grabbing the first commit:

`git log --reverse | head -1`

and you get

`commit 3e026567e0013354ae6763d254b99e31c0c65b36`

Let's start the process:

```
git bisect start
git bisect good 3e026567e0013354ae6763d254b99e31c0c65b36
git bisect bad HEAD
```

Now git knows that which commits we want to search between. It's going to do some math, and check out a commit around the middle.

```
Bisecting: 135 revisions left to test after this (roughly 7 steps)
[283404db12763b4e3e84f9b5c3281074723cd11b] 65b7aa75
```

At this point, we're somewhere in the middle. We don't know if the bug is present here or not.

```
./walk_the_dogs.rb
All dogs walked!
```

OK, so that works. Let's tell git that this commit is good. (If it didn't work, we'd run `git bisect bad`)

```
git bisect good

Bisecting: 67 revisions left to test after this (roughly 6 steps)
[0a56b7933c066e1597357e8515dec90b1fa5d8b1] 5bd81cb1
```

We're now on a new commit, checked out somewhere between this new commit and `HEAD`. Are we at the bug yet?

```
./walk_the_dogs.rb

All dogs walked!
All dogs fed
```

Nope. Let's tell git that it's good again.

```
git bisect good

Bisecting: 33 revisions left to test after this (roughly 5 steps)
[6ca4dd8058ef3ed415aec111956e72cfab21e042] other people's work
```

This keeps going. You run a test and decide if the code is what you want or not. If it's not, you run `git bisect bad`

(If you wanted to know which commits are left to search, `g bisect visualize` will return a `log`-like output of the commits left to be searched.)

```
Bisecting: 3 revisions left to test after this (roughly 2 steps)
[f1ba8e041baa8dfc70e2dfdd409a64403408f520] other people's work

./walk_the_dogs.rb

bisection/dog.rb:13:in `walk': Needs to eat (ArgumentError)
	from bisection/taco.rb:7:in `walk'
	from ruby/2.3.0/set.rb:306:in `each_key'
	from ruby/2.3.0/set.rb:306:in `each'
	from bisection/walker.rb:14:in `map'
	from bisection/walker.rb:14:in `walk_dogs'
	from ./walk_the_dogs.rb:14:in `<main>'
```

This commit contains the bug.

```
git bisect bad

Bisecting: 1 revision left to test after this (roughly 1 step)
[916c135249cc09f4750832aba8c79e6935a76194] other people's work

./walk_the_dogs.rb

All dogs walked!
All dogs fed
Lots of walking

git bisect good

Bisecting: 0 revisions left to test after this (roughly 0 steps)
[06dccf32cce8a23e074b4013b3bf459b24370838] updated taco to meet specification

./walk_the_dogs.rb

bisection/dog.rb:13:in `walk': Needs to eat (ArgumentError)
	from bisection/taco.rb:7:in `walk'
	from ruby/2.3.0/set.rb:306:in `each_key'
	from ruby/2.3.0/set.rb:306:in `each'
	from bisection/walker.rb:14:in `map'
	from bisection/walker.rb:14:in `walk_dogs'
	from ./walk_the_dogs.rb:14:in `<main>'


git bisect bad

06dccf32cce8a23e074b4013b3bf459b24370838 is the first bad commit
commit 06dccf32cce8a23e074b4013b3bf459b24370838
Author: Tim Rosenblatt <tim.rosenblatt@futureadvisor.com>
Date:   Fri Nov 18 21:08:35 2016 -0800

    updated taco to meet specification

:100644 100644 c74739cdb393bfb1e22a22fc3b95cec406b317a9 d1d2ab3a152ba4fc390e2ba12c72d8c59580321d M	taco.rb
```

Well, there's some information about the first commit where the bug showed up.

Now we're in the bad commit, as if we had checked it out ourselves. Git is basically just leaving the repo at the commit that failed the test.

Let's take a look at the code that introduced the problem:

`git diff HEAD^ HEAD`

Oh.

```
diff --git a/taco.rb b/taco.rb
index c74739c..d1d2ab3 100644
--- a/taco.rb
+++ b/taco.rb
@@ -8,4 +8,8 @@ class Taco < Dog

     :fast
   end
+
+  def hungry?
+    true
+  end
 end
```

Seriously, **Taco is always hungry.** He just isn't interested in you unless you are about to feed him. We probably need to change the walker so that they know how to deal with Taco.

Now that you're done, run `git bisect reset` to go back to the repo where you started.

So here's the thing about `bisect`. The important thing is that you have some way of deciding if the code is "good" or "bad". Sometimes you might just be reading a piece of code, other times you might have an automated test like a spec file or an executable.

You might be wondering "well, if I have a script, can't I use some code to automatically tell git if a command is good or not?" Git has you covered:

`git bisect run ruby ./walk_the_dogs.rb`

This will make git run `ruby ./walk_the_dogs.rb` on each checkout. If the command runs properly (and returns an exit code of `0`), the commit is treated as good. If it errors (exit code of anything except `0`), the commit is treated as bad.

Run it, and in about 2 seconds, a lot of text will scroll by, ending in:

```
06dccf32cce8a23e074b4013b3bf459b24370838 is the first bad commit
commit 06dccf32cce8a23e074b4013b3bf459b24370838
Author: Tim Rosenblatt <tim.rosenblatt@futureadvisor.com>
Date:   Fri Nov 18 21:08:35 2016 -0800

    updated taco to meet specification

:100644 100644 c74739cdb393bfb1e22a22fc3b95cec406b317a9 d1d2ab3a152ba4fc390e2ba12c72d8c59580321d M	taco.rb
bisect run success
```

Nice. Run `git bisect reset` to get out of `bisect` mode and go back to the normal repo.
