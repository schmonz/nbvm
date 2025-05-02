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

## Goals

### Short-term

- Automate more manual steps
- Add non-`qemu` guests
  (such as [NetBSD/vax](https://www.netbsd.org/ports/vax/emulator-howto.html))
- Start VMs automatically, catching `nb boot` output someplace

### Long-term

- Have these tools adopted as official pkgsrc infrastructure, so we can provide a wide variety of platforms to all pkgsrc developers
