  .section .text.startup
  .align 2
  .global main

main:

  la $gp, _gp
  la $sp, 0xA20000
  j main_user
