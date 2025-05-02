# nbvm

N.B.: now boot, no biggie.
See also [nbpkg](https://github.com/schmonz/nbpkg).

## What's here

For increasingly arbitrary combinations of...

- Unixy host/guest OSes
- hardware architectures
- emulation and virtualization tools

...we have a consistent shell UI...

- for **host** to control headless guest VMs: `nb`
- for **guest** to perform various in-system actions: `nbvm`

(There are also a few miscellaneous supporting scripts waiting to be properly integrated into these.)

Easy access to a variety of platforms serves a couple purposes for me:

- Test-build pkgsrc packages
- Test-build other Unix software (e.g., [notqmail](https://notqmail.org))

What purposes could it serve for you?

## Long-term goal

If official pkgsrc infrastructure were to include an OS zoo...

- Developers could easily test on a variety of platforms
- Official builds for a variety of platforms could be more easily published

In short, pkgsrc would be easier to maintain carefully and to use widely.

I want these outcomes, so I'm designing with the target environment in mind.
I've [designed and deployed to this infrastructure before](https://wiki.netbsd.org/wiki/todo/choose_wiki_software/).
