
build_sf32lb52-lchspi-ulp_hcpu\bootloader\bootloader.elf:     file format elf32-littlearm


Disassembly of section .text:

20020208 <deregister_tm_clones>:
20020208:	4803      	ldr	r0, [pc, #12]	@ (20020218 <deregister_tm_clones+0x10>)
2002020a:	4b04      	ldr	r3, [pc, #16]	@ (2002021c <deregister_tm_clones+0x14>)
2002020c:	4283      	cmp	r3, r0
2002020e:	d002      	beq.n	20020216 <deregister_tm_clones+0xe>
20020210:	4b03      	ldr	r3, [pc, #12]	@ (20020220 <deregister_tm_clones+0x18>)
20020212:	b103      	cbz	r3, 20020216 <deregister_tm_clones+0xe>
20020214:	4718      	bx	r3
20020216:	4770      	bx	lr
20020218:	200449f8 	.word	0x200449f8
2002021c:	200449f8 	.word	0x200449f8
20020220:	00000000 	.word	0x00000000

20020224 <register_tm_clones>:
20020224:	4b06      	ldr	r3, [pc, #24]	@ (20020240 <register_tm_clones+0x1c>)
20020226:	4907      	ldr	r1, [pc, #28]	@ (20020244 <register_tm_clones+0x20>)
20020228:	1ac9      	subs	r1, r1, r3
2002022a:	1089      	asrs	r1, r1, #2
2002022c:	bf48      	it	mi
2002022e:	3101      	addmi	r1, #1
20020230:	1049      	asrs	r1, r1, #1
20020232:	d003      	beq.n	2002023c <register_tm_clones+0x18>
20020234:	4b04      	ldr	r3, [pc, #16]	@ (20020248 <register_tm_clones+0x24>)
20020236:	b10b      	cbz	r3, 2002023c <register_tm_clones+0x18>
20020238:	4801      	ldr	r0, [pc, #4]	@ (20020240 <register_tm_clones+0x1c>)
2002023a:	4718      	bx	r3
2002023c:	4770      	bx	lr
2002023e:	bf00      	nop
20020240:	200449f8 	.word	0x200449f8
20020244:	200449f8 	.word	0x200449f8
20020248:	00000000 	.word	0x00000000

2002024c <__do_global_dtors_aux>:
2002024c:	b510      	push	{r4, lr}
2002024e:	4c06      	ldr	r4, [pc, #24]	@ (20020268 <__do_global_dtors_aux+0x1c>)
20020250:	7823      	ldrb	r3, [r4, #0]
20020252:	b943      	cbnz	r3, 20020266 <__do_global_dtors_aux+0x1a>
20020254:	f7ff ffd8 	bl	20020208 <deregister_tm_clones>
20020258:	4b04      	ldr	r3, [pc, #16]	@ (2002026c <__do_global_dtors_aux+0x20>)
2002025a:	b113      	cbz	r3, 20020262 <__do_global_dtors_aux+0x16>
2002025c:	4804      	ldr	r0, [pc, #16]	@ (20020270 <__do_global_dtors_aux+0x24>)
2002025e:	f3af 8000 	nop.w
20020262:	2301      	movs	r3, #1
20020264:	7023      	strb	r3, [r4, #0]
20020266:	bd10      	pop	{r4, pc}
20020268:	200449f8 	.word	0x200449f8
2002026c:	00000000 	.word	0x00000000
20020270:	2002c4bc 	.word	0x2002c4bc

20020274 <frame_dummy>:
20020274:	b508      	push	{r3, lr}
20020276:	4b05      	ldr	r3, [pc, #20]	@ (2002028c <frame_dummy+0x18>)
20020278:	b11b      	cbz	r3, 20020282 <frame_dummy+0xe>
2002027a:	4905      	ldr	r1, [pc, #20]	@ (20020290 <frame_dummy+0x1c>)
2002027c:	4805      	ldr	r0, [pc, #20]	@ (20020294 <frame_dummy+0x20>)
2002027e:	f3af 8000 	nop.w
20020282:	e8bd 4008 	ldmia.w	sp!, {r3, lr}
20020286:	f7ff bfcd 	b.w	20020224 <register_tm_clones>
2002028a:	bf00      	nop
2002028c:	00000000 	.word	0x00000000
20020290:	200449fc 	.word	0x200449fc
20020294:	2002c4bc 	.word	0x2002c4bc

20020298 <boot_uart_tx>:
20020298:	2300      	movs	r3, #0
2002029a:	b510      	push	{r4, lr}
2002029c:	4293      	cmp	r3, r2
2002029e:	db00      	blt.n	200202a2 <boot_uart_tx+0xa>
200202a0:	bd10      	pop	{r4, pc}
200202a2:	69c4      	ldr	r4, [r0, #28]
200202a4:	0624      	lsls	r4, r4, #24
200202a6:	d5fc      	bpl.n	200202a2 <boot_uart_tx+0xa>
200202a8:	5ccc      	ldrb	r4, [r1, r3]
200202aa:	3301      	adds	r3, #1
200202ac:	6284      	str	r4, [r0, #40]	@ 0x28
200202ae:	e7f5      	b.n	2002029c <boot_uart_tx+0x4>

200202b0 <boot_error>:
200202b0:	b507      	push	{r0, r1, r2, lr}
200202b2:	2201      	movs	r2, #1
200202b4:	f88d 0007 	strb.w	r0, [sp, #7]
200202b8:	f10d 0107 	add.w	r1, sp, #7
200202bc:	480e      	ldr	r0, [pc, #56]	@ (200202f8 <boot_error+0x48>)
200202be:	f7ff ffeb 	bl	20020298 <boot_uart_tx>
200202c2:	4b0e      	ldr	r3, [pc, #56]	@ (200202fc <boot_error+0x4c>)
200202c4:	f8d3 2088 	ldr.w	r2, [r3, #136]	@ 0x88
200202c8:	f002 0203 	and.w	r2, r2, #3
200202cc:	2a03      	cmp	r2, #3
200202ce:	f102 0101 	add.w	r1, r2, #1
200202d2:	d00f      	beq.n	200202f4 <boot_error+0x44>
200202d4:	f8d3 2088 	ldr.w	r2, [r3, #136]	@ 0x88
200202d8:	f022 0203 	bic.w	r2, r2, #3
200202dc:	f8c3 2088 	str.w	r2, [r3, #136]	@ 0x88
200202e0:	f8d3 2088 	ldr.w	r2, [r3, #136]	@ 0x88
200202e4:	430a      	orrs	r2, r1
200202e6:	f8c3 2088 	str.w	r2, [r3, #136]	@ 0x88
200202ea:	f00c f92f 	bl	2002c54c <HAL_PMU_Reboot>
200202ee:	b003      	add	sp, #12
200202f0:	f85d fb04 	ldr.w	pc, [sp], #4
200202f4:	e7fe      	b.n	200202f4 <boot_error+0x44>
200202f6:	bf00      	nop
200202f8:	50084000 	.word	0x50084000
200202fc:	500ca000 	.word	0x500ca000

20020300 <HAL_MspInit>:
20020300:	2234      	movs	r2, #52	@ 0x34
20020302:	4b01      	ldr	r3, [pc, #4]	@ (20020308 <HAL_MspInit+0x8>)
20020304:	60da      	str	r2, [r3, #12]
20020306:	4770      	bx	lr
20020308:	50094000 	.word	0x50094000

2002030c <mpu_config>:
2002030c:	4770      	bx	lr

2002030e <cache_enable>:
2002030e:	4770      	bx	lr

20020310 <board_pinmux_mpi1_puya_base>:
20020310:	b510      	push	{r4, lr}
20020312:	2301      	movs	r3, #1
20020314:	2200      	movs	r2, #0
20020316:	2103      	movs	r1, #3
20020318:	2002      	movs	r0, #2
2002031a:	f004 fca7 	bl	20024c6c <HAL_PIN_Set>
2002031e:	2301      	movs	r3, #1
20020320:	2200      	movs	r2, #0
20020322:	4619      	mov	r1, r3
20020324:	200a      	movs	r0, #10
20020326:	f004 fca1 	bl	20024c6c <HAL_PIN_Set>
2002032a:	2301      	movs	r3, #1
2002032c:	2210      	movs	r2, #16
2002032e:	2109      	movs	r1, #9
20020330:	2008      	movs	r0, #8
20020332:	f004 fc9b 	bl	20024c6c <HAL_PIN_Set>
20020336:	2301      	movs	r3, #1
20020338:	2210      	movs	r2, #16
2002033a:	210a      	movs	r1, #10
2002033c:	2003      	movs	r0, #3
2002033e:	f004 fc95 	bl	20024c6c <HAL_PIN_Set>
20020342:	e8bd 4010 	ldmia.w	sp!, {r4, lr}
20020346:	2301      	movs	r3, #1
20020348:	2200      	movs	r2, #0
2002034a:	210c      	movs	r1, #12
2002034c:	200b      	movs	r0, #11
2002034e:	f004 bc8d 	b.w	20024c6c <HAL_PIN_Set>

20020352 <board_pinmux_mpi1_puya_ext>:
20020352:	b510      	push	{r4, lr}
20020354:	4604      	mov	r4, r0
20020356:	2101      	movs	r1, #1
20020358:	2005      	movs	r0, #5
2002035a:	f004 fe0b 	bl	20024f74 <HAL_PIN_Set_Analog>
2002035e:	2101      	movs	r1, #1
20020360:	2006      	movs	r0, #6
20020362:	f004 fe07 	bl	20024f74 <HAL_PIN_Set_Analog>
20020366:	2101      	movs	r1, #1
20020368:	2007      	movs	r0, #7
2002036a:	f004 fe03 	bl	20024f74 <HAL_PIN_Set_Analog>
2002036e:	2101      	movs	r1, #1
20020370:	2009      	movs	r0, #9
20020372:	f004 fdff 	bl	20024f74 <HAL_PIN_Set_Analog>
20020376:	2101      	movs	r1, #1
20020378:	200c      	movs	r0, #12
2002037a:	f004 fdfb 	bl	20024f74 <HAL_PIN_Set_Analog>
2002037e:	2101      	movs	r1, #1
20020380:	200d      	movs	r0, #13
20020382:	f004 fdf7 	bl	20024f74 <HAL_PIN_Set_Analog>
20020386:	2101      	movs	r1, #1
20020388:	b154      	cbz	r4, 200203a0 <board_pinmux_mpi1_puya_ext+0x4e>
2002038a:	4608      	mov	r0, r1
2002038c:	f004 fdf2 	bl	20024f74 <HAL_PIN_Set_Analog>
20020390:	2301      	movs	r3, #1
20020392:	2230      	movs	r2, #48	@ 0x30
20020394:	210b      	movs	r1, #11
20020396:	2004      	movs	r0, #4
20020398:	e8bd 4010 	ldmia.w	sp!, {r4, lr}
2002039c:	f004 bc66 	b.w	20024c6c <HAL_PIN_Set>
200203a0:	2004      	movs	r0, #4
200203a2:	f004 fde7 	bl	20024f74 <HAL_PIN_Set_Analog>
200203a6:	2301      	movs	r3, #1
200203a8:	2230      	movs	r2, #48	@ 0x30
200203aa:	210b      	movs	r1, #11
200203ac:	4618      	mov	r0, r3
200203ae:	e7f3      	b.n	20020398 <board_pinmux_mpi1_puya_ext+0x46>

200203b0 <board_pinmux_mpi1_gd>:
200203b0:	b508      	push	{r3, lr}
200203b2:	2200      	movs	r2, #0
200203b4:	2301      	movs	r3, #1
200203b6:	2103      	movs	r1, #3
200203b8:	2005      	movs	r0, #5
200203ba:	f004 fc57 	bl	20024c6c <HAL_PIN_Set>
200203be:	2301      	movs	r3, #1
200203c0:	2200      	movs	r2, #0
200203c2:	4619      	mov	r1, r3
200203c4:	200a      	movs	r0, #10
200203c6:	f004 fc51 	bl	20024c6c <HAL_PIN_Set>
200203ca:	2301      	movs	r3, #1
200203cc:	2210      	movs	r2, #16
200203ce:	2109      	movs	r1, #9
200203d0:	200c      	movs	r0, #12
200203d2:	f004 fc4b 	bl	20024c6c <HAL_PIN_Set>
200203d6:	2301      	movs	r3, #1
200203d8:	2210      	movs	r2, #16
200203da:	210a      	movs	r1, #10
200203dc:	2003      	movs	r0, #3
200203de:	f004 fc45 	bl	20024c6c <HAL_PIN_Set>
200203e2:	2301      	movs	r3, #1
200203e4:	2230      	movs	r2, #48	@ 0x30
200203e6:	210b      	movs	r1, #11
200203e8:	4618      	mov	r0, r3
200203ea:	f004 fc3f 	bl	20024c6c <HAL_PIN_Set>
200203ee:	2301      	movs	r3, #1
200203f0:	2230      	movs	r2, #48	@ 0x30
200203f2:	210c      	movs	r1, #12
200203f4:	2009      	movs	r0, #9
200203f6:	f004 fc39 	bl	20024c6c <HAL_PIN_Set>
200203fa:	2101      	movs	r1, #1
200203fc:	2002      	movs	r0, #2
200203fe:	f004 fdb9 	bl	20024f74 <HAL_PIN_Set_Analog>
20020402:	2101      	movs	r1, #1
20020404:	2004      	movs	r0, #4
20020406:	f004 fdb5 	bl	20024f74 <HAL_PIN_Set_Analog>
2002040a:	2101      	movs	r1, #1
2002040c:	2006      	movs	r0, #6
2002040e:	f004 fdb1 	bl	20024f74 <HAL_PIN_Set_Analog>
20020412:	2101      	movs	r1, #1
20020414:	2007      	movs	r0, #7
20020416:	f004 fdad 	bl	20024f74 <HAL_PIN_Set_Analog>
2002041a:	2101      	movs	r1, #1
2002041c:	2008      	movs	r0, #8
2002041e:	f004 fda9 	bl	20024f74 <HAL_PIN_Set_Analog>
20020422:	2101      	movs	r1, #1
20020424:	200b      	movs	r0, #11
20020426:	f004 fda5 	bl	20024f74 <HAL_PIN_Set_Analog>
2002042a:	e8bd 4008 	ldmia.w	sp!, {r3, lr}
2002042e:	2101      	movs	r1, #1
20020430:	200d      	movs	r0, #13
20020432:	f004 bd9f 	b.w	20024f74 <HAL_PIN_Set_Analog>

20020436 <board_pinmux_mpi2>:
20020436:	b510      	push	{r4, lr}
20020438:	2301      	movs	r3, #1
2002043a:	2200      	movs	r2, #0
2002043c:	2119      	movs	r1, #25
2002043e:	201e      	movs	r0, #30
20020440:	f004 fc14 	bl	20024c6c <HAL_PIN_Set>
20020444:	2301      	movs	r3, #1
20020446:	2200      	movs	r2, #0
20020448:	211b      	movs	r1, #27
2002044a:	201a      	movs	r0, #26
2002044c:	f004 fc0e 	bl	20024c6c <HAL_PIN_Set>
20020450:	2301      	movs	r3, #1
20020452:	2210      	movs	r2, #16
20020454:	2121      	movs	r1, #33	@ 0x21
20020456:	201d      	movs	r0, #29
20020458:	f004 fc08 	bl	20024c6c <HAL_PIN_Set>
2002045c:	2301      	movs	r3, #1
2002045e:	2210      	movs	r2, #16
20020460:	2122      	movs	r1, #34	@ 0x22
20020462:	201b      	movs	r0, #27
20020464:	f004 fc02 	bl	20024c6c <HAL_PIN_Set>
20020468:	2301      	movs	r3, #1
2002046a:	2230      	movs	r2, #48	@ 0x30
2002046c:	2123      	movs	r1, #35	@ 0x23
2002046e:	201c      	movs	r0, #28
20020470:	f004 fbfc 	bl	20024c6c <HAL_PIN_Set>
20020474:	e8bd 4010 	ldmia.w	sp!, {r4, lr}
20020478:	2301      	movs	r3, #1
2002047a:	2230      	movs	r2, #48	@ 0x30
2002047c:	2124      	movs	r1, #36	@ 0x24
2002047e:	201f      	movs	r0, #31
20020480:	f004 bbf4 	b.w	20024c6c <HAL_PIN_Set>

20020484 <board_pinmux_sd>:
20020484:	b510      	push	{r4, lr}
20020486:	2301      	movs	r3, #1
20020488:	2230      	movs	r2, #48	@ 0x30
2002048a:	f44f 71da 	mov.w	r1, #436	@ 0x1b4
2002048e:	201d      	movs	r0, #29
20020490:	f004 fbec 	bl	20024c6c <HAL_PIN_Set>
20020494:	2014      	movs	r0, #20
20020496:	f001 feb0 	bl	200221fa <HAL_Delay_us>
2002049a:	2301      	movs	r3, #1
2002049c:	2200      	movs	r2, #0
2002049e:	f44f 71d9 	mov.w	r1, #434	@ 0x1b2
200204a2:	201c      	movs	r0, #28
200204a4:	f004 fbe2 	bl	20024c6c <HAL_PIN_Set>
200204a8:	2301      	movs	r3, #1
200204aa:	2230      	movs	r2, #48	@ 0x30
200204ac:	f240 11b5 	movw	r1, #437	@ 0x1b5
200204b0:	201e      	movs	r0, #30
200204b2:	f004 fbdb 	bl	20024c6c <HAL_PIN_Set>
200204b6:	2301      	movs	r3, #1
200204b8:	2230      	movs	r2, #48	@ 0x30
200204ba:	f44f 71db 	mov.w	r1, #438	@ 0x1b6
200204be:	201f      	movs	r0, #31
200204c0:	f004 fbd4 	bl	20024c6c <HAL_PIN_Set>
200204c4:	2301      	movs	r3, #1
200204c6:	2230      	movs	r2, #48	@ 0x30
200204c8:	f240 11b7 	movw	r1, #439	@ 0x1b7
200204cc:	201a      	movs	r0, #26
200204ce:	f004 fbcd 	bl	20024c6c <HAL_PIN_Set>
200204d2:	e8bd 4010 	ldmia.w	sp!, {r4, lr}
200204d6:	2301      	movs	r3, #1
200204d8:	2230      	movs	r2, #48	@ 0x30
200204da:	f44f 71dc 	mov.w	r1, #440	@ 0x1b8
200204de:	201b      	movs	r0, #27
200204e0:	f004 bbc4 	b.w	20024c6c <HAL_PIN_Set>

200204e4 <board_boot_from>:
200204e4:	b510      	push	{r4, lr}
200204e6:	4b0f      	ldr	r3, [pc, #60]	@ (20020524 <board_boot_from+0x40>)
200204e8:	490f      	ldr	r1, [pc, #60]	@ (20020528 <board_boot_from+0x44>)
200204ea:	685b      	ldr	r3, [r3, #4]
200204ec:	680a      	ldr	r2, [r1, #0]
200204ee:	f3c3 2302 	ubfx	r3, r3, #8, #3
200204f2:	f022 0208 	bic.w	r2, r2, #8
200204f6:	2b07      	cmp	r3, #7
200204f8:	600a      	str	r2, [r1, #0]
200204fa:	d10c      	bne.n	20020516 <board_boot_from+0x32>
200204fc:	2400      	movs	r4, #0
200204fe:	3401      	adds	r4, #1
20020500:	2101      	movs	r1, #1
20020502:	4620      	mov	r0, r4
20020504:	f004 fd36 	bl	20024f74 <HAL_PIN_Set_Analog>
20020508:	2c0d      	cmp	r4, #13
2002050a:	d1f8      	bne.n	200204fe <board_boot_from+0x1a>
2002050c:	2000      	movs	r0, #0
2002050e:	e8bd 4010 	ldmia.w	sp!, {r4, lr}
20020512:	f00b bfdb 	b.w	2002c4cc <HAL_Get_backup>
20020516:	b11b      	cbz	r3, 20020520 <board_boot_from+0x3c>
20020518:	2b01      	cmp	r3, #1
2002051a:	d1f7      	bne.n	2002050c <board_boot_from+0x28>
2002051c:	2002      	movs	r0, #2
2002051e:	bd10      	pop	{r4, pc}
20020520:	2001      	movs	r0, #1
20020522:	e7fc      	b.n	2002051e <board_boot_from+0x3a>
20020524:	5000b000 	.word	0x5000b000
20020528:	500ca000 	.word	0x500ca000

2002052c <board_flash_power_on>:
2002052c:	4770      	bx	lr

2002052e <board_pinmux_psram_func0>:
2002052e:	b508      	push	{r3, lr}
20020530:	2210      	movs	r2, #16
20020532:	2301      	movs	r3, #1
20020534:	2109      	movs	r1, #9
20020536:	2002      	movs	r0, #2
20020538:	f004 fb98 	bl	20024c6c <HAL_PIN_Set>
2002053c:	2301      	movs	r3, #1
2002053e:	2210      	movs	r2, #16
20020540:	210a      	movs	r1, #10
20020542:	2003      	movs	r0, #3
20020544:	f004 fb92 	bl	20024c6c <HAL_PIN_Set>
20020548:	2301      	movs	r3, #1
2002054a:	2210      	movs	r2, #16
2002054c:	210b      	movs	r1, #11
2002054e:	2004      	movs	r0, #4
20020550:	f004 fb8c 	bl	20024c6c <HAL_PIN_Set>
20020554:	2301      	movs	r3, #1
20020556:	2210      	movs	r2, #16
20020558:	210c      	movs	r1, #12
2002055a:	2005      	movs	r0, #5
2002055c:	f004 fb86 	bl	20024c6c <HAL_PIN_Set>
20020560:	2301      	movs	r3, #1
20020562:	2210      	movs	r2, #16
20020564:	210d      	movs	r1, #13
20020566:	2006      	movs	r0, #6
20020568:	f004 fb80 	bl	20024c6c <HAL_PIN_Set>
2002056c:	2301      	movs	r3, #1
2002056e:	2210      	movs	r2, #16
20020570:	210e      	movs	r1, #14
20020572:	2007      	movs	r0, #7
20020574:	f004 fb7a 	bl	20024c6c <HAL_PIN_Set>
20020578:	2301      	movs	r3, #1
2002057a:	2210      	movs	r2, #16
2002057c:	210f      	movs	r1, #15
2002057e:	2008      	movs	r0, #8
20020580:	f004 fb74 	bl	20024c6c <HAL_PIN_Set>
20020584:	2210      	movs	r2, #16
20020586:	2301      	movs	r3, #1
20020588:	4611      	mov	r1, r2
2002058a:	2009      	movs	r0, #9
2002058c:	f004 fb6e 	bl	20024c6c <HAL_PIN_Set>
20020590:	2301      	movs	r3, #1
20020592:	2210      	movs	r2, #16
20020594:	2106      	movs	r1, #6
20020596:	200a      	movs	r0, #10
20020598:	f004 fb68 	bl	20024c6c <HAL_PIN_Set>
2002059c:	2301      	movs	r3, #1
2002059e:	2200      	movs	r2, #0
200205a0:	4619      	mov	r1, r3
200205a2:	200b      	movs	r0, #11
200205a4:	f004 fb62 	bl	20024c6c <HAL_PIN_Set>
200205a8:	2301      	movs	r3, #1
200205aa:	2200      	movs	r2, #0
200205ac:	2103      	movs	r1, #3
200205ae:	200c      	movs	r0, #12
200205b0:	f004 fb5c 	bl	20024c6c <HAL_PIN_Set>
200205b4:	2101      	movs	r1, #1
200205b6:	4608      	mov	r0, r1
200205b8:	f004 fcdc 	bl	20024f74 <HAL_PIN_Set_Analog>
200205bc:	e8bd 4008 	ldmia.w	sp!, {r3, lr}
200205c0:	2101      	movs	r1, #1
200205c2:	200d      	movs	r0, #13
200205c4:	f004 bcd6 	b.w	20024f74 <HAL_PIN_Set_Analog>

200205c8 <board_pinmux_psram_func1_2_4>:
200205c8:	b510      	push	{r4, lr}
200205ca:	2301      	movs	r3, #1
200205cc:	4604      	mov	r4, r0
200205ce:	2210      	movs	r2, #16
200205d0:	2109      	movs	r1, #9
200205d2:	2002      	movs	r0, #2
200205d4:	f004 fb4a 	bl	20024c6c <HAL_PIN_Set>
200205d8:	2301      	movs	r3, #1
200205da:	2210      	movs	r2, #16
200205dc:	210a      	movs	r1, #10
200205de:	2003      	movs	r0, #3
200205e0:	f004 fb44 	bl	20024c6c <HAL_PIN_Set>
200205e4:	2301      	movs	r3, #1
200205e6:	2210      	movs	r2, #16
200205e8:	210b      	movs	r1, #11
200205ea:	2004      	movs	r0, #4
200205ec:	f004 fb3e 	bl	20024c6c <HAL_PIN_Set>
200205f0:	2301      	movs	r3, #1
200205f2:	2210      	movs	r2, #16
200205f4:	210c      	movs	r1, #12
200205f6:	2005      	movs	r0, #5
200205f8:	f004 fb38 	bl	20024c6c <HAL_PIN_Set>
200205fc:	2301      	movs	r3, #1
200205fe:	2210      	movs	r2, #16
20020600:	210d      	movs	r1, #13
20020602:	2009      	movs	r0, #9
20020604:	f004 fb32 	bl	20024c6c <HAL_PIN_Set>
20020608:	2301      	movs	r3, #1
2002060a:	2210      	movs	r2, #16
2002060c:	210e      	movs	r1, #14
2002060e:	200a      	movs	r0, #10
20020610:	f004 fb2c 	bl	20024c6c <HAL_PIN_Set>
20020614:	2301      	movs	r3, #1
20020616:	2210      	movs	r2, #16
20020618:	210f      	movs	r1, #15
2002061a:	200b      	movs	r0, #11
2002061c:	f004 fb26 	bl	20024c6c <HAL_PIN_Set>
20020620:	2210      	movs	r2, #16
20020622:	2301      	movs	r3, #1
20020624:	4611      	mov	r1, r2
20020626:	200c      	movs	r0, #12
20020628:	f004 fb20 	bl	20024c6c <HAL_PIN_Set>
2002062c:	2301      	movs	r3, #1
2002062e:	2200      	movs	r2, #0
20020630:	4619      	mov	r1, r3
20020632:	2008      	movs	r0, #8
20020634:	f004 fb1a 	bl	20024c6c <HAL_PIN_Set>
20020638:	2301      	movs	r3, #1
2002063a:	2200      	movs	r2, #0
2002063c:	2103      	movs	r1, #3
2002063e:	2006      	movs	r0, #6
20020640:	f004 fb14 	bl	20024c6c <HAL_PIN_Set>
20020644:	2c02      	cmp	r4, #2
20020646:	d013      	beq.n	20020670 <board_pinmux_psram_func1_2_4+0xa8>
20020648:	2c04      	cmp	r4, #4
2002064a:	d025      	beq.n	20020698 <board_pinmux_psram_func1_2_4+0xd0>
2002064c:	2c01      	cmp	r4, #1
2002064e:	d12c      	bne.n	200206aa <board_pinmux_psram_func1_2_4+0xe2>
20020650:	2106      	movs	r1, #6
20020652:	4623      	mov	r3, r4
20020654:	2210      	movs	r2, #16
20020656:	200d      	movs	r0, #13
20020658:	f004 fb08 	bl	20024c6c <HAL_PIN_Set>
2002065c:	4621      	mov	r1, r4
2002065e:	4620      	mov	r0, r4
20020660:	f004 fc88 	bl	20024f74 <HAL_PIN_Set_Analog>
20020664:	e8bd 4010 	ldmia.w	sp!, {r4, lr}
20020668:	2101      	movs	r1, #1
2002066a:	2007      	movs	r0, #7
2002066c:	f004 bc82 	b.w	20024f74 <HAL_PIN_Set_Analog>
20020670:	2301      	movs	r3, #1
20020672:	2210      	movs	r2, #16
20020674:	2104      	movs	r1, #4
20020676:	4618      	mov	r0, r3
20020678:	f004 faf8 	bl	20024c6c <HAL_PIN_Set>
2002067c:	2301      	movs	r3, #1
2002067e:	2210      	movs	r2, #16
20020680:	2105      	movs	r1, #5
20020682:	200d      	movs	r0, #13
20020684:	f004 faf2 	bl	20024c6c <HAL_PIN_Set>
20020688:	4621      	mov	r1, r4
2002068a:	e8bd 4010 	ldmia.w	sp!, {r4, lr}
2002068e:	2301      	movs	r3, #1
20020690:	2200      	movs	r2, #0
20020692:	2007      	movs	r0, #7
20020694:	f004 baea 	b.w	20024c6c <HAL_PIN_Set>
20020698:	2106      	movs	r1, #6
2002069a:	2301      	movs	r3, #1
2002069c:	2200      	movs	r2, #0
2002069e:	200d      	movs	r0, #13
200206a0:	f004 fae4 	bl	20024c6c <HAL_PIN_Set>
200206a4:	2101      	movs	r1, #1
200206a6:	4608      	mov	r0, r1
200206a8:	e7da      	b.n	20020660 <board_pinmux_psram_func1_2_4+0x98>
200206aa:	bd10      	pop	{r4, pc}

200206ac <board_pinmux_psram_func3>:
200206ac:	b508      	push	{r3, lr}
200206ae:	2301      	movs	r3, #1
200206b0:	2200      	movs	r2, #0
200206b2:	4619      	mov	r1, r3
200206b4:	200a      	movs	r0, #10
200206b6:	f004 fad9 	bl	20024c6c <HAL_PIN_Set>
200206ba:	2301      	movs	r3, #1
200206bc:	2200      	movs	r2, #0
200206be:	2103      	movs	r1, #3
200206c0:	2009      	movs	r0, #9
200206c2:	f004 fad3 	bl	20024c6c <HAL_PIN_Set>
200206c6:	2301      	movs	r3, #1
200206c8:	2210      	movs	r2, #16
200206ca:	2109      	movs	r1, #9
200206cc:	2006      	movs	r0, #6
200206ce:	f004 facd 	bl	20024c6c <HAL_PIN_Set>
200206d2:	2301      	movs	r3, #1
200206d4:	2210      	movs	r2, #16
200206d6:	210a      	movs	r1, #10
200206d8:	2008      	movs	r0, #8
200206da:	f004 fac7 	bl	20024c6c <HAL_PIN_Set>
200206de:	2301      	movs	r3, #1
200206e0:	2230      	movs	r2, #48	@ 0x30
200206e2:	210b      	movs	r1, #11
200206e4:	2007      	movs	r0, #7
200206e6:	f004 fac1 	bl	20024c6c <HAL_PIN_Set>
200206ea:	2301      	movs	r3, #1
200206ec:	2230      	movs	r2, #48	@ 0x30
200206ee:	210c      	movs	r1, #12
200206f0:	200b      	movs	r0, #11
200206f2:	f004 fabb 	bl	20024c6c <HAL_PIN_Set>
200206f6:	2101      	movs	r1, #1
200206f8:	4608      	mov	r0, r1
200206fa:	f004 fc3b 	bl	20024f74 <HAL_PIN_Set_Analog>
200206fe:	2101      	movs	r1, #1
20020700:	2002      	movs	r0, #2
20020702:	f004 fc37 	bl	20024f74 <HAL_PIN_Set_Analog>
20020706:	2101      	movs	r1, #1
20020708:	2003      	movs	r0, #3
2002070a:	f004 fc33 	bl	20024f74 <HAL_PIN_Set_Analog>
2002070e:	2101      	movs	r1, #1
20020710:	2004      	movs	r0, #4
20020712:	f004 fc2f 	bl	20024f74 <HAL_PIN_Set_Analog>
20020716:	2101      	movs	r1, #1
20020718:	2005      	movs	r0, #5
2002071a:	f004 fc2b 	bl	20024f74 <HAL_PIN_Set_Analog>
2002071e:	2101      	movs	r1, #1
20020720:	200c      	movs	r0, #12
20020722:	f004 fc27 	bl	20024f74 <HAL_PIN_Set_Analog>
20020726:	e8bd 4008 	ldmia.w	sp!, {r3, lr}
2002072a:	2101      	movs	r1, #1
2002072c:	200d      	movs	r0, #13
2002072e:	f004 bc21 	b.w	20024f74 <HAL_PIN_Set_Analog>

20020732 <bootloader_switch_clock>:
20020732:	2102      	movs	r1, #2
20020734:	2004      	movs	r0, #4
20020736:	f004 bd3d 	b.w	200251b4 <HAL_RCC_HCPU_ClockSelect>
	...

2002073c <boot_psram_init>:
2002073c:	e92d 41f0 	stmdb	sp!, {r4, r5, r6, r7, r8, lr}
20020740:	2400      	movs	r4, #0
20020742:	b08a      	sub	sp, #40	@ 0x28
20020744:	4605      	mov	r5, r0
20020746:	2240      	movs	r2, #64	@ 0x40
20020748:	4621      	mov	r1, r4
2002074a:	4863      	ldr	r0, [pc, #396]	@ (200208d8 <boot_psram_init+0x19c>)
2002074c:	f00a f982 	bl	2002aa54 <memset>
20020750:	4b62      	ldr	r3, [pc, #392]	@ (200208dc <boot_psram_init+0x1a0>)
20020752:	1ea8      	subs	r0, r5, #2
20020754:	9305      	str	r3, [sp, #20]
20020756:	f04f 5380 	mov.w	r3, #268435456	@ 0x10000000
2002075a:	9307      	str	r3, [sp, #28]
2002075c:	2303      	movs	r3, #3
2002075e:	9406      	str	r4, [sp, #24]
20020760:	9309      	str	r3, [sp, #36]	@ 0x24
20020762:	2804      	cmp	r0, #4
20020764:	d804      	bhi.n	20020770 <boot_psram_init+0x34>
20020766:	e8df f000 	tbb	[pc, r0]
2002076a:	6264      	.short	0x6264
2002076c:	5d04      	.short	0x5d04
2002076e:	60          	.byte	0x60
2002076f:	00          	.byte	0x00
20020770:	e7fe      	b.n	20020770 <boot_psram_init+0x34>
20020772:	2305      	movs	r3, #5
20020774:	9309      	str	r3, [sp, #36]	@ 0x24
20020776:	2304      	movs	r3, #4
20020778:	9d09      	ldr	r5, [sp, #36]	@ 0x24
2002077a:	9308      	str	r3, [sp, #32]
2002077c:	2d03      	cmp	r5, #3
2002077e:	d162      	bne.n	20020846 <boot_psram_init+0x10a>
20020780:	f001 fc42 	bl	20022008 <BSP_GetFlash1DIV>
20020784:	a905      	add	r1, sp, #20
20020786:	4602      	mov	r2, r0
20020788:	4853      	ldr	r0, [pc, #332]	@ (200208d8 <boot_psram_init+0x19c>)
2002078a:	f004 f805 	bl	20024798 <HAL_OPI_PSRAM_Init>
2002078e:	462a      	mov	r2, r5
20020790:	2108      	movs	r1, #8
20020792:	4851      	ldr	r0, [pc, #324]	@ (200208d8 <boot_psram_init+0x19c>)
20020794:	f003 fef2 	bl	2002457c <HAL_MPI_MR_WRITE>
20020798:	484f      	ldr	r0, [pc, #316]	@ (200208d8 <boot_psram_init+0x19c>)
2002079a:	f003 fbe5 	bl	20023f68 <HAL_QSPI_GET_CLK>
2002079e:	4b50      	ldr	r3, [pc, #320]	@ (200208e0 <boot_psram_init+0x1a4>)
200207a0:	4298      	cmp	r0, r3
200207a2:	d948      	bls.n	20020836 <boot_psram_init+0xfa>
200207a4:	f103 63a4 	add.w	r3, r3, #85983232	@ 0x5200000
200207a8:	f503 4383 	add.w	r3, r3, #16768	@ 0x4180
200207ac:	4298      	cmp	r0, r3
200207ae:	d944      	bls.n	2002083a <boot_psram_init+0xfe>
200207b0:	f103 7337 	add.w	r3, r3, #47972352	@ 0x2dc0000
200207b4:	f503 43d8 	add.w	r3, r3, #27648	@ 0x6c00
200207b8:	4298      	cmp	r0, r3
200207ba:	d940      	bls.n	2002083e <boot_psram_init+0x102>
200207bc:	4b49      	ldr	r3, [pc, #292]	@ (200208e4 <boot_psram_init+0x1a8>)
200207be:	4298      	cmp	r0, r3
200207c0:	d93f      	bls.n	20020842 <boot_psram_init+0x106>
200207c2:	4b49      	ldr	r3, [pc, #292]	@ (200208e8 <boot_psram_init+0x1ac>)
200207c4:	4298      	cmp	r0, r3
200207c6:	bf98      	it	ls
200207c8:	2407      	movls	r4, #7
200207ca:	2600      	movs	r6, #0
200207cc:	2507      	movs	r5, #7
200207ce:	f04f 0803 	mov.w	r8, #3
200207d2:	0067      	lsls	r7, r4, #1
200207d4:	b2ff      	uxtb	r7, r7
200207d6:	1e7a      	subs	r2, r7, #1
200207d8:	4633      	mov	r3, r6
200207da:	b252      	sxtb	r2, r2
200207dc:	4629      	mov	r1, r5
200207de:	483e      	ldr	r0, [pc, #248]	@ (200208d8 <boot_psram_init+0x19c>)
200207e0:	e9cd 5502 	strd	r5, r5, [sp, #8]
200207e4:	e9cd 6800 	strd	r6, r8, [sp]
200207e8:	f002 fa76 	bl	20022cd8 <HAL_FLASH_CFG_AHB_RCMD>
200207ec:	4631      	mov	r1, r6
200207ee:	483a      	ldr	r0, [pc, #232]	@ (200208d8 <boot_psram_init+0x19c>)
200207f0:	f002 fa67 	bl	20022cc2 <HAL_FLASH_SET_AHB_RCMD>
200207f4:	1e62      	subs	r2, r4, #1
200207f6:	4633      	mov	r3, r6
200207f8:	b252      	sxtb	r2, r2
200207fa:	4629      	mov	r1, r5
200207fc:	4836      	ldr	r0, [pc, #216]	@ (200208d8 <boot_psram_init+0x19c>)
200207fe:	e9cd 5502 	strd	r5, r5, [sp, #8]
20020802:	e9cd 6800 	strd	r6, r8, [sp]
20020806:	f002 fa90 	bl	20022d2a <HAL_FLASH_CFG_AHB_WCMD>
2002080a:	2180      	movs	r1, #128	@ 0x80
2002080c:	4832      	ldr	r0, [pc, #200]	@ (200208d8 <boot_psram_init+0x19c>)
2002080e:	f002 fa80 	bl	20022d12 <HAL_FLASH_SET_AHB_WCMD>
20020812:	4623      	mov	r3, r4
20020814:	463a      	mov	r2, r7
20020816:	2101      	movs	r1, #1
20020818:	482f      	ldr	r0, [pc, #188]	@ (200208d8 <boot_psram_init+0x19c>)
2002081a:	f003 fed3 	bl	200245c4 <HAL_MPI_SET_FIXLAT>
2002081e:	b00a      	add	sp, #40	@ 0x28
20020820:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}
20020824:	2302      	movs	r3, #2
20020826:	9309      	str	r3, [sp, #36]	@ 0x24
20020828:	e7a6      	b.n	20020778 <boot_psram_init+0x3c>
2002082a:	2306      	movs	r3, #6
2002082c:	9309      	str	r3, [sp, #36]	@ 0x24
2002082e:	2308      	movs	r3, #8
20020830:	e7a2      	b.n	20020778 <boot_psram_init+0x3c>
20020832:	2310      	movs	r3, #16
20020834:	e7a0      	b.n	20020778 <boot_psram_init+0x3c>
20020836:	462c      	mov	r4, r5
20020838:	e7c7      	b.n	200207ca <boot_psram_init+0x8e>
2002083a:	2404      	movs	r4, #4
2002083c:	e7c5      	b.n	200207ca <boot_psram_init+0x8e>
2002083e:	2405      	movs	r4, #5
20020840:	e7c3      	b.n	200207ca <boot_psram_init+0x8e>
20020842:	2406      	movs	r4, #6
20020844:	e7c1      	b.n	200207ca <boot_psram_init+0x8e>
20020846:	2d05      	cmp	r5, #5
20020848:	d10d      	bne.n	20020866 <boot_psram_init+0x12a>
2002084a:	f001 fbdd 	bl	20022008 <BSP_GetFlash1DIV>
2002084e:	a905      	add	r1, sp, #20
20020850:	4602      	mov	r2, r0
20020852:	4821      	ldr	r0, [pc, #132]	@ (200208d8 <boot_psram_init+0x19c>)
20020854:	f004 f820 	bl	20024898 <HAL_LEGACY_PSRAM_Init>
20020858:	481f      	ldr	r0, [pc, #124]	@ (200208d8 <boot_psram_init+0x19c>)
2002085a:	f003 ff25 	bl	200246a8 <HAL_LEGACY_CFG_READ>
2002085e:	481e      	ldr	r0, [pc, #120]	@ (200208d8 <boot_psram_init+0x19c>)
20020860:	f003 ff3d 	bl	200246de <HAL_LEGACY_CFG_WRITE>
20020864:	e7db      	b.n	2002081e <boot_psram_init+0xe2>
20020866:	2d06      	cmp	r5, #6
20020868:	d10d      	bne.n	20020886 <boot_psram_init+0x14a>
2002086a:	f001 fbcd 	bl	20022008 <BSP_GetFlash1DIV>
2002086e:	a905      	add	r1, sp, #20
20020870:	4602      	mov	r2, r0
20020872:	4819      	ldr	r0, [pc, #100]	@ (200208d8 <boot_psram_init+0x19c>)
20020874:	f004 f8de 	bl	20024a34 <HAL_HYPER_PSRAM_Init>
20020878:	4817      	ldr	r0, [pc, #92]	@ (200208d8 <boot_psram_init+0x19c>)
2002087a:	f004 f913 	bl	20024aa4 <HAL_HYPER_CFG_READ>
2002087e:	4816      	ldr	r0, [pc, #88]	@ (200208d8 <boot_psram_init+0x19c>)
20020880:	f004 f922 	bl	20024ac8 <HAL_HYPER_CFG_WRITE>
20020884:	e7cb      	b.n	2002081e <boot_psram_init+0xe2>
20020886:	f001 fbbf 	bl	20022008 <BSP_GetFlash1DIV>
2002088a:	2500      	movs	r5, #0
2002088c:	2403      	movs	r4, #3
2002088e:	2701      	movs	r7, #1
20020890:	2602      	movs	r6, #2
20020892:	4602      	mov	r2, r0
20020894:	a905      	add	r1, sp, #20
20020896:	4810      	ldr	r0, [pc, #64]	@ (200208d8 <boot_psram_init+0x19c>)
20020898:	f003 fe1a 	bl	200244d0 <HAL_SPI_PSRAM_Init>
2002089c:	462b      	mov	r3, r5
2002089e:	2206      	movs	r2, #6
200208a0:	4621      	mov	r1, r4
200208a2:	e9cd 4702 	strd	r4, r7, [sp, #8]
200208a6:	e9cd 5600 	strd	r5, r6, [sp]
200208aa:	480b      	ldr	r0, [pc, #44]	@ (200208d8 <boot_psram_init+0x19c>)
200208ac:	f002 fa14 	bl	20022cd8 <HAL_FLASH_CFG_AHB_RCMD>
200208b0:	21eb      	movs	r1, #235	@ 0xeb
200208b2:	4809      	ldr	r0, [pc, #36]	@ (200208d8 <boot_psram_init+0x19c>)
200208b4:	f002 fa05 	bl	20022cc2 <HAL_FLASH_SET_AHB_RCMD>
200208b8:	4621      	mov	r1, r4
200208ba:	462b      	mov	r3, r5
200208bc:	462a      	mov	r2, r5
200208be:	e9cd 4702 	strd	r4, r7, [sp, #8]
200208c2:	e9cd 5600 	strd	r5, r6, [sp]
200208c6:	4804      	ldr	r0, [pc, #16]	@ (200208d8 <boot_psram_init+0x19c>)
200208c8:	f002 fa2f 	bl	20022d2a <HAL_FLASH_CFG_AHB_WCMD>
200208cc:	2138      	movs	r1, #56	@ 0x38
200208ce:	4802      	ldr	r0, [pc, #8]	@ (200208d8 <boot_psram_init+0x19c>)
200208d0:	f002 fa1f 	bl	20022d12 <HAL_FLASH_SET_AHB_WCMD>
200208d4:	e7a3      	b.n	2002081e <boot_psram_init+0xe2>
200208d6:	bf00      	nop
200208d8:	20044a14 	.word	0x20044a14
200208dc:	50041000 	.word	0x50041000
200208e0:	07de2901 	.word	0x07de2901
200208e4:	13c9eb01 	.word	0x13c9eb01
200208e8:	17d78401 	.word	0x17d78401

200208ec <board_init_psram>:
200208ec:	b510      	push	{r4, lr}
200208ee:	4b15      	ldr	r3, [pc, #84]	@ (20020944 <board_init_psram+0x58>)
200208f0:	685c      	ldr	r4, [r3, #4]
200208f2:	f3c4 2402 	ubfx	r4, r4, #8, #3
200208f6:	1ea3      	subs	r3, r4, #2
200208f8:	2b04      	cmp	r3, #4
200208fa:	d821      	bhi.n	20020940 <board_init_psram+0x54>
200208fc:	e8df f003 	tbb	[pc, r3]
20020900:	03151b1d 	.word	0x03151b1d
20020904:	19          	.byte	0x19
20020905:	00          	.byte	0x00
20020906:	f7ff fed1 	bl	200206ac <board_pinmux_psram_func3>
2002090a:	2201      	movs	r2, #1
2002090c:	2000      	movs	r0, #0
2002090e:	4611      	mov	r1, r2
20020910:	f00b fde2 	bl	2002c4d8 <HAL_PMU_ConfigPeriLdo>
20020914:	2001      	movs	r0, #1
20020916:	f7ff ff0c 	bl	20020732 <bootloader_switch_clock>
2002091a:	2002      	movs	r0, #2
2002091c:	f001 fb80 	bl	20022020 <BSP_SetFlash1DIV>
20020920:	4620      	mov	r0, r4
20020922:	e8bd 4010 	ldmia.w	sp!, {r4, lr}
20020926:	f7ff bf09 	b.w	2002073c <boot_psram_init>
2002092a:	2002      	movs	r0, #2
2002092c:	f7ff fe4c 	bl	200205c8 <board_pinmux_psram_func1_2_4>
20020930:	e7eb      	b.n	2002090a <board_init_psram+0x1e>
20020932:	2004      	movs	r0, #4
20020934:	e7fa      	b.n	2002092c <board_init_psram+0x40>
20020936:	2001      	movs	r0, #1
20020938:	e7f8      	b.n	2002092c <board_init_psram+0x40>
2002093a:	f7ff fdf8 	bl	2002052e <board_pinmux_psram_func0>
2002093e:	e7e4      	b.n	2002090a <board_init_psram+0x1e>
20020940:	bd10      	pop	{r4, pc}
20020942:	bf00      	nop
20020944:	5000b000 	.word	0x5000b000

20020948 <erase_nor>:
20020948:	4b15      	ldr	r3, [pc, #84]	@ (200209a0 <erase_nor+0x58>)
2002094a:	b570      	push	{r4, r5, r6, lr}
2002094c:	f103 0654 	add.w	r6, r3, #84	@ 0x54
20020950:	f1b0 5f90 	cmp.w	r0, #301989888	@ 0x12000000
20020954:	bf38      	it	cc
20020956:	461e      	movcc	r6, r3
20020958:	6933      	ldr	r3, [r6, #16]
2002095a:	460c      	mov	r4, r1
2002095c:	4283      	cmp	r3, r0
2002095e:	d901      	bls.n	20020964 <erase_nor+0x1c>
20020960:	2001      	movs	r0, #1
20020962:	bd70      	pop	{r4, r5, r6, pc}
20020964:	6972      	ldr	r2, [r6, #20]
20020966:	441a      	add	r2, r3
20020968:	4282      	cmp	r2, r0
2002096a:	d3f9      	bcc.n	20020960 <erase_nor+0x18>
2002096c:	1ac0      	subs	r0, r0, r3
2002096e:	f3c0 030b 	ubfx	r3, r0, #0, #12
20020972:	b97b      	cbnz	r3, 20020994 <erase_nor+0x4c>
20020974:	f3c1 030b 	ubfx	r3, r1, #0, #12
20020978:	b97b      	cbnz	r3, 2002099a <erase_nor+0x52>
2002097a:	1845      	adds	r5, r0, r1
2002097c:	1b29      	subs	r1, r5, r4
2002097e:	b90c      	cbnz	r4, 20020984 <erase_nor+0x3c>
20020980:	4620      	mov	r0, r4
20020982:	e7ee      	b.n	20020962 <erase_nor+0x1a>
20020984:	4630      	mov	r0, r6
20020986:	f003 faa4 	bl	20023ed2 <HAL_QSPIEX_SECT_ERASE>
2002098a:	2800      	cmp	r0, #0
2002098c:	d1e8      	bne.n	20020960 <erase_nor+0x18>
2002098e:	f5a4 5480 	sub.w	r4, r4, #4096	@ 0x1000
20020992:	e7f3      	b.n	2002097c <erase_nor+0x34>
20020994:	f04f 30ff 	mov.w	r0, #4294967295
20020998:	e7e3      	b.n	20020962 <erase_nor+0x1a>
2002099a:	f06f 0001 	mvn.w	r0, #1
2002099e:	e7e0      	b.n	20020962 <erase_nor+0x1a>
200209a0:	20046f74 	.word	0x20046f74

200209a4 <write_nor>:
200209a4:	e92d 43f8 	stmdb	sp!, {r3, r4, r5, r6, r7, r8, r9, lr}
200209a8:	4b20      	ldr	r3, [pc, #128]	@ (20020a2c <write_nor+0x88>)
200209aa:	460f      	mov	r7, r1
200209ac:	f103 0854 	add.w	r8, r3, #84	@ 0x54
200209b0:	f1b0 5f90 	cmp.w	r0, #301989888	@ 0x12000000
200209b4:	bf38      	it	cc
200209b6:	4698      	movcc	r8, r3
200209b8:	f8d8 5010 	ldr.w	r5, [r8, #16]
200209bc:	4616      	mov	r6, r2
200209be:	4285      	cmp	r5, r0
200209c0:	d902      	bls.n	200209c8 <write_nor+0x24>
200209c2:	2000      	movs	r0, #0
200209c4:	e8bd 83f8 	ldmia.w	sp!, {r3, r4, r5, r6, r7, r8, r9, pc}
200209c8:	f8d8 2014 	ldr.w	r2, [r8, #20]
200209cc:	442a      	add	r2, r5
200209ce:	4282      	cmp	r2, r0
200209d0:	d3f7      	bcc.n	200209c2 <write_nor+0x1e>
200209d2:	1b45      	subs	r5, r0, r5
200209d4:	f015 04ff 	ands.w	r4, r5, #255	@ 0xff
200209d8:	d012      	beq.n	20020a00 <write_nor+0x5c>
200209da:	f5c4 7480 	rsb	r4, r4, #256	@ 0x100
200209de:	42b4      	cmp	r4, r6
200209e0:	bf28      	it	cs
200209e2:	4634      	movcs	r4, r6
200209e4:	460a      	mov	r2, r1
200209e6:	4623      	mov	r3, r4
200209e8:	4629      	mov	r1, r5
200209ea:	4640      	mov	r0, r8
200209ec:	f003 f98c 	bl	20023d08 <HAL_QSPIEX_WRITE_PAGE>
200209f0:	4284      	cmp	r4, r0
200209f2:	d1e6      	bne.n	200209c2 <write_nor+0x1e>
200209f4:	4425      	add	r5, r4
200209f6:	4427      	add	r7, r4
200209f8:	1b34      	subs	r4, r6, r4
200209fa:	b91c      	cbnz	r4, 20020a04 <write_nor+0x60>
200209fc:	4630      	mov	r0, r6
200209fe:	e7e1      	b.n	200209c4 <write_nor+0x20>
20020a00:	4634      	mov	r4, r6
20020a02:	e7fa      	b.n	200209fa <write_nor+0x56>
20020a04:	f5b4 7f80 	cmp.w	r4, #256	@ 0x100
20020a08:	46a1      	mov	r9, r4
20020a0a:	bf28      	it	cs
20020a0c:	f44f 7980 	movcs.w	r9, #256	@ 0x100
20020a10:	463a      	mov	r2, r7
20020a12:	464b      	mov	r3, r9
20020a14:	4629      	mov	r1, r5
20020a16:	4640      	mov	r0, r8
20020a18:	f003 f976 	bl	20023d08 <HAL_QSPIEX_WRITE_PAGE>
20020a1c:	4581      	cmp	r9, r0
20020a1e:	d1d0      	bne.n	200209c2 <write_nor+0x1e>
20020a20:	444d      	add	r5, r9
20020a22:	444f      	add	r7, r9
20020a24:	eba4 0409 	sub.w	r4, r4, r9
20020a28:	e7e7      	b.n	200209fa <write_nor+0x56>
20020a2a:	bf00      	nop
20020a2c:	20046f74 	.word	0x20046f74

20020a30 <read_nor>:
20020a30:	460b      	mov	r3, r1
20020a32:	b510      	push	{r4, lr}
20020a34:	4614      	mov	r4, r2
20020a36:	4601      	mov	r1, r0
20020a38:	4618      	mov	r0, r3
20020a3a:	f00a f825 	bl	2002aa88 <memcpy>
20020a3e:	4620      	mov	r0, r4
20020a40:	bd10      	pop	{r4, pc}
	...

20020a44 <read_nand>:
20020a44:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
20020a48:	2600      	movs	r6, #0
20020a4a:	460f      	mov	r7, r1
20020a4c:	4615      	mov	r5, r2
20020a4e:	46b0      	mov	r8, r6
20020a50:	4b19      	ldr	r3, [pc, #100]	@ (20020ab8 <read_nand+0x74>)
20020a52:	f8df a068 	ldr.w	sl, [pc, #104]	@ 20020abc <read_nand+0x78>
20020a56:	681b      	ldr	r3, [r3, #0]
20020a58:	f8df b064 	ldr.w	fp, [pc, #100]	@ 20020ac0 <read_nand+0x7c>
20020a5c:	691b      	ldr	r3, [r3, #16]
20020a5e:	4604      	mov	r4, r0
20020a60:	4283      	cmp	r3, r0
20020a62:	b085      	sub	sp, #20
20020a64:	bf98      	it	ls
20020a66:	1ac4      	subls	r4, r0, r3
20020a68:	b91d      	cbnz	r5, 20020a72 <read_nand+0x2e>
20020a6a:	4630      	mov	r0, r6
20020a6c:	b005      	add	sp, #20
20020a6e:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
20020a72:	f8da 1000 	ldr.w	r1, [sl]
20020a76:	f8db 0000 	ldr.w	r0, [fp]
20020a7a:	42a9      	cmp	r1, r5
20020a7c:	fbb0 fcf1 	udiv	ip, r0, r1
20020a80:	4689      	mov	r9, r1
20020a82:	f101 32ff 	add.w	r2, r1, #4294967295
20020a86:	bf28      	it	cs
20020a88:	46a9      	movcs	r9, r5
20020a8a:	fbb4 f1f1 	udiv	r1, r4, r1
20020a8e:	f10c 3cff 	add.w	ip, ip, #4294967295
20020a92:	fbb4 f0f0 	udiv	r0, r4, r0
20020a96:	e9cd 8801 	strd	r8, r8, [sp, #4]
20020a9a:	f8cd 9000 	str.w	r9, [sp]
20020a9e:	19bb      	adds	r3, r7, r6
20020aa0:	4022      	ands	r2, r4
20020aa2:	ea0c 0101 	and.w	r1, ip, r1
20020aa6:	f004 ffdb 	bl	20025a60 <bbm_read_page>
20020aaa:	4548      	cmp	r0, r9
20020aac:	d1dd      	bne.n	20020a6a <read_nand+0x26>
20020aae:	4406      	add	r6, r0
20020ab0:	1a2d      	subs	r5, r5, r0
20020ab2:	4404      	add	r4, r0
20020ab4:	e7d8      	b.n	20020a68 <read_nand+0x24>
20020ab6:	bf00      	nop
20020ab8:	20046d5c 	.word	0x20046d5c
20020abc:	20042c04 	.word	0x20042c04
20020ac0:	20042c00 	.word	0x20042c00

20020ac4 <read_sdnand>:
20020ac4:	e92d 41f0 	stmdb	sp!, {r4, r5, r6, r7, r8, lr}
20020ac8:	4616      	mov	r6, r2
20020aca:	4614      	mov	r4, r2
20020acc:	f100 451e 	add.w	r5, r0, #2650800128	@ 0x9e000000
20020ad0:	188f      	adds	r7, r1, r2
20020ad2:	f5b4 5f00 	cmp.w	r4, #8192	@ 0x2000
20020ad6:	eba7 0804 	sub.w	r8, r7, r4
20020ada:	d221      	bcs.n	20020b20 <read_sdnand+0x5c>
20020adc:	f424 77ff 	bic.w	r7, r4, #510	@ 0x1fe
20020ae0:	f027 0701 	bic.w	r7, r7, #1
20020ae4:	f5b7 6f80 	cmp.w	r7, #1024	@ 0x400
20020ae8:	d309      	bcc.n	20020afe <read_sdnand+0x3a>
20020aea:	463a      	mov	r2, r7
20020aec:	4641      	mov	r1, r8
20020aee:	4628      	mov	r0, r5
20020af0:	f001 f902 	bl	20021cf8 <sd_read_multi>
20020af4:	4287      	cmp	r7, r0
20020af6:	d11c      	bne.n	20020b32 <read_sdnand+0x6e>
20020af8:	1be4      	subs	r4, r4, r7
20020afa:	443d      	add	r5, r7
20020afc:	44b8      	add	r8, r7
20020afe:	b16c      	cbz	r4, 20020b1c <read_sdnand+0x58>
20020b00:	f44f 7200 	mov.w	r2, #512	@ 0x200
20020b04:	4628      	mov	r0, r5
20020b06:	490f      	ldr	r1, [pc, #60]	@ (20020b44 <read_sdnand+0x80>)
20020b08:	f001 f87a 	bl	20021c00 <sd_read_data>
20020b0c:	f5b0 7f00 	cmp.w	r0, #512	@ 0x200
20020b10:	d10f      	bne.n	20020b32 <read_sdnand+0x6e>
20020b12:	4622      	mov	r2, r4
20020b14:	4640      	mov	r0, r8
20020b16:	490b      	ldr	r1, [pc, #44]	@ (20020b44 <read_sdnand+0x80>)
20020b18:	f009 ffb6 	bl	2002aa88 <memcpy>
20020b1c:	4630      	mov	r0, r6
20020b1e:	e009      	b.n	20020b34 <read_sdnand+0x70>
20020b20:	f44f 5200 	mov.w	r2, #8192	@ 0x2000
20020b24:	4641      	mov	r1, r8
20020b26:	4628      	mov	r0, r5
20020b28:	f001 f8e6 	bl	20021cf8 <sd_read_multi>
20020b2c:	f5b0 5f00 	cmp.w	r0, #8192	@ 0x2000
20020b30:	d002      	beq.n	20020b38 <read_sdnand+0x74>
20020b32:	2000      	movs	r0, #0
20020b34:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}
20020b38:	f5a4 5400 	sub.w	r4, r4, #8192	@ 0x2000
20020b3c:	f505 5500 	add.w	r5, r5, #8192	@ 0x2000
20020b40:	e7c7      	b.n	20020ad2 <read_sdnand+0xe>
20020b42:	bf00      	nop
20020b44:	20046b58 	.word	0x20046b58

20020b48 <read_sdemmc>:
20020b48:	e92d 43f8 	stmdb	sp!, {r3, r4, r5, r6, r7, r8, r9, lr}
20020b4c:	f100 461e 	add.w	r6, r0, #2650800128	@ 0x9e000000
20020b50:	460d      	mov	r5, r1
20020b52:	4614      	mov	r4, r2
20020b54:	4617      	mov	r7, r2
20020b56:	46b0      	mov	r8, r6
20020b58:	eb02 0901 	add.w	r9, r2, r1
20020b5c:	f5b7 7f00 	cmp.w	r7, #512	@ 0x200
20020b60:	eba9 0107 	sub.w	r1, r9, r7
20020b64:	d218      	bcs.n	20020b98 <read_sdemmc+0x50>
20020b66:	f3c4 0708 	ubfx	r7, r4, #0, #9
20020b6a:	b197      	cbz	r7, 20020b92 <read_sdemmc+0x4a>
20020b6c:	f424 70ff 	bic.w	r0, r4, #510	@ 0x1fe
20020b70:	f020 0001 	bic.w	r0, r0, #1
20020b74:	f44f 7200 	mov.w	r2, #512	@ 0x200
20020b78:	490c      	ldr	r1, [pc, #48]	@ (20020bac <read_sdemmc+0x64>)
20020b7a:	4430      	add	r0, r6
20020b7c:	f000 fe5a 	bl	20021834 <emmc_read_data>
20020b80:	f424 70ff 	bic.w	r0, r4, #510	@ 0x1fe
20020b84:	f020 0001 	bic.w	r0, r0, #1
20020b88:	463a      	mov	r2, r7
20020b8a:	4908      	ldr	r1, [pc, #32]	@ (20020bac <read_sdemmc+0x64>)
20020b8c:	4428      	add	r0, r5
20020b8e:	f009 ff7b 	bl	2002aa88 <memcpy>
20020b92:	4620      	mov	r0, r4
20020b94:	e8bd 83f8 	ldmia.w	sp!, {r3, r4, r5, r6, r7, r8, r9, pc}
20020b98:	4640      	mov	r0, r8
20020b9a:	f44f 7200 	mov.w	r2, #512	@ 0x200
20020b9e:	f000 fe49 	bl	20021834 <emmc_read_data>
20020ba2:	f5a7 7700 	sub.w	r7, r7, #512	@ 0x200
20020ba6:	f508 7800 	add.w	r8, r8, #512	@ 0x200
20020baa:	e7d7      	b.n	20020b5c <read_sdemmc+0x14>
20020bac:	20046b58 	.word	0x20046b58

20020bb0 <port_read_page>:
20020bb0:	e92d 47f0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, lr}
20020bb4:	4615      	mov	r5, r2
20020bb6:	460e      	mov	r6, r1
20020bb8:	492a      	ldr	r1, [pc, #168]	@ (20020c64 <port_read_page+0xb4>)
20020bba:	461a      	mov	r2, r3
20020bbc:	e9dd 3c08 	ldrd	r3, ip, [sp, #32]
20020bc0:	680f      	ldr	r7, [r1, #0]
20020bc2:	18e9      	adds	r1, r5, r3
20020bc4:	428f      	cmp	r7, r1
20020bc6:	f8dd e028 	ldr.w	lr, [sp, #40]	@ 0x28
20020bca:	d200      	bcs.n	20020bce <port_read_page+0x1e>
20020bcc:	e7fe      	b.n	20020bcc <port_read_page+0x1c>
20020bce:	4926      	ldr	r1, [pc, #152]	@ (20020c68 <port_read_page+0xb8>)
20020bd0:	f107 0980 	add.w	r9, r7, #128	@ 0x80
20020bd4:	f1b9 0f00 	cmp.w	r9, #0
20020bd8:	6809      	ldr	r1, [r1, #0]
20020bda:	dd17      	ble.n	20020c0c <port_read_page+0x5c>
20020bdc:	4c23      	ldr	r4, [pc, #140]	@ (20020c6c <port_read_page+0xbc>)
20020bde:	6e64      	ldr	r4, [r4, #100]	@ 0x64
20020be0:	f004 081f 	and.w	r8, r4, #31
20020be4:	44c8      	add	r8, r9
20020be6:	f024 041f 	bic.w	r4, r4, #31
20020bea:	f3bf 8f4f 	dsb	sy
20020bee:	f8df a084 	ldr.w	sl, [pc, #132]	@ 20020c74 <port_read_page+0xc4>
20020bf2:	44a0      	add	r8, r4
20020bf4:	f8ca 425c 	str.w	r4, [sl, #604]	@ 0x25c
20020bf8:	3420      	adds	r4, #32
20020bfa:	eba8 0904 	sub.w	r9, r8, r4
20020bfe:	f1b9 0f00 	cmp.w	r9, #0
20020c02:	dcf7      	bgt.n	20020bf4 <port_read_page+0x44>
20020c04:	f3bf 8f4f 	dsb	sy
20020c08:	f3bf 8f6f 	isb	sy
20020c0c:	07c4      	lsls	r4, r0, #31
20020c0e:	d51d      	bpl.n	20020c4c <port_read_page+0x9c>
20020c10:	4c16      	ldr	r4, [pc, #88]	@ (20020c6c <port_read_page+0xbc>)
20020c12:	f894 8083 	ldrb.w	r8, [r4, #131]	@ 0x83
20020c16:	f1b8 0f00 	cmp.w	r8, #0
20020c1a:	d017      	beq.n	20020c4c <port_read_page+0x9c>
20020c1c:	6e64      	ldr	r4, [r4, #100]	@ 0x64
20020c1e:	f504 5880 	add.w	r8, r4, #4096	@ 0x1000
20020c22:	f004 041f 	and.w	r4, r4, #31
20020c26:	f504 6408 	add.w	r4, r4, #2176	@ 0x880
20020c2a:	f028 081f 	bic.w	r8, r8, #31
20020c2e:	f3bf 8f4f 	dsb	sy
20020c32:	f8df 9040 	ldr.w	r9, [pc, #64]	@ 20020c74 <port_read_page+0xc4>
20020c36:	3c20      	subs	r4, #32
20020c38:	2c00      	cmp	r4, #0
20020c3a:	f8c9 825c 	str.w	r8, [r9, #604]	@ 0x25c
20020c3e:	f108 0820 	add.w	r8, r8, #32
20020c42:	dcf8      	bgt.n	20020c36 <port_read_page+0x86>
20020c44:	f3bf 8f4f 	dsb	sy
20020c48:	f3bf 8f6f 	isb	sy
20020c4c:	fb07 5506 	mla	r5, r7, r6, r5
20020c50:	e9cd ce08 	strd	ip, lr, [sp, #32]
20020c54:	fb01 5100 	mla	r1, r1, r0, r5
20020c58:	e8bd 47f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, lr}
20020c5c:	4804      	ldr	r0, [pc, #16]	@ (20020c70 <port_read_page+0xc0>)
20020c5e:	f002 bf71 	b.w	20023b44 <HAL_NAND_READ_WITHOOB>
20020c62:	bf00      	nop
20020c64:	20042c04 	.word	0x20042c04
20020c68:	20042c00 	.word	0x20042c00
20020c6c:	20046f74 	.word	0x20046f74
20020c70:	20046fc8 	.word	0x20046fc8
20020c74:	e000ed00 	.word	0xe000ed00

20020c78 <bbm_get_bb>:
20020c78:	b410      	push	{r4}
20020c7a:	4b1e      	ldr	r3, [pc, #120]	@ (20020cf4 <bbm_get_bb+0x7c>)
20020c7c:	4601      	mov	r1, r0
20020c7e:	6818      	ldr	r0, [r3, #0]
20020c80:	3080      	adds	r0, #128	@ 0x80
20020c82:	2800      	cmp	r0, #0
20020c84:	dd14      	ble.n	20020cb0 <bbm_get_bb+0x38>
20020c86:	4b1c      	ldr	r3, [pc, #112]	@ (20020cf8 <bbm_get_bb+0x80>)
20020c88:	6e5b      	ldr	r3, [r3, #100]	@ 0x64
20020c8a:	f003 021f 	and.w	r2, r3, #31
20020c8e:	4402      	add	r2, r0
20020c90:	f023 031f 	bic.w	r3, r3, #31
20020c94:	f3bf 8f4f 	dsb	sy
20020c98:	4c18      	ldr	r4, [pc, #96]	@ (20020cfc <bbm_get_bb+0x84>)
20020c9a:	441a      	add	r2, r3
20020c9c:	f8c4 325c 	str.w	r3, [r4, #604]	@ 0x25c
20020ca0:	3320      	adds	r3, #32
20020ca2:	1ad0      	subs	r0, r2, r3
20020ca4:	2800      	cmp	r0, #0
20020ca6:	dcf9      	bgt.n	20020c9c <bbm_get_bb+0x24>
20020ca8:	f3bf 8f4f 	dsb	sy
20020cac:	f3bf 8f6f 	isb	sy
20020cb0:	07cb      	lsls	r3, r1, #31
20020cb2:	d51a      	bpl.n	20020cea <bbm_get_bb+0x72>
20020cb4:	4b10      	ldr	r3, [pc, #64]	@ (20020cf8 <bbm_get_bb+0x80>)
20020cb6:	f893 2083 	ldrb.w	r2, [r3, #131]	@ 0x83
20020cba:	b1b2      	cbz	r2, 20020cea <bbm_get_bb+0x72>
20020cbc:	6e5b      	ldr	r3, [r3, #100]	@ 0x64
20020cbe:	f503 5280 	add.w	r2, r3, #4096	@ 0x1000
20020cc2:	f003 031f 	and.w	r3, r3, #31
20020cc6:	f503 6308 	add.w	r3, r3, #2176	@ 0x880
20020cca:	f022 021f 	bic.w	r2, r2, #31
20020cce:	f3bf 8f4f 	dsb	sy
20020cd2:	480a      	ldr	r0, [pc, #40]	@ (20020cfc <bbm_get_bb+0x84>)
20020cd4:	3b20      	subs	r3, #32
20020cd6:	2b00      	cmp	r3, #0
20020cd8:	f8c0 225c 	str.w	r2, [r0, #604]	@ 0x25c
20020cdc:	f102 0220 	add.w	r2, r2, #32
20020ce0:	dcf8      	bgt.n	20020cd4 <bbm_get_bb+0x5c>
20020ce2:	f3bf 8f4f 	dsb	sy
20020ce6:	f3bf 8f6f 	isb	sy
20020cea:	4805      	ldr	r0, [pc, #20]	@ (20020d00 <bbm_get_bb+0x88>)
20020cec:	f85d 4b04 	ldr.w	r4, [sp], #4
20020cf0:	f002 bfe9 	b.w	20023cc6 <HAL_NAND_GET_BADBLK>
20020cf4:	20042c04 	.word	0x20042c04
20020cf8:	20046f74 	.word	0x20046f74
20020cfc:	e000ed00 	.word	0xe000ed00
20020d00:	20046fc8 	.word	0x20046fc8

20020d04 <dfu_flash_init>:
20020d04:	e92d 47f0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, lr}
20020d08:	b08c      	sub	sp, #48	@ 0x30
20020d0a:	f001 ffa5 	bl	20022c58 <HAL_HPAON_EnableXT48>
20020d0e:	2101      	movs	r1, #1
20020d10:	2000      	movs	r0, #0
20020d12:	f004 fa4f 	bl	200251b4 <HAL_RCC_HCPU_ClockSelect>
20020d16:	2101      	movs	r1, #1
20020d18:	200c      	movs	r0, #12
20020d1a:	f004 fa4b 	bl	200251b4 <HAL_RCC_HCPU_ClockSelect>
20020d1e:	2001      	movs	r0, #1
20020d20:	f004 f946 	bl	20024fb0 <HAL_PMU_EnableDLL>
20020d24:	4fa3      	ldr	r7, [pc, #652]	@ (20020fb4 <dfu_flash_init+0x2b0>)
20020d26:	2090      	movs	r0, #144	@ 0x90
20020d28:	f004 fbc5 	bl	200254b6 <HAL_RCC_HCPU_ConfigHCLK>
20020d2c:	2000      	movs	r0, #0
20020d2e:	f001 fa64 	bl	200221fa <HAL_Delay_us>
20020d32:	683b      	ldr	r3, [r7, #0]
20020d34:	4ca0      	ldr	r4, [pc, #640]	@ (20020fb8 <dfu_flash_init+0x2b4>)
20020d36:	3b01      	subs	r3, #1
20020d38:	2b05      	cmp	r3, #5
20020d3a:	f200 812a 	bhi.w	20020f92 <dfu_flash_init+0x28e>
20020d3e:	e8df f013 	tbh	[pc, r3, lsl #1]
20020d42:	0006      	.short	0x0006
20020d44:	007d0006 	.word	0x007d0006
20020d48:	0105007d 	.word	0x0105007d
20020d4c:	0119      	.short	0x0119
20020d4e:	489b      	ldr	r0, [pc, #620]	@ (20020fbc <dfu_flash_init+0x2b8>)
20020d50:	f004 f9f8 	bl	20025144 <HAL_RCC_HCPU_EnableDLL2>
20020d54:	4e9a      	ldr	r6, [pc, #616]	@ (20020fc0 <dfu_flash_init+0x2bc>)
20020d56:	2006      	movs	r0, #6
20020d58:	f001 f962 	bl	20022020 <BSP_SetFlash1DIV>
20020d5c:	ad02      	add	r5, sp, #8
20020d5e:	2102      	movs	r1, #2
20020d60:	2004      	movs	r0, #4
20020d62:	f004 fa27 	bl	200251b4 <HAL_RCC_HCPU_ClockSelect>
20020d66:	ce0f      	ldmia	r6!, {r0, r1, r2, r3}
20020d68:	c50f      	stmia	r5!, {r0, r1, r2, r3}
20020d6a:	6833      	ldr	r3, [r6, #0]
20020d6c:	2210      	movs	r2, #16
20020d6e:	602b      	str	r3, [r5, #0]
20020d70:	2100      	movs	r1, #0
20020d72:	a808      	add	r0, sp, #32
20020d74:	f009 fe6e 	bl	2002aa54 <memset>
20020d78:	4b92      	ldr	r3, [pc, #584]	@ (20020fc4 <dfu_flash_init+0x2c0>)
20020d7a:	4d93      	ldr	r5, [pc, #588]	@ (20020fc8 <dfu_flash_init+0x2c4>)
20020d7c:	9307      	str	r3, [sp, #28]
20020d7e:	2332      	movs	r3, #50	@ 0x32
20020d80:	f88d 3024 	strb.w	r3, [sp, #36]	@ 0x24
20020d84:	2301      	movs	r3, #1
20020d86:	f885 3045 	strb.w	r3, [r5, #69]	@ 0x45
20020d8a:	2300      	movs	r3, #0
20020d8c:	9303      	str	r3, [sp, #12]
20020d8e:	683b      	ldr	r3, [r7, #0]
20020d90:	2b01      	cmp	r3, #1
20020d92:	d14e      	bne.n	20020e32 <dfu_flash_init+0x12e>
20020d94:	f7ff fabc 	bl	20020310 <board_pinmux_mpi1_puya_base>
20020d98:	f001 f936 	bl	20022008 <BSP_GetFlash1DIV>
20020d9c:	4a8b      	ldr	r2, [pc, #556]	@ (20020fcc <dfu_flash_init+0x2c8>)
20020d9e:	9000      	str	r0, [sp, #0]
20020da0:	ab07      	add	r3, sp, #28
20020da2:	4889      	ldr	r0, [pc, #548]	@ (20020fc8 <dfu_flash_init+0x2c4>)
20020da4:	a902      	add	r1, sp, #8
20020da6:	f003 f965 	bl	20024074 <HAL_FLASH_Init>
20020daa:	683e      	ldr	r6, [r7, #0]
20020dac:	2e01      	cmp	r6, #1
20020dae:	d10d      	bne.n	20020dcc <dfu_flash_init+0xc8>
20020db0:	6c28      	ldr	r0, [r5, #64]	@ 0x40
20020db2:	4b87      	ldr	r3, [pc, #540]	@ (20020fd0 <dfu_flash_init+0x2cc>)
20020db4:	1ac3      	subs	r3, r0, r3
20020db6:	4258      	negs	r0, r3
20020db8:	4158      	adcs	r0, r3
20020dba:	f7ff faca 	bl	20020352 <board_pinmux_mpi1_puya_ext>
20020dbe:	4631      	mov	r1, r6
20020dc0:	4881      	ldr	r0, [pc, #516]	@ (20020fc8 <dfu_flash_init+0x2c4>)
20020dc2:	f002 fbb4 	bl	2002352e <HAL_FLASH_SET_QUAL_SPI>
20020dc6:	2302      	movs	r3, #2
20020dc8:	f885 3028 	strb.w	r3, [r5, #40]	@ 0x28
20020dcc:	4b81      	ldr	r3, [pc, #516]	@ (20020fd4 <dfu_flash_init+0x2d0>)
20020dce:	4a82      	ldr	r2, [pc, #520]	@ (20020fd8 <dfu_flash_init+0x2d4>)
20020dd0:	6023      	str	r3, [r4, #0]
20020dd2:	4b82      	ldr	r3, [pc, #520]	@ (20020fdc <dfu_flash_init+0x2d8>)
20020dd4:	601a      	str	r2, [r3, #0]
20020dd6:	4b82      	ldr	r3, [pc, #520]	@ (20020fe0 <dfu_flash_init+0x2dc>)
20020dd8:	4a82      	ldr	r2, [pc, #520]	@ (20020fe4 <dfu_flash_init+0x2e0>)
20020dda:	601a      	str	r2, [r3, #0]
20020ddc:	4b82      	ldr	r3, [pc, #520]	@ (20020fe8 <dfu_flash_init+0x2e4>)
20020dde:	6caa      	ldr	r2, [r5, #72]	@ 0x48
20020de0:	601a      	str	r2, [r3, #0]
20020de2:	4b82      	ldr	r3, [pc, #520]	@ (20020fec <dfu_flash_init+0x2e8>)
20020de4:	601d      	str	r5, [r3, #0]
20020de6:	2505      	movs	r5, #5
20020de8:	f8df 8204 	ldr.w	r8, [pc, #516]	@ 20020ff0 <dfu_flash_init+0x2ec>
20020dec:	4e7e      	ldr	r6, [pc, #504]	@ (20020fe8 <dfu_flash_init+0x2e4>)
20020dee:	f8df 9238 	ldr.w	r9, [pc, #568]	@ 20021028 <dfu_flash_init+0x324>
20020df2:	6823      	ldr	r3, [r4, #0]
20020df4:	f642 4210 	movw	r2, #11280	@ 0x2c10
20020df8:	497d      	ldr	r1, [pc, #500]	@ (20020ff0 <dfu_flash_init+0x2ec>)
20020dfa:	6830      	ldr	r0, [r6, #0]
20020dfc:	4798      	blx	r3
20020dfe:	f8d8 3000 	ldr.w	r3, [r8]
20020e02:	454b      	cmp	r3, r9
20020e04:	f040 80c9 	bne.w	20020f9a <dfu_flash_init+0x296>
20020e08:	683b      	ldr	r3, [r7, #0]
20020e0a:	2b04      	cmp	r3, #4
20020e0c:	f040 808e 	bne.w	20020f2c <dfu_flash_init+0x228>
20020e10:	f8d8 30a4 	ldr.w	r3, [r8, #164]	@ 0xa4
20020e14:	1e5a      	subs	r2, r3, #1
20020e16:	3203      	adds	r2, #3
20020e18:	f200 8088 	bhi.w	20020f2c <dfu_flash_init+0x228>
20020e1c:	4a75      	ldr	r2, [pc, #468]	@ (20020ff4 <dfu_flash_init+0x2f0>)
20020e1e:	4974      	ldr	r1, [pc, #464]	@ (20020ff0 <dfu_flash_init+0x2ec>)
20020e20:	6013      	str	r3, [r2, #0]
20020e22:	f642 4210 	movw	r2, #11280	@ 0x2c10
20020e26:	6823      	ldr	r3, [r4, #0]
20020e28:	6830      	ldr	r0, [r6, #0]
20020e2a:	b00c      	add	sp, #48	@ 0x30
20020e2c:	e8bd 47f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, lr}
20020e30:	4718      	bx	r3
20020e32:	f7ff fabd 	bl	200203b0 <board_pinmux_mpi1_gd>
20020e36:	2302      	movs	r3, #2
20020e38:	9303      	str	r3, [sp, #12]
20020e3a:	e7ad      	b.n	20020d98 <dfu_flash_init+0x94>
20020e3c:	485f      	ldr	r0, [pc, #380]	@ (20020fbc <dfu_flash_init+0x2b8>)
20020e3e:	f004 f981 	bl	20025144 <HAL_RCC_HCPU_EnableDLL2>
20020e42:	4e6d      	ldr	r6, [pc, #436]	@ (20020ff8 <dfu_flash_init+0x2f4>)
20020e44:	2006      	movs	r0, #6
20020e46:	f001 f8f1 	bl	2002202c <BSP_SetFlash2DIV>
20020e4a:	ad02      	add	r5, sp, #8
20020e4c:	2102      	movs	r1, #2
20020e4e:	2006      	movs	r0, #6
20020e50:	f004 f9b0 	bl	200251b4 <HAL_RCC_HCPU_ClockSelect>
20020e54:	ce0f      	ldmia	r6!, {r0, r1, r2, r3}
20020e56:	c50f      	stmia	r5!, {r0, r1, r2, r3}
20020e58:	f8d7 8000 	ldr.w	r8, [r7]
20020e5c:	6833      	ldr	r3, [r6, #0]
20020e5e:	f1b8 0a03 	subs.w	sl, r8, #3
20020e62:	602b      	str	r3, [r5, #0]
20020e64:	f04f 0210 	mov.w	r2, #16
20020e68:	f04f 0100 	mov.w	r1, #0
20020e6c:	a808      	add	r0, sp, #32
20020e6e:	bf18      	it	ne
20020e70:	f04f 0a01 	movne.w	sl, #1
20020e74:	f009 fdee 	bl	2002aa54 <memset>
20020e78:	4b60      	ldr	r3, [pc, #384]	@ (20020ffc <dfu_flash_init+0x2f8>)
20020e7a:	2601      	movs	r6, #1
20020e7c:	9307      	str	r3, [sp, #28]
20020e7e:	2333      	movs	r3, #51	@ 0x33
20020e80:	960a      	str	r6, [sp, #40]	@ 0x28
20020e82:	f88d 3024 	strb.w	r3, [sp, #36]	@ 0x24
20020e86:	f7ff fad6 	bl	20020436 <board_pinmux_mpi2>
20020e8a:	2302      	movs	r3, #2
20020e8c:	f1b8 0f03 	cmp.w	r8, #3
20020e90:	4d4d      	ldr	r5, [pc, #308]	@ (20020fc8 <dfu_flash_init+0x2c4>)
20020e92:	9303      	str	r3, [sp, #12]
20020e94:	d04d      	beq.n	20020f32 <dfu_flash_init+0x22e>
20020e96:	4b5a      	ldr	r3, [pc, #360]	@ (20021000 <dfu_flash_init+0x2fc>)
20020e98:	9606      	str	r6, [sp, #24]
20020e9a:	6023      	str	r3, [r4, #0]
20020e9c:	9b04      	ldr	r3, [sp, #16]
20020e9e:	f103 43a0 	add.w	r3, r3, #1342177280	@ 0x50000000
20020ea2:	9304      	str	r3, [sp, #16]
20020ea4:	4b57      	ldr	r3, [pc, #348]	@ (20021004 <dfu_flash_init+0x300>)
20020ea6:	672b      	str	r3, [r5, #112]	@ 0x70
20020ea8:	f04f 0901 	mov.w	r9, #1
20020eac:	2000      	movs	r0, #0
20020eae:	f001 f9a4 	bl	200221fa <HAL_Delay_us>
20020eb2:	f885 9099 	strb.w	r9, [r5, #153]	@ 0x99
20020eb6:	f885 a098 	strb.w	sl, [r5, #152]	@ 0x98
20020eba:	f001 f8ab 	bl	20022014 <BSP_GetFlash2DIV>
20020ebe:	4a52      	ldr	r2, [pc, #328]	@ (20021008 <dfu_flash_init+0x304>)
20020ec0:	9000      	str	r0, [sp, #0]
20020ec2:	ab07      	add	r3, sp, #28
20020ec4:	4851      	ldr	r0, [pc, #324]	@ (2002100c <dfu_flash_init+0x308>)
20020ec6:	a902      	add	r1, sp, #8
20020ec8:	f003 f8d4 	bl	20024074 <HAL_FLASH_Init>
20020ecc:	4e4f      	ldr	r6, [pc, #316]	@ (2002100c <dfu_flash_init+0x308>)
20020ece:	bb98      	cbnz	r0, 20020f38 <dfu_flash_init+0x234>
20020ed0:	f1b8 0f03 	cmp.w	r8, #3
20020ed4:	d033      	beq.n	20020f3e <dfu_flash_init+0x23a>
20020ed6:	4630      	mov	r0, r6
20020ed8:	f002 fe29 	bl	20023b2e <HAL_NAND_PAGE_SIZE>
20020edc:	f8df a114 	ldr.w	sl, [pc, #276]	@ 20020ff4 <dfu_flash_init+0x2f0>
20020ee0:	f8df 8148 	ldr.w	r8, [pc, #328]	@ 2002102c <dfu_flash_init+0x328>
20020ee4:	f8ca 0000 	str.w	r0, [sl]
20020ee8:	4630      	mov	r0, r6
20020eea:	f002 fee0 	bl	20023cae <HAL_NAND_BLOCK_SIZE>
20020eee:	4649      	mov	r1, r9
20020ef0:	f8c8 0000 	str.w	r0, [r8]
20020ef4:	4630      	mov	r0, r6
20020ef6:	f885 9082 	strb.w	r9, [r5, #130]	@ 0x82
20020efa:	f002 fcd8 	bl	200238ae <HAL_NAND_CONF_ECC>
20020efe:	f8da 0000 	ldr.w	r0, [sl]
20020f02:	f005 f895 	bl	20026030 <bbm_set_page_size>
20020f06:	f8d8 0000 	ldr.w	r0, [r8]
20020f0a:	f005 f897 	bl	2002603c <bbm_set_blk_size>
20020f0e:	4940      	ldr	r1, [pc, #256]	@ (20021010 <dfu_flash_init+0x30c>)
20020f10:	f8d5 00a0 	ldr.w	r0, [r5, #160]	@ 0xa0
20020f14:	f004 ff2e 	bl	20025d74 <sif_bbm_init>
20020f18:	4b33      	ldr	r3, [pc, #204]	@ (20020fe8 <dfu_flash_init+0x2e4>)
20020f1a:	f8d5 209c 	ldr.w	r2, [r5, #156]	@ 0x9c
20020f1e:	601a      	str	r2, [r3, #0]
20020f20:	4b32      	ldr	r3, [pc, #200]	@ (20020fec <dfu_flash_init+0x2e8>)
20020f22:	601e      	str	r6, [r3, #0]
20020f24:	6823      	ldr	r3, [r4, #0]
20020f26:	2b00      	cmp	r3, #0
20020f28:	f47f af5d 	bne.w	20020de6 <dfu_flash_init+0xe2>
20020f2c:	b00c      	add	sp, #48	@ 0x30
20020f2e:	e8bd 87f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, pc}
20020f32:	4b28      	ldr	r3, [pc, #160]	@ (20020fd4 <dfu_flash_init+0x2d0>)
20020f34:	6023      	str	r3, [r4, #0]
20020f36:	e7b7      	b.n	20020ea8 <dfu_flash_init+0x1a4>
20020f38:	f1b8 0f03 	cmp.w	r8, #3
20020f3c:	d1ec      	bne.n	20020f18 <dfu_flash_init+0x214>
20020f3e:	4b27      	ldr	r3, [pc, #156]	@ (20020fdc <dfu_flash_init+0x2d8>)
20020f40:	4a25      	ldr	r2, [pc, #148]	@ (20020fd8 <dfu_flash_init+0x2d4>)
20020f42:	601a      	str	r2, [r3, #0]
20020f44:	4b26      	ldr	r3, [pc, #152]	@ (20020fe0 <dfu_flash_init+0x2dc>)
20020f46:	4a27      	ldr	r2, [pc, #156]	@ (20020fe4 <dfu_flash_init+0x2e0>)
20020f48:	601a      	str	r2, [r3, #0]
20020f4a:	e7e5      	b.n	20020f18 <dfu_flash_init+0x214>
20020f4c:	481b      	ldr	r0, [pc, #108]	@ (20020fbc <dfu_flash_init+0x2b8>)
20020f4e:	f004 f8f9 	bl	20025144 <HAL_RCC_HCPU_EnableDLL2>
20020f52:	f7ff fa97 	bl	20020484 <board_pinmux_sd>
20020f56:	f000 fd57 	bl	20021a08 <sdmmc1_sdnand>
20020f5a:	2801      	cmp	r0, #1
20020f5c:	d001      	beq.n	20020f62 <dfu_flash_init+0x25e>
20020f5e:	f7ff f9a7 	bl	200202b0 <boot_error>
20020f62:	4b2c      	ldr	r3, [pc, #176]	@ (20021014 <dfu_flash_init+0x310>)
20020f64:	4a2c      	ldr	r2, [pc, #176]	@ (20021018 <dfu_flash_init+0x314>)
20020f66:	6023      	str	r3, [r4, #0]
20020f68:	4b1f      	ldr	r3, [pc, #124]	@ (20020fe8 <dfu_flash_init+0x2e4>)
20020f6a:	601a      	str	r2, [r3, #0]
20020f6c:	2200      	movs	r2, #0
20020f6e:	4b1f      	ldr	r3, [pc, #124]	@ (20020fec <dfu_flash_init+0x2e8>)
20020f70:	601a      	str	r2, [r3, #0]
20020f72:	e738      	b.n	20020de6 <dfu_flash_init+0xe2>
20020f74:	4811      	ldr	r0, [pc, #68]	@ (20020fbc <dfu_flash_init+0x2b8>)
20020f76:	f004 f8e5 	bl	20025144 <HAL_RCC_HCPU_EnableDLL2>
20020f7a:	f7ff fa83 	bl	20020484 <board_pinmux_sd>
20020f7e:	f000 fb33 	bl	200215e8 <sdio_emmc_init>
20020f82:	4b26      	ldr	r3, [pc, #152]	@ (2002101c <dfu_flash_init+0x318>)
20020f84:	6018      	str	r0, [r3, #0]
20020f86:	b110      	cbz	r0, 20020f8e <dfu_flash_init+0x28a>
20020f88:	b2c0      	uxtb	r0, r0
20020f8a:	f7ff f991 	bl	200202b0 <boot_error>
20020f8e:	4b24      	ldr	r3, [pc, #144]	@ (20021020 <dfu_flash_init+0x31c>)
20020f90:	e7e8      	b.n	20020f64 <dfu_flash_init+0x260>
20020f92:	2053      	movs	r0, #83	@ 0x53
20020f94:	f7ff f98c 	bl	200202b0 <boot_error>
20020f98:	e7c4      	b.n	20020f24 <dfu_flash_init+0x220>
20020f9a:	4822      	ldr	r0, [pc, #136]	@ (20021024 <dfu_flash_init+0x320>)
20020f9c:	f001 f92d 	bl	200221fa <HAL_Delay_us>
20020fa0:	3d01      	subs	r5, #1
20020fa2:	f47f af26 	bne.w	20020df2 <dfu_flash_init+0xee>
20020fa6:	2043      	movs	r0, #67	@ 0x43
20020fa8:	b00c      	add	sp, #48	@ 0x30
20020faa:	e8bd 47f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, lr}
20020fae:	f7ff b97f 	b.w	200202b0 <boot_error>
20020fb2:	bf00      	nop
20020fb4:	20049fc8 	.word	0x20049fc8
20020fb8:	20046d68 	.word	0x20046d68
20020fbc:	112a8800 	.word	0x112a8800
20020fc0:	2002ab58 	.word	0x2002ab58
20020fc4:	50081008 	.word	0x50081008
20020fc8:	20046f74 	.word	0x20046f74
20020fcc:	20046d6c 	.word	0x20046d6c
20020fd0:	00176085 	.word	0x00176085
20020fd4:	20020a31 	.word	0x20020a31
20020fd8:	200209a5 	.word	0x200209a5
20020fdc:	20046d64 	.word	0x20046d64
20020fe0:	20046d60 	.word	0x20046d60
20020fe4:	20020949 	.word	0x20020949
20020fe8:	20046d58 	.word	0x20046d58
20020fec:	20046d5c 	.word	0x20046d5c
20020ff0:	200473b8 	.word	0x200473b8
20020ff4:	20042c04 	.word	0x20042c04
20020ff8:	2002ab6c 	.word	0x2002ab6c
20020ffc:	5008101c 	.word	0x5008101c
20021000:	20020a45 	.word	0x20020a45
20021004:	20045ad8 	.word	0x20045ad8
20021008:	20046dd4 	.word	0x20046dd4
2002100c:	20046fc8 	.word	0x20046fc8
20021010:	20044a58 	.word	0x20044a58
20021014:	20020ac5 	.word	0x20020ac5
20021018:	62001000 	.word	0x62001000
2002101c:	20044a54 	.word	0x20044a54
20021020:	20020b49 	.word	0x20020b49
20021024:	000f4240 	.word	0x000f4240
20021028:	53454346 	.word	0x53454346
2002102c:	20042c00 	.word	0x20042c00

20021030 <sifli_hw_efuse_read_bank>:
20021030:	2803      	cmp	r0, #3
20021032:	b508      	push	{r3, lr}
20021034:	d80c      	bhi.n	20021050 <sifli_hw_efuse_read_bank+0x20>
20021036:	0200      	lsls	r0, r0, #8
20021038:	2220      	movs	r2, #32
2002103a:	4907      	ldr	r1, [pc, #28]	@ (20021058 <sifli_hw_efuse_read_bank+0x28>)
2002103c:	f400 407f 	and.w	r0, r0, #65280	@ 0xff00
20021040:	f001 fd84 	bl	20022b4c <HAL_EFUSE_Read>
20021044:	2800      	cmp	r0, #0
20021046:	bf0c      	ite	eq
20021048:	f06f 0001 	mvneq.w	r0, #1
2002104c:	2000      	movne	r0, #0
2002104e:	bd08      	pop	{r3, pc}
20021050:	f04f 30ff 	mov.w	r0, #4294967295
20021054:	e7fb      	b.n	2002104e <sifli_hw_efuse_read_bank+0x1e>
20021056:	bf00      	nop
20021058:	20047338 	.word	0x20047338

2002105c <sifli_hw_efuse_read>:
2002105c:	b513      	push	{r0, r1, r4, lr}
2002105e:	3801      	subs	r0, #1
20021060:	460c      	mov	r4, r1
20021062:	2803      	cmp	r0, #3
20021064:	d81e      	bhi.n	200210a4 <sifli_hw_efuse_read+0x48>
20021066:	e8df f000 	tbb	[pc, r0]
2002106a:	0c02      	.short	0x0c02
2002106c:	1009      	.short	0x1009
2002106e:	2210      	movs	r2, #16
20021070:	2000      	movs	r0, #0
20021072:	b002      	add	sp, #8
20021074:	e8bd 4010 	ldmia.w	sp!, {r4, lr}
20021078:	f001 bd68 	b.w	20022b4c <HAL_EFUSE_Read>
2002107c:	2208      	movs	r2, #8
2002107e:	2080      	movs	r0, #128	@ 0x80
20021080:	e7f7      	b.n	20021072 <sifli_hw_efuse_read+0x16>
20021082:	2220      	movs	r2, #32
20021084:	f44f 7040 	mov.w	r0, #768	@ 0x300
20021088:	e7f3      	b.n	20021072 <sifli_hw_efuse_read+0x16>
2002108a:	2204      	movs	r2, #4
2002108c:	20c0      	movs	r0, #192	@ 0xc0
2002108e:	eb0d 0102 	add.w	r1, sp, r2
20021092:	f001 fd5b 	bl	20022b4c <HAL_EFUSE_Read>
20021096:	2804      	cmp	r0, #4
20021098:	d104      	bne.n	200210a4 <sifli_hw_efuse_read+0x48>
2002109a:	2001      	movs	r0, #1
2002109c:	9b01      	ldr	r3, [sp, #4]
2002109e:	7023      	strb	r3, [r4, #0]
200210a0:	b002      	add	sp, #8
200210a2:	bd10      	pop	{r4, pc}
200210a4:	2000      	movs	r0, #0
200210a6:	e7fb      	b.n	200210a0 <sifli_hw_efuse_read+0x44>

200210a8 <sifli_hw_init_xip_key>:
200210a8:	b538      	push	{r3, r4, r5, lr}
200210aa:	4605      	mov	r5, r0
200210ac:	4c0f      	ldr	r4, [pc, #60]	@ (200210ec <sifli_hw_init_xip_key+0x44>)
200210ae:	2210      	movs	r2, #16
200210b0:	68e3      	ldr	r3, [r4, #12]
200210b2:	490f      	ldr	r1, [pc, #60]	@ (200210f0 <sifli_hw_init_xip_key+0x48>)
200210b4:	f043 0301 	orr.w	r3, r3, #1
200210b8:	60e3      	str	r3, [r4, #12]
200210ba:	2001      	movs	r0, #1
200210bc:	f7ff ffce 	bl	2002105c <sifli_hw_efuse_read>
200210c0:	2220      	movs	r2, #32
200210c2:	2100      	movs	r1, #0
200210c4:	480b      	ldr	r0, [pc, #44]	@ (200210f4 <sifli_hw_init_xip_key+0x4c>)
200210c6:	f009 fcc5 	bl	2002aa54 <memset>
200210ca:	2302      	movs	r3, #2
200210cc:	2120      	movs	r1, #32
200210ce:	4a08      	ldr	r2, [pc, #32]	@ (200210f0 <sifli_hw_init_xip_key+0x48>)
200210d0:	2000      	movs	r0, #0
200210d2:	f001 f90b 	bl	200222ec <HAL_AES_init>
200210d6:	2320      	movs	r3, #32
200210d8:	4629      	mov	r1, r5
200210da:	2000      	movs	r0, #0
200210dc:	4a05      	ldr	r2, [pc, #20]	@ (200210f4 <sifli_hw_init_xip_key+0x4c>)
200210de:	f001 f94b 	bl	20022378 <HAL_AES_run>
200210e2:	68e3      	ldr	r3, [r4, #12]
200210e4:	f023 0301 	bic.w	r3, r3, #1
200210e8:	60e3      	str	r3, [r4, #12]
200210ea:	bd38      	pop	{r3, r4, r5, pc}
200210ec:	5000b000 	.word	0x5000b000
200210f0:	20047368 	.word	0x20047368
200210f4:	20047318 	.word	0x20047318

200210f8 <sifli_hw_dec_key>:
200210f8:	b538      	push	{r3, r4, r5, lr}
200210fa:	4604      	mov	r4, r0
200210fc:	460d      	mov	r5, r1
200210fe:	2210      	movs	r2, #16
20021100:	4908      	ldr	r1, [pc, #32]	@ (20021124 <sifli_hw_dec_key+0x2c>)
20021102:	2001      	movs	r0, #1
20021104:	f7ff ffaa 	bl	2002105c <sifli_hw_efuse_read>
20021108:	2302      	movs	r3, #2
2002110a:	2120      	movs	r1, #32
2002110c:	4a05      	ldr	r2, [pc, #20]	@ (20021124 <sifli_hw_dec_key+0x2c>)
2002110e:	2000      	movs	r0, #0
20021110:	f001 f8ec 	bl	200222ec <HAL_AES_init>
20021114:	2320      	movs	r3, #32
20021116:	462a      	mov	r2, r5
20021118:	4621      	mov	r1, r4
2002111a:	2000      	movs	r0, #0
2002111c:	f001 f92c 	bl	20022378 <HAL_AES_run>
20021120:	2000      	movs	r0, #0
20021122:	bd38      	pop	{r3, r4, r5, pc}
20021124:	20047368 	.word	0x20047368

20021128 <dfu_get_counter>:
20021128:	b538      	push	{r3, r4, r5, lr}
2002112a:	4d0a      	ldr	r5, [pc, #40]	@ (20021154 <dfu_get_counter+0x2c>)
2002112c:	4604      	mov	r4, r0
2002112e:	2208      	movs	r2, #8
20021130:	4629      	mov	r1, r5
20021132:	2003      	movs	r0, #3
20021134:	f7ff ff92 	bl	2002105c <sifli_hw_efuse_read>
20021138:	2300      	movs	r3, #0
2002113a:	e9c5 3302 	strd	r3, r3, [r5, #8]
2002113e:	230f      	movs	r3, #15
20021140:	0924      	lsrs	r4, r4, #4
20021142:	b12c      	cbz	r4, 20021150 <dfu_get_counter+0x28>
20021144:	54ec      	strb	r4, [r5, r3]
20021146:	3b01      	subs	r3, #1
20021148:	2b0b      	cmp	r3, #11
2002114a:	ea4f 2414 	mov.w	r4, r4, lsr #8
2002114e:	d1f8      	bne.n	20021142 <dfu_get_counter+0x1a>
20021150:	4800      	ldr	r0, [pc, #0]	@ (20021154 <dfu_get_counter+0x2c>)
20021152:	bd38      	pop	{r3, r4, r5, pc}
20021154:	20047358 	.word	0x20047358

20021158 <sifli_hw_dec>:
20021158:	e92d 47f0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, lr}
2002115c:	4680      	mov	r8, r0
2002115e:	4689      	mov	r9, r1
20021160:	4692      	mov	sl, r2
20021162:	2100      	movs	r1, #0
20021164:	f44f 7200 	mov.w	r2, #512	@ 0x200
20021168:	4814      	ldr	r0, [pc, #80]	@ (200211bc <sifli_hw_dec+0x64>)
2002116a:	461e      	mov	r6, r3
2002116c:	9f08      	ldr	r7, [sp, #32]
2002116e:	2400      	movs	r4, #0
20021170:	f009 fc70 	bl	2002aa54 <memset>
20021174:	42a6      	cmp	r6, r4
20021176:	d802      	bhi.n	2002117e <sifli_hw_dec+0x26>
20021178:	4620      	mov	r0, r4
2002117a:	e8bd 87f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, pc}
2002117e:	1b35      	subs	r5, r6, r4
20021180:	f5b5 7f00 	cmp.w	r5, #512	@ 0x200
20021184:	bf28      	it	cs
20021186:	f44f 7500 	movcs.w	r5, #512	@ 0x200
2002118a:	eb09 0104 	add.w	r1, r9, r4
2002118e:	462a      	mov	r2, r5
20021190:	480a      	ldr	r0, [pc, #40]	@ (200211bc <sifli_hw_dec+0x64>)
20021192:	f009 fc79 	bl	2002aa88 <memcpy>
20021196:	19e0      	adds	r0, r4, r7
20021198:	f7ff ffc6 	bl	20021128 <dfu_get_counter>
2002119c:	2301      	movs	r3, #1
2002119e:	4602      	mov	r2, r0
200211a0:	2120      	movs	r1, #32
200211a2:	4640      	mov	r0, r8
200211a4:	f001 f8a2 	bl	200222ec <HAL_AES_init>
200211a8:	eb0a 0204 	add.w	r2, sl, r4
200211ac:	462b      	mov	r3, r5
200211ae:	2000      	movs	r0, #0
200211b0:	4902      	ldr	r1, [pc, #8]	@ (200211bc <sifli_hw_dec+0x64>)
200211b2:	f001 f8e1 	bl	20022378 <HAL_AES_run>
200211b6:	442c      	add	r4, r5
200211b8:	e7dc      	b.n	20021174 <sifli_hw_dec+0x1c>
200211ba:	bf00      	nop
200211bc:	20047118 	.word	0x20047118

200211c0 <update_sec_flash>:
200211c0:	b510      	push	{r4, lr}
200211c2:	4604      	mov	r4, r0
200211c4:	4b08      	ldr	r3, [pc, #32]	@ (200211e8 <update_sec_flash+0x28>)
200211c6:	f44f 5140 	mov.w	r1, #12288	@ 0x3000
200211ca:	681b      	ldr	r3, [r3, #0]
200211cc:	f04f 5090 	mov.w	r0, #301989888	@ 0x12000000
200211d0:	4798      	blx	r3
200211d2:	4b06      	ldr	r3, [pc, #24]	@ (200211ec <update_sec_flash+0x2c>)
200211d4:	4621      	mov	r1, r4
200211d6:	e8bd 4010 	ldmia.w	sp!, {r4, lr}
200211da:	f642 4210 	movw	r2, #11280	@ 0x2c10
200211de:	f04f 5090 	mov.w	r0, #301989888	@ 0x12000000
200211e2:	681b      	ldr	r3, [r3, #0]
200211e4:	4718      	bx	r3
200211e6:	bf00      	nop
200211e8:	20046d60 	.word	0x20046d60
200211ec:	20046d68 	.word	0x20046d68

200211f0 <boot_ram>:
200211f0:	4b05      	ldr	r3, [pc, #20]	@ (20021208 <boot_ram+0x18>)
200211f2:	b082      	sub	sp, #8
200211f4:	6b9b      	ldr	r3, [r3, #56]	@ 0x38
200211f6:	9301      	str	r3, [sp, #4]
200211f8:	9b01      	ldr	r3, [sp, #4]
200211fa:	b113      	cbz	r3, 20021202 <boot_ram+0x12>
200211fc:	9b01      	ldr	r3, [sp, #4]
200211fe:	b002      	add	sp, #8
20021200:	4718      	bx	r3
20021202:	b002      	add	sp, #8
20021204:	4770      	bx	lr
20021206:	bf00      	nop
20021208:	500c0000 	.word	0x500c0000

2002120c <is_addr_in_nor>:
2002120c:	4b09      	ldr	r3, [pc, #36]	@ (20021234 <is_addr_in_nor+0x28>)
2002120e:	4602      	mov	r2, r0
20021210:	681b      	ldr	r3, [r3, #0]
20021212:	b163      	cbz	r3, 2002122e <is_addr_in_nor+0x22>
20021214:	f893 002b 	ldrb.w	r0, [r3, #43]	@ 0x2b
20021218:	b948      	cbnz	r0, 2002122e <is_addr_in_nor+0x22>
2002121a:	6919      	ldr	r1, [r3, #16]
2002121c:	4291      	cmp	r1, r2
2002121e:	d807      	bhi.n	20021230 <is_addr_in_nor+0x24>
20021220:	695b      	ldr	r3, [r3, #20]
20021222:	4419      	add	r1, r3
20021224:	4291      	cmp	r1, r2
20021226:	bf94      	ite	ls
20021228:	2000      	movls	r0, #0
2002122a:	2001      	movhi	r0, #1
2002122c:	4770      	bx	lr
2002122e:	2000      	movs	r0, #0
20021230:	4770      	bx	lr
20021232:	bf00      	nop
20021234:	20046d5c 	.word	0x20046d5c

20021238 <dfu_boot_img_in_flash>:
20021238:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
2002123c:	4f5e      	ldr	r7, [pc, #376]	@ (200213b8 <dfu_boot_img_in_flash+0x180>)
2002123e:	1e84      	subs	r4, r0, #2
20021240:	eb07 1300 	add.w	r3, r7, r0, lsl #4
20021244:	eb07 2040 	add.w	r0, r7, r0, lsl #9
20021248:	f8d3 8004 	ldr.w	r8, [r3, #4]
2002124c:	68dd      	ldr	r5, [r3, #12]
2002124e:	f8b0 3c06 	ldrh.w	r3, [r0, #3078]	@ 0xc06
20021252:	b085      	sub	sp, #20
20021254:	07db      	lsls	r3, r3, #31
20021256:	f140 8095 	bpl.w	20021384 <dfu_boot_img_in_flash+0x14c>
2002125a:	f44f 7193 	mov.w	r1, #294	@ 0x126
2002125e:	f507 7082 	add.w	r0, r7, #260	@ 0x104
20021262:	f000 fe6a 	bl	20021f3a <sifli_sigkey_pub_verify>
20021266:	b110      	cbz	r0, 2002126e <dfu_boot_img_in_flash+0x36>
20021268:	2001      	movs	r0, #1
2002126a:	f000 feb3 	bl	20021fd4 <sifli_secboot_exception>
2002126e:	2c07      	cmp	r4, #7
20021270:	f300 8093 	bgt.w	2002139a <dfu_boot_img_in_flash+0x162>
20021274:	2003      	movs	r0, #3
20021276:	f7ff fedb 	bl	20021030 <sifli_hw_efuse_read_bank>
2002127a:	4262      	negs	r2, r4
2002127c:	f002 0203 	and.w	r2, r2, #3
20021280:	f004 0303 	and.w	r3, r4, #3
20021284:	bf58      	it	pl
20021286:	4253      	negpl	r3, r2
20021288:	2b02      	cmp	r3, #2
2002128a:	f200 8086 	bhi.w	2002139a <dfu_boot_img_in_flash+0x162>
2002128e:	4628      	mov	r0, r5
20021290:	f7ff ffbc 	bl	2002120c <is_addr_in_nor>
20021294:	f241 0308 	movw	r3, #4104	@ 0x1008
20021298:	4682      	mov	sl, r0
2002129a:	ea4f 2944 	mov.w	r9, r4, lsl #9
2002129e:	f8df c12c 	ldr.w	ip, [pc, #300]	@ 200213cc <dfu_boot_img_in_flash+0x194>
200212a2:	eb07 0609 	add.w	r6, r7, r9
200212a6:	441e      	add	r6, r3
200212a8:	ce0f      	ldmia	r6!, {r0, r1, r2, r3}
200212aa:	e8ac 000f 	stmia.w	ip!, {r0, r1, r2, r3}
200212ae:	e896 000f 	ldmia.w	r6, {r0, r1, r2, r3}
200212b2:	e88c 000f 	stmia.w	ip, {r0, r1, r2, r3}
200212b6:	f1ba 0f00 	cmp.w	sl, #0
200212ba:	d04b      	beq.n	20021354 <dfu_boot_img_in_flash+0x11c>
200212bc:	f104 0608 	add.w	r6, r4, #8
200212c0:	f1ac 0010 	sub.w	r0, ip, #16
200212c4:	0276      	lsls	r6, r6, #9
200212c6:	f7ff feef 	bl	200210a8 <sifli_hw_init_xip_key>
200212ca:	59ba      	ldr	r2, [r7, r6]
200212cc:	f8df a0f0 	ldr.w	sl, [pc, #240]	@ 200213c0 <dfu_boot_img_in_flash+0x188>
200212d0:	442a      	add	r2, r5
200212d2:	2000      	movs	r0, #0
200212d4:	f8da b000 	ldr.w	fp, [sl]
200212d8:	9203      	str	r2, [sp, #12]
200212da:	f7ff ff25 	bl	20021128 <dfu_get_counter>
200212de:	4629      	mov	r1, r5
200212e0:	4603      	mov	r3, r0
200212e2:	9a03      	ldr	r2, [sp, #12]
200212e4:	4658      	mov	r0, fp
200212e6:	f002 fa90 	bl	2002380a <HAL_FLASH_NONCE_CFG>
200212ea:	4629      	mov	r1, r5
200212ec:	f8da 0000 	ldr.w	r0, [sl]
200212f0:	59ba      	ldr	r2, [r7, r6]
200212f2:	eba8 0305 	sub.w	r3, r8, r5
200212f6:	f002 fa77 	bl	200237e8 <HAL_FLASH_ALIAS_CFG>
200212fa:	2101      	movs	r1, #1
200212fc:	f8da 0000 	ldr.w	r0, [sl]
20021300:	f002 fa9b 	bl	2002383a <HAL_FLASH_AES_CFG>
20021304:	f104 0308 	add.w	r3, r4, #8
20021308:	f509 5081 	add.w	r0, r9, #4128	@ 0x1020
2002130c:	025b      	lsls	r3, r3, #9
2002130e:	3008      	adds	r0, #8
20021310:	462a      	mov	r2, r5
20021312:	58fb      	ldr	r3, [r7, r3]
20021314:	4929      	ldr	r1, [pc, #164]	@ (200213bc <dfu_boot_img_in_flash+0x184>)
20021316:	4438      	add	r0, r7
20021318:	f000 fe27 	bl	20021f6a <sifli_img_sig_hash_verify>
2002131c:	b110      	cbz	r0, 20021324 <dfu_boot_img_in_flash+0xec>
2002131e:	2002      	movs	r0, #2
20021320:	f000 fe58 	bl	20021fd4 <sifli_secboot_exception>
20021324:	f8d5 d000 	ldr.w	sp, [r5]
20021328:	f8d5 f004 	ldr.w	pc, [r5, #4]
2002132c:	4628      	mov	r0, r5
2002132e:	f7ff ff6d 	bl	2002120c <is_addr_in_nor>
20021332:	2800      	cmp	r0, #0
20021334:	d034      	beq.n	200213a0 <dfu_boot_img_in_flash+0x168>
20021336:	4822      	ldr	r0, [pc, #136]	@ (200213c0 <dfu_boot_img_in_flash+0x188>)
20021338:	3408      	adds	r4, #8
2002133a:	0264      	lsls	r4, r4, #9
2002133c:	4629      	mov	r1, r5
2002133e:	593a      	ldr	r2, [r7, r4]
20021340:	6800      	ldr	r0, [r0, #0]
20021342:	eba8 0305 	sub.w	r3, r8, r5
20021346:	f002 fa4f 	bl	200237e8 <HAL_FLASH_ALIAS_CFG>
2002134a:	f8d5 d000 	ldr.w	sp, [r5]
2002134e:	f8d5 f004 	ldr.w	pc, [r5, #4]
20021352:	e022      	b.n	2002139a <dfu_boot_img_in_flash+0x162>
20021354:	f1ac 0010 	sub.w	r0, ip, #16
20021358:	2220      	movs	r2, #32
2002135a:	491a      	ldr	r1, [pc, #104]	@ (200213c4 <dfu_boot_img_in_flash+0x18c>)
2002135c:	f7ff fecc 	bl	200210f8 <sifli_hw_dec_key>
20021360:	f104 0608 	add.w	r6, r4, #8
20021364:	4b18      	ldr	r3, [pc, #96]	@ (200213c8 <dfu_boot_img_in_flash+0x190>)
20021366:	0276      	lsls	r6, r6, #9
20021368:	4629      	mov	r1, r5
2002136a:	59ba      	ldr	r2, [r7, r6]
2002136c:	4640      	mov	r0, r8
2002136e:	681b      	ldr	r3, [r3, #0]
20021370:	4798      	blx	r3
20021372:	f8cd a000 	str.w	sl, [sp]
20021376:	462a      	mov	r2, r5
20021378:	4629      	mov	r1, r5
2002137a:	59bb      	ldr	r3, [r7, r6]
2002137c:	4811      	ldr	r0, [pc, #68]	@ (200213c4 <dfu_boot_img_in_flash+0x18c>)
2002137e:	f7ff feeb 	bl	20021158 <sifli_hw_dec>
20021382:	e7bf      	b.n	20021304 <dfu_boot_img_in_flash+0xcc>
20021384:	2c07      	cmp	r4, #7
20021386:	dc08      	bgt.n	2002139a <dfu_boot_img_in_flash+0x162>
20021388:	4262      	negs	r2, r4
2002138a:	f002 0203 	and.w	r2, r2, #3
2002138e:	f004 0303 	and.w	r3, r4, #3
20021392:	bf58      	it	pl
20021394:	4253      	negpl	r3, r2
20021396:	2b02      	cmp	r3, #2
20021398:	d9c8      	bls.n	2002132c <dfu_boot_img_in_flash+0xf4>
2002139a:	b005      	add	sp, #20
2002139c:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
200213a0:	45a8      	cmp	r8, r5
200213a2:	d0d2      	beq.n	2002134a <dfu_boot_img_in_flash+0x112>
200213a4:	4b08      	ldr	r3, [pc, #32]	@ (200213c8 <dfu_boot_img_in_flash+0x190>)
200213a6:	3408      	adds	r4, #8
200213a8:	0264      	lsls	r4, r4, #9
200213aa:	4629      	mov	r1, r5
200213ac:	4640      	mov	r0, r8
200213ae:	681b      	ldr	r3, [r3, #0]
200213b0:	593a      	ldr	r2, [r7, r4]
200213b2:	4798      	blx	r3
200213b4:	e7c9      	b.n	2002134a <dfu_boot_img_in_flash+0x112>
200213b6:	bf00      	nop
200213b8:	200473b8 	.word	0x200473b8
200213bc:	200474bc 	.word	0x200474bc
200213c0:	20046d5c 	.word	0x20046d5c
200213c4:	20047378 	.word	0x20047378
200213c8:	20046d68 	.word	0x20046d68
200213cc:	20047398 	.word	0x20047398

200213d0 <boot_images_help>:
200213d0:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
200213d4:	4e52      	ldr	r6, [pc, #328]	@ (20021520 <boot_images_help+0x150>)
200213d6:	f8df a158 	ldr.w	sl, [pc, #344]	@ 20021530 <boot_images_help+0x160>
200213da:	6833      	ldr	r3, [r6, #0]
200213dc:	b085      	sub	sp, #20
200213de:	4553      	cmp	r3, sl
200213e0:	d150      	bne.n	20021484 <boot_images_help+0xb4>
200213e2:	2208      	movs	r2, #8
200213e4:	2300      	movs	r3, #0
200213e6:	f8df b14c 	ldr.w	fp, [pc, #332]	@ 20021534 <boot_images_help+0x164>
200213ea:	eb0d 0102 	add.w	r1, sp, r2
200213ee:	e9cd 3302 	strd	r3, r3, [sp, #8]
200213f2:	484c      	ldr	r0, [pc, #304]	@ (20021524 <boot_images_help+0x154>)
200213f4:	f8db 3000 	ldr.w	r3, [fp]
200213f8:	4798      	blx	r3
200213fa:	2008      	movs	r0, #8
200213fc:	f00b f866 	bl	2002c4cc <HAL_Get_backup>
20021400:	4605      	mov	r5, r0
20021402:	2005      	movs	r0, #5
20021404:	f00b f862 	bl	2002c4cc <HAL_Get_backup>
20021408:	f8df 912c 	ldr.w	r9, [pc, #300]	@ 20021538 <boot_images_help+0x168>
2002140c:	4946      	ldr	r1, [pc, #280]	@ (20021528 <boot_images_help+0x158>)
2002140e:	f8d9 4000 	ldr.w	r4, [r9]
20021412:	f8df 8128 	ldr.w	r8, [pc, #296]	@ 2002153c <boot_images_help+0x16c>
20021416:	f642 4210 	movw	r2, #11280	@ 0x2c10
2002141a:	f8db 3000 	ldr.w	r3, [fp]
2002141e:	4607      	mov	r7, r0
20021420:	f8c8 1000 	str.w	r1, [r8]
20021424:	4620      	mov	r0, r4
20021426:	f506 5600 	add.w	r6, r6, #8192	@ 0x2000
2002142a:	4798      	blx	r3
2002142c:	f8d6 bc08 	ldr.w	fp, [r6, #3080]	@ 0xc08
20021430:	f504 52a0 	add.w	r2, r4, #5120	@ 0x1400
20021434:	4593      	cmp	fp, r2
20021436:	d14e      	bne.n	200214d6 <boot_images_help+0x106>
20021438:	b2eb      	uxtb	r3, r5
2002143a:	2b04      	cmp	r3, #4
2002143c:	d025      	beq.n	2002148a <boot_images_help+0xba>
2002143e:	2b06      	cmp	r3, #6
20021440:	d039      	beq.n	200214b6 <boot_images_help+0xe6>
20021442:	2b01      	cmp	r3, #1
20021444:	d142      	bne.n	200214cc <boot_images_help+0xfc>
20021446:	2005      	movs	r0, #5
20021448:	f00b f840 	bl	2002c4cc <HAL_Get_backup>
2002144c:	2802      	cmp	r0, #2
2002144e:	d006      	beq.n	2002145e <boot_images_help+0x8e>
20021450:	9b02      	ldr	r3, [sp, #8]
20021452:	4553      	cmp	r3, sl
20021454:	d106      	bne.n	20021464 <boot_images_help+0x94>
20021456:	f89d 300d 	ldrb.w	r3, [sp, #13]
2002145a:	2b7f      	cmp	r3, #127	@ 0x7f
2002145c:	d102      	bne.n	20021464 <boot_images_help+0x94>
2002145e:	4b33      	ldr	r3, [pc, #204]	@ (2002152c <boot_images_help+0x15c>)
20021460:	f8c6 3c08 	str.w	r3, [r6, #3080]	@ 0xc08
20021464:	f8d6 3c08 	ldr.w	r3, [r6, #3080]	@ 0xc08
20021468:	1c5a      	adds	r2, r3, #1
2002146a:	d00b      	beq.n	20021484 <boot_images_help+0xb4>
2002146c:	f8d9 4000 	ldr.w	r4, [r9]
20021470:	1b1c      	subs	r4, r3, r4
20021472:	f5a4 5480 	sub.w	r4, r4, #4096	@ 0x1000
20021476:	0a64      	lsrs	r4, r4, #9
20021478:	3402      	adds	r4, #2
2002147a:	f7ff fa37 	bl	200208ec <board_init_psram>
2002147e:	4620      	mov	r0, r4
20021480:	f7ff feda 	bl	20021238 <dfu_boot_img_in_flash>
20021484:	b005      	add	sp, #20
20021486:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
2002148a:	2008      	movs	r0, #8
2002148c:	f504 54e0 	add.w	r4, r4, #7168	@ 0x1c00
20021490:	2106      	movs	r1, #6
20021492:	f8c6 4c08 	str.w	r4, [r6, #3080]	@ 0xc08
20021496:	f00b f813 	bl	2002c4c0 <HAL_Set_backup>
2002149a:	f8d8 0000 	ldr.w	r0, [r8]
2002149e:	f500 5300 	add.w	r3, r0, #8192	@ 0x2000
200214a2:	f8c3 4c08 	str.w	r4, [r3, #3080]	@ 0xc08
200214a6:	b11f      	cbz	r7, 200214b0 <boot_images_help+0xe0>
200214a8:	f500 5380 	add.w	r3, r0, #4096	@ 0x1000
200214ac:	f8c3 7c00 	str.w	r7, [r3, #3072]	@ 0xc00
200214b0:	f7ff fe86 	bl	200211c0 <update_sec_flash>
200214b4:	e7c7      	b.n	20021446 <boot_images_help+0x76>
200214b6:	2101      	movs	r1, #1
200214b8:	2008      	movs	r0, #8
200214ba:	f00b f801 	bl	2002c4c0 <HAL_Set_backup>
200214be:	f8d8 0000 	ldr.w	r0, [r8]
200214c2:	f500 5300 	add.w	r3, r0, #8192	@ 0x2000
200214c6:	f8c3 bc08 	str.w	fp, [r3, #3080]	@ 0xc08
200214ca:	e7f1      	b.n	200214b0 <boot_images_help+0xe0>
200214cc:	2101      	movs	r1, #1
200214ce:	2008      	movs	r0, #8
200214d0:	f00a fff6 	bl	2002c4c0 <HAL_Set_backup>
200214d4:	e7b7      	b.n	20021446 <boot_images_help+0x76>
200214d6:	f504 54e0 	add.w	r4, r4, #7168	@ 0x1c00
200214da:	45a3      	cmp	fp, r4
200214dc:	d1b3      	bne.n	20021446 <boot_images_help+0x76>
200214de:	b2eb      	uxtb	r3, r5
200214e0:	2b03      	cmp	r3, #3
200214e2:	d005      	beq.n	200214f0 <boot_images_help+0x120>
200214e4:	2b05      	cmp	r3, #5
200214e6:	d018      	beq.n	2002151a <boot_images_help+0x14a>
200214e8:	2b02      	cmp	r3, #2
200214ea:	d0ac      	beq.n	20021446 <boot_images_help+0x76>
200214ec:	2102      	movs	r1, #2
200214ee:	e7ee      	b.n	200214ce <boot_images_help+0xfe>
200214f0:	2008      	movs	r0, #8
200214f2:	2105      	movs	r1, #5
200214f4:	f8c6 2c08 	str.w	r2, [r6, #3080]	@ 0xc08
200214f8:	9201      	str	r2, [sp, #4]
200214fa:	f00a ffe1 	bl	2002c4c0 <HAL_Set_backup>
200214fe:	f8d8 0000 	ldr.w	r0, [r8]
20021502:	9a01      	ldr	r2, [sp, #4]
20021504:	f500 5300 	add.w	r3, r0, #8192	@ 0x2000
20021508:	f8c3 2c08 	str.w	r2, [r3, #3080]	@ 0xc08
2002150c:	2f00      	cmp	r7, #0
2002150e:	d0cf      	beq.n	200214b0 <boot_images_help+0xe0>
20021510:	f500 5380 	add.w	r3, r0, #4096	@ 0x1000
20021514:	f8c3 7400 	str.w	r7, [r3, #1024]	@ 0x400
20021518:	e7ca      	b.n	200214b0 <boot_images_help+0xe0>
2002151a:	2102      	movs	r1, #2
2002151c:	e7cc      	b.n	200214b8 <boot_images_help+0xe8>
2002151e:	bf00      	nop
20021520:	200473b8 	.word	0x200473b8
20021524:	12880000 	.word	0x12880000
20021528:	20049fd0 	.word	0x20049fd0
2002152c:	12001000 	.word	0x12001000
20021530:	53454346 	.word	0x53454346
20021534:	20046d68 	.word	0x20046d68
20021538:	20046d58 	.word	0x20046d58
2002153c:	20049fcc 	.word	0x20049fcc

20021540 <hw_preinit0>:
20021540:	b508      	push	{r3, lr}
20021542:	4b0e      	ldr	r3, [pc, #56]	@ (2002157c <hw_preinit0+0x3c>)
20021544:	685b      	ldr	r3, [r3, #4]
20021546:	b2db      	uxtb	r3, r3
20021548:	2b06      	cmp	r3, #6
2002154a:	d80a      	bhi.n	20021562 <hw_preinit0+0x22>
2002154c:	4a0c      	ldr	r2, [pc, #48]	@ (20021580 <hw_preinit0+0x40>)
2002154e:	6a93      	ldr	r3, [r2, #40]	@ 0x28
20021550:	f023 037f 	bic.w	r3, r3, #127	@ 0x7f
20021554:	f043 0306 	orr.w	r3, r3, #6
20021558:	6293      	str	r3, [r2, #40]	@ 0x28
2002155a:	6853      	ldr	r3, [r2, #4]
2002155c:	f043 0380 	orr.w	r3, r3, #128	@ 0x80
20021560:	6053      	str	r3, [r2, #4]
20021562:	2000      	movs	r0, #0
20021564:	f000 fe49 	bl	200221fa <HAL_Delay_us>
20021568:	4b06      	ldr	r3, [pc, #24]	@ (20021584 <hw_preinit0+0x44>)
2002156a:	4a07      	ldr	r2, [pc, #28]	@ (20021588 <hw_preinit0+0x48>)
2002156c:	2000      	movs	r0, #0
2002156e:	605a      	str	r2, [r3, #4]
20021570:	f7ff fd5e 	bl	20021030 <sifli_hw_efuse_read_bank>
20021574:	e8bd 4008 	ldmia.w	sp!, {r3, lr}
20021578:	f7ff be3a 	b.w	200211f0 <boot_ram>
2002157c:	5000b000 	.word	0x5000b000
20021580:	500ca000 	.word	0x500ca000
20021584:	5000c000 	.word	0x5000c000
20021588:	0002d08f 	.word	0x0002d08f

2002158c <entry>:
2002158c:	4c14      	ldr	r4, [pc, #80]	@ (200215e0 <entry+0x54>)
2002158e:	b508      	push	{r3, lr}
20021590:	2000      	movs	r0, #0
20021592:	f000 fe32 	bl	200221fa <HAL_Delay_us>
20021596:	6863      	ldr	r3, [r4, #4]
20021598:	4d12      	ldr	r5, [pc, #72]	@ (200215e4 <entry+0x58>)
2002159a:	b2db      	uxtb	r3, r3
2002159c:	2b06      	cmp	r3, #6
2002159e:	d90f      	bls.n	200215c0 <entry+0x34>
200215a0:	f7fe ffc4 	bl	2002052c <board_flash_power_on>
200215a4:	f7fe feac 	bl	20020300 <HAL_MspInit>
200215a8:	f7fe ff9c 	bl	200204e4 <board_boot_from>
200215ac:	6028      	str	r0, [r5, #0]
200215ae:	68e3      	ldr	r3, [r4, #12]
200215b0:	f023 0301 	bic.w	r3, r3, #1
200215b4:	60e3      	str	r3, [r4, #12]
200215b6:	f7ff fba5 	bl	20020d04 <dfu_flash_init>
200215ba:	f7ff ff09 	bl	200213d0 <boot_images_help>
200215be:	e7fe      	b.n	200215be <entry+0x32>
200215c0:	f7fe ff90 	bl	200204e4 <board_boot_from>
200215c4:	6028      	str	r0, [r5, #0]
200215c6:	f7fe ffb1 	bl	2002052c <board_flash_power_on>
200215ca:	f7fe fe99 	bl	20020300 <HAL_MspInit>
200215ce:	68e3      	ldr	r3, [r4, #12]
200215d0:	f023 0301 	bic.w	r3, r3, #1
200215d4:	60e3      	str	r3, [r4, #12]
200215d6:	f7ff fb95 	bl	20020d04 <dfu_flash_init>
200215da:	f7ff fef9 	bl	200213d0 <boot_images_help>
200215de:	e7ee      	b.n	200215be <entry+0x32>
200215e0:	5000b000 	.word	0x5000b000
200215e4:	20049fc8 	.word	0x20049fc8

200215e8 <sdio_emmc_init>:
200215e8:	b570      	push	{r4, r5, r6, lr}
200215ea:	b08c      	sub	sp, #48	@ 0x30
200215ec:	f000 f968 	bl	200218c0 <sd1_init>
200215f0:	4c8d      	ldr	r4, [pc, #564]	@ (20021828 <sdio_emmc_init+0x240>)
200215f2:	4b8e      	ldr	r3, [pc, #568]	@ (2002182c <sdio_emmc_init+0x244>)
200215f4:	2500      	movs	r5, #0
200215f6:	6323      	str	r3, [r4, #48]	@ 0x30
200215f8:	6b23      	ldr	r3, [r4, #48]	@ 0x30
200215fa:	f44f 70fa 	mov.w	r0, #500	@ 0x1f4
200215fe:	f043 0302 	orr.w	r3, r3, #2
20021602:	6323      	str	r3, [r4, #48]	@ 0x30
20021604:	f04f 7300 	mov.w	r3, #33554432	@ 0x2000000
20021608:	62e5      	str	r5, [r4, #44]	@ 0x2c
2002160a:	6223      	str	r3, [r4, #32]
2002160c:	f000 fdf5 	bl	200221fa <HAL_Delay_us>
20021610:	4629      	mov	r1, r5
20021612:	4628      	mov	r0, r5
20021614:	f000 f986 	bl	20021924 <sd1_send_cmd>
20021618:	2301      	movs	r3, #1
2002161a:	65e3      	str	r3, [r4, #92]	@ 0x5c
2002161c:	6de3      	ldr	r3, [r4, #92]	@ 0x5c
2002161e:	079d      	lsls	r5, r3, #30
20021620:	d5fc      	bpl.n	2002161c <sdio_emmc_init+0x34>
20021622:	6be3      	ldr	r3, [r4, #60]	@ 0x3c
20021624:	f043 0320 	orr.w	r3, r3, #32
20021628:	63e3      	str	r3, [r4, #60]	@ 0x3c
2002162a:	4981      	ldr	r1, [pc, #516]	@ (20021830 <sdio_emmc_init+0x248>)
2002162c:	2001      	movs	r0, #1
2002162e:	ad07      	add	r5, sp, #28
20021630:	f000 f978 	bl	20021924 <sd1_send_cmd>
20021634:	ab06      	add	r3, sp, #24
20021636:	aa05      	add	r2, sp, #20
20021638:	a904      	add	r1, sp, #16
2002163a:	f10d 000f 	add.w	r0, sp, #15
2002163e:	9500      	str	r5, [sp, #0]
20021640:	f000 f9ae 	bl	200219a0 <sd1_get_rsp>
20021644:	2014      	movs	r0, #20
20021646:	f000 fdd8 	bl	200221fa <HAL_Delay_us>
2002164a:	9b04      	ldr	r3, [sp, #16]
2002164c:	2b00      	cmp	r3, #0
2002164e:	daec      	bge.n	2002162a <sdio_emmc_init+0x42>
20021650:	2014      	movs	r0, #20
20021652:	f000 fdd2 	bl	200221fa <HAL_Delay_us>
20021656:	2100      	movs	r1, #0
20021658:	2002      	movs	r0, #2
2002165a:	f000 f963 	bl	20021924 <sd1_send_cmd>
2002165e:	2801      	cmp	r0, #1
20021660:	f000 8081 	beq.w	20021766 <sdio_emmc_init+0x17e>
20021664:	2802      	cmp	r0, #2
20021666:	d07e      	beq.n	20021766 <sdio_emmc_init+0x17e>
20021668:	ab08      	add	r3, sp, #32
2002166a:	aa0a      	add	r2, sp, #40	@ 0x28
2002166c:	a90b      	add	r1, sp, #44	@ 0x2c
2002166e:	9300      	str	r3, [sp, #0]
20021670:	f10d 000f 	add.w	r0, sp, #15
20021674:	ab09      	add	r3, sp, #36	@ 0x24
20021676:	f000 f993 	bl	200219a0 <sd1_get_rsp>
2002167a:	2014      	movs	r0, #20
2002167c:	f000 fdbd 	bl	200221fa <HAL_Delay_us>
20021680:	f44f 3180 	mov.w	r1, #65536	@ 0x10000
20021684:	2003      	movs	r0, #3
20021686:	f000 f94d 	bl	20021924 <sd1_send_cmd>
2002168a:	2801      	cmp	r0, #1
2002168c:	f000 80ab 	beq.w	200217e6 <sdio_emmc_init+0x1fe>
20021690:	2802      	cmp	r0, #2
20021692:	f000 80aa 	beq.w	200217ea <sdio_emmc_init+0x202>
20021696:	ab06      	add	r3, sp, #24
20021698:	9500      	str	r5, [sp, #0]
2002169a:	aa05      	add	r2, sp, #20
2002169c:	a904      	add	r1, sp, #16
2002169e:	f10d 000f 	add.w	r0, sp, #15
200216a2:	f000 f97d 	bl	200219a0 <sd1_get_rsp>
200216a6:	f89d 300f 	ldrb.w	r3, [sp, #15]
200216aa:	2b03      	cmp	r3, #3
200216ac:	f040 809f 	bne.w	200217ee <sdio_emmc_init+0x206>
200216b0:	4c5d      	ldr	r4, [pc, #372]	@ (20021828 <sdio_emmc_init+0x240>)
200216b2:	2014      	movs	r0, #20
200216b4:	6be3      	ldr	r3, [r4, #60]	@ 0x3c
200216b6:	f023 0320 	bic.w	r3, r3, #32
200216ba:	63e3      	str	r3, [r4, #60]	@ 0x3c
200216bc:	f000 fd9d 	bl	200221fa <HAL_Delay_us>
200216c0:	f44f 3180 	mov.w	r1, #65536	@ 0x10000
200216c4:	2009      	movs	r0, #9
200216c6:	f000 f92d 	bl	20021924 <sd1_send_cmd>
200216ca:	2801      	cmp	r0, #1
200216cc:	f000 8091 	beq.w	200217f2 <sdio_emmc_init+0x20a>
200216d0:	2802      	cmp	r0, #2
200216d2:	f000 8090 	beq.w	200217f6 <sdio_emmc_init+0x20e>
200216d6:	aa05      	add	r2, sp, #20
200216d8:	a904      	add	r1, sp, #16
200216da:	ab06      	add	r3, sp, #24
200216dc:	f10d 000f 	add.w	r0, sp, #15
200216e0:	9500      	str	r5, [sp, #0]
200216e2:	f000 f95d 	bl	200219a0 <sd1_get_rsp>
200216e6:	f44f 53b8 	mov.w	r3, #5888	@ 0x1700
200216ea:	6323      	str	r3, [r4, #48]	@ 0x30
200216ec:	6b23      	ldr	r3, [r4, #48]	@ 0x30
200216ee:	2014      	movs	r0, #20
200216f0:	f043 0302 	orr.w	r3, r3, #2
200216f4:	6323      	str	r3, [r4, #48]	@ 0x30
200216f6:	f04f 7300 	mov.w	r3, #33554432	@ 0x2000000
200216fa:	6223      	str	r3, [r4, #32]
200216fc:	2302      	movs	r3, #2
200216fe:	63e3      	str	r3, [r4, #60]	@ 0x3c
20021700:	f000 fd7b 	bl	200221fa <HAL_Delay_us>
20021704:	f44f 3180 	mov.w	r1, #65536	@ 0x10000
20021708:	2007      	movs	r0, #7
2002170a:	f000 f90b 	bl	20021924 <sd1_send_cmd>
2002170e:	2801      	cmp	r0, #1
20021710:	d073      	beq.n	200217fa <sdio_emmc_init+0x212>
20021712:	2802      	cmp	r0, #2
20021714:	d073      	beq.n	200217fe <sdio_emmc_init+0x216>
20021716:	ab06      	add	r3, sp, #24
20021718:	9500      	str	r5, [sp, #0]
2002171a:	aa05      	add	r2, sp, #20
2002171c:	a904      	add	r1, sp, #16
2002171e:	f10d 000f 	add.w	r0, sp, #15
20021722:	f000 f93d 	bl	200219a0 <sd1_get_rsp>
20021726:	f89d 300f 	ldrb.w	r3, [sp, #15]
2002172a:	2b07      	cmp	r3, #7
2002172c:	d169      	bne.n	20021802 <sdio_emmc_init+0x21a>
2002172e:	f04f 33ff 	mov.w	r3, #4294967295
20021732:	2101      	movs	r1, #1
20021734:	2000      	movs	r0, #0
20021736:	6023      	str	r3, [r4, #0]
20021738:	f000 f942 	bl	200219c0 <sd1_read>
2002173c:	2100      	movs	r1, #0
2002173e:	2008      	movs	r0, #8
20021740:	f000 f8f0 	bl	20021924 <sd1_send_cmd>
20021744:	2801      	cmp	r0, #1
20021746:	d05e      	beq.n	20021806 <sdio_emmc_init+0x21e>
20021748:	2802      	cmp	r0, #2
2002174a:	d05e      	beq.n	2002180a <sdio_emmc_init+0x222>
2002174c:	ab06      	add	r3, sp, #24
2002174e:	9500      	str	r5, [sp, #0]
20021750:	aa05      	add	r2, sp, #20
20021752:	a904      	add	r1, sp, #16
20021754:	f10d 000f 	add.w	r0, sp, #15
20021758:	f000 f922 	bl	200219a0 <sd1_get_rsp>
2002175c:	f89d 300f 	ldrb.w	r3, [sp, #15]
20021760:	2b08      	cmp	r3, #8
20021762:	d002      	beq.n	2002176a <sdio_emmc_init+0x182>
20021764:	200d      	movs	r0, #13
20021766:	b00c      	add	sp, #48	@ 0x30
20021768:	bd70      	pop	{r4, r5, r6, pc}
2002176a:	2320      	movs	r3, #32
2002176c:	62e3      	str	r3, [r4, #44]	@ 0x2c
2002176e:	f000 f937 	bl	200219e0 <sd1_wait_read>
20021772:	6823      	ldr	r3, [r4, #0]
20021774:	0618      	lsls	r0, r3, #24
20021776:	d4f5      	bmi.n	20021764 <sdio_emmc_init+0x17c>
20021778:	6823      	ldr	r3, [r4, #0]
2002177a:	0659      	lsls	r1, r3, #25
2002177c:	d447      	bmi.n	2002180e <sdio_emmc_init+0x226>
2002177e:	2680      	movs	r6, #128	@ 0x80
20021780:	3e01      	subs	r6, #1
20021782:	f8d4 3200 	ldr.w	r3, [r4, #512]	@ 0x200
20021786:	d1fb      	bne.n	20021780 <sdio_emmc_init+0x198>
20021788:	2101      	movs	r1, #1
2002178a:	4630      	mov	r0, r6
2002178c:	f000 f918 	bl	200219c0 <sd1_read>
20021790:	2014      	movs	r0, #20
20021792:	f000 fd32 	bl	200221fa <HAL_Delay_us>
20021796:	f04f 33ff 	mov.w	r3, #4294967295
2002179a:	4631      	mov	r1, r6
2002179c:	2011      	movs	r0, #17
2002179e:	6023      	str	r3, [r4, #0]
200217a0:	f000 f8c0 	bl	20021924 <sd1_send_cmd>
200217a4:	2801      	cmp	r0, #1
200217a6:	d034      	beq.n	20021812 <sdio_emmc_init+0x22a>
200217a8:	2802      	cmp	r0, #2
200217aa:	d034      	beq.n	20021816 <sdio_emmc_init+0x22e>
200217ac:	ab06      	add	r3, sp, #24
200217ae:	9500      	str	r5, [sp, #0]
200217b0:	aa05      	add	r2, sp, #20
200217b2:	a904      	add	r1, sp, #16
200217b4:	f10d 000f 	add.w	r0, sp, #15
200217b8:	f000 f8f2 	bl	200219a0 <sd1_get_rsp>
200217bc:	f89d 300f 	ldrb.w	r3, [sp, #15]
200217c0:	2b11      	cmp	r3, #17
200217c2:	d12a      	bne.n	2002181a <sdio_emmc_init+0x232>
200217c4:	2320      	movs	r3, #32
200217c6:	62e3      	str	r3, [r4, #44]	@ 0x2c
200217c8:	f000 f90a 	bl	200219e0 <sd1_wait_read>
200217cc:	6823      	ldr	r3, [r4, #0]
200217ce:	061a      	lsls	r2, r3, #24
200217d0:	d425      	bmi.n	2002181e <sdio_emmc_init+0x236>
200217d2:	6823      	ldr	r3, [r4, #0]
200217d4:	065b      	lsls	r3, r3, #25
200217d6:	d424      	bmi.n	20021822 <sdio_emmc_init+0x23a>
200217d8:	2080      	movs	r0, #128	@ 0x80
200217da:	4b13      	ldr	r3, [pc, #76]	@ (20021828 <sdio_emmc_init+0x240>)
200217dc:	3801      	subs	r0, #1
200217de:	f8d3 2200 	ldr.w	r2, [r3, #512]	@ 0x200
200217e2:	d1fb      	bne.n	200217dc <sdio_emmc_init+0x1f4>
200217e4:	e7bf      	b.n	20021766 <sdio_emmc_init+0x17e>
200217e6:	2003      	movs	r0, #3
200217e8:	e7bd      	b.n	20021766 <sdio_emmc_init+0x17e>
200217ea:	2004      	movs	r0, #4
200217ec:	e7bb      	b.n	20021766 <sdio_emmc_init+0x17e>
200217ee:	2005      	movs	r0, #5
200217f0:	e7b9      	b.n	20021766 <sdio_emmc_init+0x17e>
200217f2:	2006      	movs	r0, #6
200217f4:	e7b7      	b.n	20021766 <sdio_emmc_init+0x17e>
200217f6:	2007      	movs	r0, #7
200217f8:	e7b5      	b.n	20021766 <sdio_emmc_init+0x17e>
200217fa:	2008      	movs	r0, #8
200217fc:	e7b3      	b.n	20021766 <sdio_emmc_init+0x17e>
200217fe:	2009      	movs	r0, #9
20021800:	e7b1      	b.n	20021766 <sdio_emmc_init+0x17e>
20021802:	200a      	movs	r0, #10
20021804:	e7af      	b.n	20021766 <sdio_emmc_init+0x17e>
20021806:	200b      	movs	r0, #11
20021808:	e7ad      	b.n	20021766 <sdio_emmc_init+0x17e>
2002180a:	200c      	movs	r0, #12
2002180c:	e7ab      	b.n	20021766 <sdio_emmc_init+0x17e>
2002180e:	200e      	movs	r0, #14
20021810:	e7a9      	b.n	20021766 <sdio_emmc_init+0x17e>
20021812:	2011      	movs	r0, #17
20021814:	e7a7      	b.n	20021766 <sdio_emmc_init+0x17e>
20021816:	2012      	movs	r0, #18
20021818:	e7a5      	b.n	20021766 <sdio_emmc_init+0x17e>
2002181a:	2013      	movs	r0, #19
2002181c:	e7a3      	b.n	20021766 <sdio_emmc_init+0x17e>
2002181e:	2014      	movs	r0, #20
20021820:	e7a1      	b.n	20021766 <sdio_emmc_init+0x17e>
20021822:	2015      	movs	r0, #21
20021824:	e79f      	b.n	20021766 <sdio_emmc_init+0x17e>
20021826:	bf00      	nop
20021828:	50045000 	.word	0x50045000
2002182c:	00016700 	.word	0x00016700
20021830:	40000080 	.word	0x40000080

20021834 <emmc_read_data>:
20021834:	e92d 41f0 	stmdb	sp!, {r4, r5, r6, r7, r8, lr}
20021838:	4607      	mov	r7, r0
2002183a:	f04f 38ff 	mov.w	r8, #4294967295
2002183e:	b088      	sub	sp, #32
20021840:	2000      	movs	r0, #0
20021842:	460d      	mov	r5, r1
20021844:	4e1d      	ldr	r6, [pc, #116]	@ (200218bc <emmc_read_data+0x88>)
20021846:	2101      	movs	r1, #1
20021848:	4614      	mov	r4, r2
2002184a:	f000 f8b9 	bl	200219c0 <sd1_read>
2002184e:	2014      	movs	r0, #20
20021850:	f000 fcd3 	bl	200221fa <HAL_Delay_us>
20021854:	2011      	movs	r0, #17
20021856:	f8c6 8000 	str.w	r8, [r6]
2002185a:	0a79      	lsrs	r1, r7, #9
2002185c:	f000 f862 	bl	20021924 <sd1_send_cmd>
20021860:	4440      	add	r0, r8
20021862:	b2c0      	uxtb	r0, r0
20021864:	2801      	cmp	r0, #1
20021866:	d803      	bhi.n	20021870 <emmc_read_data+0x3c>
20021868:	2000      	movs	r0, #0
2002186a:	b008      	add	sp, #32
2002186c:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}
20021870:	ab07      	add	r3, sp, #28
20021872:	9300      	str	r3, [sp, #0]
20021874:	aa05      	add	r2, sp, #20
20021876:	ab06      	add	r3, sp, #24
20021878:	a904      	add	r1, sp, #16
2002187a:	f10d 000f 	add.w	r0, sp, #15
2002187e:	f000 f88f 	bl	200219a0 <sd1_get_rsp>
20021882:	f89d 300f 	ldrb.w	r3, [sp, #15]
20021886:	2b11      	cmp	r3, #17
20021888:	d1ee      	bne.n	20021868 <emmc_read_data+0x34>
2002188a:	2320      	movs	r3, #32
2002188c:	f8c6 8000 	str.w	r8, [r6]
20021890:	62f3      	str	r3, [r6, #44]	@ 0x2c
20021892:	f000 f8a5 	bl	200219e0 <sd1_wait_read>
20021896:	6833      	ldr	r3, [r6, #0]
20021898:	061a      	lsls	r2, r3, #24
2002189a:	d4e5      	bmi.n	20021868 <emmc_read_data+0x34>
2002189c:	6833      	ldr	r3, [r6, #0]
2002189e:	065b      	lsls	r3, r3, #25
200218a0:	d4e2      	bmi.n	20021868 <emmc_read_data+0x34>
200218a2:	f024 0303 	bic.w	r3, r4, #3
200218a6:	442b      	add	r3, r5
200218a8:	429d      	cmp	r5, r3
200218aa:	d101      	bne.n	200218b0 <emmc_read_data+0x7c>
200218ac:	4620      	mov	r0, r4
200218ae:	e7dc      	b.n	2002186a <emmc_read_data+0x36>
200218b0:	f8d6 2200 	ldr.w	r2, [r6, #512]	@ 0x200
200218b4:	f845 2b04 	str.w	r2, [r5], #4
200218b8:	e7f6      	b.n	200218a8 <emmc_read_data+0x74>
200218ba:	bf00      	nop
200218bc:	50045000 	.word	0x50045000

200218c0 <sd1_init>:
200218c0:	b510      	push	{r4, lr}
200218c2:	f04f 44a0 	mov.w	r4, #1342177280	@ 0x50000000
200218c6:	68e3      	ldr	r3, [r4, #12]
200218c8:	2064      	movs	r0, #100	@ 0x64
200218ca:	f023 0310 	bic.w	r3, r3, #16
200218ce:	60e3      	str	r3, [r4, #12]
200218d0:	f000 fc93 	bl	200221fa <HAL_Delay_us>
200218d4:	68e3      	ldr	r3, [r4, #12]
200218d6:	4a07      	ldr	r2, [pc, #28]	@ (200218f4 <sd1_init+0x34>)
200218d8:	f043 0310 	orr.w	r3, r3, #16
200218dc:	60e3      	str	r3, [r4, #12]
200218de:	6913      	ldr	r3, [r2, #16]
200218e0:	f043 0302 	orr.w	r3, r3, #2
200218e4:	6113      	str	r3, [r2, #16]
200218e6:	f44f 7280 	mov.w	r2, #256	@ 0x100
200218ea:	4b03      	ldr	r3, [pc, #12]	@ (200218f8 <sd1_init+0x38>)
200218ec:	631a      	str	r2, [r3, #48]	@ 0x30
200218ee:	2200      	movs	r2, #0
200218f0:	63da      	str	r2, [r3, #60]	@ 0x3c
200218f2:	bd10      	pop	{r4, pc}
200218f4:	5000b000 	.word	0x5000b000
200218f8:	50045000 	.word	0x50045000

200218fc <sd1_wait_cmd>:
200218fc:	4b08      	ldr	r3, [pc, #32]	@ (20021920 <sd1_wait_cmd+0x24>)
200218fe:	681a      	ldr	r2, [r3, #0]
20021900:	f012 0f0a 	tst.w	r2, #10
20021904:	d0fb      	beq.n	200218fe <sd1_wait_cmd+0x2>
20021906:	2202      	movs	r2, #2
20021908:	601a      	str	r2, [r3, #0]
2002190a:	681a      	ldr	r2, [r3, #0]
2002190c:	0712      	lsls	r2, r2, #28
2002190e:	bf5f      	itttt	pl
20021910:	6818      	ldrpl	r0, [r3, #0]
20021912:	f3c0 0080 	ubfxpl	r0, r0, #2, #1
20021916:	0040      	lslpl	r0, r0, #1
20021918:	b2c0      	uxtbpl	r0, r0
2002191a:	bf48      	it	mi
2002191c:	2001      	movmi	r0, #1
2002191e:	4770      	bx	lr
20021920:	50045000 	.word	0x50045000

20021924 <sd1_send_cmd>:
20021924:	4b0e      	ldr	r3, [pc, #56]	@ (20021960 <sd1_send_cmd+0x3c>)
20021926:	280f      	cmp	r0, #15
20021928:	6099      	str	r1, [r3, #8]
2002192a:	ea4f 4380 	mov.w	r3, r0, lsl #18
2002192e:	d813      	bhi.n	20021958 <sd1_send_cmd+0x34>
20021930:	2201      	movs	r2, #1
20021932:	f248 0111 	movw	r1, #32785	@ 0x8011
20021936:	4082      	lsls	r2, r0
20021938:	420a      	tst	r2, r1
2002193a:	d105      	bne.n	20021948 <sd1_send_cmd+0x24>
2002193c:	f240 6104 	movw	r1, #1540	@ 0x604
20021940:	420a      	tst	r2, r1
20021942:	d009      	beq.n	20021958 <sd1_send_cmd+0x34>
20021944:	f443 3340 	orr.w	r3, r3, #196608	@ 0x30000
20021948:	4a05      	ldr	r2, [pc, #20]	@ (20021960 <sd1_send_cmd+0x3c>)
2002194a:	f443 7380 	orr.w	r3, r3, #256	@ 0x100
2002194e:	f043 0301 	orr.w	r3, r3, #1
20021952:	6053      	str	r3, [r2, #4]
20021954:	f7ff bfd2 	b.w	200218fc <sd1_wait_cmd>
20021958:	f443 3380 	orr.w	r3, r3, #65536	@ 0x10000
2002195c:	e7f4      	b.n	20021948 <sd1_send_cmd+0x24>
2002195e:	bf00      	nop
20021960:	50045000 	.word	0x50045000

20021964 <sd1_send_acmd>:
20021964:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
20021966:	4605      	mov	r5, r0
20021968:	460f      	mov	r7, r1
2002196a:	2037      	movs	r0, #55	@ 0x37
2002196c:	0411      	lsls	r1, r2, #16
2002196e:	f7ff ffd9 	bl	20021924 <sd1_send_cmd>
20021972:	4604      	mov	r4, r0
20021974:	b968      	cbnz	r0, 20021992 <sd1_send_acmd+0x2e>
20021976:	4b08      	ldr	r3, [pc, #32]	@ (20021998 <sd1_send_acmd+0x34>)
20021978:	4e08      	ldr	r6, [pc, #32]	@ (2002199c <sd1_send_acmd+0x38>)
2002197a:	ea43 4385 	orr.w	r3, r3, r5, lsl #18
2002197e:	60b7      	str	r7, [r6, #8]
20021980:	6073      	str	r3, [r6, #4]
20021982:	f7ff ffbb 	bl	200218fc <sd1_wait_cmd>
20021986:	2802      	cmp	r0, #2
20021988:	d104      	bne.n	20021994 <sd1_send_acmd+0x30>
2002198a:	2d29      	cmp	r5, #41	@ 0x29
2002198c:	d102      	bne.n	20021994 <sd1_send_acmd+0x30>
2002198e:	2304      	movs	r3, #4
20021990:	6033      	str	r3, [r6, #0]
20021992:	4620      	mov	r0, r4
20021994:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
20021996:	bf00      	nop
20021998:	00010101 	.word	0x00010101
2002199c:	50045000 	.word	0x50045000

200219a0 <sd1_get_rsp>:
200219a0:	b530      	push	{r4, r5, lr}
200219a2:	4c06      	ldr	r4, [pc, #24]	@ (200219bc <sd1_get_rsp+0x1c>)
200219a4:	68e5      	ldr	r5, [r4, #12]
200219a6:	7005      	strb	r5, [r0, #0]
200219a8:	6920      	ldr	r0, [r4, #16]
200219aa:	6008      	str	r0, [r1, #0]
200219ac:	6961      	ldr	r1, [r4, #20]
200219ae:	6011      	str	r1, [r2, #0]
200219b0:	69a2      	ldr	r2, [r4, #24]
200219b2:	601a      	str	r2, [r3, #0]
200219b4:	69e2      	ldr	r2, [r4, #28]
200219b6:	9b03      	ldr	r3, [sp, #12]
200219b8:	601a      	str	r2, [r3, #0]
200219ba:	bd30      	pop	{r4, r5, pc}
200219bc:	50045000 	.word	0x50045000

200219c0 <sd1_read>:
200219c0:	f04f 33ff 	mov.w	r3, #4294967295
200219c4:	4a04      	ldr	r2, [pc, #16]	@ (200219d8 <sd1_read+0x18>)
200219c6:	eb03 2341 	add.w	r3, r3, r1, lsl #9
200219ca:	6293      	str	r3, [r2, #40]	@ 0x28
200219cc:	4b03      	ldr	r3, [pc, #12]	@ (200219dc <sd1_read+0x1c>)
200219ce:	ea43 23c0 	orr.w	r3, r3, r0, lsl #11
200219d2:	6253      	str	r3, [r2, #36]	@ 0x24
200219d4:	4770      	bx	lr
200219d6:	bf00      	nop
200219d8:	50045000 	.word	0x50045000
200219dc:	01ff0301 	.word	0x01ff0301

200219e0 <sd1_wait_read>:
200219e0:	4b08      	ldr	r3, [pc, #32]	@ (20021a04 <sd1_wait_read+0x24>)
200219e2:	681a      	ldr	r2, [r3, #0]
200219e4:	f012 0fe0 	tst.w	r2, #224	@ 0xe0
200219e8:	d0fb      	beq.n	200219e2 <sd1_wait_read+0x2>
200219ea:	2220      	movs	r2, #32
200219ec:	601a      	str	r2, [r3, #0]
200219ee:	681a      	ldr	r2, [r3, #0]
200219f0:	0612      	lsls	r2, r2, #24
200219f2:	bf5f      	itttt	pl
200219f4:	6818      	ldrpl	r0, [r3, #0]
200219f6:	f3c0 1080 	ubfxpl	r0, r0, #6, #1
200219fa:	0040      	lslpl	r0, r0, #1
200219fc:	b2c0      	uxtbpl	r0, r0
200219fe:	bf48      	it	mi
20021a00:	2001      	movmi	r0, #1
20021a02:	4770      	bx	lr
20021a04:	50045000 	.word	0x50045000

20021a08 <sdmmc1_sdnand>:
20021a08:	b5f0      	push	{r4, r5, r6, r7, lr}
20021a0a:	b08d      	sub	sp, #52	@ 0x34
20021a0c:	f7ff ff58 	bl	200218c0 <sd1_init>
20021a10:	4c76      	ldr	r4, [pc, #472]	@ (20021bec <sdmmc1_sdnand+0x1e4>)
20021a12:	4b77      	ldr	r3, [pc, #476]	@ (20021bf0 <sdmmc1_sdnand+0x1e8>)
20021a14:	2500      	movs	r5, #0
20021a16:	6323      	str	r3, [r4, #48]	@ 0x30
20021a18:	6b23      	ldr	r3, [r4, #48]	@ 0x30
20021a1a:	f44f 70fa 	mov.w	r0, #500	@ 0x1f4
20021a1e:	f043 0302 	orr.w	r3, r3, #2
20021a22:	6323      	str	r3, [r4, #48]	@ 0x30
20021a24:	f44f 1380 	mov.w	r3, #1048576	@ 0x100000
20021a28:	62e5      	str	r5, [r4, #44]	@ 0x2c
20021a2a:	6223      	str	r3, [r4, #32]
20021a2c:	f000 fbe5 	bl	200221fa <HAL_Delay_us>
20021a30:	4629      	mov	r1, r5
20021a32:	4628      	mov	r0, r5
20021a34:	f7ff ff76 	bl	20021924 <sd1_send_cmd>
20021a38:	2301      	movs	r3, #1
20021a3a:	65e3      	str	r3, [r4, #92]	@ 0x5c
20021a3c:	6de3      	ldr	r3, [r4, #92]	@ 0x5c
20021a3e:	079b      	lsls	r3, r3, #30
20021a40:	d5fc      	bpl.n	20021a3c <sdmmc1_sdnand+0x34>
20021a42:	2014      	movs	r0, #20
20021a44:	f000 fbd9 	bl	200221fa <HAL_Delay_us>
20021a48:	f44f 71d5 	mov.w	r1, #426	@ 0x1aa
20021a4c:	2008      	movs	r0, #8
20021a4e:	f7ff ff69 	bl	20021924 <sd1_send_cmd>
20021a52:	3801      	subs	r0, #1
20021a54:	b2c0      	uxtb	r0, r0
20021a56:	2801      	cmp	r0, #1
20021a58:	d802      	bhi.n	20021a60 <sdmmc1_sdnand+0x58>
20021a5a:	2038      	movs	r0, #56	@ 0x38
20021a5c:	b00d      	add	sp, #52	@ 0x34
20021a5e:	bdf0      	pop	{r4, r5, r6, r7, pc}
20021a60:	ac07      	add	r4, sp, #28
20021a62:	ab06      	add	r3, sp, #24
20021a64:	9400      	str	r4, [sp, #0]
20021a66:	aa05      	add	r2, sp, #20
20021a68:	a904      	add	r1, sp, #16
20021a6a:	f10d 000f 	add.w	r0, sp, #15
20021a6e:	f7ff ff97 	bl	200219a0 <sd1_get_rsp>
20021a72:	f89d 300f 	ldrb.w	r3, [sp, #15]
20021a76:	2b08      	cmp	r3, #8
20021a78:	d1ef      	bne.n	20021a5a <sdmmc1_sdnand+0x52>
20021a7a:	9b04      	ldr	r3, [sp, #16]
20021a7c:	f5b3 7fd5 	cmp.w	r3, #426	@ 0x1aa
20021a80:	d1eb      	bne.n	20021a5a <sdmmc1_sdnand+0x52>
20021a82:	2014      	movs	r0, #20
20021a84:	f000 fbb9 	bl	200221fa <HAL_Delay_us>
20021a88:	2200      	movs	r2, #0
20021a8a:	2029      	movs	r0, #41	@ 0x29
20021a8c:	4959      	ldr	r1, [pc, #356]	@ (20021bf4 <sdmmc1_sdnand+0x1ec>)
20021a8e:	f7ff ff69 	bl	20021964 <sd1_send_acmd>
20021a92:	2801      	cmp	r0, #1
20021a94:	f000 80a2 	beq.w	20021bdc <sdmmc1_sdnand+0x1d4>
20021a98:	ab06      	add	r3, sp, #24
20021a9a:	9400      	str	r4, [sp, #0]
20021a9c:	aa05      	add	r2, sp, #20
20021a9e:	a904      	add	r1, sp, #16
20021aa0:	f10d 000f 	add.w	r0, sp, #15
20021aa4:	f7ff ff7c 	bl	200219a0 <sd1_get_rsp>
20021aa8:	9b04      	ldr	r3, [sp, #16]
20021aaa:	2b00      	cmp	r3, #0
20021aac:	db03      	blt.n	20021ab6 <sdmmc1_sdnand+0xae>
20021aae:	2002      	movs	r0, #2
20021ab0:	f000 fba3 	bl	200221fa <HAL_Delay_us>
20021ab4:	e7e5      	b.n	20021a82 <sdmmc1_sdnand+0x7a>
20021ab6:	2014      	movs	r0, #20
20021ab8:	f000 fb9f 	bl	200221fa <HAL_Delay_us>
20021abc:	2100      	movs	r1, #0
20021abe:	2002      	movs	r0, #2
20021ac0:	f7ff ff30 	bl	20021924 <sd1_send_cmd>
20021ac4:	3801      	subs	r0, #1
20021ac6:	b2c0      	uxtb	r0, r0
20021ac8:	2801      	cmp	r0, #1
20021aca:	f240 8089 	bls.w	20021be0 <sdmmc1_sdnand+0x1d8>
20021ace:	ab08      	add	r3, sp, #32
20021ad0:	aa0a      	add	r2, sp, #40	@ 0x28
20021ad2:	a90b      	add	r1, sp, #44	@ 0x2c
20021ad4:	9300      	str	r3, [sp, #0]
20021ad6:	f10d 000f 	add.w	r0, sp, #15
20021ada:	ab09      	add	r3, sp, #36	@ 0x24
20021adc:	f7ff ff60 	bl	200219a0 <sd1_get_rsp>
20021ae0:	2014      	movs	r0, #20
20021ae2:	f000 fb8a 	bl	200221fa <HAL_Delay_us>
20021ae6:	2100      	movs	r1, #0
20021ae8:	2003      	movs	r0, #3
20021aea:	f7ff ff1b 	bl	20021924 <sd1_send_cmd>
20021aee:	3801      	subs	r0, #1
20021af0:	b2c0      	uxtb	r0, r0
20021af2:	2801      	cmp	r0, #1
20021af4:	d801      	bhi.n	20021afa <sdmmc1_sdnand+0xf2>
20021af6:	2033      	movs	r0, #51	@ 0x33
20021af8:	e7b0      	b.n	20021a5c <sdmmc1_sdnand+0x54>
20021afa:	ab06      	add	r3, sp, #24
20021afc:	9400      	str	r4, [sp, #0]
20021afe:	aa05      	add	r2, sp, #20
20021b00:	a904      	add	r1, sp, #16
20021b02:	f10d 000f 	add.w	r0, sp, #15
20021b06:	f7ff ff4b 	bl	200219a0 <sd1_get_rsp>
20021b0a:	f89d 300f 	ldrb.w	r3, [sp, #15]
20021b0e:	2b03      	cmp	r3, #3
20021b10:	d1f1      	bne.n	20021af6 <sdmmc1_sdnand+0xee>
20021b12:	9d04      	ldr	r5, [sp, #16]
20021b14:	2014      	movs	r0, #20
20021b16:	0c2e      	lsrs	r6, r5, #16
20021b18:	0436      	lsls	r6, r6, #16
20021b1a:	f000 fb6e 	bl	200221fa <HAL_Delay_us>
20021b1e:	4631      	mov	r1, r6
20021b20:	2009      	movs	r0, #9
20021b22:	f7ff feff 	bl	20021924 <sd1_send_cmd>
20021b26:	3801      	subs	r0, #1
20021b28:	b2c0      	uxtb	r0, r0
20021b2a:	2801      	cmp	r0, #1
20021b2c:	d95a      	bls.n	20021be4 <sdmmc1_sdnand+0x1dc>
20021b2e:	ab06      	add	r3, sp, #24
20021b30:	aa05      	add	r2, sp, #20
20021b32:	a904      	add	r1, sp, #16
20021b34:	f10d 000f 	add.w	r0, sp, #15
20021b38:	9400      	str	r4, [sp, #0]
20021b3a:	f7ff ff31 	bl	200219a0 <sd1_get_rsp>
20021b3e:	e9dd 2004 	ldrd	r2, r0, [sp, #16]
20021b42:	9f06      	ldr	r7, [sp, #24]
20021b44:	9907      	ldr	r1, [sp, #28]
20021b46:	0e3b      	lsrs	r3, r7, #24
20021b48:	ea43 2301 	orr.w	r3, r3, r1, lsl #8
20021b4c:	0e01      	lsrs	r1, r0, #24
20021b4e:	ea41 2107 	orr.w	r1, r1, r7, lsl #8
20021b52:	9105      	str	r1, [sp, #20]
20021b54:	0e11      	lsrs	r1, r2, #24
20021b56:	9304      	str	r3, [sp, #16]
20021b58:	ea41 2100 	orr.w	r1, r1, r0, lsl #8
20021b5c:	0212      	lsls	r2, r2, #8
20021b5e:	0f9b      	lsrs	r3, r3, #30
20021b60:	9106      	str	r1, [sp, #24]
20021b62:	9207      	str	r2, [sp, #28]
20021b64:	d01d      	beq.n	20021ba2 <sdmmc1_sdnand+0x19a>
20021b66:	2b01      	cmp	r3, #1
20021b68:	d13e      	bne.n	20021be8 <sdmmc1_sdnand+0x1e0>
20021b6a:	2300      	movs	r3, #0
20021b6c:	4a22      	ldr	r2, [pc, #136]	@ (20021bf8 <sdmmc1_sdnand+0x1f0>)
20021b6e:	2014      	movs	r0, #20
20021b70:	7013      	strb	r3, [r2, #0]
20021b72:	f44f 7200 	mov.w	r2, #512	@ 0x200
20021b76:	4b1d      	ldr	r3, [pc, #116]	@ (20021bec <sdmmc1_sdnand+0x1e4>)
20021b78:	631a      	str	r2, [r3, #48]	@ 0x30
20021b7a:	6b1a      	ldr	r2, [r3, #48]	@ 0x30
20021b7c:	f042 0202 	orr.w	r2, r2, #2
20021b80:	631a      	str	r2, [r3, #48]	@ 0x30
20021b82:	4a1e      	ldr	r2, [pc, #120]	@ (20021bfc <sdmmc1_sdnand+0x1f4>)
20021b84:	621a      	str	r2, [r3, #32]
20021b86:	2200      	movs	r2, #0
20021b88:	63da      	str	r2, [r3, #60]	@ 0x3c
20021b8a:	f000 fb36 	bl	200221fa <HAL_Delay_us>
20021b8e:	4631      	mov	r1, r6
20021b90:	2007      	movs	r0, #7
20021b92:	f7ff fec7 	bl	20021924 <sd1_send_cmd>
20021b96:	3801      	subs	r0, #1
20021b98:	b2c0      	uxtb	r0, r0
20021b9a:	2801      	cmp	r0, #1
20021b9c:	d803      	bhi.n	20021ba6 <sdmmc1_sdnand+0x19e>
20021b9e:	2037      	movs	r0, #55	@ 0x37
20021ba0:	e75c      	b.n	20021a5c <sdmmc1_sdnand+0x54>
20021ba2:	2301      	movs	r3, #1
20021ba4:	e7e2      	b.n	20021b6c <sdmmc1_sdnand+0x164>
20021ba6:	ab06      	add	r3, sp, #24
20021ba8:	9400      	str	r4, [sp, #0]
20021baa:	aa05      	add	r2, sp, #20
20021bac:	a904      	add	r1, sp, #16
20021bae:	f10d 000f 	add.w	r0, sp, #15
20021bb2:	f7ff fef5 	bl	200219a0 <sd1_get_rsp>
20021bb6:	f89d 300f 	ldrb.w	r3, [sp, #15]
20021bba:	2b07      	cmp	r3, #7
20021bbc:	d1ef      	bne.n	20021b9e <sdmmc1_sdnand+0x196>
20021bbe:	2014      	movs	r0, #20
20021bc0:	f000 fb1b 	bl	200221fa <HAL_Delay_us>
20021bc4:	2102      	movs	r1, #2
20021bc6:	2006      	movs	r0, #6
20021bc8:	0c2a      	lsrs	r2, r5, #16
20021bca:	f7ff fecb 	bl	20021964 <sd1_send_acmd>
20021bce:	3801      	subs	r0, #1
20021bd0:	b2c0      	uxtb	r0, r0
20021bd2:	2801      	cmp	r0, #1
20021bd4:	bf8c      	ite	hi
20021bd6:	2001      	movhi	r0, #1
20021bd8:	2036      	movls	r0, #54	@ 0x36
20021bda:	e73f      	b.n	20021a5c <sdmmc1_sdnand+0x54>
20021bdc:	2034      	movs	r0, #52	@ 0x34
20021bde:	e73d      	b.n	20021a5c <sdmmc1_sdnand+0x54>
20021be0:	2032      	movs	r0, #50	@ 0x32
20021be2:	e73b      	b.n	20021a5c <sdmmc1_sdnand+0x54>
20021be4:	2039      	movs	r0, #57	@ 0x39
20021be6:	e739      	b.n	20021a5c <sdmmc1_sdnand+0x54>
20021be8:	2054      	movs	r0, #84	@ 0x54
20021bea:	e737      	b.n	20021a5c <sdmmc1_sdnand+0x54>
20021bec:	50045000 	.word	0x50045000
20021bf0:	00016700 	.word	0x00016700
20021bf4:	40ff8000 	.word	0x40ff8000
20021bf8:	20042c08 	.word	0x20042c08
20021bfc:	00249f00 	.word	0x00249f00

20021c00 <sd_read_data>:
20021c00:	b570      	push	{r4, r5, r6, lr}
20021c02:	f1b1 4fc0 	cmp.w	r1, #1610612736	@ 0x60000000
20021c06:	4605      	mov	r5, r0
20021c08:	4614      	mov	r4, r2
20021c0a:	b088      	sub	sp, #32
20021c0c:	d314      	bcc.n	20021c38 <sd_read_data+0x38>
20021c0e:	2a00      	cmp	r2, #0
20021c10:	dd12      	ble.n	20021c38 <sd_read_data+0x38>
20021c12:	f001 021f 	and.w	r2, r1, #31
20021c16:	4422      	add	r2, r4
20021c18:	f021 031f 	bic.w	r3, r1, #31
20021c1c:	f3bf 8f4f 	dsb	sy
20021c20:	4e30      	ldr	r6, [pc, #192]	@ (20021ce4 <sd_read_data+0xe4>)
20021c22:	441a      	add	r2, r3
20021c24:	f8c6 325c 	str.w	r3, [r6, #604]	@ 0x25c
20021c28:	3320      	adds	r3, #32
20021c2a:	1ad0      	subs	r0, r2, r3
20021c2c:	2800      	cmp	r0, #0
20021c2e:	dcf9      	bgt.n	20021c24 <sd_read_data+0x24>
20021c30:	f3bf 8f4f 	dsb	sy
20021c34:	f3bf 8f6f 	isb	sy
20021c38:	2200      	movs	r2, #0
20021c3a:	4b2b      	ldr	r3, [pc, #172]	@ (20021ce8 <sd_read_data+0xe8>)
20021c3c:	631a      	str	r2, [r3, #48]	@ 0x30
20021c3e:	4a2b      	ldr	r2, [pc, #172]	@ (20021cec <sd_read_data+0xec>)
20021c40:	639a      	str	r2, [r3, #56]	@ 0x38
20021c42:	2280      	movs	r2, #128	@ 0x80
20021c44:	63d9      	str	r1, [r3, #60]	@ 0x3c
20021c46:	635a      	str	r2, [r3, #52]	@ 0x34
20021c48:	f8d3 20a8 	ldr.w	r2, [r3, #168]	@ 0xa8
20021c4c:	2101      	movs	r1, #1
20021c4e:	f422 127c 	bic.w	r2, r2, #4128768	@ 0x3f0000
20021c52:	f442 1264 	orr.w	r2, r2, #3735552	@ 0x390000
20021c56:	f8c3 20a8 	str.w	r2, [r3, #168]	@ 0xa8
20021c5a:	f44f 6228 	mov.w	r2, #2688	@ 0xa80
20021c5e:	631a      	str	r2, [r3, #48]	@ 0x30
20021c60:	6b1a      	ldr	r2, [r3, #48]	@ 0x30
20021c62:	4608      	mov	r0, r1
20021c64:	f022 0220 	bic.w	r2, r2, #32
20021c68:	631a      	str	r2, [r3, #48]	@ 0x30
20021c6a:	6b1a      	ldr	r2, [r3, #48]	@ 0x30
20021c6c:	f042 0201 	orr.w	r2, r2, #1
20021c70:	631a      	str	r2, [r3, #48]	@ 0x30
20021c72:	f7ff fea5 	bl	200219c0 <sd1_read>
20021c76:	2014      	movs	r0, #20
20021c78:	f000 fabf 	bl	200221fa <HAL_Delay_us>
20021c7c:	4b1c      	ldr	r3, [pc, #112]	@ (20021cf0 <sd_read_data+0xf0>)
20021c7e:	781b      	ldrb	r3, [r3, #0]
20021c80:	b903      	cbnz	r3, 20021c84 <sd_read_data+0x84>
20021c82:	0a6d      	lsrs	r5, r5, #9
20021c84:	4629      	mov	r1, r5
20021c86:	2011      	movs	r0, #17
20021c88:	f7ff fe4c 	bl	20021924 <sd1_send_cmd>
20021c8c:	3801      	subs	r0, #1
20021c8e:	b2c0      	uxtb	r0, r0
20021c90:	2801      	cmp	r0, #1
20021c92:	d802      	bhi.n	20021c9a <sd_read_data+0x9a>
20021c94:	2000      	movs	r0, #0
20021c96:	b008      	add	sp, #32
20021c98:	bd70      	pop	{r4, r5, r6, pc}
20021c9a:	ab07      	add	r3, sp, #28
20021c9c:	9300      	str	r3, [sp, #0]
20021c9e:	aa05      	add	r2, sp, #20
20021ca0:	ab06      	add	r3, sp, #24
20021ca2:	a904      	add	r1, sp, #16
20021ca4:	f10d 000f 	add.w	r0, sp, #15
20021ca8:	f7ff fe7a 	bl	200219a0 <sd1_get_rsp>
20021cac:	f89d 300f 	ldrb.w	r3, [sp, #15]
20021cb0:	2b11      	cmp	r3, #17
20021cb2:	d1ef      	bne.n	20021c94 <sd_read_data+0x94>
20021cb4:	f04f 33ff 	mov.w	r3, #4294967295
20021cb8:	4d0e      	ldr	r5, [pc, #56]	@ (20021cf4 <sd_read_data+0xf4>)
20021cba:	602b      	str	r3, [r5, #0]
20021cbc:	2320      	movs	r3, #32
20021cbe:	62eb      	str	r3, [r5, #44]	@ 0x2c
20021cc0:	f7ff fe8e 	bl	200219e0 <sd1_wait_read>
20021cc4:	682b      	ldr	r3, [r5, #0]
20021cc6:	061a      	lsls	r2, r3, #24
20021cc8:	d4e4      	bmi.n	20021c94 <sd_read_data+0x94>
20021cca:	682b      	ldr	r3, [r5, #0]
20021ccc:	065b      	lsls	r3, r3, #25
20021cce:	d4e1      	bmi.n	20021c94 <sd_read_data+0x94>
20021cd0:	4b05      	ldr	r3, [pc, #20]	@ (20021ce8 <sd_read_data+0xe8>)
20021cd2:	6b5a      	ldr	r2, [r3, #52]	@ 0x34
20021cd4:	2a00      	cmp	r2, #0
20021cd6:	d1fc      	bne.n	20021cd2 <sd_read_data+0xd2>
20021cd8:	6b1a      	ldr	r2, [r3, #48]	@ 0x30
20021cda:	4620      	mov	r0, r4
20021cdc:	f022 0201 	bic.w	r2, r2, #1
20021ce0:	631a      	str	r2, [r3, #48]	@ 0x30
20021ce2:	e7d8      	b.n	20021c96 <sd_read_data+0x96>
20021ce4:	e000ed00 	.word	0xe000ed00
20021ce8:	50081000 	.word	0x50081000
20021cec:	50045200 	.word	0x50045200
20021cf0:	20042c08 	.word	0x20042c08
20021cf4:	50045000 	.word	0x50045000

20021cf8 <sd_read_multi>:
20021cf8:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
20021cfc:	4680      	mov	r8, r0
20021cfe:	460e      	mov	r6, r1
20021d00:	4615      	mov	r5, r2
20021d02:	b089      	sub	sp, #36	@ 0x24
20021d04:	2a00      	cmp	r2, #0
20021d06:	d059      	beq.n	20021dbc <sd_read_multi+0xc4>
20021d08:	f3c2 0308 	ubfx	r3, r2, #0, #9
20021d0c:	2b00      	cmp	r3, #0
20021d0e:	d155      	bne.n	20021dbc <sd_read_multi+0xc4>
20021d10:	4691      	mov	r9, r2
20021d12:	4c4d      	ldr	r4, [pc, #308]	@ (20021e48 <sd_read_multi+0x150>)
20021d14:	f8df b140 	ldr.w	fp, [pc, #320]	@ 20021e58 <sd_read_multi+0x160>
20021d18:	f8d4 30a8 	ldr.w	r3, [r4, #168]	@ 0xa8
20021d1c:	f423 137c 	bic.w	r3, r3, #4128768	@ 0x3f0000
20021d20:	f443 1364 	orr.w	r3, r3, #3735552	@ 0x390000
20021d24:	f8c4 30a8 	str.w	r3, [r4, #168]	@ 0xa8
20021d28:	f5b9 3f00 	cmp.w	r9, #131072	@ 0x20000
20021d2c:	bf2c      	ite	cs
20021d2e:	21ff      	movcs	r1, #255	@ 0xff
20021d30:	ea4f 2159 	movcc.w	r1, r9, lsr #9
20021d34:	f1b6 4fc0 	cmp.w	r6, #1610612736	@ 0x60000000
20021d38:	ea4f 2741 	mov.w	r7, r1, lsl #9
20021d3c:	d312      	bcc.n	20021d64 <sd_read_multi+0x6c>
20021d3e:	b18f      	cbz	r7, 20021d64 <sd_read_multi+0x6c>
20021d40:	f006 021f 	and.w	r2, r6, #31
20021d44:	443a      	add	r2, r7
20021d46:	f026 031f 	bic.w	r3, r6, #31
20021d4a:	f3bf 8f4f 	dsb	sy
20021d4e:	441a      	add	r2, r3
20021d50:	f8cb 325c 	str.w	r3, [fp, #604]	@ 0x25c
20021d54:	3320      	adds	r3, #32
20021d56:	1ad0      	subs	r0, r2, r3
20021d58:	2800      	cmp	r0, #0
20021d5a:	dcf9      	bgt.n	20021d50 <sd_read_multi+0x58>
20021d5c:	f3bf 8f4f 	dsb	sy
20021d60:	f3bf 8f6f 	isb	sy
20021d64:	6b23      	ldr	r3, [r4, #48]	@ 0x30
20021d66:	f04f 32ff 	mov.w	r2, #4294967295
20021d6a:	f023 0301 	bic.w	r3, r3, #1
20021d6e:	6323      	str	r3, [r4, #48]	@ 0x30
20021d70:	4b36      	ldr	r3, [pc, #216]	@ (20021e4c <sd_read_multi+0x154>)
20021d72:	2001      	movs	r0, #1
20021d74:	63a3      	str	r3, [r4, #56]	@ 0x38
20021d76:	08bb      	lsrs	r3, r7, #2
20021d78:	63e6      	str	r6, [r4, #60]	@ 0x3c
20021d7a:	6363      	str	r3, [r4, #52]	@ 0x34
20021d7c:	f44f 6328 	mov.w	r3, #2688	@ 0xa80
20021d80:	6323      	str	r3, [r4, #48]	@ 0x30
20021d82:	6b23      	ldr	r3, [r4, #48]	@ 0x30
20021d84:	b2c9      	uxtb	r1, r1
20021d86:	f023 0320 	bic.w	r3, r3, #32
20021d8a:	6323      	str	r3, [r4, #48]	@ 0x30
20021d8c:	4b30      	ldr	r3, [pc, #192]	@ (20021e50 <sd_read_multi+0x158>)
20021d8e:	601a      	str	r2, [r3, #0]
20021d90:	f7ff fe16 	bl	200219c0 <sd1_read>
20021d94:	6b23      	ldr	r3, [r4, #48]	@ 0x30
20021d96:	f043 0301 	orr.w	r3, r3, #1
20021d9a:	6323      	str	r3, [r4, #48]	@ 0x30
20021d9c:	4b2d      	ldr	r3, [pc, #180]	@ (20021e54 <sd_read_multi+0x15c>)
20021d9e:	781b      	ldrb	r3, [r3, #0]
20021da0:	b983      	cbnz	r3, 20021dc4 <sd_read_multi+0xcc>
20021da2:	ea4f 2158 	mov.w	r1, r8, lsr #9
20021da6:	2012      	movs	r0, #18
20021da8:	f7ff fdbc 	bl	20021924 <sd1_send_cmd>
20021dac:	3801      	subs	r0, #1
20021dae:	2801      	cmp	r0, #1
20021db0:	d80a      	bhi.n	20021dc8 <sd_read_multi+0xd0>
20021db2:	4a25      	ldr	r2, [pc, #148]	@ (20021e48 <sd_read_multi+0x150>)
20021db4:	6b13      	ldr	r3, [r2, #48]	@ 0x30
20021db6:	f023 0301 	bic.w	r3, r3, #1
20021dba:	6313      	str	r3, [r2, #48]	@ 0x30
20021dbc:	2000      	movs	r0, #0
20021dbe:	b009      	add	sp, #36	@ 0x24
20021dc0:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
20021dc4:	4641      	mov	r1, r8
20021dc6:	e7ee      	b.n	20021da6 <sd_read_multi+0xae>
20021dc8:	ab07      	add	r3, sp, #28
20021dca:	9300      	str	r3, [sp, #0]
20021dcc:	aa05      	add	r2, sp, #20
20021dce:	ab06      	add	r3, sp, #24
20021dd0:	a904      	add	r1, sp, #16
20021dd2:	f10d 000f 	add.w	r0, sp, #15
20021dd6:	f7ff fde3 	bl	200219a0 <sd1_get_rsp>
20021dda:	f89d 300f 	ldrb.w	r3, [sp, #15]
20021dde:	2b12      	cmp	r3, #18
20021de0:	d1e7      	bne.n	20021db2 <sd_read_multi+0xba>
20021de2:	2220      	movs	r2, #32
20021de4:	f8df a068 	ldr.w	sl, [pc, #104]	@ 20021e50 <sd_read_multi+0x158>
20021de8:	f8ca 202c 	str.w	r2, [sl, #44]	@ 0x2c
20021dec:	f7ff fdf8 	bl	200219e0 <sd1_wait_read>
20021df0:	f8da 3000 	ldr.w	r3, [sl]
20021df4:	f013 0fc0 	tst.w	r3, #192	@ 0xc0
20021df8:	d008      	beq.n	20021e0c <sd_read_multi+0x114>
20021dfa:	6b23      	ldr	r3, [r4, #48]	@ 0x30
20021dfc:	2100      	movs	r1, #0
20021dfe:	f023 0301 	bic.w	r3, r3, #1
20021e02:	6323      	str	r3, [r4, #48]	@ 0x30
20021e04:	200c      	movs	r0, #12
20021e06:	f7ff fd8d 	bl	20021924 <sd1_send_cmd>
20021e0a:	e7d7      	b.n	20021dbc <sd_read_multi+0xc4>
20021e0c:	6b61      	ldr	r1, [r4, #52]	@ 0x34
20021e0e:	2900      	cmp	r1, #0
20021e10:	d1fc      	bne.n	20021e0c <sd_read_multi+0x114>
20021e12:	6b23      	ldr	r3, [r4, #48]	@ 0x30
20021e14:	200c      	movs	r0, #12
20021e16:	f023 0301 	bic.w	r3, r3, #1
20021e1a:	6323      	str	r3, [r4, #48]	@ 0x30
20021e1c:	f7ff fd82 	bl	20021924 <sd1_send_cmd>
20021e20:	3801      	subs	r0, #1
20021e22:	2801      	cmp	r0, #1
20021e24:	d9ca      	bls.n	20021dbc <sd_read_multi+0xc4>
20021e26:	ab07      	add	r3, sp, #28
20021e28:	9300      	str	r3, [sp, #0]
20021e2a:	aa05      	add	r2, sp, #20
20021e2c:	ab06      	add	r3, sp, #24
20021e2e:	a904      	add	r1, sp, #16
20021e30:	f10d 000f 	add.w	r0, sp, #15
20021e34:	f7ff fdb4 	bl	200219a0 <sd1_get_rsp>
20021e38:	ebb9 0907 	subs.w	r9, r9, r7
20021e3c:	443e      	add	r6, r7
20021e3e:	44b8      	add	r8, r7
20021e40:	f47f af72 	bne.w	20021d28 <sd_read_multi+0x30>
20021e44:	4628      	mov	r0, r5
20021e46:	e7ba      	b.n	20021dbe <sd_read_multi+0xc6>
20021e48:	50081000 	.word	0x50081000
20021e4c:	50045200 	.word	0x50045200
20021e50:	50045000 	.word	0x50045000
20021e54:	20042c08 	.word	0x20042c08
20021e58:	e000ed00 	.word	0xe000ed00

20021e5c <sifli_hash_calculate>:
20021e5c:	e92d 47f0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, lr}
20021e60:	460c      	mov	r4, r1
20021e62:	4615      	mov	r5, r2
20021e64:	4699      	mov	r9, r3
20021e66:	4680      	mov	r8, r0
20021e68:	2800      	cmp	r0, #0
20021e6a:	d03f      	beq.n	20021eec <sifli_hash_calculate+0x90>
20021e6c:	2900      	cmp	r1, #0
20021e6e:	d03d      	beq.n	20021eec <sifli_hash_calculate+0x90>
20021e70:	2a00      	cmp	r2, #0
20021e72:	d03b      	beq.n	20021eec <sifli_hash_calculate+0x90>
20021e74:	2b03      	cmp	r3, #3
20021e76:	d839      	bhi.n	20021eec <sifli_hash_calculate+0x90>
20021e78:	f000 fad4 	bl	20022424 <HAL_HASH_reset>
20021e7c:	2200      	movs	r2, #0
20021e7e:	4649      	mov	r1, r9
20021e80:	4610      	mov	r0, r2
20021e82:	f000 fad7 	bl	20022434 <HAL_HASH_init>
20021e86:	f5b4 7f80 	cmp.w	r4, #256	@ 0x100
20021e8a:	d929      	bls.n	20021ee0 <sifli_hash_calculate+0x84>
20021e8c:	2600      	movs	r6, #0
20021e8e:	4637      	mov	r7, r6
20021e90:	f506 7680 	add.w	r6, r6, #256	@ 0x100
20021e94:	42a6      	cmp	r6, r4
20021e96:	bf34      	ite	cc
20021e98:	f04f 0a00 	movcc.w	sl, #0
20021e9c:	f04f 0a01 	movcs.w	sl, #1
20021ea0:	b14f      	cbz	r7, 20021eb6 <sifli_hash_calculate+0x5a>
20021ea2:	f000 fabf 	bl	20022424 <HAL_HASH_reset>
20021ea6:	42a6      	cmp	r6, r4
20021ea8:	bf2c      	ite	cs
20021eaa:	463a      	movcs	r2, r7
20021eac:	2200      	movcc	r2, #0
20021eae:	4649      	mov	r1, r9
20021eb0:	4628      	mov	r0, r5
20021eb2:	f000 fabf 	bl	20022434 <HAL_HASH_init>
20021eb6:	42a6      	cmp	r6, r4
20021eb8:	bf34      	ite	cc
20021eba:	f44f 7180 	movcc.w	r1, #256	@ 0x100
20021ebe:	1be1      	subcs	r1, r4, r7
20021ec0:	4652      	mov	r2, sl
20021ec2:	eb08 0007 	add.w	r0, r8, r7
20021ec6:	f000 fa8f 	bl	200223e8 <HAL_HASH_run>
20021eca:	4628      	mov	r0, r5
20021ecc:	f000 fae0 	bl	20022490 <HAL_HASH_result>
20021ed0:	42a6      	cmp	r6, r4
20021ed2:	d3dc      	bcc.n	20021e8e <sifli_hash_calculate+0x32>
20021ed4:	4628      	mov	r0, r5
20021ed6:	f000 fadb 	bl	20022490 <HAL_HASH_result>
20021eda:	2000      	movs	r0, #0
20021edc:	e8bd 87f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, pc}
20021ee0:	2201      	movs	r2, #1
20021ee2:	4621      	mov	r1, r4
20021ee4:	4640      	mov	r0, r8
20021ee6:	f000 fa7f 	bl	200223e8 <HAL_HASH_run>
20021eea:	e7f3      	b.n	20021ed4 <sifli_hash_calculate+0x78>
20021eec:	f04f 30ff 	mov.w	r0, #4294967295
20021ef0:	e7f4      	b.n	20021edc <sifli_hash_calculate+0x80>

20021ef2 <sifli_hash_verify>:
20021ef2:	b5f0      	push	{r4, r5, r6, r7, lr}
20021ef4:	4605      	mov	r5, r0
20021ef6:	b089      	sub	sp, #36	@ 0x24
20021ef8:	460f      	mov	r7, r1
20021efa:	4614      	mov	r4, r2
20021efc:	2100      	movs	r1, #0
20021efe:	2220      	movs	r2, #32
20021f00:	4668      	mov	r0, sp
20021f02:	461e      	mov	r6, r3
20021f04:	f008 fda6 	bl	2002aa54 <memset>
20021f08:	b91d      	cbnz	r5, 20021f12 <sifli_hash_verify+0x20>
20021f0a:	f04f 30ff 	mov.w	r0, #4294967295
20021f0e:	b009      	add	sp, #36	@ 0x24
20021f10:	bdf0      	pop	{r4, r5, r6, r7, pc}
20021f12:	2c00      	cmp	r4, #0
20021f14:	d0f9      	beq.n	20021f0a <sifli_hash_verify+0x18>
20021f16:	2302      	movs	r3, #2
20021f18:	466a      	mov	r2, sp
20021f1a:	4639      	mov	r1, r7
20021f1c:	4628      	mov	r0, r5
20021f1e:	f7ff ff9d 	bl	20021e5c <sifli_hash_calculate>
20021f22:	2800      	cmp	r0, #0
20021f24:	d1f1      	bne.n	20021f0a <sifli_hash_verify+0x18>
20021f26:	4632      	mov	r2, r6
20021f28:	4621      	mov	r1, r4
20021f2a:	4668      	mov	r0, sp
20021f2c:	f008 fd82 	bl	2002aa34 <memcmp>
20021f30:	3800      	subs	r0, #0
20021f32:	bf18      	it	ne
20021f34:	2001      	movne	r0, #1
20021f36:	4240      	negs	r0, r0
20021f38:	e7e9      	b.n	20021f0e <sifli_hash_verify+0x1c>

20021f3a <sifli_sigkey_pub_verify>:
20021f3a:	2300      	movs	r3, #0
20021f3c:	b537      	push	{r0, r1, r2, r4, r5, lr}
20021f3e:	4604      	mov	r4, r0
20021f40:	460d      	mov	r5, r1
20021f42:	2208      	movs	r2, #8
20021f44:	4669      	mov	r1, sp
20021f46:	2003      	movs	r0, #3
20021f48:	e9cd 3300 	strd	r3, r3, [sp]
20021f4c:	f7ff f886 	bl	2002105c <sifli_hw_efuse_read>
20021f50:	2808      	cmp	r0, #8
20021f52:	4603      	mov	r3, r0
20021f54:	d106      	bne.n	20021f64 <sifli_sigkey_pub_verify+0x2a>
20021f56:	466a      	mov	r2, sp
20021f58:	4629      	mov	r1, r5
20021f5a:	4620      	mov	r0, r4
20021f5c:	f7ff ffc9 	bl	20021ef2 <sifli_hash_verify>
20021f60:	b003      	add	sp, #12
20021f62:	bd30      	pop	{r4, r5, pc}
20021f64:	f04f 30ff 	mov.w	r0, #4294967295
20021f68:	e7fa      	b.n	20021f60 <sifli_sigkey_pub_verify+0x26>

20021f6a <sifli_img_sig_hash_verify>:
20021f6a:	b5f0      	push	{r4, r5, r6, r7, lr}
20021f6c:	461f      	mov	r7, r3
20021f6e:	4616      	mov	r6, r2
20021f70:	b08d      	sub	sp, #52	@ 0x34
20021f72:	2220      	movs	r2, #32
20021f74:	4604      	mov	r4, r0
20021f76:	460d      	mov	r5, r1
20021f78:	a804      	add	r0, sp, #16
20021f7a:	2100      	movs	r1, #0
20021f7c:	f008 fd6a 	bl	2002aa54 <memset>
20021f80:	2302      	movs	r3, #2
20021f82:	4639      	mov	r1, r7
20021f84:	4630      	mov	r0, r6
20021f86:	aa04      	add	r2, sp, #16
20021f88:	f7ff ff68 	bl	20021e5c <sifli_hash_calculate>
20021f8c:	b118      	cbz	r0, 20021f96 <sifli_img_sig_hash_verify+0x2c>
20021f8e:	f04f 30ff 	mov.w	r0, #4294967295
20021f92:	b00d      	add	sp, #52	@ 0x34
20021f94:	bdf0      	pop	{r4, r5, r6, r7, pc}
20021f96:	a802      	add	r0, sp, #8
20021f98:	f007 fad0 	bl	2002953c <mbedtls_pk_init>
20021f9c:	4629      	mov	r1, r5
20021f9e:	f44f 7293 	mov.w	r2, #294	@ 0x126
20021fa2:	a802      	add	r0, sp, #8
20021fa4:	f007 fbd6 	bl	20029754 <mbedtls_pk_parse_public_key>
20021fa8:	4601      	mov	r1, r0
20021faa:	2800      	cmp	r0, #0
20021fac:	d1ef      	bne.n	20021f8e <sifli_img_sig_hash_verify+0x24>
20021fae:	2206      	movs	r2, #6
20021fb0:	9803      	ldr	r0, [sp, #12]
20021fb2:	f007 fc76 	bl	200298a2 <mbedtls_rsa_set_padding>
20021fb6:	f44f 7380 	mov.w	r3, #256	@ 0x100
20021fba:	2106      	movs	r1, #6
20021fbc:	e9cd 4300 	strd	r4, r3, [sp]
20021fc0:	aa04      	add	r2, sp, #16
20021fc2:	2320      	movs	r3, #32
20021fc4:	a802      	add	r0, sp, #8
20021fc6:	f007 faed 	bl	200295a4 <mbedtls_pk_verify>
20021fca:	3800      	subs	r0, #0
20021fcc:	bf18      	it	ne
20021fce:	2001      	movne	r0, #1
20021fd0:	4240      	negs	r0, r0
20021fd2:	e7de      	b.n	20021f92 <sifli_img_sig_hash_verify+0x28>

20021fd4 <sifli_secboot_exception>:
20021fd4:	2801      	cmp	r0, #1
20021fd6:	b508      	push	{r3, lr}
20021fd8:	d004      	beq.n	20021fe4 <sifli_secboot_exception+0x10>
20021fda:	2802      	cmp	r0, #2
20021fdc:	d009      	beq.n	20021ff2 <sifli_secboot_exception+0x1e>
20021fde:	2213      	movs	r2, #19
20021fe0:	4905      	ldr	r1, [pc, #20]	@ (20021ff8 <sifli_secboot_exception+0x24>)
20021fe2:	e001      	b.n	20021fe8 <sifli_secboot_exception+0x14>
20021fe4:	2217      	movs	r2, #23
20021fe6:	4905      	ldr	r1, [pc, #20]	@ (20021ffc <sifli_secboot_exception+0x28>)
20021fe8:	4805      	ldr	r0, [pc, #20]	@ (20022000 <sifli_secboot_exception+0x2c>)
20021fea:	f7fe f955 	bl	20020298 <boot_uart_tx>
20021fee:	e7fe      	b.n	20021fee <sifli_secboot_exception+0x1a>
20021ff0:	bd08      	pop	{r3, pc}
20021ff2:	2219      	movs	r2, #25
20021ff4:	4903      	ldr	r1, [pc, #12]	@ (20022004 <sifli_secboot_exception+0x30>)
20021ff6:	e7f7      	b.n	20021fe8 <sifli_secboot_exception+0x14>
20021ff8:	2002abb2 	.word	0x2002abb2
20021ffc:	2002ab80 	.word	0x2002ab80
20022000:	50084000 	.word	0x50084000
20022004:	2002ab98 	.word	0x2002ab98

20022008 <BSP_GetFlash1DIV>:
20022008:	4b01      	ldr	r3, [pc, #4]	@ (20022010 <BSP_GetFlash1DIV+0x8>)
2002200a:	8818      	ldrh	r0, [r3, #0]
2002200c:	4770      	bx	lr
2002200e:	bf00      	nop
20022010:	20042c0c 	.word	0x20042c0c

20022014 <BSP_GetFlash2DIV>:
20022014:	4b01      	ldr	r3, [pc, #4]	@ (2002201c <BSP_GetFlash2DIV+0x8>)
20022016:	8818      	ldrh	r0, [r3, #0]
20022018:	4770      	bx	lr
2002201a:	bf00      	nop
2002201c:	20042c0a 	.word	0x20042c0a

20022020 <BSP_SetFlash1DIV>:
20022020:	4b01      	ldr	r3, [pc, #4]	@ (20022028 <BSP_SetFlash1DIV+0x8>)
20022022:	8018      	strh	r0, [r3, #0]
20022024:	4770      	bx	lr
20022026:	bf00      	nop
20022028:	20042c0c 	.word	0x20042c0c

2002202c <BSP_SetFlash2DIV>:
2002202c:	4b01      	ldr	r3, [pc, #4]	@ (20022034 <BSP_SetFlash2DIV+0x8>)
2002202e:	8018      	strh	r0, [r3, #0]
20022030:	4770      	bx	lr
20022032:	bf00      	nop
20022034:	20042c0a 	.word	0x20042c0a

20022038 <boot_images>:
20022038:	4770      	bx	lr

2002203a <SystemPowerOnModeInit>:
2002203a:	4770      	bx	lr

2002203c <SystemInit>:
2002203c:	b508      	push	{r3, lr}
2002203e:	4a10      	ldr	r2, [pc, #64]	@ (20022080 <SystemInit+0x44>)
20022040:	4b10      	ldr	r3, [pc, #64]	@ (20022084 <SystemInit+0x48>)
20022042:	609a      	str	r2, [r3, #8]
20022044:	f8d3 2088 	ldr.w	r2, [r3, #136]	@ 0x88
20022048:	f042 023f 	orr.w	r2, r2, #63	@ 0x3f
2002204c:	f8c3 2088 	str.w	r2, [r3, #136]	@ 0x88
20022050:	f8d3 2088 	ldr.w	r2, [r3, #136]	@ 0x88
20022054:	f442 0270 	orr.w	r2, r2, #15728640	@ 0xf00000
20022058:	f8c3 2088 	str.w	r2, [r3, #136]	@ 0x88
2002205c:	f7ff fa70 	bl	20021540 <hw_preinit0>
20022060:	f7fe f954 	bl	2002030c <mpu_config>
20022064:	4b08      	ldr	r3, [pc, #32]	@ (20022088 <SystemInit+0x4c>)
20022066:	681b      	ldr	r3, [r3, #0]
20022068:	07db      	lsls	r3, r3, #31
2002206a:	d401      	bmi.n	20022070 <SystemInit+0x34>
2002206c:	f7ff ffe4 	bl	20022038 <boot_images>
20022070:	f7fe f94d 	bl	2002030e <cache_enable>
20022074:	f7ff ffe1 	bl	2002203a <SystemPowerOnModeInit>
20022078:	4b04      	ldr	r3, [pc, #16]	@ (2002208c <SystemInit+0x50>)
2002207a:	4a05      	ldr	r2, [pc, #20]	@ (20022090 <SystemInit+0x54>)
2002207c:	601a      	str	r2, [r3, #0]
2002207e:	bd08      	pop	{r3, pc}
20022080:	20020000 	.word	0x20020000
20022084:	e000ed00 	.word	0xe000ed00
20022088:	5000b000 	.word	0x5000b000
2002208c:	20042c10 	.word	0x20042c10
20022090:	017d7840 	.word	0x017d7840

20022094 <pmu_ldo_inc>:
20022094:	b510      	push	{r4, lr}
20022096:	4b08      	ldr	r3, [pc, #32]	@ (200220b8 <pmu_ldo_inc+0x24>)
20022098:	f8d3 4094 	ldr.w	r4, [r3, #148]	@ 0x94
2002209c:	4420      	add	r0, r4
2002209e:	280e      	cmp	r0, #14
200220a0:	bf38      	it	cc
200220a2:	200e      	movcc	r0, #14
200220a4:	280f      	cmp	r0, #15
200220a6:	bf28      	it	cs
200220a8:	200f      	movcs	r0, #15
200220aa:	f8c3 0094 	str.w	r0, [r3, #148]	@ 0x94
200220ae:	2014      	movs	r0, #20
200220b0:	f000 f8a3 	bl	200221fa <HAL_Delay_us>
200220b4:	4620      	mov	r0, r4
200220b6:	bd10      	pop	{r4, pc}
200220b8:	500ca000 	.word	0x500ca000

200220bc <pmu_ldo_recover>:
200220bc:	4b01      	ldr	r3, [pc, #4]	@ (200220c4 <pmu_ldo_recover+0x8>)
200220be:	f8c3 0094 	str.w	r0, [r3, #148]	@ 0x94
200220c2:	4770      	bx	lr
200220c4:	500ca000 	.word	0x500ca000

200220c8 <Reset_Handler>:
200220c8:	f8df d048 	ldr.w	sp, [pc, #72]	@ 20022114 <AES_IRQHandler+0x2>
200220cc:	4812      	ldr	r0, [pc, #72]	@ (20022118 <AES_IRQHandler+0x6>)
200220ce:	f380 880a 	msr	MSPLIM, r0
200220d2:	f7ff ffb3 	bl	2002203c <SystemInit>
200220d6:	4c11      	ldr	r4, [pc, #68]	@ (2002211c <AES_IRQHandler+0xa>)
200220d8:	4d11      	ldr	r5, [pc, #68]	@ (20022120 <AES_IRQHandler+0xe>)
200220da:	42ac      	cmp	r4, r5
200220dc:	da09      	bge.n	200220f2 <Reset_Handler+0x2a>
200220de:	6821      	ldr	r1, [r4, #0]
200220e0:	6862      	ldr	r2, [r4, #4]
200220e2:	68a3      	ldr	r3, [r4, #8]
200220e4:	3b04      	subs	r3, #4
200220e6:	bfa2      	ittt	ge
200220e8:	58c8      	ldrge	r0, [r1, r3]
200220ea:	50d0      	strge	r0, [r2, r3]
200220ec:	e7fa      	bge.n	200220e4 <Reset_Handler+0x1c>
200220ee:	340c      	adds	r4, #12
200220f0:	e7f3      	b.n	200220da <Reset_Handler+0x12>
200220f2:	4b0c      	ldr	r3, [pc, #48]	@ (20022124 <AES_IRQHandler+0x12>)
200220f4:	4c0c      	ldr	r4, [pc, #48]	@ (20022128 <AES_IRQHandler+0x16>)
200220f6:	42a3      	cmp	r3, r4
200220f8:	da08      	bge.n	2002210c <Reset_Handler+0x44>
200220fa:	6819      	ldr	r1, [r3, #0]
200220fc:	685a      	ldr	r2, [r3, #4]
200220fe:	2000      	movs	r0, #0
20022100:	3a04      	subs	r2, #4
20022102:	bfa4      	itt	ge
20022104:	5088      	strge	r0, [r1, r2]
20022106:	e7fb      	bge.n	20022100 <Reset_Handler+0x38>
20022108:	3308      	adds	r3, #8
2002210a:	e7f4      	b.n	200220f6 <Reset_Handler+0x2e>
2002210c:	f7ff fa3e 	bl	2002158c <entry>

20022110 <HardFault_Handler>:
20022110:	e7fe      	b.n	20022110 <HardFault_Handler>

20022112 <AES_IRQHandler>:
20022112:	e7fe      	b.n	20022112 <AES_IRQHandler>
20022114:	20042000 	.word	0x20042000
20022118:	20040000 	.word	0x20040000
2002211c:	2002c61c 	.word	0x2002c61c
20022120:	2002c628 	.word	0x2002c628
20022124:	2002c628 	.word	0x2002c628
20022128:	2002c630 	.word	0x2002c630

2002212c <__aeabi_unwind_cpp_pr0>:
2002212c:	2000      	movs	r0, #0
2002212e:	4770      	bx	lr

20022130 <HAL_GetTick>:
20022130:	4b01      	ldr	r3, [pc, #4]	@ (20022138 <HAL_GetTick+0x8>)
20022132:	6818      	ldr	r0, [r3, #0]
20022134:	4770      	bx	lr
20022136:	bf00      	nop
20022138:	2004cbe4 	.word	0x2004cbe4

2002213c <HAL_Delay_us_>:
2002213c:	b513      	push	{r0, r1, r4, lr}
2002213e:	9001      	str	r0, [sp, #4]
20022140:	9b01      	ldr	r3, [sp, #4]
20022142:	4c1a      	ldr	r4, [pc, #104]	@ (200221ac <HAL_Delay_us_+0x70>)
20022144:	b133      	cbz	r3, 20022154 <HAL_Delay_us_+0x18>
20022146:	6823      	ldr	r3, [r4, #0]
20022148:	b123      	cbz	r3, 20022154 <HAL_Delay_us_+0x18>
2002214a:	9b01      	ldr	r3, [sp, #4]
2002214c:	f1b3 7f80 	cmp.w	r3, #16777216	@ 0x1000000
20022150:	d90c      	bls.n	2002216c <HAL_Delay_us_+0x30>
20022152:	e7fe      	b.n	20022152 <HAL_Delay_us_+0x16>
20022154:	2000      	movs	r0, #0
20022156:	f003 f811 	bl	2002517c <HAL_RCC_GetHCLKFreq>
2002215a:	4b15      	ldr	r3, [pc, #84]	@ (200221b0 <HAL_Delay_us_+0x74>)
2002215c:	fbb0 f0f3 	udiv	r0, r0, r3
20022160:	9b01      	ldr	r3, [sp, #4]
20022162:	6020      	str	r0, [r4, #0]
20022164:	2b00      	cmp	r3, #0
20022166:	d1f0      	bne.n	2002214a <HAL_Delay_us_+0xe>
20022168:	b002      	add	sp, #8
2002216a:	bd10      	pop	{r4, pc}
2002216c:	9b01      	ldr	r3, [sp, #4]
2002216e:	2b00      	cmp	r3, #0
20022170:	d0fa      	beq.n	20022168 <HAL_Delay_us_+0x2c>
20022172:	4a10      	ldr	r2, [pc, #64]	@ (200221b4 <HAL_Delay_us_+0x78>)
20022174:	6813      	ldr	r3, [r2, #0]
20022176:	f013 0301 	ands.w	r3, r3, #1
2002217a:	d10d      	bne.n	20022198 <HAL_Delay_us_+0x5c>
2002217c:	480e      	ldr	r0, [pc, #56]	@ (200221b8 <HAL_Delay_us_+0x7c>)
2002217e:	f8d0 10fc 	ldr.w	r1, [r0, #252]	@ 0xfc
20022182:	f041 7180 	orr.w	r1, r1, #16777216	@ 0x1000000
20022186:	f8c0 10fc 	str.w	r1, [r0, #252]	@ 0xfc
2002218a:	6053      	str	r3, [r2, #4]
2002218c:	6813      	ldr	r3, [r2, #0]
2002218e:	f443 3300 	orr.w	r3, r3, #131072	@ 0x20000
20022192:	f043 0301 	orr.w	r3, r3, #1
20022196:	6013      	str	r3, [r2, #0]
20022198:	9b01      	ldr	r3, [sp, #4]
2002219a:	6822      	ldr	r2, [r4, #0]
2002219c:	4905      	ldr	r1, [pc, #20]	@ (200221b4 <HAL_Delay_us_+0x78>)
2002219e:	4353      	muls	r3, r2
200221a0:	6848      	ldr	r0, [r1, #4]
200221a2:	684a      	ldr	r2, [r1, #4]
200221a4:	1a12      	subs	r2, r2, r0
200221a6:	429a      	cmp	r2, r3
200221a8:	d3fb      	bcc.n	200221a2 <HAL_Delay_us_+0x66>
200221aa:	e7dd      	b.n	20022168 <HAL_Delay_us_+0x2c>
200221ac:	2004cbe0 	.word	0x2004cbe0
200221b0:	000f4240 	.word	0x000f4240
200221b4:	e0001000 	.word	0xe0001000
200221b8:	e000ed00 	.word	0xe000ed00

200221bc <HAL_Delay_us2_>:
200221bc:	b537      	push	{r0, r1, r2, r4, r5, lr}
200221be:	9001      	str	r0, [sp, #4]
200221c0:	f04f 20e0 	mov.w	r0, #3758153728	@ 0xe000e000
200221c4:	f44f 727a 	mov.w	r2, #1000	@ 0x3e8
200221c8:	6944      	ldr	r4, [r0, #20]
200221ca:	9b01      	ldr	r3, [sp, #4]
200221cc:	4363      	muls	r3, r4
200221ce:	fbb3 f3f2 	udiv	r3, r3, r2
200221d2:	9301      	str	r3, [sp, #4]
200221d4:	2300      	movs	r3, #0
200221d6:	6981      	ldr	r1, [r0, #24]
200221d8:	6982      	ldr	r2, [r0, #24]
200221da:	428a      	cmp	r2, r1
200221dc:	d0fc      	beq.n	200221d8 <HAL_Delay_us2_+0x1c>
200221de:	bf25      	ittet	cs
200221e0:	1aa5      	subcs	r5, r4, r2
200221e2:	195b      	addcs	r3, r3, r5
200221e4:	185b      	addcc	r3, r3, r1
200221e6:	185b      	addcs	r3, r3, r1
200221e8:	9901      	ldr	r1, [sp, #4]
200221ea:	bf38      	it	cc
200221ec:	1a9b      	subcc	r3, r3, r2
200221ee:	4299      	cmp	r1, r3
200221f0:	d801      	bhi.n	200221f6 <HAL_Delay_us2_+0x3a>
200221f2:	b003      	add	sp, #12
200221f4:	bd30      	pop	{r4, r5, pc}
200221f6:	4611      	mov	r1, r2
200221f8:	e7ee      	b.n	200221d8 <HAL_Delay_us2_+0x1c>

200221fa <HAL_Delay_us>:
200221fa:	4603      	mov	r3, r0
200221fc:	b570      	push	{r4, r5, r6, lr}
200221fe:	b1b8      	cbz	r0, 20022230 <HAL_Delay_us+0x36>
20022200:	f242 7510 	movw	r5, #10000	@ 0x2710
20022204:	f04f 26e0 	mov.w	r6, #3758153728	@ 0xe000e000
20022208:	42ab      	cmp	r3, r5
2002220a:	bf84      	itt	hi
2002220c:	f5a3 541c 	subhi.w	r4, r3, #9984	@ 0x2700
20022210:	f242 7310 	movwhi	r3, #10000	@ 0x2710
20022214:	6932      	ldr	r2, [r6, #16]
20022216:	bf98      	it	ls
20022218:	2400      	movls	r4, #0
2002221a:	4618      	mov	r0, r3
2002221c:	bf88      	it	hi
2002221e:	3c10      	subhi	r4, #16
20022220:	07d3      	lsls	r3, r2, #31
20022222:	d508      	bpl.n	20022236 <HAL_Delay_us+0x3c>
20022224:	f7ff ffca 	bl	200221bc <HAL_Delay_us2_>
20022228:	4623      	mov	r3, r4
2002222a:	2c00      	cmp	r4, #0
2002222c:	d1ec      	bne.n	20022208 <HAL_Delay_us+0xe>
2002222e:	e001      	b.n	20022234 <HAL_Delay_us+0x3a>
20022230:	f7ff ff84 	bl	2002213c <HAL_Delay_us_>
20022234:	bd70      	pop	{r4, r5, r6, pc}
20022236:	f7ff ff81 	bl	2002213c <HAL_Delay_us_>
2002223a:	e7f5      	b.n	20022228 <HAL_Delay_us+0x2e>

2002223c <WDT_IRQHandler>:
2002223c:	4770      	bx	lr

2002223e <DBG_Trigger_IRQHandler>:
2002223e:	4770      	bx	lr

20022240 <NMI_Handler>:
20022240:	b508      	push	{r3, lr}
20022242:	4b05      	ldr	r3, [pc, #20]	@ (20022258 <NMI_Handler+0x18>)
20022244:	6a1b      	ldr	r3, [r3, #32]
20022246:	005b      	lsls	r3, r3, #1
20022248:	d502      	bpl.n	20022250 <NMI_Handler+0x10>
2002224a:	f7ff fff8 	bl	2002223e <DBG_Trigger_IRQHandler>
2002224e:	bd08      	pop	{r3, pc}
20022250:	f7ff fff4 	bl	2002223c <WDT_IRQHandler>
20022254:	e7fb      	b.n	2002224e <NMI_Handler+0xe>
20022256:	bf00      	nop
20022258:	5000b000 	.word	0x5000b000

2002225c <HAL_AES_run_help>:
2002225c:	b510      	push	{r4, lr}
2002225e:	f101 4470 	add.w	r4, r1, #4026531840	@ 0xf0000000
20022262:	f1b4 5f80 	cmp.w	r4, #268435456	@ 0x10000000
20022266:	4c0e      	ldr	r4, [pc, #56]	@ (200222a0 <HAL_AES_run_help+0x44>)
20022268:	bf38      	it	cc
2002226a:	f101 41a0 	addcc.w	r1, r1, #1342177280	@ 0x50000000
2002226e:	6161      	str	r1, [r4, #20]
20022270:	f102 4170 	add.w	r1, r2, #4026531840	@ 0xf0000000
20022274:	f1b1 5f80 	cmp.w	r1, #268435456	@ 0x10000000
20022278:	f103 030f 	add.w	r3, r3, #15
2002227c:	ea4f 1323 	mov.w	r3, r3, asr #4
20022280:	bf38      	it	cc
20022282:	f102 42a0 	addcc.w	r2, r2, #1342177280	@ 0x50000000
20022286:	61a2      	str	r2, [r4, #24]
20022288:	61e3      	str	r3, [r4, #28]
2002228a:	6923      	ldr	r3, [r4, #16]
2002228c:	b108      	cbz	r0, 20022292 <HAL_AES_run_help+0x36>
2002228e:	ea43 13c0 	orr.w	r3, r3, r0, lsl #7
20022292:	4a03      	ldr	r2, [pc, #12]	@ (200222a0 <HAL_AES_run_help+0x44>)
20022294:	6123      	str	r3, [r4, #16]
20022296:	6813      	ldr	r3, [r2, #0]
20022298:	f043 0301 	orr.w	r3, r3, #1
2002229c:	6013      	str	r3, [r2, #0]
2002229e:	bd10      	pop	{r4, pc}
200222a0:	5000d000 	.word	0x5000d000

200222a4 <HAL_HASH_run_help.isra.0>:
200222a4:	f100 4370 	add.w	r3, r0, #4026531840	@ 0xf0000000
200222a8:	b510      	push	{r4, lr}
200222aa:	f1b3 5f80 	cmp.w	r3, #268435456	@ 0x10000000
200222ae:	4c09      	ldr	r4, [pc, #36]	@ (200222d4 <HAL_HASH_run_help.isra.0+0x30>)
200222b0:	bf38      	it	cc
200222b2:	f100 40a0 	addcc.w	r0, r0, #1342177280	@ 0x50000000
200222b6:	6560      	str	r0, [r4, #84]	@ 0x54
200222b8:	65a1      	str	r1, [r4, #88]	@ 0x58
200222ba:	b11a      	cbz	r2, 200222c4 <HAL_HASH_run_help.isra.0+0x20>
200222bc:	6d23      	ldr	r3, [r4, #80]	@ 0x50
200222be:	f043 0308 	orr.w	r3, r3, #8
200222c2:	6523      	str	r3, [r4, #80]	@ 0x50
200222c4:	6d21      	ldr	r1, [r4, #80]	@ 0x50
200222c6:	4804      	ldr	r0, [pc, #16]	@ (200222d8 <HAL_HASH_run_help.isra.0+0x34>)
200222c8:	f000 fc98 	bl	20022bfc <HAL_DBG_printf>
200222cc:	2304      	movs	r3, #4
200222ce:	6023      	str	r3, [r4, #0]
200222d0:	bd10      	pop	{r4, pc}
200222d2:	bf00      	nop
200222d4:	5000d000 	.word	0x5000d000
200222d8:	2002abc6 	.word	0x2002abc6

200222dc <HAL_AES_reset>:
200222dc:	2202      	movs	r2, #2
200222de:	2000      	movs	r0, #0
200222e0:	4b01      	ldr	r3, [pc, #4]	@ (200222e8 <HAL_AES_reset+0xc>)
200222e2:	601a      	str	r2, [r3, #0]
200222e4:	6018      	str	r0, [r3, #0]
200222e6:	4770      	bx	lr
200222e8:	5000d000 	.word	0x5000d000

200222ec <HAL_AES_init>:
200222ec:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
200222ee:	4604      	mov	r4, r0
200222f0:	200c      	movs	r0, #12
200222f2:	461e      	mov	r6, r3
200222f4:	460d      	mov	r5, r1
200222f6:	4617      	mov	r7, r2
200222f8:	f003 f8be 	bl	20025478 <HAL_RCC_EnableModule>
200222fc:	4b1c      	ldr	r3, [pc, #112]	@ (20022370 <HAL_AES_init+0x84>)
200222fe:	685b      	ldr	r3, [r3, #4]
20022300:	07db      	lsls	r3, r3, #31
20022302:	d501      	bpl.n	20022308 <HAL_AES_init+0x1c>
20022304:	f7ff ffea 	bl	200222dc <HAL_AES_reset>
20022308:	fab4 f184 	clz	r1, r4
2002230c:	2d18      	cmp	r5, #24
2002230e:	ea4f 1151 	mov.w	r1, r1, lsr #5
20022312:	ea4f 1141 	mov.w	r1, r1, lsl #5
20022316:	d01b      	beq.n	20022350 <HAL_AES_init+0x64>
20022318:	2d20      	cmp	r5, #32
2002231a:	d01b      	beq.n	20022354 <HAL_AES_init+0x68>
2002231c:	2d10      	cmp	r5, #16
2002231e:	d124      	bne.n	2002236a <HAL_AES_init+0x7e>
20022320:	2300      	movs	r3, #0
20022322:	b164      	cbz	r4, 2002233e <HAL_AES_init+0x52>
20022324:	4620      	mov	r0, r4
20022326:	4a13      	ldr	r2, [pc, #76]	@ (20022374 <HAL_AES_init+0x88>)
20022328:	f025 0503 	bic.w	r5, r5, #3
2002232c:	4425      	add	r5, r4
2002232e:	1b12      	subs	r2, r2, r4
20022330:	1814      	adds	r4, r2, r0
20022332:	f850 cb04 	ldr.w	ip, [r0], #4
20022336:	4285      	cmp	r5, r0
20022338:	f8c4 c000 	str.w	ip, [r4]
2002233c:	d1f8      	bne.n	20022330 <HAL_AES_init+0x44>
2002233e:	4331      	orrs	r1, r6
20022340:	ea41 01c3 	orr.w	r1, r1, r3, lsl #3
20022344:	4b0a      	ldr	r3, [pc, #40]	@ (20022370 <HAL_AES_init+0x84>)
20022346:	6119      	str	r1, [r3, #16]
20022348:	b106      	cbz	r6, 2002234c <HAL_AES_init+0x60>
2002234a:	b92f      	cbnz	r7, 20022358 <HAL_AES_init+0x6c>
2002234c:	2000      	movs	r0, #0
2002234e:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
20022350:	2301      	movs	r3, #1
20022352:	e7e6      	b.n	20022322 <HAL_AES_init+0x36>
20022354:	2302      	movs	r3, #2
20022356:	e7e4      	b.n	20022322 <HAL_AES_init+0x36>
20022358:	683a      	ldr	r2, [r7, #0]
2002235a:	621a      	str	r2, [r3, #32]
2002235c:	687a      	ldr	r2, [r7, #4]
2002235e:	625a      	str	r2, [r3, #36]	@ 0x24
20022360:	68ba      	ldr	r2, [r7, #8]
20022362:	629a      	str	r2, [r3, #40]	@ 0x28
20022364:	68fa      	ldr	r2, [r7, #12]
20022366:	62da      	str	r2, [r3, #44]	@ 0x2c
20022368:	e7f0      	b.n	2002234c <HAL_AES_init+0x60>
2002236a:	f04f 30ff 	mov.w	r0, #4294967295
2002236e:	e7ee      	b.n	2002234e <HAL_AES_init+0x62>
20022370:	5000d000 	.word	0x5000d000
20022374:	5000d030 	.word	0x5000d030

20022378 <HAL_AES_run>:
20022378:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
2002237a:	2708      	movs	r7, #8
2002237c:	4e17      	ldr	r6, [pc, #92]	@ (200223dc <HAL_AES_run+0x64>)
2002237e:	4614      	mov	r4, r2
20022380:	461d      	mov	r5, r3
20022382:	f8c6 7088 	str.w	r7, [r6, #136]	@ 0x88
20022386:	f3bf 8f4f 	dsb	sy
2002238a:	f3bf 8f6f 	isb	sy
2002238e:	2700      	movs	r7, #0
20022390:	4e13      	ldr	r6, [pc, #76]	@ (200223e0 <HAL_AES_run+0x68>)
20022392:	60f7      	str	r7, [r6, #12]
20022394:	f7ff ff62 	bl	2002225c <HAL_AES_run_help>
20022398:	6873      	ldr	r3, [r6, #4]
2002239a:	07db      	lsls	r3, r3, #31
2002239c:	d4fc      	bmi.n	20022398 <HAL_AES_run+0x20>
2002239e:	68b0      	ldr	r0, [r6, #8]
200223a0:	f000 0006 	and.w	r0, r0, #6
200223a4:	3800      	subs	r0, #0
200223a6:	bf18      	it	ne
200223a8:	2001      	movne	r0, #1
200223aa:	f1b4 4fc0 	cmp.w	r4, #1610612736	@ 0x60000000
200223ae:	d314      	bcc.n	200223da <HAL_AES_run+0x62>
200223b0:	2d00      	cmp	r5, #0
200223b2:	dd12      	ble.n	200223da <HAL_AES_run+0x62>
200223b4:	f004 031f 	and.w	r3, r4, #31
200223b8:	442b      	add	r3, r5
200223ba:	f024 021f 	bic.w	r2, r4, #31
200223be:	f3bf 8f4f 	dsb	sy
200223c2:	4c08      	ldr	r4, [pc, #32]	@ (200223e4 <HAL_AES_run+0x6c>)
200223c4:	4413      	add	r3, r2
200223c6:	f8c4 225c 	str.w	r2, [r4, #604]	@ 0x25c
200223ca:	3220      	adds	r2, #32
200223cc:	1a99      	subs	r1, r3, r2
200223ce:	2900      	cmp	r1, #0
200223d0:	dcf9      	bgt.n	200223c6 <HAL_AES_run+0x4e>
200223d2:	f3bf 8f4f 	dsb	sy
200223d6:	f3bf 8f6f 	isb	sy
200223da:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
200223dc:	e000e100 	.word	0xe000e100
200223e0:	5000d000 	.word	0x5000d000
200223e4:	e000ed00 	.word	0xe000ed00

200223e8 <HAL_HASH_run>:
200223e8:	b510      	push	{r4, lr}
200223ea:	2408      	movs	r4, #8
200223ec:	4b0b      	ldr	r3, [pc, #44]	@ (2002241c <HAL_HASH_run+0x34>)
200223ee:	f8c3 4088 	str.w	r4, [r3, #136]	@ 0x88
200223f2:	f3bf 8f4f 	dsb	sy
200223f6:	f3bf 8f6f 	isb	sy
200223fa:	f7ff ff53 	bl	200222a4 <HAL_HASH_run_help.isra.0>
200223fe:	4b08      	ldr	r3, [pc, #32]	@ (20022420 <HAL_HASH_run+0x38>)
20022400:	685a      	ldr	r2, [r3, #4]
20022402:	0752      	lsls	r2, r2, #29
20022404:	d4fc      	bmi.n	20022400 <HAL_HASH_run+0x18>
20022406:	689a      	ldr	r2, [r3, #8]
20022408:	f002 0238 	and.w	r2, r2, #56	@ 0x38
2002240c:	609a      	str	r2, [r3, #8]
2002240e:	6898      	ldr	r0, [r3, #8]
20022410:	f000 0030 	and.w	r0, r0, #48	@ 0x30
20022414:	3800      	subs	r0, #0
20022416:	bf18      	it	ne
20022418:	2001      	movne	r0, #1
2002241a:	bd10      	pop	{r4, pc}
2002241c:	e000e100 	.word	0xe000e100
20022420:	5000d000 	.word	0x5000d000

20022424 <HAL_HASH_reset>:
20022424:	2208      	movs	r2, #8
20022426:	2000      	movs	r0, #0
20022428:	4b01      	ldr	r3, [pc, #4]	@ (20022430 <HAL_HASH_reset+0xc>)
2002242a:	601a      	str	r2, [r3, #0]
2002242c:	6018      	str	r0, [r3, #0]
2002242e:	4770      	bx	lr
20022430:	5000d000 	.word	0x5000d000

20022434 <HAL_HASH_init>:
20022434:	0693      	lsls	r3, r2, #26
20022436:	b570      	push	{r4, r5, r6, lr}
20022438:	4606      	mov	r6, r0
2002243a:	460c      	mov	r4, r1
2002243c:	4615      	mov	r5, r2
2002243e:	d11c      	bne.n	2002247a <HAL_HASH_init+0x46>
20022440:	2903      	cmp	r1, #3
20022442:	d81a      	bhi.n	2002247a <HAL_HASH_init+0x46>
20022444:	f7ff ffee 	bl	20022424 <HAL_HASH_reset>
20022448:	b13e      	cbz	r6, 2002245a <HAL_HASH_init+0x26>
2002244a:	4b0d      	ldr	r3, [pc, #52]	@ (20022480 <HAL_HASH_init+0x4c>)
2002244c:	480d      	ldr	r0, [pc, #52]	@ (20022484 <HAL_HASH_init+0x50>)
2002244e:	5c5a      	ldrb	r2, [r3, r1]
20022450:	4631      	mov	r1, r6
20022452:	f008 fb19 	bl	2002aa88 <memcpy>
20022456:	f044 0420 	orr.w	r4, r4, #32
2002245a:	4b0b      	ldr	r3, [pc, #44]	@ (20022488 <HAL_HASH_init+0x54>)
2002245c:	f044 0180 	orr.w	r1, r4, #128	@ 0x80
20022460:	6519      	str	r1, [r3, #80]	@ 0x50
20022462:	b11d      	cbz	r5, 2002246c <HAL_HASH_init+0x38>
20022464:	f8c3 509c 	str.w	r5, [r3, #156]	@ 0x9c
20022468:	f444 71c0 	orr.w	r1, r4, #384	@ 0x180
2002246c:	4807      	ldr	r0, [pc, #28]	@ (2002248c <HAL_HASH_init+0x58>)
2002246e:	462a      	mov	r2, r5
20022470:	6519      	str	r1, [r3, #80]	@ 0x50
20022472:	f000 fbc3 	bl	20022bfc <HAL_DBG_printf>
20022476:	2000      	movs	r0, #0
20022478:	bd70      	pop	{r4, r5, r6, pc}
2002247a:	f04f 30ff 	mov.w	r0, #4294967295
2002247e:	e7fb      	b.n	20022478 <HAL_HASH_init+0x44>
20022480:	2002ba5c 	.word	0x2002ba5c
20022484:	5000d05c 	.word	0x5000d05c
20022488:	5000d000 	.word	0x5000d000
2002248c:	2002abd9 	.word	0x2002abd9

20022490 <HAL_HASH_result>:
20022490:	b510      	push	{r4, lr}
20022492:	4c08      	ldr	r4, [pc, #32]	@ (200224b4 <HAL_HASH_result+0x24>)
20022494:	4a08      	ldr	r2, [pc, #32]	@ (200224b8 <HAL_HASH_result+0x28>)
20022496:	6d23      	ldr	r3, [r4, #80]	@ 0x50
20022498:	f104 017c 	add.w	r1, r4, #124	@ 0x7c
2002249c:	f003 0307 	and.w	r3, r3, #7
200224a0:	5cd2      	ldrb	r2, [r2, r3]
200224a2:	f008 faf1 	bl	2002aa88 <memcpy>
200224a6:	f8d4 10a4 	ldr.w	r1, [r4, #164]	@ 0xa4
200224aa:	4804      	ldr	r0, [pc, #16]	@ (200224bc <HAL_HASH_result+0x2c>)
200224ac:	e8bd 4010 	ldmia.w	sp!, {r4, lr}
200224b0:	f000 bba4 	b.w	20022bfc <HAL_DBG_printf>
200224b4:	5000d000 	.word	0x5000d000
200224b8:	2002ba5c 	.word	0x2002ba5c
200224bc:	2002ac0d 	.word	0x2002ac0d

200224c0 <HAL_NVIC_EnableIRQ>:
200224c0:	2800      	cmp	r0, #0
200224c2:	da00      	bge.n	200224c6 <HAL_NVIC_EnableIRQ+0x6>
200224c4:	e7fe      	b.n	200224c4 <HAL_NVIC_EnableIRQ+0x4>
200224c6:	2301      	movs	r3, #1
200224c8:	0941      	lsrs	r1, r0, #5
200224ca:	4a03      	ldr	r2, [pc, #12]	@ (200224d8 <HAL_NVIC_EnableIRQ+0x18>)
200224cc:	f000 001f 	and.w	r0, r0, #31
200224d0:	4083      	lsls	r3, r0
200224d2:	f842 3021 	str.w	r3, [r2, r1, lsl #2]
200224d6:	4770      	bx	lr
200224d8:	e000e100 	.word	0xe000e100

200224dc <HAL_NVIC_DisableIRQ>:
200224dc:	2800      	cmp	r0, #0
200224de:	da00      	bge.n	200224e2 <HAL_NVIC_DisableIRQ+0x6>
200224e0:	e7fe      	b.n	200224e0 <HAL_NVIC_DisableIRQ+0x4>
200224e2:	2201      	movs	r2, #1
200224e4:	4906      	ldr	r1, [pc, #24]	@ (20022500 <HAL_NVIC_DisableIRQ+0x24>)
200224e6:	0943      	lsrs	r3, r0, #5
200224e8:	f000 001f 	and.w	r0, r0, #31
200224ec:	4082      	lsls	r2, r0
200224ee:	3320      	adds	r3, #32
200224f0:	f841 2023 	str.w	r2, [r1, r3, lsl #2]
200224f4:	f3bf 8f4f 	dsb	sy
200224f8:	f3bf 8f6f 	isb	sy
200224fc:	4770      	bx	lr
200224fe:	bf00      	nop
20022500:	e000e100 	.word	0xe000e100

20022504 <DMA_Init>:
20022504:	2302      	movs	r3, #2
20022506:	b530      	push	{r4, r5, lr}
20022508:	6a42      	ldr	r2, [r0, #36]	@ 0x24
2002250a:	f880 302d 	strb.w	r3, [r0, #45]	@ 0x2d
2002250e:	6803      	ldr	r3, [r0, #0]
20022510:	611a      	str	r2, [r3, #16]
20022512:	e9d0 3402 	ldrd	r3, r4, [r0, #8]
20022516:	4323      	orrs	r3, r4
20022518:	6904      	ldr	r4, [r0, #16]
2002251a:	6801      	ldr	r1, [r0, #0]
2002251c:	4323      	orrs	r3, r4
2002251e:	6944      	ldr	r4, [r0, #20]
20022520:	680a      	ldr	r2, [r1, #0]
20022522:	4323      	orrs	r3, r4
20022524:	6984      	ldr	r4, [r0, #24]
20022526:	f36f 120e 	bfc	r2, #4, #11
2002252a:	4323      	orrs	r3, r4
2002252c:	69c4      	ldr	r4, [r0, #28]
2002252e:	4323      	orrs	r3, r4
20022530:	6a04      	ldr	r4, [r0, #32]
20022532:	4323      	orrs	r3, r4
20022534:	4313      	orrs	r3, r2
20022536:	600b      	str	r3, [r1, #0]
20022538:	6883      	ldr	r3, [r0, #8]
2002253a:	f5b3 4f80 	cmp.w	r3, #16384	@ 0x4000
2002253e:	d018      	beq.n	20022572 <DMA_Init+0x6e>
20022540:	6cc1      	ldr	r1, [r0, #76]	@ 0x4c
20022542:	6c82      	ldr	r2, [r0, #72]	@ 0x48
20022544:	f3c1 0387 	ubfx	r3, r1, #2, #8
20022548:	06c9      	lsls	r1, r1, #27
2002254a:	d41b      	bmi.n	20022584 <DMA_Init+0x80>
2002254c:	243f      	movs	r4, #63	@ 0x3f
2002254e:	f003 0307 	and.w	r3, r3, #7
20022552:	f8d2 10a8 	ldr.w	r1, [r2, #168]	@ 0xa8
20022556:	00db      	lsls	r3, r3, #3
20022558:	409c      	lsls	r4, r3
2002255a:	ea21 0104 	bic.w	r1, r1, r4
2002255e:	f8c2 10a8 	str.w	r1, [r2, #168]	@ 0xa8
20022562:	6c81      	ldr	r1, [r0, #72]	@ 0x48
20022564:	6842      	ldr	r2, [r0, #4]
20022566:	f8d1 40a8 	ldr.w	r4, [r1, #168]	@ 0xa8
2002256a:	409a      	lsls	r2, r3
2002256c:	4322      	orrs	r2, r4
2002256e:	f8c1 20a8 	str.w	r2, [r1, #168]	@ 0xa8
20022572:	6982      	ldr	r2, [r0, #24]
20022574:	f5b2 6f80 	cmp.w	r2, #1024	@ 0x400
20022578:	d018      	beq.n	200225ac <DMA_Init+0xa8>
2002257a:	f5b2 6f00 	cmp.w	r2, #2048	@ 0x800
2002257e:	d01f      	beq.n	200225c0 <DMA_Init+0xbc>
20022580:	b1aa      	cbz	r2, 200225ae <DMA_Init+0xaa>
20022582:	e7fe      	b.n	20022582 <DMA_Init+0x7e>
20022584:	243f      	movs	r4, #63	@ 0x3f
20022586:	f003 0303 	and.w	r3, r3, #3
2002258a:	f8d2 10ac 	ldr.w	r1, [r2, #172]	@ 0xac
2002258e:	00db      	lsls	r3, r3, #3
20022590:	409c      	lsls	r4, r3
20022592:	ea21 0104 	bic.w	r1, r1, r4
20022596:	f8c2 10ac 	str.w	r1, [r2, #172]	@ 0xac
2002259a:	6c81      	ldr	r1, [r0, #72]	@ 0x48
2002259c:	6842      	ldr	r2, [r0, #4]
2002259e:	f8d1 40ac 	ldr.w	r4, [r1, #172]	@ 0xac
200225a2:	409a      	lsls	r2, r3
200225a4:	4322      	orrs	r2, r4
200225a6:	f8c1 20ac 	str.w	r2, [r1, #172]	@ 0xac
200225aa:	e7e2      	b.n	20022572 <DMA_Init+0x6e>
200225ac:	2201      	movs	r2, #1
200225ae:	6943      	ldr	r3, [r0, #20]
200225b0:	f5b3 7f80 	cmp.w	r3, #256	@ 0x100
200225b4:	d006      	beq.n	200225c4 <DMA_Init+0xc0>
200225b6:	f5b3 7f00 	cmp.w	r3, #512	@ 0x200
200225ba:	d02b      	beq.n	20022614 <DMA_Init+0x110>
200225bc:	b11b      	cbz	r3, 200225c6 <DMA_Init+0xc2>
200225be:	e7fe      	b.n	200225be <DMA_Init+0xba>
200225c0:	2202      	movs	r2, #2
200225c2:	e7f4      	b.n	200225ae <DMA_Init+0xaa>
200225c4:	2301      	movs	r3, #1
200225c6:	6901      	ldr	r1, [r0, #16]
200225c8:	f1a1 0480 	sub.w	r4, r1, #128	@ 0x80
200225cc:	4261      	negs	r1, r4
200225ce:	4161      	adcs	r1, r4
200225d0:	68c4      	ldr	r4, [r0, #12]
200225d2:	f1a4 0540 	sub.w	r5, r4, #64	@ 0x40
200225d6:	426c      	negs	r4, r5
200225d8:	416c      	adcs	r4, r5
200225da:	6885      	ldr	r5, [r0, #8]
200225dc:	2d10      	cmp	r5, #16
200225de:	bf1f      	itttt	ne
200225e0:	f880 1065 	strbne.w	r1, [r0, #101]	@ 0x65
200225e4:	4619      	movne	r1, r3
200225e6:	4613      	movne	r3, r2
200225e8:	460a      	movne	r2, r1
200225ea:	f880 3067 	strb.w	r3, [r0, #103]	@ 0x67
200225ee:	f880 2066 	strb.w	r2, [r0, #102]	@ 0x66
200225f2:	f04f 0300 	mov.w	r3, #0
200225f6:	f04f 0201 	mov.w	r2, #1
200225fa:	6443      	str	r3, [r0, #68]	@ 0x44
200225fc:	bf06      	itte	eq
200225fe:	f880 4065 	strbeq.w	r4, [r0, #101]	@ 0x65
20022602:	f880 1064 	strbeq.w	r1, [r0, #100]	@ 0x64
20022606:	f880 4064 	strbne.w	r4, [r0, #100]	@ 0x64
2002260a:	f880 202d 	strb.w	r2, [r0, #45]	@ 0x2d
2002260e:	f880 302c 	strb.w	r3, [r0, #44]	@ 0x2c
20022612:	bd30      	pop	{r4, r5, pc}
20022614:	2302      	movs	r3, #2
20022616:	e7d6      	b.n	200225c6 <DMA_Init+0xc2>

20022618 <DMA_AllocChannel>:
20022618:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
2002261a:	4b2e      	ldr	r3, [pc, #184]	@ (200226d4 <DMA_AllocChannel+0xbc>)
2002261c:	6802      	ldr	r2, [r0, #0]
2002261e:	4413      	add	r3, r2
20022620:	2ba0      	cmp	r3, #160	@ 0xa0
20022622:	d904      	bls.n	2002262e <DMA_AllocChannel+0x16>
20022624:	4b2c      	ldr	r3, [pc, #176]	@ (200226d8 <DMA_AllocChannel+0xc0>)
20022626:	4413      	add	r3, r2
20022628:	2ba0      	cmp	r3, #160	@ 0xa0
2002262a:	d90f      	bls.n	2002264c <DMA_AllocChannel+0x34>
2002262c:	e7fe      	b.n	2002262c <DMA_AllocChannel+0x14>
2002262e:	2632      	movs	r6, #50	@ 0x32
20022630:	f8df c0b0 	ldr.w	ip, [pc, #176]	@ 200226e4 <DMA_AllocChannel+0xcc>
20022634:	4b29      	ldr	r3, [pc, #164]	@ (200226dc <DMA_AllocChannel+0xc4>)
20022636:	f3ef 8710 	mrs	r7, PRIMASK
2002263a:	2201      	movs	r2, #1
2002263c:	f382 8810 	msr	PRIMASK, r2
20022640:	6cc5      	ldr	r5, [r0, #76]	@ 0x4c
20022642:	2d1f      	cmp	r5, #31
20022644:	ea4f 0495 	mov.w	r4, r5, lsr #2
20022648:	d905      	bls.n	20022656 <DMA_AllocChannel+0x3e>
2002264a:	e7fe      	b.n	2002264a <DMA_AllocChannel+0x32>
2002264c:	2602      	movs	r6, #2
2002264e:	f8df c098 	ldr.w	ip, [pc, #152]	@ 200226e8 <DMA_AllocChannel+0xd0>
20022652:	4b23      	ldr	r3, [pc, #140]	@ (200226e0 <DMA_AllocChannel+0xc8>)
20022654:	e7ef      	b.n	20022636 <DMA_AllocChannel+0x1e>
20022656:	eb03 05c4 	add.w	r5, r3, r4, lsl #3
2002265a:	f895 e004 	ldrb.w	lr, [r5, #4]
2002265e:	f1be 0f00 	cmp.w	lr, #0
20022662:	d032      	beq.n	200226ca <DMA_AllocChannel+0xb2>
20022664:	f853 2034 	ldr.w	r2, [r3, r4, lsl #3]
20022668:	4282      	cmp	r2, r0
2002266a:	d103      	bne.n	20022674 <DMA_AllocChannel+0x5c>
2002266c:	f387 8810 	msr	PRIMASK, r7
20022670:	2002      	movs	r0, #2
20022672:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
20022674:	2200      	movs	r2, #0
20022676:	791c      	ldrb	r4, [r3, #4]
20022678:	461d      	mov	r5, r3
2002267a:	bb04      	cbnz	r4, 200226be <DMA_AllocChannel+0xa6>
2002267c:	2301      	movs	r3, #1
2002267e:	712b      	strb	r3, [r5, #4]
20022680:	2314      	movs	r3, #20
20022682:	fb03 c302 	mla	r3, r3, r2, ip
20022686:	4416      	add	r6, r2
20022688:	0092      	lsls	r2, r2, #2
2002268a:	b274      	sxtb	r4, r6
2002268c:	6003      	str	r3, [r0, #0]
2002268e:	64c2      	str	r2, [r0, #76]	@ 0x4c
20022690:	f387 8810 	msr	PRIMASK, r7
20022694:	b121      	cbz	r1, 200226a0 <DMA_AllocChannel+0x88>
20022696:	682b      	ldr	r3, [r5, #0]
20022698:	4283      	cmp	r3, r0
2002269a:	d001      	beq.n	200226a0 <DMA_AllocChannel+0x88>
2002269c:	f7ff ff32 	bl	20022504 <DMA_Init>
200226a0:	6028      	str	r0, [r5, #0]
200226a2:	6a83      	ldr	r3, [r0, #40]	@ 0x28
200226a4:	f104 4260 	add.w	r2, r4, #3758096384	@ 0xe0000000
200226a8:	015b      	lsls	r3, r3, #5
200226aa:	b2db      	uxtb	r3, r3
200226ac:	f502 4261 	add.w	r2, r2, #57600	@ 0xe100
200226b0:	4620      	mov	r0, r4
200226b2:	f882 3300 	strb.w	r3, [r2, #768]	@ 0x300
200226b6:	f7ff ff03 	bl	200224c0 <HAL_NVIC_EnableIRQ>
200226ba:	2000      	movs	r0, #0
200226bc:	e7d9      	b.n	20022672 <DMA_AllocChannel+0x5a>
200226be:	3201      	adds	r2, #1
200226c0:	2a08      	cmp	r2, #8
200226c2:	f103 0308 	add.w	r3, r3, #8
200226c6:	d1d6      	bne.n	20022676 <DMA_AllocChannel+0x5e>
200226c8:	e7d0      	b.n	2002266c <DMA_AllocChannel+0x54>
200226ca:	4434      	add	r4, r6
200226cc:	712a      	strb	r2, [r5, #4]
200226ce:	b264      	sxtb	r4, r4
200226d0:	e7de      	b.n	20022690 <DMA_AllocChannel+0x78>
200226d2:	bf00      	nop
200226d4:	aff7eff8 	.word	0xaff7eff8
200226d8:	bfffeff8 	.word	0xbfffeff8
200226dc:	2004cc28 	.word	0x2004cc28
200226e0:	2004cbe8 	.word	0x2004cbe8
200226e4:	50081008 	.word	0x50081008
200226e8:	40001008 	.word	0x40001008

200226ec <DMA_FreeChannel.isra.0>:
200226ec:	b538      	push	{r3, r4, r5, lr}
200226ee:	4a13      	ldr	r2, [pc, #76]	@ (2002273c <DMA_FreeChannel.isra.0+0x50>)
200226f0:	6c83      	ldr	r3, [r0, #72]	@ 0x48
200226f2:	4293      	cmp	r3, r2
200226f4:	d003      	beq.n	200226fe <DMA_FreeChannel.isra.0+0x12>
200226f6:	4a12      	ldr	r2, [pc, #72]	@ (20022740 <DMA_FreeChannel.isra.0+0x54>)
200226f8:	4293      	cmp	r3, r2
200226fa:	d008      	beq.n	2002270e <DMA_FreeChannel.isra.0+0x22>
200226fc:	e7fe      	b.n	200226fc <DMA_FreeChannel.isra.0+0x10>
200226fe:	2132      	movs	r1, #50	@ 0x32
20022700:	4a10      	ldr	r2, [pc, #64]	@ (20022744 <DMA_FreeChannel.isra.0+0x58>)
20022702:	6cc4      	ldr	r4, [r0, #76]	@ 0x4c
20022704:	2c1f      	cmp	r4, #31
20022706:	ea4f 0394 	mov.w	r3, r4, lsr #2
2002270a:	d903      	bls.n	20022714 <DMA_FreeChannel.isra.0+0x28>
2002270c:	e7fe      	b.n	2002270c <DMA_FreeChannel.isra.0+0x20>
2002270e:	2102      	movs	r1, #2
20022710:	4a0d      	ldr	r2, [pc, #52]	@ (20022748 <DMA_FreeChannel.isra.0+0x5c>)
20022712:	e7f6      	b.n	20022702 <DMA_FreeChannel.isra.0+0x16>
20022714:	f3ef 8410 	mrs	r4, PRIMASK
20022718:	2501      	movs	r5, #1
2002271a:	f385 8810 	msr	PRIMASK, r5
2002271e:	eb02 05c3 	add.w	r5, r2, r3, lsl #3
20022722:	f852 2033 	ldr.w	r2, [r2, r3, lsl #3]
20022726:	4290      	cmp	r0, r2
20022728:	d105      	bne.n	20022736 <DMA_FreeChannel.isra.0+0x4a>
2002272a:	1858      	adds	r0, r3, r1
2002272c:	b240      	sxtb	r0, r0
2002272e:	f7ff fed5 	bl	200224dc <HAL_NVIC_DisableIRQ>
20022732:	2300      	movs	r3, #0
20022734:	712b      	strb	r3, [r5, #4]
20022736:	f384 8810 	msr	PRIMASK, r4
2002273a:	bd38      	pop	{r3, r4, r5, pc}
2002273c:	50081000 	.word	0x50081000
20022740:	40001000 	.word	0x40001000
20022744:	2004cc28 	.word	0x2004cc28
20022748:	2004cbe8 	.word	0x2004cbe8

2002274c <HAL_DMA_Init>:
2002274c:	b538      	push	{r3, r4, r5, lr}
2002274e:	4604      	mov	r4, r0
20022750:	2800      	cmp	r0, #0
20022752:	d052      	beq.n	200227fa <HAL_DMA_Init+0xae>
20022754:	6883      	ldr	r3, [r0, #8]
20022756:	f033 0210 	bics.w	r2, r3, #16
2002275a:	d003      	beq.n	20022764 <HAL_DMA_Init+0x18>
2002275c:	f5b3 4f80 	cmp.w	r3, #16384	@ 0x4000
20022760:	d000      	beq.n	20022764 <HAL_DMA_Init+0x18>
20022762:	e7fe      	b.n	20022762 <HAL_DMA_Init+0x16>
20022764:	68e3      	ldr	r3, [r4, #12]
20022766:	f033 0340 	bics.w	r3, r3, #64	@ 0x40
2002276a:	d000      	beq.n	2002276e <HAL_DMA_Init+0x22>
2002276c:	e7fe      	b.n	2002276c <HAL_DMA_Init+0x20>
2002276e:	6923      	ldr	r3, [r4, #16]
20022770:	f033 0380 	bics.w	r3, r3, #128	@ 0x80
20022774:	d000      	beq.n	20022778 <HAL_DMA_Init+0x2c>
20022776:	e7fe      	b.n	20022776 <HAL_DMA_Init+0x2a>
20022778:	6963      	ldr	r3, [r4, #20]
2002277a:	f433 7280 	bics.w	r2, r3, #256	@ 0x100
2002277e:	d003      	beq.n	20022788 <HAL_DMA_Init+0x3c>
20022780:	f5b3 7f00 	cmp.w	r3, #512	@ 0x200
20022784:	d000      	beq.n	20022788 <HAL_DMA_Init+0x3c>
20022786:	e7fe      	b.n	20022786 <HAL_DMA_Init+0x3a>
20022788:	69a3      	ldr	r3, [r4, #24]
2002278a:	f433 6280 	bics.w	r2, r3, #1024	@ 0x400
2002278e:	d003      	beq.n	20022798 <HAL_DMA_Init+0x4c>
20022790:	f5b3 6f00 	cmp.w	r3, #2048	@ 0x800
20022794:	d000      	beq.n	20022798 <HAL_DMA_Init+0x4c>
20022796:	e7fe      	b.n	20022796 <HAL_DMA_Init+0x4a>
20022798:	69e3      	ldr	r3, [r4, #28]
2002279a:	f033 0320 	bics.w	r3, r3, #32
2002279e:	d000      	beq.n	200227a2 <HAL_DMA_Init+0x56>
200227a0:	e7fe      	b.n	200227a0 <HAL_DMA_Init+0x54>
200227a2:	6a23      	ldr	r3, [r4, #32]
200227a4:	f433 5340 	bics.w	r3, r3, #12288	@ 0x3000
200227a8:	d000      	beq.n	200227ac <HAL_DMA_Init+0x60>
200227aa:	e7fe      	b.n	200227aa <HAL_DMA_Init+0x5e>
200227ac:	6863      	ldr	r3, [r4, #4]
200227ae:	2b3f      	cmp	r3, #63	@ 0x3f
200227b0:	d900      	bls.n	200227b4 <HAL_DMA_Init+0x68>
200227b2:	e7fe      	b.n	200227b2 <HAL_DMA_Init+0x66>
200227b4:	6822      	ldr	r2, [r4, #0]
200227b6:	4b13      	ldr	r3, [pc, #76]	@ (20022804 <HAL_DMA_Init+0xb8>)
200227b8:	4413      	add	r3, r2
200227ba:	2b8c      	cmp	r3, #140	@ 0x8c
200227bc:	d813      	bhi.n	200227e6 <HAL_DMA_Init+0x9a>
200227be:	2214      	movs	r2, #20
200227c0:	fbb3 f3f2 	udiv	r3, r3, r2
200227c4:	4a10      	ldr	r2, [pc, #64]	@ (20022808 <HAL_DMA_Init+0xbc>)
200227c6:	009b      	lsls	r3, r3, #2
200227c8:	2100      	movs	r1, #0
200227ca:	4620      	mov	r0, r4
200227cc:	e9c4 2312 	strd	r2, r3, [r4, #72]	@ 0x48
200227d0:	f7ff ff22 	bl	20022618 <DMA_AllocChannel>
200227d4:	4605      	mov	r5, r0
200227d6:	b990      	cbnz	r0, 200227fe <HAL_DMA_Init+0xb2>
200227d8:	4620      	mov	r0, r4
200227da:	f7ff fe93 	bl	20022504 <DMA_Init>
200227de:	f7ff ff85 	bl	200226ec <DMA_FreeChannel.isra.0>
200227e2:	4628      	mov	r0, r5
200227e4:	bd38      	pop	{r3, r4, r5, pc}
200227e6:	4b09      	ldr	r3, [pc, #36]	@ (2002280c <HAL_DMA_Init+0xc0>)
200227e8:	4413      	add	r3, r2
200227ea:	2b8c      	cmp	r3, #140	@ 0x8c
200227ec:	d805      	bhi.n	200227fa <HAL_DMA_Init+0xae>
200227ee:	2214      	movs	r2, #20
200227f0:	fbb3 f3f2 	udiv	r3, r3, r2
200227f4:	4a06      	ldr	r2, [pc, #24]	@ (20022810 <HAL_DMA_Init+0xc4>)
200227f6:	009b      	lsls	r3, r3, #2
200227f8:	e7e6      	b.n	200227c8 <HAL_DMA_Init+0x7c>
200227fa:	2501      	movs	r5, #1
200227fc:	e7f1      	b.n	200227e2 <HAL_DMA_Init+0x96>
200227fe:	2502      	movs	r5, #2
20022800:	e7ef      	b.n	200227e2 <HAL_DMA_Init+0x96>
20022802:	bf00      	nop
20022804:	aff7eff8 	.word	0xaff7eff8
20022808:	50081000 	.word	0x50081000
2002280c:	bfffeff8 	.word	0xbfffeff8
20022810:	40001000 	.word	0x40001000

20022814 <HAL_DMA_DeInit>:
20022814:	b510      	push	{r4, lr}
20022816:	4604      	mov	r4, r0
20022818:	2800      	cmp	r0, #0
2002281a:	d051      	beq.n	200228c0 <HAL_DMA_DeInit+0xac>
2002281c:	6802      	ldr	r2, [r0, #0]
2002281e:	6813      	ldr	r3, [r2, #0]
20022820:	f023 0301 	bic.w	r3, r3, #1
20022824:	6013      	str	r3, [r2, #0]
20022826:	6802      	ldr	r2, [r0, #0]
20022828:	4b26      	ldr	r3, [pc, #152]	@ (200228c4 <HAL_DMA_DeInit+0xb0>)
2002282a:	4413      	add	r3, r2
2002282c:	2b8c      	cmp	r3, #140	@ 0x8c
2002282e:	d82f      	bhi.n	20022890 <HAL_DMA_DeInit+0x7c>
20022830:	2114      	movs	r1, #20
20022832:	fbb3 f3f1 	udiv	r3, r3, r1
20022836:	009b      	lsls	r3, r3, #2
20022838:	64c3      	str	r3, [r0, #76]	@ 0x4c
2002283a:	4b23      	ldr	r3, [pc, #140]	@ (200228c8 <HAL_DMA_DeInit+0xb4>)
2002283c:	64a3      	str	r3, [r4, #72]	@ 0x48
2002283e:	2300      	movs	r3, #0
20022840:	6013      	str	r3, [r2, #0]
20022842:	e9d4 1312 	ldrd	r1, r3, [r4, #72]	@ 0x48
20022846:	f003 021c 	and.w	r2, r3, #28
2002284a:	2301      	movs	r3, #1
2002284c:	4093      	lsls	r3, r2
2002284e:	604b      	str	r3, [r1, #4]
20022850:	6ce3      	ldr	r3, [r4, #76]	@ 0x4c
20022852:	6ca1      	ldr	r1, [r4, #72]	@ 0x48
20022854:	2b0f      	cmp	r3, #15
20022856:	ea4f 0293 	mov.w	r2, r3, lsr #2
2002285a:	d824      	bhi.n	200228a6 <HAL_DMA_DeInit+0x92>
2002285c:	203f      	movs	r0, #63	@ 0x3f
2002285e:	005b      	lsls	r3, r3, #1
20022860:	f8d1 20a8 	ldr.w	r2, [r1, #168]	@ 0xa8
20022864:	f003 0338 	and.w	r3, r3, #56	@ 0x38
20022868:	fa00 f303 	lsl.w	r3, r0, r3
2002286c:	ea22 0303 	bic.w	r3, r2, r3
20022870:	f8c1 30a8 	str.w	r3, [r1, #168]	@ 0xa8
20022874:	4620      	mov	r0, r4
20022876:	f7ff ff39 	bl	200226ec <DMA_FreeChannel.isra.0>
2002287a:	2000      	movs	r0, #0
2002287c:	e9c4 000d 	strd	r0, r0, [r4, #52]	@ 0x34
20022880:	e9c4 000f 	strd	r0, r0, [r4, #60]	@ 0x3c
20022884:	6460      	str	r0, [r4, #68]	@ 0x44
20022886:	f884 002c 	strb.w	r0, [r4, #44]	@ 0x2c
2002288a:	f884 002d 	strb.w	r0, [r4, #45]	@ 0x2d
2002288e:	bd10      	pop	{r4, pc}
20022890:	4b0e      	ldr	r3, [pc, #56]	@ (200228cc <HAL_DMA_DeInit+0xb8>)
20022892:	4413      	add	r3, r2
20022894:	2b8c      	cmp	r3, #140	@ 0x8c
20022896:	d8d2      	bhi.n	2002283e <HAL_DMA_DeInit+0x2a>
20022898:	2114      	movs	r1, #20
2002289a:	fbb3 f3f1 	udiv	r3, r3, r1
2002289e:	009b      	lsls	r3, r3, #2
200228a0:	64c3      	str	r3, [r0, #76]	@ 0x4c
200228a2:	4b0b      	ldr	r3, [pc, #44]	@ (200228d0 <HAL_DMA_DeInit+0xbc>)
200228a4:	e7ca      	b.n	2002283c <HAL_DMA_DeInit+0x28>
200228a6:	f002 0303 	and.w	r3, r2, #3
200228aa:	223f      	movs	r2, #63	@ 0x3f
200228ac:	f8d1 00ac 	ldr.w	r0, [r1, #172]	@ 0xac
200228b0:	00db      	lsls	r3, r3, #3
200228b2:	fa02 f303 	lsl.w	r3, r2, r3
200228b6:	ea20 0303 	bic.w	r3, r0, r3
200228ba:	f8c1 30ac 	str.w	r3, [r1, #172]	@ 0xac
200228be:	e7d9      	b.n	20022874 <HAL_DMA_DeInit+0x60>
200228c0:	2001      	movs	r0, #1
200228c2:	e7e4      	b.n	2002288e <HAL_DMA_DeInit+0x7a>
200228c4:	aff7eff8 	.word	0xaff7eff8
200228c8:	50081000 	.word	0x50081000
200228cc:	bfffeff8 	.word	0xbfffeff8
200228d0:	40001000 	.word	0x40001000

200228d4 <HAL_DMA_PollForTransfer>:
200228d4:	e92d 4ff8 	stmdb	sp!, {r3, r4, r5, r6, r7, r8, r9, sl, fp, lr}
200228d8:	f890 302d 	ldrb.w	r3, [r0, #45]	@ 0x2d
200228dc:	4617      	mov	r7, r2
200228de:	2b02      	cmp	r3, #2
200228e0:	4604      	mov	r4, r0
200228e2:	4688      	mov	r8, r1
200228e4:	b2da      	uxtb	r2, r3
200228e6:	d005      	beq.n	200228f4 <HAL_DMA_PollForTransfer+0x20>
200228e8:	2304      	movs	r3, #4
200228ea:	6443      	str	r3, [r0, #68]	@ 0x44
200228ec:	2300      	movs	r3, #0
200228ee:	f884 302c 	strb.w	r3, [r4, #44]	@ 0x2c
200228f2:	e006      	b.n	20022902 <HAL_DMA_PollForTransfer+0x2e>
200228f4:	6803      	ldr	r3, [r0, #0]
200228f6:	681b      	ldr	r3, [r3, #0]
200228f8:	0699      	lsls	r1, r3, #26
200228fa:	d505      	bpl.n	20022908 <HAL_DMA_PollForTransfer+0x34>
200228fc:	f44f 7380 	mov.w	r3, #256	@ 0x100
20022900:	6443      	str	r3, [r0, #68]	@ 0x44
20022902:	2001      	movs	r0, #1
20022904:	e8bd 8ff8 	ldmia.w	sp!, {r3, r4, r5, r6, r7, r8, r9, sl, fp, pc}
20022908:	6cc5      	ldr	r5, [r0, #76]	@ 0x4c
2002290a:	f005 051c 	and.w	r5, r5, #28
2002290e:	f1b8 0f00 	cmp.w	r8, #0
20022912:	d123      	bne.n	2002295c <HAL_DMA_PollForTransfer+0x88>
20022914:	fa02 f505 	lsl.w	r5, r2, r5
20022918:	f7ff fc0a 	bl	20022130 <HAL_GetTick>
2002291c:	f04f 0a08 	mov.w	sl, #8
20022920:	4681      	mov	r9, r0
20022922:	e9d4 6312 	ldrd	r6, r3, [r4, #72]	@ 0x48
20022926:	f003 031c 	and.w	r3, r3, #28
2002292a:	fa0a f103 	lsl.w	r1, sl, r3
2002292e:	6832      	ldr	r2, [r6, #0]
20022930:	ea12 0b05 	ands.w	fp, r2, r5
20022934:	d016      	beq.n	20022964 <HAL_DMA_PollForTransfer+0x90>
20022936:	f1b8 0f00 	cmp.w	r8, #0
2002293a:	d136      	bne.n	200229aa <HAL_DMA_PollForTransfer+0xd6>
2002293c:	2202      	movs	r2, #2
2002293e:	fa02 f303 	lsl.w	r3, r2, r3
20022942:	6073      	str	r3, [r6, #4]
20022944:	6d23      	ldr	r3, [r4, #80]	@ 0x50
20022946:	b92b      	cbnz	r3, 20022954 <HAL_DMA_PollForTransfer+0x80>
20022948:	4620      	mov	r0, r4
2002294a:	f7ff fecf 	bl	200226ec <DMA_FreeChannel.isra.0>
2002294e:	2301      	movs	r3, #1
20022950:	f884 302d 	strb.w	r3, [r4, #45]	@ 0x2d
20022954:	2000      	movs	r0, #0
20022956:	f884 002c 	strb.w	r0, [r4, #44]	@ 0x2c
2002295a:	e7d3      	b.n	20022904 <HAL_DMA_PollForTransfer+0x30>
2002295c:	2304      	movs	r3, #4
2002295e:	fa03 f505 	lsl.w	r5, r3, r5
20022962:	e7d9      	b.n	20022918 <HAL_DMA_PollForTransfer+0x44>
20022964:	6832      	ldr	r2, [r6, #0]
20022966:	4211      	tst	r1, r2
20022968:	d00c      	beq.n	20022984 <HAL_DMA_PollForTransfer+0xb0>
2002296a:	2501      	movs	r5, #1
2002296c:	fa05 f303 	lsl.w	r3, r5, r3
20022970:	6073      	str	r3, [r6, #4]
20022972:	4620      	mov	r0, r4
20022974:	6465      	str	r5, [r4, #68]	@ 0x44
20022976:	f7ff feb9 	bl	200226ec <DMA_FreeChannel.isra.0>
2002297a:	f884 502d 	strb.w	r5, [r4, #45]	@ 0x2d
2002297e:	f884 b02c 	strb.w	fp, [r4, #44]	@ 0x2c
20022982:	e7be      	b.n	20022902 <HAL_DMA_PollForTransfer+0x2e>
20022984:	1c7a      	adds	r2, r7, #1
20022986:	d0d2      	beq.n	2002292e <HAL_DMA_PollForTransfer+0x5a>
20022988:	f7ff fbd2 	bl	20022130 <HAL_GetTick>
2002298c:	eba0 0009 	sub.w	r0, r0, r9
20022990:	42b8      	cmp	r0, r7
20022992:	d801      	bhi.n	20022998 <HAL_DMA_PollForTransfer+0xc4>
20022994:	2f00      	cmp	r7, #0
20022996:	d1c4      	bne.n	20022922 <HAL_DMA_PollForTransfer+0x4e>
20022998:	2320      	movs	r3, #32
2002299a:	4620      	mov	r0, r4
2002299c:	6463      	str	r3, [r4, #68]	@ 0x44
2002299e:	f7ff fea5 	bl	200226ec <DMA_FreeChannel.isra.0>
200229a2:	2301      	movs	r3, #1
200229a4:	f884 302d 	strb.w	r3, [r4, #45]	@ 0x2d
200229a8:	e7a0      	b.n	200228ec <HAL_DMA_PollForTransfer+0x18>
200229aa:	2204      	movs	r2, #4
200229ac:	fa02 f303 	lsl.w	r3, r2, r3
200229b0:	6073      	str	r3, [r6, #4]
200229b2:	e7cf      	b.n	20022954 <HAL_DMA_PollForTransfer+0x80>

200229b4 <DMA_Remap>:
200229b4:	b530      	push	{r4, r5, lr}
200229b6:	4b15      	ldr	r3, [pc, #84]	@ (20022a0c <DMA_Remap+0x58>)
200229b8:	6c84      	ldr	r4, [r0, #72]	@ 0x48
200229ba:	429c      	cmp	r4, r3
200229bc:	d11b      	bne.n	200229f6 <DMA_Remap+0x42>
200229be:	6883      	ldr	r3, [r0, #8]
200229c0:	2b10      	cmp	r3, #16
200229c2:	d002      	beq.n	200229ca <DMA_Remap+0x16>
200229c4:	f5b3 4f80 	cmp.w	r3, #16384	@ 0x4000
200229c8:	d108      	bne.n	200229dc <DMA_Remap+0x28>
200229ca:	680b      	ldr	r3, [r1, #0]
200229cc:	4c10      	ldr	r4, [pc, #64]	@ (20022a10 <DMA_Remap+0x5c>)
200229ce:	f103 4560 	add.w	r5, r3, #3758096384	@ 0xe0000000
200229d2:	42a5      	cmp	r5, r4
200229d4:	bf98      	it	ls
200229d6:	f103 6320 	addls.w	r3, r3, #167772160	@ 0xa000000
200229da:	600b      	str	r3, [r1, #0]
200229dc:	6883      	ldr	r3, [r0, #8]
200229de:	f433 4380 	bics.w	r3, r3, #16384	@ 0x4000
200229e2:	d108      	bne.n	200229f6 <DMA_Remap+0x42>
200229e4:	6813      	ldr	r3, [r2, #0]
200229e6:	480a      	ldr	r0, [pc, #40]	@ (20022a10 <DMA_Remap+0x5c>)
200229e8:	f103 4460 	add.w	r4, r3, #3758096384	@ 0xe0000000
200229ec:	4284      	cmp	r4, r0
200229ee:	bf98      	it	ls
200229f0:	f103 6320 	addls.w	r3, r3, #167772160	@ 0xa000000
200229f4:	6013      	str	r3, [r2, #0]
200229f6:	680b      	ldr	r3, [r1, #0]
200229f8:	f103 4270 	add.w	r2, r3, #4026531840	@ 0xf0000000
200229fc:	f1b2 5f80 	cmp.w	r2, #268435456	@ 0x10000000
20022a00:	bf3c      	itt	cc
20022a02:	f103 43a0 	addcc.w	r3, r3, #1342177280	@ 0x50000000
20022a06:	600b      	strcc	r3, [r1, #0]
20022a08:	bd30      	pop	{r4, r5, pc}
20022a0a:	bf00      	nop
20022a0c:	40001000 	.word	0x40001000
20022a10:	0007fffe 	.word	0x0007fffe

20022a14 <DMA_Start>:
20022a14:	e92d 41f3 	stmdb	sp!, {r0, r1, r4, r5, r6, r7, r8, lr}
20022a18:	f64f 75ff 	movw	r5, #65535	@ 0xffff
20022a1c:	6d03      	ldr	r3, [r0, #80]	@ 0x50
20022a1e:	6802      	ldr	r2, [r0, #0]
20022a20:	429d      	cmp	r5, r3
20022a22:	bf28      	it	cs
20022a24:	461d      	movcs	r5, r3
20022a26:	1b5b      	subs	r3, r3, r5
20022a28:	6503      	str	r3, [r0, #80]	@ 0x50
20022a2a:	6585      	str	r5, [r0, #88]	@ 0x58
20022a2c:	6813      	ldr	r3, [r2, #0]
20022a2e:	f890 7066 	ldrb.w	r7, [r0, #102]	@ 0x66
20022a32:	f023 0301 	bic.w	r3, r3, #1
20022a36:	f890 8067 	ldrb.w	r8, [r0, #103]	@ 0x67
20022a3a:	6013      	str	r3, [r2, #0]
20022a3c:	e9d0 2317 	ldrd	r2, r3, [r0, #92]	@ 0x5c
20022a40:	460e      	mov	r6, r1
20022a42:	e9cd 2300 	strd	r2, r3, [sp]
20022a46:	e9d0 2312 	ldrd	r2, r3, [r0, #72]	@ 0x48
20022a4a:	f003 011c 	and.w	r1, r3, #28
20022a4e:	2301      	movs	r3, #1
20022a50:	4604      	mov	r4, r0
20022a52:	408b      	lsls	r3, r1
20022a54:	6053      	str	r3, [r2, #4]
20022a56:	6803      	ldr	r3, [r0, #0]
20022a58:	4669      	mov	r1, sp
20022a5a:	605d      	str	r5, [r3, #4]
20022a5c:	aa01      	add	r2, sp, #4
20022a5e:	f7ff ffa9 	bl	200229b4 <DMA_Remap>
20022a62:	e9dd 0300 	ldrd	r0, r3, [sp]
20022a66:	68a1      	ldr	r1, [r4, #8]
20022a68:	6822      	ldr	r2, [r4, #0]
20022a6a:	2910      	cmp	r1, #16
20022a6c:	bf0b      	itete	eq
20022a6e:	6093      	streq	r3, [r2, #8]
20022a70:	6090      	strne	r0, [r2, #8]
20022a72:	6823      	ldreq	r3, [r4, #0]
20022a74:	6822      	ldrne	r2, [r4, #0]
20022a76:	bf0c      	ite	eq
20022a78:	60d8      	streq	r0, [r3, #12]
20022a7a:	60d3      	strne	r3, [r2, #12]
20022a7c:	f894 3064 	ldrb.w	r3, [r4, #100]	@ 0x64
20022a80:	b123      	cbz	r3, 20022a8c <DMA_Start+0x78>
20022a82:	6de3      	ldr	r3, [r4, #92]	@ 0x5c
20022a84:	fa05 f707 	lsl.w	r7, r5, r7
20022a88:	443b      	add	r3, r7
20022a8a:	65e3      	str	r3, [r4, #92]	@ 0x5c
20022a8c:	f894 3065 	ldrb.w	r3, [r4, #101]	@ 0x65
20022a90:	b123      	cbz	r3, 20022a9c <DMA_Start+0x88>
20022a92:	6e23      	ldr	r3, [r4, #96]	@ 0x60
20022a94:	fa05 f508 	lsl.w	r5, r5, r8
20022a98:	442b      	add	r3, r5
20022a9a:	6623      	str	r3, [r4, #96]	@ 0x60
20022a9c:	b136      	cbz	r6, 20022aac <DMA_Start+0x98>
20022a9e:	6ba2      	ldr	r2, [r4, #56]	@ 0x38
20022aa0:	6823      	ldr	r3, [r4, #0]
20022aa2:	b15a      	cbz	r2, 20022abc <DMA_Start+0xa8>
20022aa4:	681a      	ldr	r2, [r3, #0]
20022aa6:	f042 020e 	orr.w	r2, r2, #14
20022aaa:	601a      	str	r2, [r3, #0]
20022aac:	6822      	ldr	r2, [r4, #0]
20022aae:	6813      	ldr	r3, [r2, #0]
20022ab0:	f043 0301 	orr.w	r3, r3, #1
20022ab4:	6013      	str	r3, [r2, #0]
20022ab6:	b002      	add	sp, #8
20022ab8:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}
20022abc:	681a      	ldr	r2, [r3, #0]
20022abe:	f022 0204 	bic.w	r2, r2, #4
20022ac2:	601a      	str	r2, [r3, #0]
20022ac4:	6822      	ldr	r2, [r4, #0]
20022ac6:	6813      	ldr	r3, [r2, #0]
20022ac8:	f043 030a 	orr.w	r3, r3, #10
20022acc:	6013      	str	r3, [r2, #0]
20022ace:	e7ed      	b.n	20022aac <DMA_Start+0x98>

20022ad0 <HAL_DMA_Start>:
20022ad0:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
20022ad2:	461d      	mov	r5, r3
20022ad4:	69c3      	ldr	r3, [r0, #28]
20022ad6:	4604      	mov	r4, r0
20022ad8:	2b20      	cmp	r3, #32
20022ada:	460f      	mov	r7, r1
20022adc:	4616      	mov	r6, r2
20022ade:	d105      	bne.n	20022aec <HAL_DMA_Start+0x1c>
20022ae0:	f64f 73fd 	movw	r3, #65533	@ 0xfffd
20022ae4:	1e6a      	subs	r2, r5, #1
20022ae6:	429a      	cmp	r2, r3
20022ae8:	d900      	bls.n	20022aec <HAL_DMA_Start+0x1c>
20022aea:	e7fe      	b.n	20022aea <HAL_DMA_Start+0x1a>
20022aec:	f894 302c 	ldrb.w	r3, [r4, #44]	@ 0x2c
20022af0:	2b01      	cmp	r3, #1
20022af2:	d00e      	beq.n	20022b12 <HAL_DMA_Start+0x42>
20022af4:	2301      	movs	r3, #1
20022af6:	f884 302c 	strb.w	r3, [r4, #44]	@ 0x2c
20022afa:	f894 302d 	ldrb.w	r3, [r4, #45]	@ 0x2d
20022afe:	2b01      	cmp	r3, #1
20022b00:	b2d9      	uxtb	r1, r3
20022b02:	d103      	bne.n	20022b0c <HAL_DMA_Start+0x3c>
20022b04:	4620      	mov	r0, r4
20022b06:	f7ff fd87 	bl	20022618 <DMA_AllocChannel>
20022b0a:	b120      	cbz	r0, 20022b16 <HAL_DMA_Start+0x46>
20022b0c:	2300      	movs	r3, #0
20022b0e:	f884 302c 	strb.w	r3, [r4, #44]	@ 0x2c
20022b12:	2002      	movs	r0, #2
20022b14:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
20022b16:	2302      	movs	r3, #2
20022b18:	e9c4 5514 	strd	r5, r5, [r4, #80]	@ 0x50
20022b1c:	e9c4 7617 	strd	r7, r6, [r4, #92]	@ 0x5c
20022b20:	f884 302d 	strb.w	r3, [r4, #45]	@ 0x2d
20022b24:	6460      	str	r0, [r4, #68]	@ 0x44
20022b26:	6d20      	ldr	r0, [r4, #80]	@ 0x50
20022b28:	2800      	cmp	r0, #0
20022b2a:	d0f3      	beq.n	20022b14 <HAL_DMA_Start+0x44>
20022b2c:	2100      	movs	r1, #0
20022b2e:	4620      	mov	r0, r4
20022b30:	f7ff ff70 	bl	20022a14 <DMA_Start>
20022b34:	6d23      	ldr	r3, [r4, #80]	@ 0x50
20022b36:	2b00      	cmp	r3, #0
20022b38:	d0f5      	beq.n	20022b26 <HAL_DMA_Start+0x56>
20022b3a:	f44f 727a 	mov.w	r2, #1000	@ 0x3e8
20022b3e:	2100      	movs	r1, #0
20022b40:	4620      	mov	r0, r4
20022b42:	f7ff fec7 	bl	200228d4 <HAL_DMA_PollForTransfer>
20022b46:	2800      	cmp	r0, #0
20022b48:	d0ed      	beq.n	20022b26 <HAL_DMA_Start+0x56>
20022b4a:	e7e3      	b.n	20022b14 <HAL_DMA_Start+0x44>

20022b4c <HAL_EFUSE_Read>:
20022b4c:	2a20      	cmp	r2, #32
20022b4e:	e92d 43f8 	stmdb	sp!, {r3, r4, r5, r6, r7, r8, r9, lr}
20022b52:	4607      	mov	r7, r0
20022b54:	460c      	mov	r4, r1
20022b56:	4690      	mov	r8, r2
20022b58:	dc25      	bgt.n	20022ba6 <HAL_EFUSE_Read+0x5a>
20022b5a:	f3c0 09c4 	ubfx	r9, r0, #3, #5
20022b5e:	eb09 0302 	add.w	r3, r9, r2
20022b62:	2b20      	cmp	r3, #32
20022b64:	dc1f      	bgt.n	20022ba6 <HAL_EFUSE_Read+0x5a>
20022b66:	f012 0f03 	tst.w	r2, #3
20022b6a:	d11c      	bne.n	20022ba6 <HAL_EFUSE_Read+0x5a>
20022b6c:	f010 051f 	ands.w	r5, r0, #31
20022b70:	d119      	bne.n	20022ba6 <HAL_EFUSE_Read+0x5a>
20022b72:	2003      	movs	r0, #3
20022b74:	f7ff fa8e 	bl	20022094 <pmu_ldo_inc>
20022b78:	4629      	mov	r1, r5
20022b7a:	4e1d      	ldr	r6, [pc, #116]	@ (20022bf0 <HAL_EFUSE_Read+0xa4>)
20022b7c:	0a3f      	lsrs	r7, r7, #8
20022b7e:	00bb      	lsls	r3, r7, #2
20022b80:	6033      	str	r3, [r6, #0]
20022b82:	6833      	ldr	r3, [r6, #0]
20022b84:	4a1b      	ldr	r2, [pc, #108]	@ (20022bf4 <HAL_EFUSE_Read+0xa8>)
20022b86:	f043 0301 	orr.w	r3, r3, #1
20022b8a:	6033      	str	r3, [r6, #0]
20022b8c:	68b3      	ldr	r3, [r6, #8]
20022b8e:	07db      	lsls	r3, r3, #31
20022b90:	d401      	bmi.n	20022b96 <HAL_EFUSE_Read+0x4a>
20022b92:	4291      	cmp	r1, r2
20022b94:	d10c      	bne.n	20022bb0 <HAL_EFUSE_Read+0x64>
20022b96:	68b3      	ldr	r3, [r6, #8]
20022b98:	4291      	cmp	r1, r2
20022b9a:	f043 0301 	orr.w	r3, r3, #1
20022b9e:	60b3      	str	r3, [r6, #8]
20022ba0:	d108      	bne.n	20022bb4 <HAL_EFUSE_Read+0x68>
20022ba2:	f7ff fa8b 	bl	200220bc <pmu_ldo_recover>
20022ba6:	f04f 0800 	mov.w	r8, #0
20022baa:	4640      	mov	r0, r8
20022bac:	e8bd 83f8 	ldmia.w	sp!, {r3, r4, r5, r6, r7, r8, r9, pc}
20022bb0:	3101      	adds	r1, #1
20022bb2:	e7eb      	b.n	20022b8c <HAL_EFUSE_Read+0x40>
20022bb4:	4a10      	ldr	r2, [pc, #64]	@ (20022bf8 <HAL_EFUSE_Read+0xac>)
20022bb6:	f009 031c 	and.w	r3, r9, #28
20022bba:	eb03 1347 	add.w	r3, r3, r7, lsl #5
20022bbe:	f028 0103 	bic.w	r1, r8, #3
20022bc2:	441a      	add	r2, r3
20022bc4:	4421      	add	r1, r4
20022bc6:	428c      	cmp	r4, r1
20022bc8:	d102      	bne.n	20022bd0 <HAL_EFUSE_Read+0x84>
20022bca:	f7ff fa77 	bl	200220bc <pmu_ldo_recover>
20022bce:	e7ec      	b.n	20022baa <HAL_EFUSE_Read+0x5e>
20022bd0:	f852 3b04 	ldr.w	r3, [r2], #4
20022bd4:	3404      	adds	r4, #4
20022bd6:	0a1d      	lsrs	r5, r3, #8
20022bd8:	f804 3c04 	strb.w	r3, [r4, #-4]
20022bdc:	f804 5c03 	strb.w	r5, [r4, #-3]
20022be0:	0c1d      	lsrs	r5, r3, #16
20022be2:	0e1b      	lsrs	r3, r3, #24
20022be4:	f804 5c02 	strb.w	r5, [r4, #-2]
20022be8:	f804 3c01 	strb.w	r3, [r4, #-1]
20022bec:	e7eb      	b.n	20022bc6 <HAL_EFUSE_Read+0x7a>
20022bee:	bf00      	nop
20022bf0:	5000c000 	.word	0x5000c000
20022bf4:	00bb8000 	.word	0x00bb8000
20022bf8:	5000c030 	.word	0x5000c030

20022bfc <HAL_DBG_printf>:
20022bfc:	b40f      	push	{r0, r1, r2, r3}
20022bfe:	b004      	add	sp, #16
20022c00:	4770      	bx	lr
	...

20022c04 <HAL_HPAON_WakeCore>:
20022c04:	2802      	cmp	r0, #2
20022c06:	b510      	push	{r4, lr}
20022c08:	d120      	bne.n	20022c4c <HAL_HPAON_WakeCore+0x48>
20022c0a:	4c11      	ldr	r4, [pc, #68]	@ (20022c50 <HAL_HPAON_WakeCore+0x4c>)
20022c0c:	20e6      	movs	r0, #230	@ 0xe6
20022c0e:	6ae3      	ldr	r3, [r4, #44]	@ 0x2c
20022c10:	f043 0301 	orr.w	r3, r3, #1
20022c14:	62e3      	str	r3, [r4, #44]	@ 0x2c
20022c16:	f7ff faf0 	bl	200221fa <HAL_Delay_us>
20022c1a:	6ae3      	ldr	r3, [r4, #44]	@ 0x2c
20022c1c:	069a      	lsls	r2, r3, #26
20022c1e:	d5fc      	bpl.n	20022c1a <HAL_HPAON_WakeCore+0x16>
20022c20:	201e      	movs	r0, #30
20022c22:	f7ff faea 	bl	200221fa <HAL_Delay_us>
20022c26:	6ae3      	ldr	r3, [r4, #44]	@ 0x2c
20022c28:	069b      	lsls	r3, r3, #26
20022c2a:	d5fc      	bpl.n	20022c26 <HAL_HPAON_WakeCore+0x22>
20022c2c:	f3ef 8110 	mrs	r1, PRIMASK
20022c30:	2301      	movs	r3, #1
20022c32:	f383 8810 	msr	PRIMASK, r3
20022c36:	4a07      	ldr	r2, [pc, #28]	@ (20022c54 <HAL_HPAON_WakeCore+0x50>)
20022c38:	7813      	ldrb	r3, [r2, #0]
20022c3a:	2b13      	cmp	r3, #19
20022c3c:	d900      	bls.n	20022c40 <HAL_HPAON_WakeCore+0x3c>
20022c3e:	e7fe      	b.n	20022c3e <HAL_HPAON_WakeCore+0x3a>
20022c40:	3301      	adds	r3, #1
20022c42:	7013      	strb	r3, [r2, #0]
20022c44:	f381 8810 	msr	PRIMASK, r1
20022c48:	2000      	movs	r0, #0
20022c4a:	bd10      	pop	{r4, pc}
20022c4c:	2001      	movs	r0, #1
20022c4e:	e7fc      	b.n	20022c4a <HAL_HPAON_WakeCore+0x46>
20022c50:	500c0000 	.word	0x500c0000
20022c54:	2004cc68 	.word	0x2004cc68

20022c58 <HAL_HPAON_EnableXT48>:
20022c58:	4b04      	ldr	r3, [pc, #16]	@ (20022c6c <HAL_HPAON_EnableXT48+0x14>)
20022c5a:	691a      	ldr	r2, [r3, #16]
20022c5c:	f042 0202 	orr.w	r2, r2, #2
20022c60:	611a      	str	r2, [r3, #16]
20022c62:	691a      	ldr	r2, [r3, #16]
20022c64:	2a00      	cmp	r2, #0
20022c66:	dafc      	bge.n	20022c62 <HAL_HPAON_EnableXT48+0xa>
20022c68:	4770      	bx	lr
20022c6a:	bf00      	nop
20022c6c:	500c0000 	.word	0x500c0000

20022c70 <HAL_HPAON_DisableXT48>:
20022c70:	4a02      	ldr	r2, [pc, #8]	@ (20022c7c <HAL_HPAON_DisableXT48+0xc>)
20022c72:	6913      	ldr	r3, [r2, #16]
20022c74:	f023 0302 	bic.w	r3, r3, #2
20022c78:	6113      	str	r3, [r2, #16]
20022c7a:	4770      	bx	lr
20022c7c:	500c0000 	.word	0x500c0000

20022c80 <HAL_QSPI_Init>:
20022c80:	b510      	push	{r4, lr}
20022c82:	b1e0      	cbz	r0, 20022cbe <HAL_QSPI_Init+0x3e>
20022c84:	b1d9      	cbz	r1, 20022cbe <HAL_QSPI_Init+0x3e>
20022c86:	2300      	movs	r3, #0
20022c88:	2201      	movs	r2, #1
20022c8a:	6043      	str	r3, [r0, #4]
20022c8c:	f880 202a 	strb.w	r2, [r0, #42]	@ 0x2a
20022c90:	680c      	ldr	r4, [r1, #0]
20022c92:	6004      	str	r4, [r0, #0]
20022c94:	684a      	ldr	r2, [r1, #4]
20022c96:	f880 2028 	strb.w	r2, [r0, #40]	@ 0x28
20022c9a:	688a      	ldr	r2, [r1, #8]
20022c9c:	6102      	str	r2, [r0, #16]
20022c9e:	68ca      	ldr	r2, [r1, #12]
20022ca0:	0512      	lsls	r2, r2, #20
20022ca2:	6142      	str	r2, [r0, #20]
20022ca4:	22ff      	movs	r2, #255	@ 0xff
20022ca6:	f8c4 2084 	str.w	r2, [r4, #132]	@ 0x84
20022caa:	f04f 2450 	mov.w	r4, #1342197760	@ 0x50005000
20022cae:	6801      	ldr	r1, [r0, #0]
20022cb0:	678c      	str	r4, [r1, #120]	@ 0x78
20022cb2:	6801      	ldr	r1, [r0, #0]
20022cb4:	620a      	str	r2, [r1, #32]
20022cb6:	6801      	ldr	r1, [r0, #0]
20022cb8:	4618      	mov	r0, r3
20022cba:	644a      	str	r2, [r1, #68]	@ 0x44
20022cbc:	bd10      	pop	{r4, pc}
20022cbe:	2001      	movs	r0, #1
20022cc0:	e7fc      	b.n	20022cbc <HAL_QSPI_Init+0x3c>

20022cc2 <HAL_FLASH_SET_AHB_RCMD>:
20022cc2:	b138      	cbz	r0, 20022cd4 <HAL_FLASH_SET_AHB_RCMD+0x12>
20022cc4:	6802      	ldr	r2, [r0, #0]
20022cc6:	2000      	movs	r0, #0
20022cc8:	6c13      	ldr	r3, [r2, #64]	@ 0x40
20022cca:	f023 03ff 	bic.w	r3, r3, #255	@ 0xff
20022cce:	4319      	orrs	r1, r3
20022cd0:	6411      	str	r1, [r2, #64]	@ 0x40
20022cd2:	4770      	bx	lr
20022cd4:	2001      	movs	r0, #1
20022cd6:	4770      	bx	lr

20022cd8 <HAL_FLASH_CFG_AHB_RCMD>:
20022cd8:	b570      	push	{r4, r5, r6, lr}
20022cda:	b1c8      	cbz	r0, 20022d10 <HAL_FLASH_CFG_AHB_RCMD+0x38>
20022cdc:	6805      	ldr	r5, [r0, #0]
20022cde:	f99d 6018 	ldrsb.w	r6, [sp, #24]
20022ce2:	f99d 001c 	ldrsb.w	r0, [sp, #28]
20022ce6:	6cac      	ldr	r4, [r5, #72]	@ 0x48
20022ce8:	ea40 00c6 	orr.w	r0, r0, r6, lsl #3
20022cec:	ea40 23c3 	orr.w	r3, r0, r3, lsl #11
20022cf0:	f99d 0010 	ldrsb.w	r0, [sp, #16]
20022cf4:	f36f 0414 	bfc	r4, #0, #21
20022cf8:	ea43 2300 	orr.w	r3, r3, r0, lsl #8
20022cfc:	f99d 0014 	ldrsb.w	r0, [sp, #20]
20022d00:	ea43 1380 	orr.w	r3, r3, r0, lsl #6
20022d04:	ea43 3242 	orr.w	r2, r3, r2, lsl #13
20022d08:	ea42 4181 	orr.w	r1, r2, r1, lsl #18
20022d0c:	4321      	orrs	r1, r4
20022d0e:	64a9      	str	r1, [r5, #72]	@ 0x48
20022d10:	bd70      	pop	{r4, r5, r6, pc}

20022d12 <HAL_FLASH_SET_AHB_WCMD>:
20022d12:	b140      	cbz	r0, 20022d26 <HAL_FLASH_SET_AHB_WCMD+0x14>
20022d14:	6802      	ldr	r2, [r0, #0]
20022d16:	2000      	movs	r0, #0
20022d18:	6c13      	ldr	r3, [r2, #64]	@ 0x40
20022d1a:	f423 437f 	bic.w	r3, r3, #65280	@ 0xff00
20022d1e:	ea43 2101 	orr.w	r1, r3, r1, lsl #8
20022d22:	6411      	str	r1, [r2, #64]	@ 0x40
20022d24:	4770      	bx	lr
20022d26:	2001      	movs	r0, #1
20022d28:	4770      	bx	lr

20022d2a <HAL_FLASH_CFG_AHB_WCMD>:
20022d2a:	b570      	push	{r4, r5, r6, lr}
20022d2c:	b1c8      	cbz	r0, 20022d62 <HAL_FLASH_CFG_AHB_WCMD+0x38>
20022d2e:	6805      	ldr	r5, [r0, #0]
20022d30:	f99d 6018 	ldrsb.w	r6, [sp, #24]
20022d34:	f99d 001c 	ldrsb.w	r0, [sp, #28]
20022d38:	6d2c      	ldr	r4, [r5, #80]	@ 0x50
20022d3a:	ea40 00c6 	orr.w	r0, r0, r6, lsl #3
20022d3e:	ea40 23c3 	orr.w	r3, r0, r3, lsl #11
20022d42:	f99d 0010 	ldrsb.w	r0, [sp, #16]
20022d46:	f36f 0414 	bfc	r4, #0, #21
20022d4a:	ea43 2300 	orr.w	r3, r3, r0, lsl #8
20022d4e:	f99d 0014 	ldrsb.w	r0, [sp, #20]
20022d52:	ea43 1380 	orr.w	r3, r3, r0, lsl #6
20022d56:	ea43 3242 	orr.w	r2, r3, r2, lsl #13
20022d5a:	ea42 4181 	orr.w	r1, r2, r1, lsl #18
20022d5e:	4321      	orrs	r1, r4
20022d60:	6529      	str	r1, [r5, #80]	@ 0x50
20022d62:	bd70      	pop	{r4, r5, r6, pc}

20022d64 <HAL_FLASH_WRITE_WORD>:
20022d64:	b118      	cbz	r0, 20022d6e <HAL_FLASH_WRITE_WORD+0xa>
20022d66:	6803      	ldr	r3, [r0, #0]
20022d68:	2000      	movs	r0, #0
20022d6a:	6059      	str	r1, [r3, #4]
20022d6c:	4770      	bx	lr
20022d6e:	2001      	movs	r0, #1
20022d70:	4770      	bx	lr

20022d72 <HAL_FLASH_WRITE_DLEN>:
20022d72:	b130      	cbz	r0, 20022d82 <HAL_FLASH_WRITE_DLEN+0x10>
20022d74:	6803      	ldr	r3, [r0, #0]
20022d76:	3901      	subs	r1, #1
20022d78:	f3c1 0113 	ubfx	r1, r1, #0, #20
20022d7c:	2000      	movs	r0, #0
20022d7e:	6259      	str	r1, [r3, #36]	@ 0x24
20022d80:	4770      	bx	lr
20022d82:	2001      	movs	r0, #1
20022d84:	4770      	bx	lr

20022d86 <HAL_FLASH_WRITE_DLEN2>:
20022d86:	b130      	cbz	r0, 20022d96 <HAL_FLASH_WRITE_DLEN2+0x10>
20022d88:	6803      	ldr	r3, [r0, #0]
20022d8a:	3901      	subs	r1, #1
20022d8c:	f3c1 0113 	ubfx	r1, r1, #0, #20
20022d90:	2000      	movs	r0, #0
20022d92:	6399      	str	r1, [r3, #56]	@ 0x38
20022d94:	4770      	bx	lr
20022d96:	2001      	movs	r0, #1
20022d98:	4770      	bx	lr

20022d9a <HAL_FLASH_WRITE_ABYTE>:
20022d9a:	b108      	cbz	r0, 20022da0 <HAL_FLASH_WRITE_ABYTE+0x6>
20022d9c:	6803      	ldr	r3, [r0, #0]
20022d9e:	6219      	str	r1, [r3, #32]
20022da0:	4770      	bx	lr

20022da2 <HAL_FLASH_IS_CMD_DONE>:
20022da2:	b118      	cbz	r0, 20022dac <HAL_FLASH_IS_CMD_DONE+0xa>
20022da4:	6803      	ldr	r3, [r0, #0]
20022da6:	6918      	ldr	r0, [r3, #16]
20022da8:	f000 0001 	and.w	r0, r0, #1
20022dac:	4770      	bx	lr

20022dae <HAL_FLASH_CLR_CMD_DONE>:
20022dae:	b120      	cbz	r0, 20022dba <HAL_FLASH_CLR_CMD_DONE+0xc>
20022db0:	6802      	ldr	r2, [r0, #0]
20022db2:	6953      	ldr	r3, [r2, #20]
20022db4:	f043 0301 	orr.w	r3, r3, #1
20022db8:	6153      	str	r3, [r2, #20]
20022dba:	4770      	bx	lr

20022dbc <HAL_FLASH_SET_CMD>:
20022dbc:	b538      	push	{r3, r4, r5, lr}
20022dbe:	460d      	mov	r5, r1
20022dc0:	4604      	mov	r4, r0
20022dc2:	b1a8      	cbz	r0, 20022df0 <HAL_FLASH_SET_CMD+0x34>
20022dc4:	6803      	ldr	r3, [r0, #0]
20022dc6:	61da      	str	r2, [r3, #28]
20022dc8:	6b43      	ldr	r3, [r0, #52]	@ 0x34
20022dca:	b10b      	cbz	r3, 20022dd0 <HAL_FLASH_SET_CMD+0x14>
20022dcc:	2001      	movs	r0, #1
20022dce:	4798      	blx	r3
20022dd0:	6823      	ldr	r3, [r4, #0]
20022dd2:	619d      	str	r5, [r3, #24]
20022dd4:	4620      	mov	r0, r4
20022dd6:	f7ff ffe4 	bl	20022da2 <HAL_FLASH_IS_CMD_DONE>
20022dda:	2800      	cmp	r0, #0
20022ddc:	d0fa      	beq.n	20022dd4 <HAL_FLASH_SET_CMD+0x18>
20022dde:	4620      	mov	r0, r4
20022de0:	f7ff ffe5 	bl	20022dae <HAL_FLASH_CLR_CMD_DONE>
20022de4:	6b63      	ldr	r3, [r4, #52]	@ 0x34
20022de6:	b10b      	cbz	r3, 20022dec <HAL_FLASH_SET_CMD+0x30>
20022de8:	2000      	movs	r0, #0
20022dea:	4798      	blx	r3
20022dec:	2000      	movs	r0, #0
20022dee:	bd38      	pop	{r3, r4, r5, pc}
20022df0:	2001      	movs	r0, #1
20022df2:	e7fc      	b.n	20022dee <HAL_FLASH_SET_CMD+0x32>

20022df4 <HAL_FLASH_CLR_STATUS>:
20022df4:	b118      	cbz	r0, 20022dfe <HAL_FLASH_CLR_STATUS+0xa>
20022df6:	6802      	ldr	r2, [r0, #0]
20022df8:	6953      	ldr	r3, [r2, #20]
20022dfa:	4319      	orrs	r1, r3
20022dfc:	6151      	str	r1, [r2, #20]
20022dfe:	4770      	bx	lr

20022e00 <HAL_FLASH_STATUS_MATCH>:
20022e00:	b118      	cbz	r0, 20022e0a <HAL_FLASH_STATUS_MATCH+0xa>
20022e02:	6803      	ldr	r3, [r0, #0]
20022e04:	6918      	ldr	r0, [r3, #16]
20022e06:	f3c0 00c0 	ubfx	r0, r0, #3, #1
20022e0a:	4770      	bx	lr

20022e0c <HAL_FLASH_IS_PROG_DONE>:
20022e0c:	b128      	cbz	r0, 20022e1a <HAL_FLASH_IS_PROG_DONE+0xe>
20022e0e:	6803      	ldr	r3, [r0, #0]
20022e10:	6858      	ldr	r0, [r3, #4]
20022e12:	43c0      	mvns	r0, r0
20022e14:	f000 0001 	and.w	r0, r0, #1
20022e18:	4770      	bx	lr
20022e1a:	2001      	movs	r0, #1
20022e1c:	4770      	bx	lr

20022e1e <HAL_FLASH_READ32>:
20022e1e:	b108      	cbz	r0, 20022e24 <HAL_FLASH_READ32+0x6>
20022e20:	6803      	ldr	r3, [r0, #0]
20022e22:	6858      	ldr	r0, [r3, #4]
20022e24:	4770      	bx	lr

20022e26 <HAL_FLASH_SET_TXSLOT>:
20022e26:	b120      	cbz	r0, 20022e32 <HAL_FLASH_SET_TXSLOT+0xc>
20022e28:	6802      	ldr	r2, [r0, #0]
20022e2a:	6d53      	ldr	r3, [r2, #84]	@ 0x54
20022e2c:	f361 238e 	bfi	r3, r1, #10, #5
20022e30:	6553      	str	r3, [r2, #84]	@ 0x54
20022e32:	4770      	bx	lr

20022e34 <HAL_FLASH_SET_CLK_rom>:
20022e34:	b108      	cbz	r0, 20022e3a <HAL_FLASH_SET_CLK_rom+0x6>
20022e36:	6803      	ldr	r3, [r0, #0]
20022e38:	60d9      	str	r1, [r3, #12]
20022e3a:	4770      	bx	lr

20022e3c <HAL_FLASH_GET_DIV>:
20022e3c:	b110      	cbz	r0, 20022e44 <HAL_FLASH_GET_DIV+0x8>
20022e3e:	6803      	ldr	r3, [r0, #0]
20022e40:	68d8      	ldr	r0, [r3, #12]
20022e42:	b2c0      	uxtb	r0, r0
20022e44:	4770      	bx	lr

20022e46 <HAL_FLASH_MANUAL_CMD>:
20022e46:	b570      	push	{r4, r5, r6, lr}
20022e48:	b1e8      	cbz	r0, 20022e86 <HAL_FLASH_MANUAL_CMD+0x40>
20022e4a:	6805      	ldr	r5, [r0, #0]
20022e4c:	f99d 601c 	ldrsb.w	r6, [sp, #28]
20022e50:	f99d 0020 	ldrsb.w	r0, [sp, #32]
20022e54:	6aac      	ldr	r4, [r5, #40]	@ 0x28
20022e56:	ea40 00c6 	orr.w	r0, r0, r6, lsl #3
20022e5a:	f99d 6010 	ldrsb.w	r6, [sp, #16]
20022e5e:	f36f 0415 	bfc	r4, #0, #22
20022e62:	ea40 20c6 	orr.w	r0, r0, r6, lsl #11
20022e66:	f99d 6014 	ldrsb.w	r6, [sp, #20]
20022e6a:	ea40 2006 	orr.w	r0, r0, r6, lsl #8
20022e6e:	f99d 6018 	ldrsb.w	r6, [sp, #24]
20022e72:	ea40 1086 	orr.w	r0, r0, r6, lsl #6
20022e76:	ea40 3343 	orr.w	r3, r0, r3, lsl #13
20022e7a:	ea43 4282 	orr.w	r2, r3, r2, lsl #18
20022e7e:	ea42 5141 	orr.w	r1, r2, r1, lsl #21
20022e82:	4321      	orrs	r1, r4
20022e84:	62a9      	str	r1, [r5, #40]	@ 0x28
20022e86:	bd70      	pop	{r4, r5, r6, pc}

20022e88 <HAL_FLASH_MANUAL_CMD2>:
20022e88:	b570      	push	{r4, r5, r6, lr}
20022e8a:	b1e8      	cbz	r0, 20022ec8 <HAL_FLASH_MANUAL_CMD2+0x40>
20022e8c:	6805      	ldr	r5, [r0, #0]
20022e8e:	f99d 601c 	ldrsb.w	r6, [sp, #28]
20022e92:	f99d 0020 	ldrsb.w	r0, [sp, #32]
20022e96:	6bec      	ldr	r4, [r5, #60]	@ 0x3c
20022e98:	ea40 00c6 	orr.w	r0, r0, r6, lsl #3
20022e9c:	f99d 6010 	ldrsb.w	r6, [sp, #16]
20022ea0:	f36f 0415 	bfc	r4, #0, #22
20022ea4:	ea40 20c6 	orr.w	r0, r0, r6, lsl #11
20022ea8:	f99d 6014 	ldrsb.w	r6, [sp, #20]
20022eac:	ea40 2006 	orr.w	r0, r0, r6, lsl #8
20022eb0:	f99d 6018 	ldrsb.w	r6, [sp, #24]
20022eb4:	ea40 1086 	orr.w	r0, r0, r6, lsl #6
20022eb8:	ea40 3343 	orr.w	r3, r0, r3, lsl #13
20022ebc:	ea43 4282 	orr.w	r2, r3, r2, lsl #18
20022ec0:	ea42 5141 	orr.w	r1, r2, r1, lsl #21
20022ec4:	4321      	orrs	r1, r4
20022ec6:	63e9      	str	r1, [r5, #60]	@ 0x3c
20022ec8:	bd70      	pop	{r4, r5, r6, pc}
	...

20022ecc <HAL_FLASH_SET_ALIAS_RANGE>:
20022ecc:	b510      	push	{r4, lr}
20022ece:	b158      	cbz	r0, 20022ee8 <HAL_FLASH_SET_ALIAS_RANGE+0x1c>
20022ed0:	4b06      	ldr	r3, [pc, #24]	@ (20022eec <HAL_FLASH_SET_ALIAS_RANGE+0x20>)
20022ed2:	6804      	ldr	r4, [r0, #0]
20022ed4:	f202 32ff 	addw	r2, r2, #1023	@ 0x3ff
20022ed8:	440a      	add	r2, r1
20022eda:	4019      	ands	r1, r3
20022edc:	66e1      	str	r1, [r4, #108]	@ 0x6c
20022ede:	401a      	ands	r2, r3
20022ee0:	6803      	ldr	r3, [r0, #0]
20022ee2:	2000      	movs	r0, #0
20022ee4:	671a      	str	r2, [r3, #112]	@ 0x70
20022ee6:	bd10      	pop	{r4, pc}
20022ee8:	2001      	movs	r0, #1
20022eea:	e7fc      	b.n	20022ee6 <HAL_FLASH_SET_ALIAS_RANGE+0x1a>
20022eec:	fffffc00 	.word	0xfffffc00

20022ef0 <HAL_FLASH_SET_ALIAS_OFFSET>:
20022ef0:	b128      	cbz	r0, 20022efe <HAL_FLASH_SET_ALIAS_OFFSET+0xe>
20022ef2:	6803      	ldr	r3, [r0, #0]
20022ef4:	f36f 0109 	bfc	r1, #0, #10
20022ef8:	2000      	movs	r0, #0
20022efa:	6759      	str	r1, [r3, #116]	@ 0x74
20022efc:	4770      	bx	lr
20022efe:	2001      	movs	r0, #1
20022f00:	4770      	bx	lr
	...

20022f04 <HAL_FLASH_SET_CTR>:
20022f04:	b510      	push	{r4, lr}
20022f06:	b150      	cbz	r0, 20022f1e <HAL_FLASH_SET_CTR+0x1a>
20022f08:	4b06      	ldr	r3, [pc, #24]	@ (20022f24 <HAL_FLASH_SET_CTR+0x20>)
20022f0a:	6804      	ldr	r4, [r0, #0]
20022f0c:	4019      	ands	r1, r3
20022f0e:	65e1      	str	r1, [r4, #92]	@ 0x5c
20022f10:	6801      	ldr	r1, [r0, #0]
20022f12:	2000      	movs	r0, #0
20022f14:	f202 32ff 	addw	r2, r2, #1023	@ 0x3ff
20022f18:	401a      	ands	r2, r3
20022f1a:	660a      	str	r2, [r1, #96]	@ 0x60
20022f1c:	bd10      	pop	{r4, pc}
20022f1e:	2001      	movs	r0, #1
20022f20:	e7fc      	b.n	20022f1c <HAL_FLASH_SET_CTR+0x18>
20022f22:	bf00      	nop
20022f24:	fffffc00 	.word	0xfffffc00

20022f28 <HAL_FLASH_SET_NONCE>:
20022f28:	b150      	cbz	r0, 20022f40 <HAL_FLASH_SET_NONCE+0x18>
20022f2a:	b149      	cbz	r1, 20022f40 <HAL_FLASH_SET_NONCE+0x18>
20022f2c:	680b      	ldr	r3, [r1, #0]
20022f2e:	6802      	ldr	r2, [r0, #0]
20022f30:	ba1b      	rev	r3, r3
20022f32:	6653      	str	r3, [r2, #100]	@ 0x64
20022f34:	684b      	ldr	r3, [r1, #4]
20022f36:	6802      	ldr	r2, [r0, #0]
20022f38:	ba1b      	rev	r3, r3
20022f3a:	2000      	movs	r0, #0
20022f3c:	6693      	str	r3, [r2, #104]	@ 0x68
20022f3e:	4770      	bx	lr
20022f40:	2001      	movs	r0, #1
20022f42:	4770      	bx	lr

20022f44 <HAL_FLASH_SET_AES>:
20022f44:	b158      	cbz	r0, 20022f5e <HAL_FLASH_SET_AES+0x1a>
20022f46:	6803      	ldr	r3, [r0, #0]
20022f48:	2901      	cmp	r1, #1
20022f4a:	681a      	ldr	r2, [r3, #0]
20022f4c:	d104      	bne.n	20022f58 <HAL_FLASH_SET_AES+0x14>
20022f4e:	f042 0280 	orr.w	r2, r2, #128	@ 0x80
20022f52:	2000      	movs	r0, #0
20022f54:	601a      	str	r2, [r3, #0]
20022f56:	4770      	bx	lr
20022f58:	f022 0280 	bic.w	r2, r2, #128	@ 0x80
20022f5c:	e7f9      	b.n	20022f52 <HAL_FLASH_SET_AES+0xe>
20022f5e:	2001      	movs	r0, #1
20022f60:	4770      	bx	lr

20022f62 <HAL_FLASH_ENABLE_AES>:
20022f62:	b150      	cbz	r0, 20022f7a <HAL_FLASH_ENABLE_AES+0x18>
20022f64:	6803      	ldr	r3, [r0, #0]
20022f66:	681a      	ldr	r2, [r3, #0]
20022f68:	b121      	cbz	r1, 20022f74 <HAL_FLASH_ENABLE_AES+0x12>
20022f6a:	f042 0240 	orr.w	r2, r2, #64	@ 0x40
20022f6e:	2000      	movs	r0, #0
20022f70:	601a      	str	r2, [r3, #0]
20022f72:	4770      	bx	lr
20022f74:	f022 0240 	bic.w	r2, r2, #64	@ 0x40
20022f78:	e7f9      	b.n	20022f6e <HAL_FLASH_ENABLE_AES+0xc>
20022f7a:	2001      	movs	r0, #1
20022f7c:	4770      	bx	lr

20022f7e <HAL_FLASH_ENABLE_QSPI>:
20022f7e:	b150      	cbz	r0, 20022f96 <HAL_FLASH_ENABLE_QSPI+0x18>
20022f80:	6803      	ldr	r3, [r0, #0]
20022f82:	681a      	ldr	r2, [r3, #0]
20022f84:	b121      	cbz	r1, 20022f90 <HAL_FLASH_ENABLE_QSPI+0x12>
20022f86:	f042 0201 	orr.w	r2, r2, #1
20022f8a:	2000      	movs	r0, #0
20022f8c:	601a      	str	r2, [r3, #0]
20022f8e:	4770      	bx	lr
20022f90:	f022 0201 	bic.w	r2, r2, #1
20022f94:	e7f9      	b.n	20022f8a <HAL_FLASH_ENABLE_QSPI+0xc>
20022f96:	2001      	movs	r0, #1
20022f98:	4770      	bx	lr

20022f9a <HAL_FLASH_ENABLE_OPI>:
20022f9a:	b150      	cbz	r0, 20022fb2 <HAL_FLASH_ENABLE_OPI+0x18>
20022f9c:	6803      	ldr	r3, [r0, #0]
20022f9e:	681a      	ldr	r2, [r3, #0]
20022fa0:	b121      	cbz	r1, 20022fac <HAL_FLASH_ENABLE_OPI+0x12>
20022fa2:	f442 1200 	orr.w	r2, r2, #2097152	@ 0x200000
20022fa6:	2000      	movs	r0, #0
20022fa8:	601a      	str	r2, [r3, #0]
20022faa:	4770      	bx	lr
20022fac:	f422 1200 	bic.w	r2, r2, #2097152	@ 0x200000
20022fb0:	e7f9      	b.n	20022fa6 <HAL_FLASH_ENABLE_OPI+0xc>
20022fb2:	2001      	movs	r0, #1
20022fb4:	4770      	bx	lr

20022fb6 <HAL_FLASH_ENABLE_HYPER>:
20022fb6:	b150      	cbz	r0, 20022fce <HAL_FLASH_ENABLE_HYPER+0x18>
20022fb8:	6803      	ldr	r3, [r0, #0]
20022fba:	689a      	ldr	r2, [r3, #8]
20022fbc:	b121      	cbz	r1, 20022fc8 <HAL_FLASH_ENABLE_HYPER+0x12>
20022fbe:	f042 0210 	orr.w	r2, r2, #16
20022fc2:	2000      	movs	r0, #0
20022fc4:	609a      	str	r2, [r3, #8]
20022fc6:	4770      	bx	lr
20022fc8:	f022 0210 	bic.w	r2, r2, #16
20022fcc:	e7f9      	b.n	20022fc2 <HAL_FLASH_ENABLE_HYPER+0xc>
20022fce:	2001      	movs	r0, #1
20022fd0:	4770      	bx	lr

20022fd2 <HAL_FLASH_ENABLE_CMD2>:
20022fd2:	b150      	cbz	r0, 20022fea <HAL_FLASH_ENABLE_CMD2+0x18>
20022fd4:	6803      	ldr	r3, [r0, #0]
20022fd6:	681a      	ldr	r2, [r3, #0]
20022fd8:	b121      	cbz	r1, 20022fe4 <HAL_FLASH_ENABLE_CMD2+0x12>
20022fda:	f442 3280 	orr.w	r2, r2, #65536	@ 0x10000
20022fde:	2000      	movs	r0, #0
20022fe0:	601a      	str	r2, [r3, #0]
20022fe2:	4770      	bx	lr
20022fe4:	f422 3280 	bic.w	r2, r2, #65536	@ 0x10000
20022fe8:	e7f9      	b.n	20022fde <HAL_FLASH_ENABLE_CMD2+0xc>
20022fea:	2001      	movs	r0, #1
20022fec:	4770      	bx	lr

20022fee <HAL_FLASH_STAUS_MATCH_CMD2>:
20022fee:	b150      	cbz	r0, 20023006 <HAL_FLASH_STAUS_MATCH_CMD2+0x18>
20022ff0:	6803      	ldr	r3, [r0, #0]
20022ff2:	681a      	ldr	r2, [r3, #0]
20022ff4:	b121      	cbz	r1, 20023000 <HAL_FLASH_STAUS_MATCH_CMD2+0x12>
20022ff6:	f442 2280 	orr.w	r2, r2, #262144	@ 0x40000
20022ffa:	2000      	movs	r0, #0
20022ffc:	601a      	str	r2, [r3, #0]
20022ffe:	4770      	bx	lr
20023000:	f422 2280 	bic.w	r2, r2, #262144	@ 0x40000
20023004:	e7f9      	b.n	20022ffa <HAL_FLASH_STAUS_MATCH_CMD2+0xc>
20023006:	2001      	movs	r0, #1
20023008:	4770      	bx	lr

2002300a <HAL_FLASH_SET_CS_TIME>:
2002300a:	b530      	push	{r4, r5, lr}
2002300c:	b180      	cbz	r0, 20023030 <HAL_FLASH_SET_CS_TIME+0x26>
2002300e:	6805      	ldr	r5, [r0, #0]
20023010:	f8bd 000c 	ldrh.w	r0, [sp, #12]
20023014:	68ac      	ldr	r4, [r5, #8]
20023016:	0680      	lsls	r0, r0, #26
20023018:	ea40 5383 	orr.w	r3, r0, r3, lsl #22
2002301c:	2000      	movs	r0, #0
2002301e:	ea43 4181 	orr.w	r1, r3, r1, lsl #18
20023022:	f36f 149e 	bfc	r4, #6, #25
20023026:	ea41 1282 	orr.w	r2, r1, r2, lsl #6
2002302a:	4322      	orrs	r2, r4
2002302c:	60aa      	str	r2, [r5, #8]
2002302e:	bd30      	pop	{r4, r5, pc}
20023030:	2001      	movs	r0, #1
20023032:	e7fc      	b.n	2002302e <HAL_FLASH_SET_CS_TIME+0x24>

20023034 <HAL_FLASH_SET_ROW_BOUNDARY>:
20023034:	b130      	cbz	r0, 20023044 <HAL_FLASH_SET_ROW_BOUNDARY+0x10>
20023036:	6802      	ldr	r2, [r0, #0]
20023038:	2000      	movs	r0, #0
2002303a:	6893      	ldr	r3, [r2, #8]
2002303c:	f361 0302 	bfi	r3, r1, #0, #3
20023040:	6093      	str	r3, [r2, #8]
20023042:	4770      	bx	lr
20023044:	2001      	movs	r0, #1
20023046:	4770      	bx	lr

20023048 <HAL_FLASH_SET_LEGACY>:
20023048:	b150      	cbz	r0, 20023060 <HAL_FLASH_SET_LEGACY+0x18>
2002304a:	6803      	ldr	r3, [r0, #0]
2002304c:	689a      	ldr	r2, [r3, #8]
2002304e:	b121      	cbz	r1, 2002305a <HAL_FLASH_SET_LEGACY+0x12>
20023050:	f042 0220 	orr.w	r2, r2, #32
20023054:	2000      	movs	r0, #0
20023056:	609a      	str	r2, [r3, #8]
20023058:	4770      	bx	lr
2002305a:	f022 0220 	bic.w	r2, r2, #32
2002305e:	e7f9      	b.n	20023054 <HAL_FLASH_SET_LEGACY+0xc>
20023060:	2001      	movs	r0, #1
20023062:	4770      	bx	lr

20023064 <HAL_FLASH_SET_DUAL_MODE>:
20023064:	b150      	cbz	r0, 2002307c <HAL_FLASH_SET_DUAL_MODE+0x18>
20023066:	6803      	ldr	r3, [r0, #0]
20023068:	681a      	ldr	r2, [r3, #0]
2002306a:	b121      	cbz	r1, 20023076 <HAL_FLASH_SET_DUAL_MODE+0x12>
2002306c:	f042 7280 	orr.w	r2, r2, #16777216	@ 0x1000000
20023070:	2000      	movs	r0, #0
20023072:	601a      	str	r2, [r3, #0]
20023074:	4770      	bx	lr
20023076:	f022 7280 	bic.w	r2, r2, #16777216	@ 0x1000000
2002307a:	e7f9      	b.n	20023070 <HAL_FLASH_SET_DUAL_MODE+0xc>
2002307c:	2001      	movs	r0, #1
2002307e:	4770      	bx	lr

20023080 <HAL_MPI_EN_FIXLAT>:
20023080:	b150      	cbz	r0, 20023098 <HAL_MPI_EN_FIXLAT+0x18>
20023082:	6803      	ldr	r3, [r0, #0]
20023084:	689a      	ldr	r2, [r3, #8]
20023086:	b121      	cbz	r1, 20023092 <HAL_MPI_EN_FIXLAT+0x12>
20023088:	f042 4200 	orr.w	r2, r2, #2147483648	@ 0x80000000
2002308c:	2000      	movs	r0, #0
2002308e:	609a      	str	r2, [r3, #8]
20023090:	4770      	bx	lr
20023092:	f022 4200 	bic.w	r2, r2, #2147483648	@ 0x80000000
20023096:	e7f9      	b.n	2002308c <HAL_MPI_EN_FIXLAT+0xc>
20023098:	2001      	movs	r0, #1
2002309a:	4770      	bx	lr

2002309c <HAL_MPI_ENABLE_DQS>:
2002309c:	b150      	cbz	r0, 200230b4 <HAL_MPI_ENABLE_DQS+0x18>
2002309e:	6803      	ldr	r3, [r0, #0]
200230a0:	689a      	ldr	r2, [r3, #8]
200230a2:	b121      	cbz	r1, 200230ae <HAL_MPI_ENABLE_DQS+0x12>
200230a4:	f042 0208 	orr.w	r2, r2, #8
200230a8:	2000      	movs	r0, #0
200230aa:	609a      	str	r2, [r3, #8]
200230ac:	4770      	bx	lr
200230ae:	f022 0208 	bic.w	r2, r2, #8
200230b2:	e7f9      	b.n	200230a8 <HAL_MPI_ENABLE_DQS+0xc>
200230b4:	2001      	movs	r0, #1
200230b6:	4770      	bx	lr

200230b8 <HAL_MPI_SET_DQS_DELAY>:
200230b8:	b140      	cbz	r0, 200230cc <HAL_MPI_SET_DQS_DELAY+0x14>
200230ba:	6802      	ldr	r2, [r0, #0]
200230bc:	2000      	movs	r0, #0
200230be:	6d93      	ldr	r3, [r2, #88]	@ 0x58
200230c0:	f423 037f 	bic.w	r3, r3, #16711680	@ 0xff0000
200230c4:	ea43 4101 	orr.w	r1, r3, r1, lsl #16
200230c8:	6591      	str	r1, [r2, #88]	@ 0x58
200230ca:	4770      	bx	lr
200230cc:	2001      	movs	r0, #1
200230ce:	4770      	bx	lr

200230d0 <HAL_MPI_SET_SCK>:
200230d0:	b160      	cbz	r0, 200230ec <HAL_MPI_SET_SCK+0x1c>
200230d2:	6800      	ldr	r0, [r0, #0]
200230d4:	0652      	lsls	r2, r2, #25
200230d6:	6d83      	ldr	r3, [r0, #88]	@ 0x58
200230d8:	ea42 2101 	orr.w	r1, r2, r1, lsl #8
200230dc:	f023 7300 	bic.w	r3, r3, #33554432	@ 0x2000000
200230e0:	f423 437f 	bic.w	r3, r3, #65280	@ 0xff00
200230e4:	4319      	orrs	r1, r3
200230e6:	6581      	str	r1, [r0, #88]	@ 0x58
200230e8:	2000      	movs	r0, #0
200230ea:	4770      	bx	lr
200230ec:	2001      	movs	r0, #1
200230ee:	4770      	bx	lr

200230f0 <HAL_MPI_CFG_DTR>:
200230f0:	b510      	push	{r4, lr}
200230f2:	b1f0      	cbz	r0, 20023132 <HAL_MPI_CFG_DTR+0x42>
200230f4:	6804      	ldr	r4, [r0, #0]
200230f6:	6da0      	ldr	r0, [r4, #88]	@ 0x58
200230f8:	b1b1      	cbz	r1, 20023128 <HAL_MPI_CFG_DTR+0x38>
200230fa:	2a02      	cmp	r2, #2
200230fc:	bf84      	itt	hi
200230fe:	3a02      	subhi	r2, #2
20023100:	b2d2      	uxtbhi	r2, r2
20023102:	0213      	lsls	r3, r2, #8
20023104:	f36f 000f 	bfc	r0, #0, #16
20023108:	f403 43fe 	and.w	r3, r3, #32512	@ 0x7f00
2002310c:	4303      	orrs	r3, r0
2002310e:	0612      	lsls	r2, r2, #24
20023110:	bf54      	ite	pl
20023112:	f043 6380 	orrpl.w	r3, r3, #67108864	@ 0x4000000
20023116:	f043 63a0 	orrmi.w	r3, r3, #83886080	@ 0x5000000
2002311a:	f043 030a 	orr.w	r3, r3, #10
2002311e:	f023 7300 	bic.w	r3, r3, #33554432	@ 0x2000000
20023122:	2000      	movs	r0, #0
20023124:	65a3      	str	r3, [r4, #88]	@ 0x58
20023126:	bd10      	pop	{r4, pc}
20023128:	4b03      	ldr	r3, [pc, #12]	@ (20023138 <HAL_MPI_CFG_DTR+0x48>)
2002312a:	4003      	ands	r3, r0
2002312c:	f043 7300 	orr.w	r3, r3, #33554432	@ 0x2000000
20023130:	e7f7      	b.n	20023122 <HAL_MPI_CFG_DTR+0x32>
20023132:	2001      	movs	r0, #1
20023134:	e7f7      	b.n	20023126 <HAL_MPI_CFG_DTR+0x36>
20023136:	bf00      	nop
20023138:	faff0000 	.word	0xfaff0000

2002313c <HAL_MPI_MODIFY_RCMD_DELAY>:
2002313c:	b130      	cbz	r0, 2002314c <HAL_MPI_MODIFY_RCMD_DELAY+0x10>
2002313e:	6802      	ldr	r2, [r0, #0]
20023140:	6c93      	ldr	r3, [r2, #72]	@ 0x48
20023142:	f423 3378 	bic.w	r3, r3, #253952	@ 0x3e000
20023146:	ea43 3141 	orr.w	r1, r3, r1, lsl #13
2002314a:	6491      	str	r1, [r2, #72]	@ 0x48
2002314c:	4770      	bx	lr

2002314e <HAL_MPI_MODIFY_WCMD_DELAY>:
2002314e:	b130      	cbz	r0, 2002315e <HAL_MPI_MODIFY_WCMD_DELAY+0x10>
20023150:	6802      	ldr	r2, [r0, #0]
20023152:	6d13      	ldr	r3, [r2, #80]	@ 0x50
20023154:	f423 3378 	bic.w	r3, r3, #253952	@ 0x3e000
20023158:	ea43 3141 	orr.w	r1, r3, r1, lsl #13
2002315c:	6511      	str	r1, [r2, #80]	@ 0x50
2002315e:	4770      	bx	lr

20023160 <HAL_FLASH_CONFIG_AHB_READ>:
20023160:	b57f      	push	{r0, r1, r2, r3, r4, r5, r6, lr}
20023162:	4605      	mov	r5, r0
20023164:	2800      	cmp	r0, #0
20023166:	d03d      	beq.n	200231e4 <HAL_FLASH_CONFIG_AHB_READ+0x84>
20023168:	68c4      	ldr	r4, [r0, #12]
2002316a:	b301      	cbz	r1, 200231ae <HAL_FLASH_CONFIG_AHB_READ+0x4e>
2002316c:	f894 306a 	ldrb.w	r3, [r4, #106]	@ 0x6a
20023170:	2b00      	cmp	r3, #0
20023172:	d037      	beq.n	200231e4 <HAL_FLASH_CONFIG_AHB_READ+0x84>
20023174:	f994 6072 	ldrsb.w	r6, [r4, #114]	@ 0x72
20023178:	f994 306e 	ldrsb.w	r3, [r4, #110]	@ 0x6e
2002317c:	f994 106c 	ldrsb.w	r1, [r4, #108]	@ 0x6c
20023180:	f994 206d 	ldrsb.w	r2, [r4, #109]	@ 0x6d
20023184:	9603      	str	r6, [sp, #12]
20023186:	f994 6071 	ldrsb.w	r6, [r4, #113]	@ 0x71
2002318a:	9602      	str	r6, [sp, #8]
2002318c:	f994 6070 	ldrsb.w	r6, [r4, #112]	@ 0x70
20023190:	9601      	str	r6, [sp, #4]
20023192:	f994 406f 	ldrsb.w	r4, [r4, #111]	@ 0x6f
20023196:	9400      	str	r4, [sp, #0]
20023198:	f7ff fd9e 	bl	20022cd8 <HAL_FLASH_CFG_AHB_RCMD>
2002319c:	68eb      	ldr	r3, [r5, #12]
2002319e:	f893 106a 	ldrb.w	r1, [r3, #106]	@ 0x6a
200231a2:	4628      	mov	r0, r5
200231a4:	f7ff fd8d 	bl	20022cc2 <HAL_FLASH_SET_AHB_RCMD>
200231a8:	2000      	movs	r0, #0
200231aa:	b004      	add	sp, #16
200231ac:	bd70      	pop	{r4, r5, r6, pc}
200231ae:	f894 3046 	ldrb.w	r3, [r4, #70]	@ 0x46
200231b2:	b1bb      	cbz	r3, 200231e4 <HAL_FLASH_CONFIG_AHB_READ+0x84>
200231b4:	f994 604e 	ldrsb.w	r6, [r4, #78]	@ 0x4e
200231b8:	f994 304a 	ldrsb.w	r3, [r4, #74]	@ 0x4a
200231bc:	f994 1048 	ldrsb.w	r1, [r4, #72]	@ 0x48
200231c0:	f994 2049 	ldrsb.w	r2, [r4, #73]	@ 0x49
200231c4:	9603      	str	r6, [sp, #12]
200231c6:	f994 604d 	ldrsb.w	r6, [r4, #77]	@ 0x4d
200231ca:	9602      	str	r6, [sp, #8]
200231cc:	f994 604c 	ldrsb.w	r6, [r4, #76]	@ 0x4c
200231d0:	9601      	str	r6, [sp, #4]
200231d2:	f994 404b 	ldrsb.w	r4, [r4, #75]	@ 0x4b
200231d6:	9400      	str	r4, [sp, #0]
200231d8:	f7ff fd7e 	bl	20022cd8 <HAL_FLASH_CFG_AHB_RCMD>
200231dc:	68eb      	ldr	r3, [r5, #12]
200231de:	f893 1046 	ldrb.w	r1, [r3, #70]	@ 0x46
200231e2:	e7de      	b.n	200231a2 <HAL_FLASH_CONFIG_AHB_READ+0x42>
200231e4:	2001      	movs	r0, #1
200231e6:	e7e0      	b.n	200231aa <HAL_FLASH_CONFIG_AHB_READ+0x4a>

200231e8 <HAL_FLASH_CONFIG_FULL_AHB_READ>:
200231e8:	b57f      	push	{r0, r1, r2, r3, r4, r5, r6, lr}
200231ea:	4605      	mov	r5, r0
200231ec:	2800      	cmp	r0, #0
200231ee:	d036      	beq.n	2002325e <HAL_FLASH_CONFIG_FULL_AHB_READ+0x76>
200231f0:	68c4      	ldr	r4, [r0, #12]
200231f2:	b1e1      	cbz	r1, 2002322e <HAL_FLASH_CONFIG_FULL_AHB_READ+0x46>
200231f4:	f994 616e 	ldrsb.w	r6, [r4, #366]	@ 0x16e
200231f8:	f994 316a 	ldrsb.w	r3, [r4, #362]	@ 0x16a
200231fc:	f994 1168 	ldrsb.w	r1, [r4, #360]	@ 0x168
20023200:	f994 2169 	ldrsb.w	r2, [r4, #361]	@ 0x169
20023204:	9603      	str	r6, [sp, #12]
20023206:	f994 616d 	ldrsb.w	r6, [r4, #365]	@ 0x16d
2002320a:	9602      	str	r6, [sp, #8]
2002320c:	f994 616c 	ldrsb.w	r6, [r4, #364]	@ 0x16c
20023210:	9601      	str	r6, [sp, #4]
20023212:	f994 416b 	ldrsb.w	r4, [r4, #363]	@ 0x16b
20023216:	9400      	str	r4, [sp, #0]
20023218:	f7ff fd5e 	bl	20022cd8 <HAL_FLASH_CFG_AHB_RCMD>
2002321c:	68eb      	ldr	r3, [r5, #12]
2002321e:	f893 1166 	ldrb.w	r1, [r3, #358]	@ 0x166
20023222:	4628      	mov	r0, r5
20023224:	f7ff fd4d 	bl	20022cc2 <HAL_FLASH_SET_AHB_RCMD>
20023228:	2000      	movs	r0, #0
2002322a:	b004      	add	sp, #16
2002322c:	bd70      	pop	{r4, r5, r6, pc}
2002322e:	f994 615c 	ldrsb.w	r6, [r4, #348]	@ 0x15c
20023232:	f994 3158 	ldrsb.w	r3, [r4, #344]	@ 0x158
20023236:	f994 1156 	ldrsb.w	r1, [r4, #342]	@ 0x156
2002323a:	f994 2157 	ldrsb.w	r2, [r4, #343]	@ 0x157
2002323e:	9603      	str	r6, [sp, #12]
20023240:	f994 615b 	ldrsb.w	r6, [r4, #347]	@ 0x15b
20023244:	9602      	str	r6, [sp, #8]
20023246:	f994 615a 	ldrsb.w	r6, [r4, #346]	@ 0x15a
2002324a:	9601      	str	r6, [sp, #4]
2002324c:	f994 4159 	ldrsb.w	r4, [r4, #345]	@ 0x159
20023250:	9400      	str	r4, [sp, #0]
20023252:	f7ff fd41 	bl	20022cd8 <HAL_FLASH_CFG_AHB_RCMD>
20023256:	68eb      	ldr	r3, [r5, #12]
20023258:	f893 1154 	ldrb.w	r1, [r3, #340]	@ 0x154
2002325c:	e7e1      	b.n	20023222 <HAL_FLASH_CONFIG_FULL_AHB_READ+0x3a>
2002325e:	2001      	movs	r0, #1
20023260:	e7e3      	b.n	2002322a <HAL_FLASH_CONFIG_FULL_AHB_READ+0x42>

20023262 <HAL_FLASH_PRE_CMD>:
20023262:	b530      	push	{r4, r5, lr}
20023264:	68c4      	ldr	r4, [r0, #12]
20023266:	b087      	sub	sp, #28
20023268:	b304      	cbz	r4, 200232ac <HAL_FLASH_PRE_CMD+0x4a>
2002326a:	2938      	cmp	r1, #56	@ 0x38
2002326c:	d81e      	bhi.n	200232ac <HAL_FLASH_PRE_CMD+0x4a>
2002326e:	eb01 01c1 	add.w	r1, r1, r1, lsl #3
20023272:	440c      	add	r4, r1
20023274:	7c23      	ldrb	r3, [r4, #16]
20023276:	b1cb      	cbz	r3, 200232ac <HAL_FLASH_PRE_CMD+0x4a>
20023278:	f994 5018 	ldrsb.w	r5, [r4, #24]
2002327c:	f994 3013 	ldrsb.w	r3, [r4, #19]
20023280:	f994 2012 	ldrsb.w	r2, [r4, #18]
20023284:	f994 1011 	ldrsb.w	r1, [r4, #17]
20023288:	9504      	str	r5, [sp, #16]
2002328a:	f994 5017 	ldrsb.w	r5, [r4, #23]
2002328e:	9503      	str	r5, [sp, #12]
20023290:	f994 5016 	ldrsb.w	r5, [r4, #22]
20023294:	9502      	str	r5, [sp, #8]
20023296:	f994 5015 	ldrsb.w	r5, [r4, #21]
2002329a:	9501      	str	r5, [sp, #4]
2002329c:	f994 4014 	ldrsb.w	r4, [r4, #20]
200232a0:	9400      	str	r4, [sp, #0]
200232a2:	f7ff fdd0 	bl	20022e46 <HAL_FLASH_MANUAL_CMD>
200232a6:	2000      	movs	r0, #0
200232a8:	b007      	add	sp, #28
200232aa:	bd30      	pop	{r4, r5, pc}
200232ac:	2001      	movs	r0, #1
200232ae:	e7fb      	b.n	200232a8 <HAL_FLASH_PRE_CMD+0x46>

200232b0 <HAL_FLASH_ISSUE_CMD>:
200232b0:	b5f0      	push	{r4, r5, r6, r7, lr}
200232b2:	68c4      	ldr	r4, [r0, #12]
200232b4:	4606      	mov	r6, r0
200232b6:	4617      	mov	r7, r2
200232b8:	b087      	sub	sp, #28
200232ba:	b354      	cbz	r4, 20023312 <HAL_FLASH_ISSUE_CMD+0x62>
200232bc:	2938      	cmp	r1, #56	@ 0x38
200232be:	d828      	bhi.n	20023312 <HAL_FLASH_ISSUE_CMD+0x62>
200232c0:	eb01 05c1 	add.w	r5, r1, r1, lsl #3
200232c4:	442c      	add	r4, r5
200232c6:	7c23      	ldrb	r3, [r4, #16]
200232c8:	b31b      	cbz	r3, 20023312 <HAL_FLASH_ISSUE_CMD+0x62>
200232ca:	f994 c018 	ldrsb.w	ip, [r4, #24]
200232ce:	f994 3013 	ldrsb.w	r3, [r4, #19]
200232d2:	f994 2012 	ldrsb.w	r2, [r4, #18]
200232d6:	f994 1011 	ldrsb.w	r1, [r4, #17]
200232da:	f8cd c010 	str.w	ip, [sp, #16]
200232de:	f994 c017 	ldrsb.w	ip, [r4, #23]
200232e2:	f8cd c00c 	str.w	ip, [sp, #12]
200232e6:	f994 c016 	ldrsb.w	ip, [r4, #22]
200232ea:	f8cd c008 	str.w	ip, [sp, #8]
200232ee:	f994 c015 	ldrsb.w	ip, [r4, #21]
200232f2:	f8cd c004 	str.w	ip, [sp, #4]
200232f6:	f994 4014 	ldrsb.w	r4, [r4, #20]
200232fa:	9400      	str	r4, [sp, #0]
200232fc:	f7ff fda3 	bl	20022e46 <HAL_FLASH_MANUAL_CMD>
20023300:	68f3      	ldr	r3, [r6, #12]
20023302:	463a      	mov	r2, r7
20023304:	442b      	add	r3, r5
20023306:	4630      	mov	r0, r6
20023308:	7c19      	ldrb	r1, [r3, #16]
2002330a:	f7ff fd57 	bl	20022dbc <HAL_FLASH_SET_CMD>
2002330e:	b007      	add	sp, #28
20023310:	bdf0      	pop	{r4, r5, r6, r7, pc}
20023312:	2001      	movs	r0, #1
20023314:	e7fb      	b.n	2002330e <HAL_FLASH_ISSUE_CMD+0x5e>

20023316 <HAL_FLASH_ISSUE_CMD_SEQ>:
20023316:	e92d 41f0 	stmdb	sp!, {r4, r5, r6, r7, r8, lr}
2002331a:	4690      	mov	r8, r2
2002331c:	68c2      	ldr	r2, [r0, #12]
2002331e:	4604      	mov	r4, r0
20023320:	b086      	sub	sp, #24
20023322:	2a00      	cmp	r2, #0
20023324:	d072      	beq.n	2002340c <HAL_FLASH_ISSUE_CMD_SEQ+0xf6>
20023326:	2938      	cmp	r1, #56	@ 0x38
20023328:	d870      	bhi.n	2002340c <HAL_FLASH_ISSUE_CMD_SEQ+0xf6>
2002332a:	eb01 07c1 	add.w	r7, r1, r1, lsl #3
2002332e:	19d6      	adds	r6, r2, r7
20023330:	7c31      	ldrb	r1, [r6, #16]
20023332:	2900      	cmp	r1, #0
20023334:	d06a      	beq.n	2002340c <HAL_FLASH_ISSUE_CMD_SEQ+0xf6>
20023336:	2b38      	cmp	r3, #56	@ 0x38
20023338:	d868      	bhi.n	2002340c <HAL_FLASH_ISSUE_CMD_SEQ+0xf6>
2002333a:	eb03 05c3 	add.w	r5, r3, r3, lsl #3
2002333e:	442a      	add	r2, r5
20023340:	7c13      	ldrb	r3, [r2, #16]
20023342:	2b00      	cmp	r3, #0
20023344:	d062      	beq.n	2002340c <HAL_FLASH_ISSUE_CMD_SEQ+0xf6>
20023346:	f996 c018 	ldrsb.w	ip, [r6, #24]
2002334a:	f996 3013 	ldrsb.w	r3, [r6, #19]
2002334e:	f996 2012 	ldrsb.w	r2, [r6, #18]
20023352:	f996 1011 	ldrsb.w	r1, [r6, #17]
20023356:	f8cd c010 	str.w	ip, [sp, #16]
2002335a:	f996 c017 	ldrsb.w	ip, [r6, #23]
2002335e:	f8cd c00c 	str.w	ip, [sp, #12]
20023362:	f996 c016 	ldrsb.w	ip, [r6, #22]
20023366:	f8cd c008 	str.w	ip, [sp, #8]
2002336a:	f996 c015 	ldrsb.w	ip, [r6, #21]
2002336e:	f8cd c004 	str.w	ip, [sp, #4]
20023372:	f996 6014 	ldrsb.w	r6, [r6, #20]
20023376:	9600      	str	r6, [sp, #0]
20023378:	f7ff fd65 	bl	20022e46 <HAL_FLASH_MANUAL_CMD>
2002337c:	68e0      	ldr	r0, [r4, #12]
2002337e:	4428      	add	r0, r5
20023380:	f990 6018 	ldrsb.w	r6, [r0, #24]
20023384:	f990 3013 	ldrsb.w	r3, [r0, #19]
20023388:	f990 2012 	ldrsb.w	r2, [r0, #18]
2002338c:	f990 1011 	ldrsb.w	r1, [r0, #17]
20023390:	9604      	str	r6, [sp, #16]
20023392:	f990 6017 	ldrsb.w	r6, [r0, #23]
20023396:	9603      	str	r6, [sp, #12]
20023398:	f990 6016 	ldrsb.w	r6, [r0, #22]
2002339c:	9602      	str	r6, [sp, #8]
2002339e:	f990 6015 	ldrsb.w	r6, [r0, #21]
200233a2:	9601      	str	r6, [sp, #4]
200233a4:	f990 0014 	ldrsb.w	r0, [r0, #20]
200233a8:	9000      	str	r0, [sp, #0]
200233aa:	4620      	mov	r0, r4
200233ac:	f7ff fd6c 	bl	20022e88 <HAL_FLASH_MANUAL_CMD2>
200233b0:	2200      	movs	r2, #0
200233b2:	6823      	ldr	r3, [r4, #0]
200233b4:	2101      	movs	r1, #1
200233b6:	67da      	str	r2, [r3, #124]	@ 0x7c
200233b8:	68e3      	ldr	r3, [r4, #12]
200233ba:	6822      	ldr	r2, [r4, #0]
200233bc:	442b      	add	r3, r5
200233be:	7c1b      	ldrb	r3, [r3, #16]
200233c0:	4620      	mov	r0, r4
200233c2:	62d3      	str	r3, [r2, #44]	@ 0x2c
200233c4:	6823      	ldr	r3, [r4, #0]
200233c6:	9a0c      	ldr	r2, [sp, #48]	@ 0x30
200233c8:	f8c3 2080 	str.w	r2, [r3, #128]	@ 0x80
200233cc:	f7ff fe01 	bl	20022fd2 <HAL_FLASH_ENABLE_CMD2>
200233d0:	4620      	mov	r0, r4
200233d2:	f7ff fe0c 	bl	20022fee <HAL_FLASH_STAUS_MATCH_CMD2>
200233d6:	6823      	ldr	r3, [r4, #0]
200233d8:	f8c3 801c 	str.w	r8, [r3, #28]
200233dc:	68e3      	ldr	r3, [r4, #12]
200233de:	6822      	ldr	r2, [r4, #0]
200233e0:	443b      	add	r3, r7
200233e2:	7c1b      	ldrb	r3, [r3, #16]
200233e4:	6193      	str	r3, [r2, #24]
200233e6:	4620      	mov	r0, r4
200233e8:	f7ff fd0a 	bl	20022e00 <HAL_FLASH_STATUS_MATCH>
200233ec:	2800      	cmp	r0, #0
200233ee:	d0fa      	beq.n	200233e6 <HAL_FLASH_ISSUE_CMD_SEQ+0xd0>
200233f0:	2109      	movs	r1, #9
200233f2:	4620      	mov	r0, r4
200233f4:	f7ff fcfe 	bl	20022df4 <HAL_FLASH_CLR_STATUS>
200233f8:	2100      	movs	r1, #0
200233fa:	f7ff fdea 	bl	20022fd2 <HAL_FLASH_ENABLE_CMD2>
200233fe:	4620      	mov	r0, r4
20023400:	f7ff fdf5 	bl	20022fee <HAL_FLASH_STAUS_MATCH_CMD2>
20023404:	4608      	mov	r0, r1
20023406:	b006      	add	sp, #24
20023408:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}
2002340c:	2001      	movs	r0, #1
2002340e:	e7fa      	b.n	20023406 <HAL_FLASH_ISSUE_CMD_SEQ+0xf0>

20023410 <nor_qspi_switch>:
20023410:	b570      	push	{r4, r5, r6, lr}
20023412:	4604      	mov	r4, r0
20023414:	b3e0      	cbz	r0, 20023490 <nor_qspi_switch+0x80>
20023416:	68c3      	ldr	r3, [r0, #12]
20023418:	b3d3      	cbz	r3, 20023490 <nor_qspi_switch+0x80>
2002341a:	b3c9      	cbz	r1, 20023490 <nor_qspi_switch+0x80>
2002341c:	f893 5193 	ldrb.w	r5, [r3, #403]	@ 0x193
20023420:	2101      	movs	r1, #1
20023422:	b3b5      	cbz	r5, 20023492 <nor_qspi_switch+0x82>
20023424:	f7ff fca5 	bl	20022d72 <HAL_FLASH_WRITE_DLEN>
20023428:	2200      	movs	r2, #0
2002342a:	2114      	movs	r1, #20
2002342c:	4620      	mov	r0, r4
2002342e:	f7ff ff3f 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
20023432:	4620      	mov	r0, r4
20023434:	f7ff fcf3 	bl	20022e1e <HAL_FLASH_READ32>
20023438:	f010 0501 	ands.w	r5, r0, #1
2002343c:	d000      	beq.n	20023440 <nor_qspi_switch+0x30>
2002343e:	e7fe      	b.n	2002343e <nor_qspi_switch+0x2e>
20023440:	462a      	mov	r2, r5
20023442:	2115      	movs	r1, #21
20023444:	4620      	mov	r0, r4
20023446:	f7ff ff33 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
2002344a:	4606      	mov	r6, r0
2002344c:	b120      	cbz	r0, 20023458 <nor_qspi_switch+0x48>
2002344e:	462a      	mov	r2, r5
20023450:	4629      	mov	r1, r5
20023452:	4620      	mov	r0, r4
20023454:	f7ff ff2c 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
20023458:	2102      	movs	r1, #2
2002345a:	4620      	mov	r0, r4
2002345c:	f7ff fc82 	bl	20022d64 <HAL_FLASH_WRITE_WORD>
20023460:	2101      	movs	r1, #1
20023462:	4620      	mov	r0, r4
20023464:	f7ff fc85 	bl	20022d72 <HAL_FLASH_WRITE_DLEN>
20023468:	2200      	movs	r2, #0
2002346a:	212b      	movs	r1, #43	@ 0x2b
2002346c:	4620      	mov	r0, r4
2002346e:	f7ff ff1f 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
20023472:	b16e      	cbz	r6, 20023490 <nor_qspi_switch+0x80>
20023474:	2101      	movs	r1, #1
20023476:	4620      	mov	r0, r4
20023478:	f7ff fc7b 	bl	20022d72 <HAL_FLASH_WRITE_DLEN>
2002347c:	2200      	movs	r2, #0
2002347e:	2102      	movs	r1, #2
20023480:	4620      	mov	r0, r4
20023482:	f7ff ff15 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
20023486:	4620      	mov	r0, r4
20023488:	f7ff fcc0 	bl	20022e0c <HAL_FLASH_IS_PROG_DONE>
2002348c:	2800      	cmp	r0, #0
2002348e:	d0f5      	beq.n	2002347c <nor_qspi_switch+0x6c>
20023490:	bd70      	pop	{r4, r5, r6, pc}
20023492:	f7ff fc6e 	bl	20022d72 <HAL_FLASH_WRITE_DLEN>
20023496:	462a      	mov	r2, r5
20023498:	2102      	movs	r1, #2
2002349a:	4620      	mov	r0, r4
2002349c:	f7ff ff08 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
200234a0:	4620      	mov	r0, r4
200234a2:	f7ff fcbc 	bl	20022e1e <HAL_FLASH_READ32>
200234a6:	462a      	mov	r2, r5
200234a8:	2114      	movs	r1, #20
200234aa:	4620      	mov	r0, r4
200234ac:	f7ff ff00 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
200234b0:	b910      	cbnz	r0, 200234b8 <nor_qspi_switch+0xa8>
200234b2:	4620      	mov	r0, r4
200234b4:	f7ff fcb3 	bl	20022e1e <HAL_FLASH_READ32>
200234b8:	68e3      	ldr	r3, [r4, #12]
200234ba:	7a1b      	ldrb	r3, [r3, #8]
200234bc:	b3ab      	cbz	r3, 2002352a <nor_qspi_switch+0x11a>
200234be:	2101      	movs	r1, #1
200234c0:	f003 050f 	and.w	r5, r3, #15
200234c4:	091b      	lsrs	r3, r3, #4
200234c6:	fa01 f303 	lsl.w	r3, r1, r3
200234ca:	b2db      	uxtb	r3, r3
200234cc:	b10d      	cbz	r5, 200234d2 <nor_qspi_switch+0xc2>
200234ce:	461d      	mov	r5, r3
200234d0:	2300      	movs	r3, #0
200234d2:	2200      	movs	r2, #0
200234d4:	2115      	movs	r1, #21
200234d6:	4620      	mov	r0, r4
200234d8:	ea43 2505 	orr.w	r5, r3, r5, lsl #8
200234dc:	f7ff fee8 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
200234e0:	4606      	mov	r6, r0
200234e2:	b120      	cbz	r0, 200234ee <nor_qspi_switch+0xde>
200234e4:	2200      	movs	r2, #0
200234e6:	4620      	mov	r0, r4
200234e8:	4611      	mov	r1, r2
200234ea:	f7ff fee1 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
200234ee:	4629      	mov	r1, r5
200234f0:	4620      	mov	r0, r4
200234f2:	f7ff fc37 	bl	20022d64 <HAL_FLASH_WRITE_WORD>
200234f6:	2102      	movs	r1, #2
200234f8:	4620      	mov	r0, r4
200234fa:	f7ff fc3a 	bl	20022d72 <HAL_FLASH_WRITE_DLEN>
200234fe:	2200      	movs	r2, #0
20023500:	2103      	movs	r1, #3
20023502:	4620      	mov	r0, r4
20023504:	f7ff fed4 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
20023508:	2e00      	cmp	r6, #0
2002350a:	d0c1      	beq.n	20023490 <nor_qspi_switch+0x80>
2002350c:	2101      	movs	r1, #1
2002350e:	4620      	mov	r0, r4
20023510:	f7ff fc2f 	bl	20022d72 <HAL_FLASH_WRITE_DLEN>
20023514:	2200      	movs	r2, #0
20023516:	2102      	movs	r1, #2
20023518:	4620      	mov	r0, r4
2002351a:	f7ff fec9 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
2002351e:	4620      	mov	r0, r4
20023520:	f7ff fc74 	bl	20022e0c <HAL_FLASH_IS_PROG_DONE>
20023524:	2800      	cmp	r0, #0
20023526:	d0f5      	beq.n	20023514 <nor_qspi_switch+0x104>
20023528:	e7b2      	b.n	20023490 <nor_qspi_switch+0x80>
2002352a:	2502      	movs	r5, #2
2002352c:	e7d1      	b.n	200234d2 <nor_qspi_switch+0xc2>

2002352e <HAL_FLASH_SET_QUAL_SPI>:
2002352e:	b538      	push	{r3, r4, r5, lr}
20023530:	4604      	mov	r4, r0
20023532:	460d      	mov	r5, r1
20023534:	f7ff ff6c 	bl	20023410 <nor_qspi_switch>
20023538:	4629      	mov	r1, r5
2002353a:	4620      	mov	r0, r4
2002353c:	e8bd 4038 	ldmia.w	sp!, {r3, r4, r5, lr}
20023540:	f7ff be0e 	b.w	20023160 <HAL_FLASH_CONFIG_AHB_READ>

20023544 <HAL_FLASH_FADDR_SET_QSPI>:
20023544:	b538      	push	{r3, r4, r5, lr}
20023546:	4604      	mov	r4, r0
20023548:	460d      	mov	r5, r1
2002354a:	f7ff ff61 	bl	20023410 <nor_qspi_switch>
2002354e:	4629      	mov	r1, r5
20023550:	4620      	mov	r0, r4
20023552:	e8bd 4038 	ldmia.w	sp!, {r3, r4, r5, lr}
20023556:	f7ff be47 	b.w	200231e8 <HAL_FLASH_CONFIG_FULL_AHB_READ>

2002355a <HAL_FLASH_GET_NOR_ID>:
2002355a:	b510      	push	{r4, lr}
2002355c:	4604      	mov	r4, r0
2002355e:	b140      	cbz	r0, 20023572 <HAL_FLASH_GET_NOR_ID+0x18>
20023560:	6802      	ldr	r2, [r0, #0]
20023562:	6a93      	ldr	r3, [r2, #40]	@ 0x28
20023564:	f36f 0315 	bfc	r3, #0, #22
20023568:	f443 2380 	orr.w	r3, r3, #262144	@ 0x40000
2002356c:	f043 0301 	orr.w	r3, r3, #1
20023570:	6293      	str	r3, [r2, #40]	@ 0x28
20023572:	2103      	movs	r1, #3
20023574:	4620      	mov	r0, r4
20023576:	f7ff fbfc 	bl	20022d72 <HAL_FLASH_WRITE_DLEN>
2002357a:	2200      	movs	r2, #0
2002357c:	219f      	movs	r1, #159	@ 0x9f
2002357e:	4620      	mov	r0, r4
20023580:	f7ff fc1c 	bl	20022dbc <HAL_FLASH_SET_CMD>
20023584:	4620      	mov	r0, r4
20023586:	f7ff fc4a 	bl	20022e1e <HAL_FLASH_READ32>
2002358a:	f020 407f 	bic.w	r0, r0, #4278190080	@ 0xff000000
2002358e:	bd10      	pop	{r4, pc}

20023590 <HAL_FLASH_CLR_PROTECT>:
20023590:	b570      	push	{r4, r5, r6, lr}
20023592:	4604      	mov	r4, r0
20023594:	2800      	cmp	r0, #0
20023596:	d03e      	beq.n	20023616 <HAL_FLASH_CLR_PROTECT+0x86>
20023598:	68c3      	ldr	r3, [r0, #12]
2002359a:	2101      	movs	r1, #1
2002359c:	f893 5193 	ldrb.w	r5, [r3, #403]	@ 0x193
200235a0:	2d00      	cmp	r5, #0
200235a2:	d03b      	beq.n	2002361c <HAL_FLASH_CLR_PROTECT+0x8c>
200235a4:	f7ff fbe5 	bl	20022d72 <HAL_FLASH_WRITE_DLEN>
200235a8:	2200      	movs	r2, #0
200235aa:	2102      	movs	r1, #2
200235ac:	4620      	mov	r0, r4
200235ae:	f7ff fe7f 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
200235b2:	bb88      	cbnz	r0, 20023618 <HAL_FLASH_CLR_PROTECT+0x88>
200235b4:	4620      	mov	r0, r4
200235b6:	f7ff fc32 	bl	20022e1e <HAL_FLASH_READ32>
200235ba:	b2c0      	uxtb	r0, r0
200235bc:	68e3      	ldr	r3, [r4, #12]
200235be:	79dd      	ldrb	r5, [r3, #7]
200235c0:	b10d      	cbz	r5, 200235c6 <HAL_FLASH_CLR_PROTECT+0x36>
200235c2:	ea20 0505 	bic.w	r5, r0, r5
200235c6:	2200      	movs	r2, #0
200235c8:	2115      	movs	r1, #21
200235ca:	4620      	mov	r0, r4
200235cc:	f7ff fe70 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
200235d0:	4606      	mov	r6, r0
200235d2:	b120      	cbz	r0, 200235de <HAL_FLASH_CLR_PROTECT+0x4e>
200235d4:	2200      	movs	r2, #0
200235d6:	4620      	mov	r0, r4
200235d8:	4611      	mov	r1, r2
200235da:	f7ff fe69 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
200235de:	4629      	mov	r1, r5
200235e0:	4620      	mov	r0, r4
200235e2:	f7ff fbbf 	bl	20022d64 <HAL_FLASH_WRITE_WORD>
200235e6:	2101      	movs	r1, #1
200235e8:	4620      	mov	r0, r4
200235ea:	f7ff fbc2 	bl	20022d72 <HAL_FLASH_WRITE_DLEN>
200235ee:	2200      	movs	r2, #0
200235f0:	2103      	movs	r1, #3
200235f2:	4620      	mov	r0, r4
200235f4:	f7ff fe5c 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
200235f8:	b16e      	cbz	r6, 20023616 <HAL_FLASH_CLR_PROTECT+0x86>
200235fa:	2101      	movs	r1, #1
200235fc:	4620      	mov	r0, r4
200235fe:	f7ff fbb8 	bl	20022d72 <HAL_FLASH_WRITE_DLEN>
20023602:	2200      	movs	r2, #0
20023604:	2102      	movs	r1, #2
20023606:	4620      	mov	r0, r4
20023608:	f7ff fe52 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
2002360c:	4620      	mov	r0, r4
2002360e:	f7ff fbfd 	bl	20022e0c <HAL_FLASH_IS_PROG_DONE>
20023612:	2800      	cmp	r0, #0
20023614:	d0f5      	beq.n	20023602 <HAL_FLASH_CLR_PROTECT+0x72>
20023616:	bd70      	pop	{r4, r5, r6, pc}
20023618:	2000      	movs	r0, #0
2002361a:	e7cf      	b.n	200235bc <HAL_FLASH_CLR_PROTECT+0x2c>
2002361c:	f7ff fba9 	bl	20022d72 <HAL_FLASH_WRITE_DLEN>
20023620:	462a      	mov	r2, r5
20023622:	2102      	movs	r1, #2
20023624:	4620      	mov	r0, r4
20023626:	f7ff fe43 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
2002362a:	2800      	cmp	r0, #0
2002362c:	d13e      	bne.n	200236ac <HAL_FLASH_CLR_PROTECT+0x11c>
2002362e:	4620      	mov	r0, r4
20023630:	f7ff fbf5 	bl	20022e1e <HAL_FLASH_READ32>
20023634:	b2c6      	uxtb	r6, r0
20023636:	2200      	movs	r2, #0
20023638:	2114      	movs	r1, #20
2002363a:	4620      	mov	r0, r4
2002363c:	f7ff fe38 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
20023640:	b918      	cbnz	r0, 2002364a <HAL_FLASH_CLR_PROTECT+0xba>
20023642:	4620      	mov	r0, r4
20023644:	f7ff fbeb 	bl	20022e1e <HAL_FLASH_READ32>
20023648:	b2c5      	uxtb	r5, r0
2002364a:	68e3      	ldr	r3, [r4, #12]
2002364c:	79d9      	ldrb	r1, [r3, #7]
2002364e:	b109      	cbz	r1, 20023654 <HAL_FLASH_CLR_PROTECT+0xc4>
20023650:	ea26 0101 	bic.w	r1, r6, r1
20023654:	2200      	movs	r2, #0
20023656:	4620      	mov	r0, r4
20023658:	ea41 2505 	orr.w	r5, r1, r5, lsl #8
2002365c:	2115      	movs	r1, #21
2002365e:	f7ff fe27 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
20023662:	4606      	mov	r6, r0
20023664:	b120      	cbz	r0, 20023670 <HAL_FLASH_CLR_PROTECT+0xe0>
20023666:	2200      	movs	r2, #0
20023668:	4620      	mov	r0, r4
2002366a:	4611      	mov	r1, r2
2002366c:	f7ff fe20 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
20023670:	4629      	mov	r1, r5
20023672:	4620      	mov	r0, r4
20023674:	f7ff fb76 	bl	20022d64 <HAL_FLASH_WRITE_WORD>
20023678:	2102      	movs	r1, #2
2002367a:	4620      	mov	r0, r4
2002367c:	f7ff fb79 	bl	20022d72 <HAL_FLASH_WRITE_DLEN>
20023680:	2200      	movs	r2, #0
20023682:	2103      	movs	r1, #3
20023684:	4620      	mov	r0, r4
20023686:	f7ff fe13 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
2002368a:	2e00      	cmp	r6, #0
2002368c:	d0c3      	beq.n	20023616 <HAL_FLASH_CLR_PROTECT+0x86>
2002368e:	2101      	movs	r1, #1
20023690:	4620      	mov	r0, r4
20023692:	f7ff fb6e 	bl	20022d72 <HAL_FLASH_WRITE_DLEN>
20023696:	2200      	movs	r2, #0
20023698:	2102      	movs	r1, #2
2002369a:	4620      	mov	r0, r4
2002369c:	f7ff fe08 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
200236a0:	4620      	mov	r0, r4
200236a2:	f7ff fbb3 	bl	20022e0c <HAL_FLASH_IS_PROG_DONE>
200236a6:	2800      	cmp	r0, #0
200236a8:	d0f5      	beq.n	20023696 <HAL_FLASH_CLR_PROTECT+0x106>
200236aa:	e7b4      	b.n	20023616 <HAL_FLASH_CLR_PROTECT+0x86>
200236ac:	462e      	mov	r6, r5
200236ae:	e7c2      	b.n	20023636 <HAL_FLASH_CLR_PROTECT+0xa6>

200236b0 <HAL_QSPI_SET_CLK_INV>:
200236b0:	b160      	cbz	r0, 200236cc <HAL_QSPI_SET_CLK_INV+0x1c>
200236b2:	6800      	ldr	r0, [r0, #0]
200236b4:	b150      	cbz	r0, 200236cc <HAL_QSPI_SET_CLK_INV+0x1c>
200236b6:	6d83      	ldr	r3, [r0, #88]	@ 0x58
200236b8:	0609      	lsls	r1, r1, #24
200236ba:	f023 7380 	bic.w	r3, r3, #16777216	@ 0x1000000
200236be:	f001 7180 	and.w	r1, r1, #16777216	@ 0x1000000
200236c2:	f023 03ff 	bic.w	r3, r3, #255	@ 0xff
200236c6:	4311      	orrs	r1, r2
200236c8:	4319      	orrs	r1, r3
200236ca:	6581      	str	r1, [r0, #88]	@ 0x58
200236cc:	4770      	bx	lr

200236ce <HAL_FLASH_RELEASE_DPD>:
200236ce:	b538      	push	{r3, r4, r5, lr}
200236d0:	4604      	mov	r4, r0
200236d2:	b1d0      	cbz	r0, 2002370a <HAL_FLASH_RELEASE_DPD+0x3c>
200236d4:	6803      	ldr	r3, [r0, #0]
200236d6:	21ab      	movs	r1, #171	@ 0xab
200236d8:	681d      	ldr	r5, [r3, #0]
200236da:	f015 0501 	ands.w	r5, r5, #1
200236de:	bf02      	ittt	eq
200236e0:	681a      	ldreq	r2, [r3, #0]
200236e2:	f042 0201 	orreq.w	r2, r2, #1
200236e6:	601a      	streq	r2, [r3, #0]
200236e8:	6802      	ldr	r2, [r0, #0]
200236ea:	6a93      	ldr	r3, [r2, #40]	@ 0x28
200236ec:	f36f 0315 	bfc	r3, #0, #22
200236f0:	f043 0301 	orr.w	r3, r3, #1
200236f4:	6293      	str	r3, [r2, #40]	@ 0x28
200236f6:	2200      	movs	r2, #0
200236f8:	f7ff fb60 	bl	20022dbc <HAL_FLASH_SET_CMD>
200236fc:	b925      	cbnz	r5, 20023708 <HAL_FLASH_RELEASE_DPD+0x3a>
200236fe:	6822      	ldr	r2, [r4, #0]
20023700:	6813      	ldr	r3, [r2, #0]
20023702:	f023 0301 	bic.w	r3, r3, #1
20023706:	6013      	str	r3, [r2, #0]
20023708:	bd38      	pop	{r3, r4, r5, pc}
2002370a:	2001      	movs	r0, #1
2002370c:	e7fc      	b.n	20023708 <HAL_FLASH_RELEASE_DPD+0x3a>

2002370e <flash_handle_valid>:
2002370e:	b118      	cbz	r0, 20023718 <flash_handle_valid+0xa>
20023710:	68c0      	ldr	r0, [r0, #12]
20023712:	3800      	subs	r0, #0
20023714:	bf18      	it	ne
20023716:	2001      	movne	r0, #1
20023718:	4770      	bx	lr

2002371a <HAL_GET_FLASH_MID>:
2002371a:	2000      	movs	r0, #0
2002371c:	4770      	bx	lr

2002371e <HAL_FLASH_DMA_START>:
2002371e:	e92d 47f0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, lr}
20023722:	4688      	mov	r8, r1
20023724:	4699      	mov	r9, r3
20023726:	4604      	mov	r4, r0
20023728:	2800      	cmp	r0, #0
2002372a:	d045      	beq.n	200237b8 <HAL_FLASH_DMA_START+0x9a>
2002372c:	6883      	ldr	r3, [r0, #8]
2002372e:	2b00      	cmp	r3, #0
20023730:	d042      	beq.n	200237b8 <HAL_FLASH_DMA_START+0x9a>
20023732:	f1b9 0f00 	cmp.w	r9, #0
20023736:	d03f      	beq.n	200237b8 <HAL_FLASH_DMA_START+0x9a>
20023738:	6801      	ldr	r1, [r0, #0]
2002373a:	680f      	ldr	r7, [r1, #0]
2002373c:	b332      	cbz	r2, 2002378c <HAL_FLASH_DMA_START+0x6e>
2002373e:	2210      	movs	r2, #16
20023740:	609a      	str	r2, [r3, #8]
20023742:	2300      	movs	r3, #0
20023744:	6882      	ldr	r2, [r0, #8]
20023746:	464e      	mov	r6, r9
20023748:	6153      	str	r3, [r2, #20]
2002374a:	6882      	ldr	r2, [r0, #8]
2002374c:	6193      	str	r3, [r2, #24]
2002374e:	6882      	ldr	r2, [r0, #8]
20023750:	60d3      	str	r3, [r2, #12]
20023752:	2280      	movs	r2, #128	@ 0x80
20023754:	6883      	ldr	r3, [r0, #8]
20023756:	611a      	str	r2, [r3, #16]
20023758:	6805      	ldr	r5, [r0, #0]
2002375a:	3504      	adds	r5, #4
2002375c:	68a0      	ldr	r0, [r4, #8]
2002375e:	f7ff f859 	bl	20022814 <HAL_DMA_DeInit>
20023762:	bb50      	cbnz	r0, 200237ba <HAL_FLASH_DMA_START+0x9c>
20023764:	68a0      	ldr	r0, [r4, #8]
20023766:	f7fe fff1 	bl	2002274c <HAL_DMA_Init>
2002376a:	bb30      	cbnz	r0, 200237ba <HAL_FLASH_DMA_START+0x9c>
2002376c:	6823      	ldr	r3, [r4, #0]
2002376e:	f047 0720 	orr.w	r7, r7, #32
20023772:	601f      	str	r7, [r3, #0]
20023774:	6822      	ldr	r2, [r4, #0]
20023776:	f109 33ff 	add.w	r3, r9, #4294967295
2002377a:	6253      	str	r3, [r2, #36]	@ 0x24
2002377c:	4641      	mov	r1, r8
2002377e:	4633      	mov	r3, r6
20023780:	462a      	mov	r2, r5
20023782:	68a0      	ldr	r0, [r4, #8]
20023784:	e8bd 47f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, lr}
20023788:	f7ff b9a2 	b.w	20022ad0 <HAL_DMA_Start>
2002378c:	f44f 7100 	mov.w	r1, #512	@ 0x200
20023790:	609a      	str	r2, [r3, #8]
20023792:	6883      	ldr	r3, [r0, #8]
20023794:	f109 0603 	add.w	r6, r9, #3
20023798:	6159      	str	r1, [r3, #20]
2002379a:	f44f 6100 	mov.w	r1, #2048	@ 0x800
2002379e:	6883      	ldr	r3, [r0, #8]
200237a0:	4645      	mov	r5, r8
200237a2:	6199      	str	r1, [r3, #24]
200237a4:	6883      	ldr	r3, [r0, #8]
200237a6:	08b6      	lsrs	r6, r6, #2
200237a8:	60da      	str	r2, [r3, #12]
200237aa:	2280      	movs	r2, #128	@ 0x80
200237ac:	6883      	ldr	r3, [r0, #8]
200237ae:	611a      	str	r2, [r3, #16]
200237b0:	6803      	ldr	r3, [r0, #0]
200237b2:	f103 0804 	add.w	r8, r3, #4
200237b6:	e7d1      	b.n	2002375c <HAL_FLASH_DMA_START+0x3e>
200237b8:	2001      	movs	r0, #1
200237ba:	e8bd 87f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, pc}

200237be <HAL_FLASH_DMA_WAIT_DONE>:
200237be:	b510      	push	{r4, lr}
200237c0:	460a      	mov	r2, r1
200237c2:	4604      	mov	r4, r0
200237c4:	b170      	cbz	r0, 200237e4 <HAL_FLASH_DMA_WAIT_DONE+0x26>
200237c6:	6880      	ldr	r0, [r0, #8]
200237c8:	b160      	cbz	r0, 200237e4 <HAL_FLASH_DMA_WAIT_DONE+0x26>
200237ca:	6b61      	ldr	r1, [r4, #52]	@ 0x34
200237cc:	b111      	cbz	r1, 200237d4 <HAL_FLASH_DMA_WAIT_DONE+0x16>
200237ce:	f04f 32ff 	mov.w	r2, #4294967295
200237d2:	2100      	movs	r1, #0
200237d4:	f7ff f87e 	bl	200228d4 <HAL_DMA_PollForTransfer>
200237d8:	6822      	ldr	r2, [r4, #0]
200237da:	6813      	ldr	r3, [r2, #0]
200237dc:	f023 0320 	bic.w	r3, r3, #32
200237e0:	6013      	str	r3, [r2, #0]
200237e2:	bd10      	pop	{r4, pc}
200237e4:	2001      	movs	r0, #1
200237e6:	e7fc      	b.n	200237e2 <HAL_FLASH_DMA_WAIT_DONE+0x24>

200237e8 <HAL_FLASH_ALIAS_CFG>:
200237e8:	b538      	push	{r3, r4, r5, lr}
200237ea:	461d      	mov	r5, r3
200237ec:	4604      	mov	r4, r0
200237ee:	b158      	cbz	r0, 20023808 <HAL_FLASH_ALIAS_CFG+0x20>
200237f0:	6903      	ldr	r3, [r0, #16]
200237f2:	428b      	cmp	r3, r1
200237f4:	bf98      	it	ls
200237f6:	1ac9      	subls	r1, r1, r3
200237f8:	f7ff fb68 	bl	20022ecc <HAL_FLASH_SET_ALIAS_RANGE>
200237fc:	4629      	mov	r1, r5
200237fe:	4620      	mov	r0, r4
20023800:	e8bd 4038 	ldmia.w	sp!, {r3, r4, r5, lr}
20023804:	f7ff bb74 	b.w	20022ef0 <HAL_FLASH_SET_ALIAS_OFFSET>
20023808:	bd38      	pop	{r3, r4, r5, pc}

2002380a <HAL_FLASH_NONCE_CFG>:
2002380a:	b570      	push	{r4, r5, r6, lr}
2002380c:	460c      	mov	r4, r1
2002380e:	4615      	mov	r5, r2
20023810:	4619      	mov	r1, r3
20023812:	4606      	mov	r6, r0
20023814:	b180      	cbz	r0, 20023838 <HAL_FLASH_NONCE_CFG+0x2e>
20023816:	b17b      	cbz	r3, 20023838 <HAL_FLASH_NONCE_CFG+0x2e>
20023818:	f7ff fb86 	bl	20022f28 <HAL_FLASH_SET_NONCE>
2002381c:	6933      	ldr	r3, [r6, #16]
2002381e:	4630      	mov	r0, r6
20023820:	42a3      	cmp	r3, r4
20023822:	bf98      	it	ls
20023824:	1ae4      	subls	r4, r4, r3
20023826:	42ab      	cmp	r3, r5
20023828:	bf98      	it	ls
2002382a:	1aed      	subls	r5, r5, r3
2002382c:	462a      	mov	r2, r5
2002382e:	4621      	mov	r1, r4
20023830:	e8bd 4070 	ldmia.w	sp!, {r4, r5, r6, lr}
20023834:	f7ff bb66 	b.w	20022f04 <HAL_FLASH_SET_CTR>
20023838:	bd70      	pop	{r4, r5, r6, pc}

2002383a <HAL_FLASH_AES_CFG>:
2002383a:	b510      	push	{r4, lr}
2002383c:	4604      	mov	r4, r0
2002383e:	b148      	cbz	r0, 20023854 <HAL_FLASH_AES_CFG+0x1a>
20023840:	b101      	cbz	r1, 20023844 <HAL_FLASH_AES_CFG+0xa>
20023842:	2101      	movs	r1, #1
20023844:	f7ff fb7e 	bl	20022f44 <HAL_FLASH_SET_AES>
20023848:	4620      	mov	r0, r4
2002384a:	e8bd 4010 	ldmia.w	sp!, {r4, lr}
2002384e:	2101      	movs	r1, #1
20023850:	f7ff bb87 	b.w	20022f62 <HAL_FLASH_ENABLE_AES>
20023854:	bd10      	pop	{r4, pc}

20023856 <nand_read_id>:
20023856:	b510      	push	{r4, lr}
20023858:	460b      	mov	r3, r1
2002385a:	4604      	mov	r4, r0
2002385c:	b086      	sub	sp, #24
2002385e:	b320      	cbz	r0, 200238aa <nand_read_id+0x54>
20023860:	2908      	cmp	r1, #8
20023862:	f04f 0100 	mov.w	r1, #0
20023866:	f04f 0201 	mov.w	r2, #1
2002386a:	bf83      	ittte	hi
2002386c:	460b      	movhi	r3, r1
2002386e:	e9cd 1202 	strdhi	r1, r2, [sp, #8]
20023872:	e9cd 1100 	strdhi	r1, r1, [sp]
20023876:	e9cd 1102 	strdls	r1, r1, [sp, #8]
2002387a:	bf8e      	itee	hi
2002387c:	4619      	movhi	r1, r3
2002387e:	e9cd 1100 	strdls	r1, r1, [sp]
20023882:	b25b      	sxtbls	r3, r3
20023884:	9204      	str	r2, [sp, #16]
20023886:	f7ff fade 	bl	20022e46 <HAL_FLASH_MANUAL_CMD>
2002388a:	2103      	movs	r1, #3
2002388c:	4620      	mov	r0, r4
2002388e:	f7ff fa70 	bl	20022d72 <HAL_FLASH_WRITE_DLEN>
20023892:	2200      	movs	r2, #0
20023894:	219f      	movs	r1, #159	@ 0x9f
20023896:	4620      	mov	r0, r4
20023898:	f7ff fa90 	bl	20022dbc <HAL_FLASH_SET_CMD>
2002389c:	4620      	mov	r0, r4
2002389e:	f7ff fabe 	bl	20022e1e <HAL_FLASH_READ32>
200238a2:	f020 407f 	bic.w	r0, r0, #4278190080	@ 0xff000000
200238a6:	b006      	add	sp, #24
200238a8:	bd10      	pop	{r4, pc}
200238aa:	20ff      	movs	r0, #255	@ 0xff
200238ac:	e7fb      	b.n	200238a6 <nand_read_id+0x50>

200238ae <HAL_NAND_CONF_ECC>:
200238ae:	b538      	push	{r3, r4, r5, lr}
200238b0:	460d      	mov	r5, r1
200238b2:	4604      	mov	r4, r0
200238b4:	b398      	cbz	r0, 2002391e <HAL_NAND_CONF_ECC+0x70>
200238b6:	68c3      	ldr	r3, [r0, #12]
200238b8:	b38b      	cbz	r3, 2002391e <HAL_NAND_CONF_ECC+0x70>
200238ba:	799a      	ldrb	r2, [r3, #6]
200238bc:	b392      	cbz	r2, 20023924 <HAL_NAND_CONF_ECC+0x76>
200238be:	7a9b      	ldrb	r3, [r3, #10]
200238c0:	b383      	cbz	r3, 20023924 <HAL_NAND_CONF_ECC+0x76>
200238c2:	2101      	movs	r1, #1
200238c4:	f7ff fa55 	bl	20022d72 <HAL_FLASH_WRITE_DLEN>
200238c8:	68e3      	ldr	r3, [r4, #12]
200238ca:	2102      	movs	r1, #2
200238cc:	799a      	ldrb	r2, [r3, #6]
200238ce:	4620      	mov	r0, r4
200238d0:	f7ff fcee 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
200238d4:	4620      	mov	r0, r4
200238d6:	f7ff faa2 	bl	20022e1e <HAL_FLASH_READ32>
200238da:	68e3      	ldr	r3, [r4, #12]
200238dc:	7a9b      	ldrb	r3, [r3, #10]
200238de:	b1dd      	cbz	r5, 20023918 <HAL_NAND_CONF_ECC+0x6a>
200238e0:	ea43 0100 	orr.w	r1, r3, r0
200238e4:	4620      	mov	r0, r4
200238e6:	f7ff fa3d 	bl	20022d64 <HAL_FLASH_WRITE_WORD>
200238ea:	2101      	movs	r1, #1
200238ec:	4620      	mov	r0, r4
200238ee:	f7ff fa40 	bl	20022d72 <HAL_FLASH_WRITE_DLEN>
200238f2:	68e3      	ldr	r3, [r4, #12]
200238f4:	2103      	movs	r1, #3
200238f6:	799a      	ldrb	r2, [r3, #6]
200238f8:	4620      	mov	r0, r4
200238fa:	f7ff fcd9 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
200238fe:	68e3      	ldr	r3, [r4, #12]
20023900:	f884 502d 	strb.w	r5, [r4, #45]	@ 0x2d
20023904:	2102      	movs	r1, #2
20023906:	799a      	ldrb	r2, [r3, #6]
20023908:	4620      	mov	r0, r4
2002390a:	f7ff fcd1 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
2002390e:	4620      	mov	r0, r4
20023910:	f7ff fa85 	bl	20022e1e <HAL_FLASH_READ32>
20023914:	2000      	movs	r0, #0
20023916:	bd38      	pop	{r3, r4, r5, pc}
20023918:	ea20 0103 	bic.w	r1, r0, r3
2002391c:	e7e2      	b.n	200238e4 <HAL_NAND_CONF_ECC+0x36>
2002391e:	f04f 30ff 	mov.w	r0, #4294967295
20023922:	e7f8      	b.n	20023916 <HAL_NAND_CONF_ECC+0x68>
20023924:	f06f 0001 	mvn.w	r0, #1
20023928:	e7f5      	b.n	20023916 <HAL_NAND_CONF_ECC+0x68>

2002392a <HAL_NAND_GET_ECC_STATUS>:
2002392a:	b510      	push	{r4, lr}
2002392c:	4604      	mov	r4, r0
2002392e:	b320      	cbz	r0, 2002397a <HAL_NAND_GET_ECC_STATUS+0x50>
20023930:	68c2      	ldr	r2, [r0, #12]
20023932:	b31a      	cbz	r2, 2002397c <HAL_NAND_GET_ECC_STATUS+0x52>
20023934:	7913      	ldrb	r3, [r2, #4]
20023936:	b31b      	cbz	r3, 20023980 <HAL_NAND_GET_ECC_STATUS+0x56>
20023938:	79d3      	ldrb	r3, [r2, #7]
2002393a:	b30b      	cbz	r3, 20023980 <HAL_NAND_GET_ECC_STATUS+0x56>
2002393c:	2101      	movs	r1, #1
2002393e:	f7ff fa18 	bl	20022d72 <HAL_FLASH_WRITE_DLEN>
20023942:	68e3      	ldr	r3, [r4, #12]
20023944:	2102      	movs	r1, #2
20023946:	791a      	ldrb	r2, [r3, #4]
20023948:	4620      	mov	r0, r4
2002394a:	f7ff fcb1 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
2002394e:	4620      	mov	r0, r4
20023950:	f7ff fa65 	bl	20022e1e <HAL_FLASH_READ32>
20023954:	f894 202c 	ldrb.w	r2, [r4, #44]	@ 0x2c
20023958:	2a3f      	cmp	r2, #63	@ 0x3f
2002395a:	ea4f 1312 	mov.w	r3, r2, lsr #4
2002395e:	d804      	bhi.n	2002396a <HAL_NAND_GET_ECC_STATUS+0x40>
20023960:	2b01      	cmp	r3, #1
20023962:	d808      	bhi.n	20023976 <HAL_NAND_GET_ECC_STATUS+0x4c>
20023964:	f000 0030 	and.w	r0, r0, #48	@ 0x30
20023968:	e007      	b.n	2002397a <HAL_NAND_GET_ECC_STATUS+0x50>
2002396a:	3b04      	subs	r3, #4
2002396c:	2b01      	cmp	r3, #1
2002396e:	d8f9      	bhi.n	20023964 <HAL_NAND_GET_ECC_STATUS+0x3a>
20023970:	f000 00f0 	and.w	r0, r0, #240	@ 0xf0
20023974:	e001      	b.n	2002397a <HAL_NAND_GET_ECC_STATUS+0x50>
20023976:	f000 0070 	and.w	r0, r0, #112	@ 0x70
2002397a:	bd10      	pop	{r4, pc}
2002397c:	4610      	mov	r0, r2
2002397e:	e7fc      	b.n	2002397a <HAL_NAND_GET_ECC_STATUS+0x50>
20023980:	4618      	mov	r0, r3
20023982:	e7fa      	b.n	2002397a <HAL_NAND_GET_ECC_STATUS+0x50>

20023984 <HAL_NAND_CHECK_ECC>:
20023984:	4603      	mov	r3, r0
20023986:	1108      	asrs	r0, r1, #4
20023988:	b172      	cbz	r2, 200239a8 <HAL_NAND_CHECK_ECC+0x24>
2002398a:	2b07      	cmp	r3, #7
2002398c:	d80c      	bhi.n	200239a8 <HAL_NAND_CHECK_ECC+0x24>
2002398e:	e8df f003 	tbb	[pc, r3]
20023992:	0d04      	.short	0x0d04
20023994:	3f352e18 	.word	0x3f352e18
20023998:	4c47      	.short	0x4c47
2002399a:	b128      	cbz	r0, 200239a8 <HAL_NAND_CHECK_ECC+0x24>
2002399c:	2801      	cmp	r0, #1
2002399e:	6813      	ldr	r3, [r2, #0]
200239a0:	d10a      	bne.n	200239b8 <HAL_NAND_CHECK_ECC+0x34>
200239a2:	f043 0301 	orr.w	r3, r3, #1
200239a6:	6013      	str	r3, [r2, #0]
200239a8:	2000      	movs	r0, #0
200239aa:	4770      	bx	lr
200239ac:	f020 0302 	bic.w	r3, r0, #2
200239b0:	2b01      	cmp	r3, #1
200239b2:	d003      	beq.n	200239bc <HAL_NAND_CHECK_ECC+0x38>
200239b4:	b1d0      	cbz	r0, 200239ec <HAL_NAND_CHECK_ECC+0x68>
200239b6:	6813      	ldr	r3, [r2, #0]
200239b8:	4303      	orrs	r3, r0
200239ba:	e016      	b.n	200239ea <HAL_NAND_CHECK_ECC+0x66>
200239bc:	6813      	ldr	r3, [r2, #0]
200239be:	4303      	orrs	r3, r0
200239c0:	e7f1      	b.n	200239a6 <HAL_NAND_CHECK_ECC+0x22>
200239c2:	2805      	cmp	r0, #5
200239c4:	d8f7      	bhi.n	200239b6 <HAL_NAND_CHECK_ECC+0x32>
200239c6:	a301      	add	r3, pc, #4	@ (adr r3, 200239cc <HAL_NAND_CHECK_ECC+0x48>)
200239c8:	f853 f020 	ldr.w	pc, [r3, r0, lsl #2]
200239cc:	200239a9 	.word	0x200239a9
200239d0:	200239bd 	.word	0x200239bd
200239d4:	200239e5 	.word	0x200239e5
200239d8:	200239bd 	.word	0x200239bd
200239dc:	200239b7 	.word	0x200239b7
200239e0:	200239bd 	.word	0x200239bd
200239e4:	6813      	ldr	r3, [r2, #0]
200239e6:	f043 0302 	orr.w	r3, r3, #2
200239ea:	6013      	str	r3, [r2, #0]
200239ec:	4770      	bx	lr
200239ee:	2800      	cmp	r0, #0
200239f0:	d0da      	beq.n	200239a8 <HAL_NAND_CHECK_ECC+0x24>
200239f2:	1e43      	subs	r3, r0, #1
200239f4:	2b05      	cmp	r3, #5
200239f6:	6813      	ldr	r3, [r2, #0]
200239f8:	d9e1      	bls.n	200239be <HAL_NAND_CHECK_ECC+0x3a>
200239fa:	e7dd      	b.n	200239b8 <HAL_NAND_CHECK_ECC+0x34>
200239fc:	07c3      	lsls	r3, r0, #31
200239fe:	f000 0103 	and.w	r1, r0, #3
20023a02:	d402      	bmi.n	20023a0a <HAL_NAND_CHECK_ECC+0x86>
20023a04:	2900      	cmp	r1, #0
20023a06:	d0cf      	beq.n	200239a8 <HAL_NAND_CHECK_ECC+0x24>
20023a08:	e7d5      	b.n	200239b6 <HAL_NAND_CHECK_ECC+0x32>
20023a0a:	6813      	ldr	r3, [r2, #0]
20023a0c:	430b      	orrs	r3, r1
20023a0e:	e7ca      	b.n	200239a6 <HAL_NAND_CHECK_ECC+0x22>
20023a10:	2800      	cmp	r0, #0
20023a12:	d0c9      	beq.n	200239a8 <HAL_NAND_CHECK_ECC+0x24>
20023a14:	6813      	ldr	r3, [r2, #0]
20023a16:	2808      	cmp	r0, #8
20023a18:	ea43 0300 	orr.w	r3, r3, r0
20023a1c:	dce5      	bgt.n	200239ea <HAL_NAND_CHECK_ECC+0x66>
20023a1e:	e7c2      	b.n	200239a6 <HAL_NAND_CHECK_ECC+0x22>
20023a20:	2800      	cmp	r0, #0
20023a22:	d0c1      	beq.n	200239a8 <HAL_NAND_CHECK_ECC+0x24>
20023a24:	1e43      	subs	r3, r0, #1
20023a26:	2b01      	cmp	r3, #1
20023a28:	e7e5      	b.n	200239f6 <HAL_NAND_CHECK_ECC+0x72>
20023a2a:	2800      	cmp	r0, #0
20023a2c:	d0bc      	beq.n	200239a8 <HAL_NAND_CHECK_ECC+0x24>
20023a2e:	1e43      	subs	r3, r0, #1
20023a30:	2b02      	cmp	r3, #2
20023a32:	e7e0      	b.n	200239f6 <HAL_NAND_CHECK_ECC+0x72>

20023a34 <HAL_NAND_GET_ECC_RESULT>:
20023a34:	b510      	push	{r4, lr}
20023a36:	f890 302d 	ldrb.w	r3, [r0, #45]	@ 0x2d
20023a3a:	4604      	mov	r4, r0
20023a3c:	b90b      	cbnz	r3, 20023a42 <HAL_NAND_GET_ECC_RESULT+0xe>
20023a3e:	2000      	movs	r0, #0
20023a40:	bd10      	pop	{r4, pc}
20023a42:	f7ff ff72 	bl	2002392a <HAL_NAND_GET_ECC_STATUS>
20023a46:	4601      	mov	r1, r0
20023a48:	2800      	cmp	r0, #0
20023a4a:	d0f8      	beq.n	20023a3e <HAL_NAND_GET_ECC_RESULT+0xa>
20023a4c:	6862      	ldr	r2, [r4, #4]
20023a4e:	6be0      	ldr	r0, [r4, #60]	@ 0x3c
20023a50:	f442 4200 	orr.w	r2, r2, #32768	@ 0x8000
20023a54:	6062      	str	r2, [r4, #4]
20023a56:	b938      	cbnz	r0, 20023a68 <HAL_NAND_GET_ECC_RESULT+0x34>
20023a58:	f894 002c 	ldrb.w	r0, [r4, #44]	@ 0x2c
20023a5c:	1d22      	adds	r2, r4, #4
20023a5e:	0900      	lsrs	r0, r0, #4
20023a60:	e8bd 4010 	ldmia.w	sp!, {r4, lr}
20023a64:	f7ff bf8e 	b.w	20023984 <HAL_NAND_CHECK_ECC>
20023a68:	f5b1 7f00 	cmp.w	r1, #512	@ 0x200
20023a6c:	ea4f 1321 	mov.w	r3, r1, asr #4
20023a70:	db00      	blt.n	20023a74 <HAL_NAND_GET_ECC_RESULT+0x40>
20023a72:	e7fe      	b.n	20023a72 <HAL_NAND_GET_ECC_RESULT+0x3e>
20023a74:	6801      	ldr	r1, [r0, #0]
20023a76:	40d9      	lsrs	r1, r3
20023a78:	f011 0f01 	tst.w	r1, #1
20023a7c:	bf18      	it	ne
20023a7e:	4618      	movne	r0, r3
20023a80:	ea43 0302 	orr.w	r3, r3, r2
20023a84:	bf08      	it	eq
20023a86:	2000      	moveq	r0, #0
20023a88:	6063      	str	r3, [r4, #4]
20023a8a:	e7d9      	b.n	20023a40 <HAL_NAND_GET_ECC_RESULT+0xc>

20023a8c <HAL_NAND_EN_QUAL>:
20023a8c:	b538      	push	{r3, r4, r5, lr}
20023a8e:	460d      	mov	r5, r1
20023a90:	4604      	mov	r4, r0
20023a92:	b348      	cbz	r0, 20023ae8 <HAL_NAND_EN_QUAL+0x5c>
20023a94:	68c3      	ldr	r3, [r0, #12]
20023a96:	b33b      	cbz	r3, 20023ae8 <HAL_NAND_EN_QUAL+0x5c>
20023a98:	799a      	ldrb	r2, [r3, #6]
20023a9a:	b10a      	cbz	r2, 20023aa0 <HAL_NAND_EN_QUAL+0x14>
20023a9c:	7a1b      	ldrb	r3, [r3, #8]
20023a9e:	b90b      	cbnz	r3, 20023aa4 <HAL_NAND_EN_QUAL+0x18>
20023aa0:	2000      	movs	r0, #0
20023aa2:	bd38      	pop	{r3, r4, r5, pc}
20023aa4:	2101      	movs	r1, #1
20023aa6:	f7ff f964 	bl	20022d72 <HAL_FLASH_WRITE_DLEN>
20023aaa:	68e3      	ldr	r3, [r4, #12]
20023aac:	2102      	movs	r1, #2
20023aae:	799a      	ldrb	r2, [r3, #6]
20023ab0:	4620      	mov	r0, r4
20023ab2:	f7ff fbfd 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
20023ab6:	4620      	mov	r0, r4
20023ab8:	f7ff f9b1 	bl	20022e1e <HAL_FLASH_READ32>
20023abc:	68e3      	ldr	r3, [r4, #12]
20023abe:	7a1b      	ldrb	r3, [r3, #8]
20023ac0:	b17d      	cbz	r5, 20023ae2 <HAL_NAND_EN_QUAL+0x56>
20023ac2:	ea43 0100 	orr.w	r1, r3, r0
20023ac6:	4620      	mov	r0, r4
20023ac8:	f7ff f94c 	bl	20022d64 <HAL_FLASH_WRITE_WORD>
20023acc:	2101      	movs	r1, #1
20023ace:	4620      	mov	r0, r4
20023ad0:	f7ff f94f 	bl	20022d72 <HAL_FLASH_WRITE_DLEN>
20023ad4:	68e3      	ldr	r3, [r4, #12]
20023ad6:	2103      	movs	r1, #3
20023ad8:	4620      	mov	r0, r4
20023ada:	799a      	ldrb	r2, [r3, #6]
20023adc:	f7ff fbe8 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
20023ae0:	e7de      	b.n	20023aa0 <HAL_NAND_EN_QUAL+0x14>
20023ae2:	ea20 0103 	bic.w	r1, r0, r3
20023ae6:	e7ee      	b.n	20023ac6 <HAL_NAND_EN_QUAL+0x3a>
20023ae8:	f04f 30ff 	mov.w	r0, #4294967295
20023aec:	e7d9      	b.n	20023aa2 <HAL_NAND_EN_QUAL+0x16>

20023aee <nand_clear_status>:
20023aee:	b538      	push	{r3, r4, r5, lr}
20023af0:	460d      	mov	r5, r1
20023af2:	2101      	movs	r1, #1
20023af4:	4604      	mov	r4, r0
20023af6:	f7ff f93c 	bl	20022d72 <HAL_FLASH_WRITE_DLEN>
20023afa:	2dc9      	cmp	r5, #201	@ 0xc9
20023afc:	d001      	beq.n	20023b02 <nand_clear_status+0x14>
20023afe:	2d01      	cmp	r5, #1
20023b00:	d109      	bne.n	20023b16 <nand_clear_status+0x28>
20023b02:	2102      	movs	r1, #2
20023b04:	4620      	mov	r0, r4
20023b06:	f7ff f92d 	bl	20022d64 <HAL_FLASH_WRITE_WORD>
20023b0a:	68e3      	ldr	r3, [r4, #12]
20023b0c:	2103      	movs	r1, #3
20023b0e:	4620      	mov	r0, r4
20023b10:	795a      	ldrb	r2, [r3, #5]
20023b12:	f7ff fbcd 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
20023b16:	2100      	movs	r1, #0
20023b18:	4620      	mov	r0, r4
20023b1a:	f7ff f923 	bl	20022d64 <HAL_FLASH_WRITE_WORD>
20023b1e:	68e3      	ldr	r3, [r4, #12]
20023b20:	2103      	movs	r1, #3
20023b22:	4620      	mov	r0, r4
20023b24:	795a      	ldrb	r2, [r3, #5]
20023b26:	f7ff fbc3 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
20023b2a:	2000      	movs	r0, #0
20023b2c:	bd38      	pop	{r3, r4, r5, pc}

20023b2e <HAL_NAND_PAGE_SIZE>:
20023b2e:	b140      	cbz	r0, 20023b42 <HAL_NAND_PAGE_SIZE+0x14>
20023b30:	f890 302c 	ldrb.w	r3, [r0, #44]	@ 0x2c
20023b34:	f013 0f01 	tst.w	r3, #1
20023b38:	bf14      	ite	ne
20023b3a:	f44f 5080 	movne.w	r0, #4096	@ 0x1000
20023b3e:	f44f 6000 	moveq.w	r0, #2048	@ 0x800
20023b42:	4770      	bx	lr

20023b44 <HAL_NAND_READ_WITHOOB>:
20023b44:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
20023b48:	b085      	sub	sp, #20
20023b4a:	460e      	mov	r6, r1
20023b4c:	4691      	mov	r9, r2
20023b4e:	461d      	mov	r5, r3
20023b50:	4604      	mov	r4, r0
20023b52:	9f0f      	ldr	r7, [sp, #60]	@ 0x3c
20023b54:	b1b0      	cbz	r0, 20023b84 <HAL_NAND_READ_WITHOOB+0x40>
20023b56:	68c3      	ldr	r3, [r0, #12]
20023b58:	b1a3      	cbz	r3, 20023b84 <HAL_NAND_READ_WITHOOB+0x40>
20023b5a:	69c3      	ldr	r3, [r0, #28]
20023b5c:	b193      	cbz	r3, 20023b84 <HAL_NAND_READ_WITHOOB+0x40>
20023b5e:	2f80      	cmp	r7, #128	@ 0x80
20023b60:	d810      	bhi.n	20023b84 <HAL_NAND_READ_WITHOOB+0x40>
20023b62:	f7ff ffe4 	bl	20023b2e <HAL_NAND_PAGE_SIZE>
20023b66:	f100 3aff 	add.w	sl, r0, #4294967295
20023b6a:	ea0a 0a01 	and.w	sl, sl, r1
20023b6e:	eb0a 0305 	add.w	r3, sl, r5
20023b72:	4283      	cmp	r3, r0
20023b74:	4680      	mov	r8, r0
20023b76:	d907      	bls.n	20023b88 <HAL_NAND_READ_WITHOOB+0x44>
20023b78:	2002      	movs	r0, #2
20023b7a:	6060      	str	r0, [r4, #4]
20023b7c:	2000      	movs	r0, #0
20023b7e:	b005      	add	sp, #20
20023b80:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
20023b84:	2001      	movs	r0, #1
20023b86:	e7f8      	b.n	20023b7a <HAL_NAND_READ_WITHOOB+0x36>
20023b88:	2300      	movs	r3, #0
20023b8a:	6063      	str	r3, [r4, #4]
20023b8c:	6923      	ldr	r3, [r4, #16]
20023b8e:	f04f 0b00 	mov.w	fp, #0
20023b92:	428b      	cmp	r3, r1
20023b94:	bf98      	it	ls
20023b96:	1ace      	subls	r6, r1, r3
20023b98:	fbb6 f2f0 	udiv	r2, r6, r0
20023b9c:	2104      	movs	r1, #4
20023b9e:	4620      	mov	r0, r4
20023ba0:	f7ff fb86 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
20023ba4:	2014      	movs	r0, #20
20023ba6:	f7fe fac9 	bl	2002213c <HAL_Delay_us_>
20023baa:	2101      	movs	r1, #1
20023bac:	4620      	mov	r0, r4
20023bae:	f7ff f8e0 	bl	20022d72 <HAL_FLASH_WRITE_DLEN>
20023bb2:	2005      	movs	r0, #5
20023bb4:	f7fe fac2 	bl	2002213c <HAL_Delay_us_>
20023bb8:	68e2      	ldr	r2, [r4, #12]
20023bba:	2102      	movs	r1, #2
20023bbc:	7912      	ldrb	r2, [r2, #4]
20023bbe:	4620      	mov	r0, r4
20023bc0:	f7ff fb76 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
20023bc4:	4620      	mov	r0, r4
20023bc6:	f7ff f92a 	bl	20022e1e <HAL_FLASH_READ32>
20023bca:	07c1      	lsls	r1, r0, #31
20023bcc:	d4f1      	bmi.n	20023bb2 <HAL_NAND_READ_WITHOOB+0x6e>
20023bce:	f1bb 0f00 	cmp.w	fp, #0
20023bd2:	d102      	bne.n	20023bda <HAL_NAND_READ_WITHOOB+0x96>
20023bd4:	f04f 0b01 	mov.w	fp, #1
20023bd8:	e7eb      	b.n	20023bb2 <HAL_NAND_READ_WITHOOB+0x6e>
20023bda:	4620      	mov	r0, r4
20023bdc:	f7ff ff2a 	bl	20023a34 <HAL_NAND_GET_ECC_RESULT>
20023be0:	b110      	cbz	r0, 20023be8 <HAL_NAND_READ_WITHOOB+0xa4>
20023be2:	f440 4000 	orr.w	r0, r0, #32768	@ 0x8000
20023be6:	e7c8      	b.n	20023b7a <HAL_NAND_READ_WITHOOB+0x36>
20023be8:	f894 2028 	ldrb.w	r2, [r4, #40]	@ 0x28
20023bec:	68e3      	ldr	r3, [r4, #12]
20023bee:	bbb2      	cbnz	r2, 20023c5e <HAL_NAND_READ_WITHOOB+0x11a>
20023bf0:	f893 1046 	ldrb.w	r1, [r3, #70]	@ 0x46
20023bf4:	4620      	mov	r0, r4
20023bf6:	f7ff f864 	bl	20022cc2 <HAL_FLASH_SET_AHB_RCMD>
20023bfa:	68e0      	ldr	r0, [r4, #12]
20023bfc:	f990 c04e 	ldrsb.w	ip, [r0, #78]	@ 0x4e
20023c00:	f990 304a 	ldrsb.w	r3, [r0, #74]	@ 0x4a
20023c04:	f990 2049 	ldrsb.w	r2, [r0, #73]	@ 0x49
20023c08:	f990 1048 	ldrsb.w	r1, [r0, #72]	@ 0x48
20023c0c:	f8cd c00c 	str.w	ip, [sp, #12]
20023c10:	f990 c04d 	ldrsb.w	ip, [r0, #77]	@ 0x4d
20023c14:	f8cd c008 	str.w	ip, [sp, #8]
20023c18:	f990 c04c 	ldrsb.w	ip, [r0, #76]	@ 0x4c
20023c1c:	f8cd c004 	str.w	ip, [sp, #4]
20023c20:	f990 004b 	ldrsb.w	r0, [r0, #75]	@ 0x4b
20023c24:	9000      	str	r0, [sp, #0]
20023c26:	4620      	mov	r0, r4
20023c28:	f7ff f856 	bl	20022cd8 <HAL_FLASH_CFG_AHB_RCMD>
20023c2c:	03b2      	lsls	r2, r6, #14
20023c2e:	f8d4 b010 	ldr.w	fp, [r4, #16]
20023c32:	d504      	bpl.n	20023c3e <HAL_NAND_READ_WITHOOB+0xfa>
20023c34:	f894 202f 	ldrb.w	r2, [r4, #47]	@ 0x2f
20023c38:	b10a      	cbz	r2, 20023c3e <HAL_NAND_READ_WITHOOB+0xfa>
20023c3a:	f44b 5b80 	orr.w	fp, fp, #4096	@ 0x1000
20023c3e:	ea49 0205 	orr.w	r2, r9, r5
20023c42:	ea42 020a 	orr.w	r2, r2, sl
20023c46:	0793      	lsls	r3, r2, #30
20023c48:	d102      	bne.n	20023c50 <HAL_NAND_READ_WITHOOB+0x10c>
20023c4a:	1e6a      	subs	r2, r5, #1
20023c4c:	2afe      	cmp	r2, #254	@ 0xfe
20023c4e:	d821      	bhi.n	20023c94 <HAL_NAND_READ_WITHOOB+0x150>
20023c50:	462a      	mov	r2, r5
20023c52:	4648      	mov	r0, r9
20023c54:	eb0b 010a 	add.w	r1, fp, sl
20023c58:	f006 ff16 	bl	2002aa88 <memcpy>
20023c5c:	e01d      	b.n	20023c9a <HAL_NAND_READ_WITHOOB+0x156>
20023c5e:	f893 106a 	ldrb.w	r1, [r3, #106]	@ 0x6a
20023c62:	4620      	mov	r0, r4
20023c64:	f7ff f82d 	bl	20022cc2 <HAL_FLASH_SET_AHB_RCMD>
20023c68:	68e0      	ldr	r0, [r4, #12]
20023c6a:	f990 c072 	ldrsb.w	ip, [r0, #114]	@ 0x72
20023c6e:	f990 306e 	ldrsb.w	r3, [r0, #110]	@ 0x6e
20023c72:	f990 206d 	ldrsb.w	r2, [r0, #109]	@ 0x6d
20023c76:	f990 106c 	ldrsb.w	r1, [r0, #108]	@ 0x6c
20023c7a:	f8cd c00c 	str.w	ip, [sp, #12]
20023c7e:	f990 c071 	ldrsb.w	ip, [r0, #113]	@ 0x71
20023c82:	f8cd c008 	str.w	ip, [sp, #8]
20023c86:	f990 c070 	ldrsb.w	ip, [r0, #112]	@ 0x70
20023c8a:	f8cd c004 	str.w	ip, [sp, #4]
20023c8e:	f990 006f 	ldrsb.w	r0, [r0, #111]	@ 0x6f
20023c92:	e7c7      	b.n	20023c24 <HAL_NAND_READ_WITHOOB+0xe0>
20023c94:	f1b9 0f00 	cmp.w	r9, #0
20023c98:	d1da      	bne.n	20023c50 <HAL_NAND_READ_WITHOOB+0x10c>
20023c9a:	9b0e      	ldr	r3, [sp, #56]	@ 0x38
20023c9c:	b12b      	cbz	r3, 20023caa <HAL_NAND_READ_WITHOOB+0x166>
20023c9e:	463a      	mov	r2, r7
20023ca0:	4618      	mov	r0, r3
20023ca2:	eb0b 0108 	add.w	r1, fp, r8
20023ca6:	f006 feef 	bl	2002aa88 <memcpy>
20023caa:	1978      	adds	r0, r7, r5
20023cac:	e767      	b.n	20023b7e <HAL_NAND_READ_WITHOOB+0x3a>

20023cae <HAL_NAND_BLOCK_SIZE>:
20023cae:	b508      	push	{r3, lr}
20023cb0:	4602      	mov	r2, r0
20023cb2:	f7ff ff3c 	bl	20023b2e <HAL_NAND_PAGE_SIZE>
20023cb6:	b128      	cbz	r0, 20023cc4 <HAL_NAND_BLOCK_SIZE+0x16>
20023cb8:	f892 302c 	ldrb.w	r3, [r2, #44]	@ 0x2c
20023cbc:	079b      	lsls	r3, r3, #30
20023cbe:	bf4c      	ite	mi
20023cc0:	01c0      	lslmi	r0, r0, #7
20023cc2:	0180      	lslpl	r0, r0, #6
20023cc4:	bd08      	pop	{r3, pc}

20023cc6 <HAL_NAND_GET_BADBLK>:
20023cc6:	b51f      	push	{r0, r1, r2, r3, r4, lr}
20023cc8:	4604      	mov	r4, r0
20023cca:	b910      	cbnz	r0, 20023cd2 <HAL_NAND_GET_BADBLK+0xc>
20023ccc:	2000      	movs	r0, #0
20023cce:	b004      	add	sp, #16
20023cd0:	bd10      	pop	{r4, pc}
20023cd2:	6a03      	ldr	r3, [r0, #32]
20023cd4:	2b00      	cmp	r3, #0
20023cd6:	d0f9      	beq.n	20023ccc <HAL_NAND_GET_BADBLK+0x6>
20023cd8:	f7ff ffe9 	bl	20023cae <HAL_NAND_BLOCK_SIZE>
20023cdc:	2304      	movs	r3, #4
20023cde:	9301      	str	r3, [sp, #4]
20023ce0:	ab03      	add	r3, sp, #12
20023ce2:	9300      	str	r3, [sp, #0]
20023ce4:	2300      	movs	r3, #0
20023ce6:	4341      	muls	r1, r0
20023ce8:	461a      	mov	r2, r3
20023cea:	4620      	mov	r0, r4
20023cec:	f7ff ff2a 	bl	20023b44 <HAL_NAND_READ_WITHOOB>
20023cf0:	b140      	cbz	r0, 20023d04 <HAL_NAND_GET_BADBLK+0x3e>
20023cf2:	f89d 300c 	ldrb.w	r3, [sp, #12]
20023cf6:	2bff      	cmp	r3, #255	@ 0xff
20023cf8:	d0e8      	beq.n	20023ccc <HAL_NAND_GET_BADBLK+0x6>
20023cfa:	9803      	ldr	r0, [sp, #12]
20023cfc:	2800      	cmp	r0, #0
20023cfe:	bf08      	it	eq
20023d00:	2001      	moveq	r0, #1
20023d02:	e7e4      	b.n	20023cce <HAL_NAND_GET_BADBLK+0x8>
20023d04:	2001      	movs	r0, #1
20023d06:	e7e2      	b.n	20023cce <HAL_NAND_GET_BADBLK+0x8>

20023d08 <HAL_QSPIEX_WRITE_PAGE>:
20023d08:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
20023d0c:	b099      	sub	sp, #100	@ 0x64
20023d0e:	4604      	mov	r4, r0
20023d10:	460e      	mov	r6, r1
20023d12:	4691      	mov	r9, r2
20023d14:	f7ff fcfb 	bl	2002370e <flash_handle_valid>
20023d18:	b318      	cbz	r0, 20023d62 <HAL_QSPIEX_WRITE_PAGE+0x5a>
20023d1a:	2b00      	cmp	r3, #0
20023d1c:	f000 80d7 	beq.w	20023ece <HAL_QSPIEX_WRITE_PAGE+0x1c6>
20023d20:	f5b3 7f80 	cmp.w	r3, #256	@ 0x100
20023d24:	bf28      	it	cs
20023d26:	f44f 7380 	movcs.w	r3, #256	@ 0x100
20023d2a:	68a1      	ldr	r1, [r4, #8]
20023d2c:	461d      	mov	r5, r3
20023d2e:	6962      	ldr	r2, [r4, #20]
20023d30:	f894 3028 	ldrb.w	r3, [r4, #40]	@ 0x28
20023d34:	2900      	cmp	r1, #0
20023d36:	d03b      	beq.n	20023db0 <HAL_QSPIEX_WRITE_PAGE+0xa8>
20023d38:	f1b2 7f80 	cmp.w	r2, #16777216	@ 0x1000000
20023d3c:	d914      	bls.n	20023d68 <HAL_QSPIEX_WRITE_PAGE+0x60>
20023d3e:	2b02      	cmp	r3, #2
20023d40:	bf14      	ite	ne
20023d42:	2727      	movne	r7, #39	@ 0x27
20023d44:	2728      	moveq	r7, #40	@ 0x28
20023d46:	4639      	mov	r1, r7
20023d48:	4620      	mov	r0, r4
20023d4a:	f7ff fa8a 	bl	20023262 <HAL_FLASH_PRE_CMD>
20023d4e:	4649      	mov	r1, r9
20023d50:	462b      	mov	r3, r5
20023d52:	2201      	movs	r2, #1
20023d54:	4620      	mov	r0, r4
20023d56:	f7ff fce2 	bl	2002371e <HAL_FLASH_DMA_START>
20023d5a:	4601      	mov	r1, r0
20023d5c:	b148      	cbz	r0, 20023d72 <HAL_QSPIEX_WRITE_PAGE+0x6a>
20023d5e:	2500      	movs	r5, #0
20023d60:	4628      	mov	r0, r5
20023d62:	b019      	add	sp, #100	@ 0x64
20023d64:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
20023d68:	2b02      	cmp	r3, #2
20023d6a:	bf14      	ite	ne
20023d6c:	2716      	movne	r7, #22
20023d6e:	2717      	moveq	r7, #23
20023d70:	e7e9      	b.n	20023d46 <HAL_QSPIEX_WRITE_PAGE+0x3e>
20023d72:	4632      	mov	r2, r6
20023d74:	4620      	mov	r0, r4
20023d76:	f7ff fa9b 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
20023d7a:	2101      	movs	r1, #1
20023d7c:	4620      	mov	r0, r4
20023d7e:	f7ff f802 	bl	20022d86 <HAL_FLASH_WRITE_DLEN2>
20023d82:	2301      	movs	r3, #1
20023d84:	4632      	mov	r2, r6
20023d86:	9300      	str	r3, [sp, #0]
20023d88:	4639      	mov	r1, r7
20023d8a:	2302      	movs	r3, #2
20023d8c:	4620      	mov	r0, r4
20023d8e:	f7ff fac2 	bl	20023316 <HAL_FLASH_ISSUE_CMD_SEQ>
20023d92:	2800      	cmp	r0, #0
20023d94:	d1e3      	bne.n	20023d5e <HAL_QSPIEX_WRITE_PAGE+0x56>
20023d96:	f44f 717a 	mov.w	r1, #1000	@ 0x3e8
20023d9a:	4620      	mov	r0, r4
20023d9c:	f7ff fd0f 	bl	200237be <HAL_FLASH_DMA_WAIT_DONE>
20023da0:	2800      	cmp	r0, #0
20023da2:	d1dc      	bne.n	20023d5e <HAL_QSPIEX_WRITE_PAGE+0x56>
20023da4:	6822      	ldr	r2, [r4, #0]
20023da6:	6813      	ldr	r3, [r2, #0]
20023da8:	f023 0320 	bic.w	r3, r3, #32
20023dac:	6013      	str	r3, [r2, #0]
20023dae:	e7d7      	b.n	20023d60 <HAL_QSPIEX_WRITE_PAGE+0x58>
20023db0:	f1b2 7f80 	cmp.w	r2, #16777216	@ 0x1000000
20023db4:	f240 8082 	bls.w	20023ebc <HAL_QSPIEX_WRITE_PAGE+0x1b4>
20023db8:	2b02      	cmp	r3, #2
20023dba:	bf14      	ite	ne
20023dbc:	2327      	movne	r3, #39	@ 0x27
20023dbe:	2328      	moveq	r3, #40	@ 0x28
20023dc0:	462f      	mov	r7, r5
20023dc2:	f04f 0800 	mov.w	r8, #0
20023dc6:	9303      	str	r3, [sp, #12]
20023dc8:	f64f 7afc 	movw	sl, #65532	@ 0xfffc
20023dcc:	2f40      	cmp	r7, #64	@ 0x40
20023dce:	bfd4      	ite	le
20023dd0:	ea0a 0a07 	andle.w	sl, sl, r7
20023dd4:	f00a 0a40 	andgt.w	sl, sl, #64	@ 0x40
20023dd8:	f1ba 0f00 	cmp.w	sl, #0
20023ddc:	d03f      	beq.n	20023e5e <HAL_QSPIEX_WRITE_PAGE+0x156>
20023dde:	2200      	movs	r2, #0
20023de0:	4620      	mov	r0, r4
20023de2:	4611      	mov	r1, r2
20023de4:	f7ff fa64 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
20023de8:	eb09 0308 	add.w	r3, r9, r8
20023dec:	f10d 0c20 	add.w	ip, sp, #32
20023df0:	f103 0e40 	add.w	lr, r3, #64	@ 0x40
20023df4:	4662      	mov	r2, ip
20023df6:	6818      	ldr	r0, [r3, #0]
20023df8:	6859      	ldr	r1, [r3, #4]
20023dfa:	3308      	adds	r3, #8
20023dfc:	c203      	stmia	r2!, {r0, r1}
20023dfe:	4573      	cmp	r3, lr
20023e00:	4694      	mov	ip, r2
20023e02:	d1f7      	bne.n	20023df4 <HAL_QSPIEX_WRITE_PAGE+0xec>
20023e04:	f04f 0b00 	mov.w	fp, #0
20023e08:	ea4f 02aa 	mov.w	r2, sl, asr #2
20023e0c:	ab08      	add	r3, sp, #32
20023e0e:	f853 1b04 	ldr.w	r1, [r3], #4
20023e12:	4620      	mov	r0, r4
20023e14:	9205      	str	r2, [sp, #20]
20023e16:	9304      	str	r3, [sp, #16]
20023e18:	f7fe ffa4 	bl	20022d64 <HAL_FLASH_WRITE_WORD>
20023e1c:	9a05      	ldr	r2, [sp, #20]
20023e1e:	f10b 0b01 	add.w	fp, fp, #1
20023e22:	4593      	cmp	fp, r2
20023e24:	9b04      	ldr	r3, [sp, #16]
20023e26:	d1f2      	bne.n	20023e0e <HAL_QSPIEX_WRITE_PAGE+0x106>
20023e28:	4651      	mov	r1, sl
20023e2a:	4620      	mov	r0, r4
20023e2c:	f7fe ffa1 	bl	20022d72 <HAL_FLASH_WRITE_DLEN>
20023e30:	4620      	mov	r0, r4
20023e32:	9903      	ldr	r1, [sp, #12]
20023e34:	eb06 0208 	add.w	r2, r6, r8
20023e38:	f7ff fa3a 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
20023e3c:	2101      	movs	r1, #1
20023e3e:	4620      	mov	r0, r4
20023e40:	f7fe ff97 	bl	20022d72 <HAL_FLASH_WRITE_DLEN>
20023e44:	2200      	movs	r2, #0
20023e46:	2102      	movs	r1, #2
20023e48:	4620      	mov	r0, r4
20023e4a:	f7ff fa31 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
20023e4e:	4620      	mov	r0, r4
20023e50:	f7fe ffdc 	bl	20022e0c <HAL_FLASH_IS_PROG_DONE>
20023e54:	2800      	cmp	r0, #0
20023e56:	d0f1      	beq.n	20023e3c <HAL_QSPIEX_WRITE_PAGE+0x134>
20023e58:	eba7 070a 	sub.w	r7, r7, sl
20023e5c:	44d0      	add	r8, sl
20023e5e:	1e7b      	subs	r3, r7, #1
20023e60:	2b02      	cmp	r3, #2
20023e62:	d830      	bhi.n	20023ec6 <HAL_QSPIEX_WRITE_PAGE+0x1be>
20023e64:	6923      	ldr	r3, [r4, #16]
20023e66:	4446      	add	r6, r8
20023e68:	4333      	orrs	r3, r6
20023e6a:	681b      	ldr	r3, [r3, #0]
20023e6c:	463a      	mov	r2, r7
20023e6e:	eb09 0108 	add.w	r1, r9, r8
20023e72:	a807      	add	r0, sp, #28
20023e74:	9307      	str	r3, [sp, #28]
20023e76:	f006 fe07 	bl	2002aa88 <memcpy>
20023e7a:	2200      	movs	r2, #0
20023e7c:	4620      	mov	r0, r4
20023e7e:	4611      	mov	r1, r2
20023e80:	f7ff fa16 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
20023e84:	9907      	ldr	r1, [sp, #28]
20023e86:	4620      	mov	r0, r4
20023e88:	f7fe ff6c 	bl	20022d64 <HAL_FLASH_WRITE_WORD>
20023e8c:	2104      	movs	r1, #4
20023e8e:	4620      	mov	r0, r4
20023e90:	f7fe ff6f 	bl	20022d72 <HAL_FLASH_WRITE_DLEN>
20023e94:	4632      	mov	r2, r6
20023e96:	4620      	mov	r0, r4
20023e98:	9903      	ldr	r1, [sp, #12]
20023e9a:	f7ff fa09 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
20023e9e:	2101      	movs	r1, #1
20023ea0:	4620      	mov	r0, r4
20023ea2:	f7fe ff66 	bl	20022d72 <HAL_FLASH_WRITE_DLEN>
20023ea6:	2200      	movs	r2, #0
20023ea8:	2102      	movs	r1, #2
20023eaa:	4620      	mov	r0, r4
20023eac:	f7ff fa00 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
20023eb0:	4620      	mov	r0, r4
20023eb2:	f7fe ffab 	bl	20022e0c <HAL_FLASH_IS_PROG_DONE>
20023eb6:	2800      	cmp	r0, #0
20023eb8:	d0f1      	beq.n	20023e9e <HAL_QSPIEX_WRITE_PAGE+0x196>
20023eba:	e751      	b.n	20023d60 <HAL_QSPIEX_WRITE_PAGE+0x58>
20023ebc:	2b02      	cmp	r3, #2
20023ebe:	bf14      	ite	ne
20023ec0:	2316      	movne	r3, #22
20023ec2:	2317      	moveq	r3, #23
20023ec4:	e77c      	b.n	20023dc0 <HAL_QSPIEX_WRITE_PAGE+0xb8>
20023ec6:	2f00      	cmp	r7, #0
20023ec8:	f73f af7e 	bgt.w	20023dc8 <HAL_QSPIEX_WRITE_PAGE+0xc0>
20023ecc:	e748      	b.n	20023d60 <HAL_QSPIEX_WRITE_PAGE+0x58>
20023ece:	4618      	mov	r0, r3
20023ed0:	e747      	b.n	20023d62 <HAL_QSPIEX_WRITE_PAGE+0x5a>

20023ed2 <HAL_QSPIEX_SECT_ERASE>:
20023ed2:	b573      	push	{r0, r1, r4, r5, r6, lr}
20023ed4:	4604      	mov	r4, r0
20023ed6:	460d      	mov	r5, r1
20023ed8:	f7ff fc19 	bl	2002370e <flash_handle_valid>
20023edc:	b1e8      	cbz	r0, 20023f1a <HAL_QSPIEX_SECT_ERASE+0x48>
20023ede:	6963      	ldr	r3, [r4, #20]
20023ee0:	460a      	mov	r2, r1
20023ee2:	f1b3 7f80 	cmp.w	r3, #16777216	@ 0x1000000
20023ee6:	f04f 0100 	mov.w	r1, #0
20023eea:	4620      	mov	r0, r4
20023eec:	bf94      	ite	ls
20023eee:	261b      	movls	r6, #27
20023ef0:	2629      	movhi	r6, #41	@ 0x29
20023ef2:	f7ff f9dd 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
20023ef6:	2101      	movs	r1, #1
20023ef8:	4620      	mov	r0, r4
20023efa:	f7fe ff44 	bl	20022d86 <HAL_FLASH_WRITE_DLEN2>
20023efe:	2301      	movs	r3, #1
20023f00:	462a      	mov	r2, r5
20023f02:	9300      	str	r3, [sp, #0]
20023f04:	4631      	mov	r1, r6
20023f06:	2302      	movs	r3, #2
20023f08:	4620      	mov	r0, r4
20023f0a:	f7ff fa04 	bl	20023316 <HAL_FLASH_ISSUE_CMD_SEQ>
20023f0e:	3800      	subs	r0, #0
20023f10:	bf18      	it	ne
20023f12:	2001      	movne	r0, #1
20023f14:	4240      	negs	r0, r0
20023f16:	b002      	add	sp, #8
20023f18:	bd70      	pop	{r4, r5, r6, pc}
20023f1a:	f04f 30ff 	mov.w	r0, #4294967295
20023f1e:	e7fa      	b.n	20023f16 <HAL_QSPIEX_SECT_ERASE+0x44>

20023f20 <HAL_QSPI_GET_SRC_CLK>:
20023f20:	b508      	push	{r3, lr}
20023f22:	b1e8      	cbz	r0, 20023f60 <HAL_QSPI_GET_SRC_CLK+0x40>
20023f24:	6803      	ldr	r3, [r0, #0]
20023f26:	4a0f      	ldr	r2, [pc, #60]	@ (20023f64 <HAL_QSPI_GET_SRC_CLK+0x44>)
20023f28:	4293      	cmp	r3, r2
20023f2a:	d00c      	beq.n	20023f46 <HAL_QSPI_GET_SRC_CLK+0x26>
20023f2c:	f502 5280 	add.w	r2, r2, #4096	@ 0x1000
20023f30:	4293      	cmp	r3, r2
20023f32:	d115      	bne.n	20023f60 <HAL_QSPI_GET_SRC_CLK+0x40>
20023f34:	2006      	movs	r0, #6
20023f36:	f001 f875 	bl	20025024 <HAL_RCC_HCPU_GetClockSrc>
20023f3a:	2802      	cmp	r0, #2
20023f3c:	d105      	bne.n	20023f4a <HAL_QSPI_GET_SRC_CLK+0x2a>
20023f3e:	e8bd 4008 	ldmia.w	sp!, {r3, lr}
20023f42:	f001 b8a4 	b.w	2002508e <HAL_RCC_HCPU_GetDLL2Freq>
20023f46:	2004      	movs	r0, #4
20023f48:	e7f5      	b.n	20023f36 <HAL_QSPI_GET_SRC_CLK+0x16>
20023f4a:	2803      	cmp	r0, #3
20023f4c:	d103      	bne.n	20023f56 <HAL_QSPI_GET_SRC_CLK+0x36>
20023f4e:	e8bd 4008 	ldmia.w	sp!, {r3, lr}
20023f52:	f001 b89f 	b.w	20025094 <HAL_RCC_HCPU_GetDLL3Freq>
20023f56:	2001      	movs	r0, #1
20023f58:	e8bd 4008 	ldmia.w	sp!, {r3, lr}
20023f5c:	f001 b8fe 	b.w	2002515c <HAL_RCC_GetSysCLKFreq>
20023f60:	2000      	movs	r0, #0
20023f62:	bd08      	pop	{r3, pc}
20023f64:	50041000 	.word	0x50041000

20023f68 <HAL_QSPI_GET_CLK>:
20023f68:	b538      	push	{r3, r4, r5, lr}
20023f6a:	4605      	mov	r5, r0
20023f6c:	b908      	cbnz	r0, 20023f72 <HAL_QSPI_GET_CLK+0xa>
20023f6e:	2000      	movs	r0, #0
20023f70:	bd38      	pop	{r3, r4, r5, pc}
20023f72:	f7fe ff63 	bl	20022e3c <HAL_FLASH_GET_DIV>
20023f76:	4604      	mov	r4, r0
20023f78:	2800      	cmp	r0, #0
20023f7a:	d0f8      	beq.n	20023f6e <HAL_QSPI_GET_CLK+0x6>
20023f7c:	4628      	mov	r0, r5
20023f7e:	f7ff ffcf 	bl	20023f20 <HAL_QSPI_GET_SRC_CLK>
20023f82:	fbb0 f0f4 	udiv	r0, r0, r4
20023f86:	e7f3      	b.n	20023f70 <HAL_QSPI_GET_CLK+0x8>

20023f88 <HAL_QSPI_READ_ID>:
20023f88:	b138      	cbz	r0, 20023f9a <HAL_QSPI_READ_ID+0x12>
20023f8a:	f890 302b 	ldrb.w	r3, [r0, #43]	@ 0x2b
20023f8e:	b113      	cbz	r3, 20023f96 <HAL_QSPI_READ_ID+0xe>
20023f90:	2100      	movs	r1, #0
20023f92:	f7ff bc60 	b.w	20023856 <nand_read_id>
20023f96:	f7ff bae0 	b.w	2002355a <HAL_FLASH_GET_NOR_ID>
20023f9a:	20ff      	movs	r0, #255	@ 0xff
20023f9c:	4770      	bx	lr

20023f9e <HAL_NOR_CFG_DTR>:
20023f9e:	b57f      	push	{r0, r1, r2, r3, r4, r5, r6, lr}
20023fa0:	4604      	mov	r4, r0
20023fa2:	460a      	mov	r2, r1
20023fa4:	b351      	cbz	r1, 20023ffc <HAL_NOR_CFG_DTR+0x5e>
20023fa6:	68c5      	ldr	r5, [r0, #12]
20023fa8:	f895 31ff 	ldrb.w	r3, [r5, #511]	@ 0x1ff
20023fac:	2b00      	cmp	r3, #0
20023fae:	d03b      	beq.n	20024028 <HAL_NOR_CFG_DTR+0x8a>
20023fb0:	f890 3028 	ldrb.w	r3, [r0, #40]	@ 0x28
20023fb4:	b3c3      	cbz	r3, 20024028 <HAL_NOR_CFG_DTR+0x8a>
20023fb6:	f995 6207 	ldrsb.w	r6, [r5, #519]	@ 0x207
20023fba:	f995 2202 	ldrsb.w	r2, [r5, #514]	@ 0x202
20023fbe:	f995 3203 	ldrsb.w	r3, [r5, #515]	@ 0x203
20023fc2:	f995 1201 	ldrsb.w	r1, [r5, #513]	@ 0x201
20023fc6:	9603      	str	r6, [sp, #12]
20023fc8:	f995 6206 	ldrsb.w	r6, [r5, #518]	@ 0x206
20023fcc:	9602      	str	r6, [sp, #8]
20023fce:	f995 6205 	ldrsb.w	r6, [r5, #517]	@ 0x205
20023fd2:	9601      	str	r6, [sp, #4]
20023fd4:	f995 5204 	ldrsb.w	r5, [r5, #516]	@ 0x204
20023fd8:	9500      	str	r5, [sp, #0]
20023fda:	f7fe fe7d 	bl	20022cd8 <HAL_FLASH_CFG_AHB_RCMD>
20023fde:	68e3      	ldr	r3, [r4, #12]
20023fe0:	4620      	mov	r0, r4
20023fe2:	f893 11ff 	ldrb.w	r1, [r3, #511]	@ 0x1ff
20023fe6:	f7fe fe6c 	bl	20022cc2 <HAL_FLASH_SET_AHB_RCMD>
20023fea:	2101      	movs	r1, #1
20023fec:	4620      	mov	r0, r4
20023fee:	f894 202d 	ldrb.w	r2, [r4, #45]	@ 0x2d
20023ff2:	f7ff f87d 	bl	200230f0 <HAL_MPI_CFG_DTR>
20023ff6:	2000      	movs	r0, #0
20023ff8:	b004      	add	sp, #16
20023ffa:	bd70      	pop	{r4, r5, r6, pc}
20023ffc:	f7ff f878 	bl	200230f0 <HAL_MPI_CFG_DTR>
20024000:	6963      	ldr	r3, [r4, #20]
20024002:	f894 1028 	ldrb.w	r1, [r4, #40]	@ 0x28
20024006:	f1b3 7f80 	cmp.w	r3, #16777216	@ 0x1000000
2002400a:	d906      	bls.n	2002401a <HAL_NOR_CFG_DTR+0x7c>
2002400c:	b919      	cbnz	r1, 20024016 <HAL_NOR_CFG_DTR+0x78>
2002400e:	4620      	mov	r0, r4
20024010:	f7ff f8ea 	bl	200231e8 <HAL_FLASH_CONFIG_FULL_AHB_READ>
20024014:	e7ef      	b.n	20023ff6 <HAL_NOR_CFG_DTR+0x58>
20024016:	2101      	movs	r1, #1
20024018:	e7f9      	b.n	2002400e <HAL_NOR_CFG_DTR+0x70>
2002401a:	b919      	cbnz	r1, 20024024 <HAL_NOR_CFG_DTR+0x86>
2002401c:	4620      	mov	r0, r4
2002401e:	f7ff f89f 	bl	20023160 <HAL_FLASH_CONFIG_AHB_READ>
20024022:	e7e8      	b.n	20023ff6 <HAL_NOR_CFG_DTR+0x58>
20024024:	2101      	movs	r1, #1
20024026:	e7f9      	b.n	2002401c <HAL_NOR_CFG_DTR+0x7e>
20024028:	2001      	movs	r0, #1
2002402a:	e7e5      	b.n	20023ff8 <HAL_NOR_CFG_DTR+0x5a>

2002402c <HAL_NOR_DTR_CAL>:
2002402c:	b510      	push	{r4, lr}
2002402e:	4604      	mov	r4, r0
20024030:	b1f0      	cbz	r0, 20024070 <HAL_NOR_DTR_CAL+0x44>
20024032:	6802      	ldr	r2, [r0, #0]
20024034:	2014      	movs	r0, #20
20024036:	f8d2 3094 	ldr.w	r3, [r2, #148]	@ 0x94
2002403a:	f043 4300 	orr.w	r3, r3, #2147483648	@ 0x80000000
2002403e:	f8c2 3094 	str.w	r3, [r2, #148]	@ 0x94
20024042:	f7fe f8da 	bl	200221fa <HAL_Delay_us>
20024046:	6823      	ldr	r3, [r4, #0]
20024048:	f8d3 2094 	ldr.w	r2, [r3, #148]	@ 0x94
2002404c:	05d2      	lsls	r2, r2, #23
2002404e:	d5fb      	bpl.n	20024048 <HAL_NOR_DTR_CAL+0x1c>
20024050:	f8d3 0094 	ldr.w	r0, [r3, #148]	@ 0x94
20024054:	f8d3 2094 	ldr.w	r2, [r3, #148]	@ 0x94
20024058:	b2c0      	uxtb	r0, r0
2002405a:	f022 4200 	bic.w	r2, r2, #2147483648	@ 0x80000000
2002405e:	f8c3 2094 	str.w	r2, [r3, #148]	@ 0x94
20024062:	f894 302d 	ldrb.w	r3, [r4, #45]	@ 0x2d
20024066:	f023 037f 	bic.w	r3, r3, #127	@ 0x7f
2002406a:	4303      	orrs	r3, r0
2002406c:	f884 302d 	strb.w	r3, [r4, #45]	@ 0x2d
20024070:	bd10      	pop	{r4, pc}
	...

20024074 <HAL_FLASH_Init>:
20024074:	e92d 43f0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, lr}
20024078:	460e      	mov	r6, r1
2002407a:	4690      	mov	r8, r2
2002407c:	461f      	mov	r7, r3
2002407e:	4604      	mov	r4, r0
20024080:	b087      	sub	sp, #28
20024082:	2800      	cmp	r0, #0
20024084:	f000 80e5 	beq.w	20024252 <HAL_FLASH_Init+0x1de>
20024088:	2900      	cmp	r1, #0
2002408a:	f000 80e2 	beq.w	20024252 <HAL_FLASH_Init+0x1de>
2002408e:	f7fe fdf7 	bl	20022c80 <HAL_QSPI_Init>
20024092:	6820      	ldr	r0, [r4, #0]
20024094:	f7ff fb41 	bl	2002371a <HAL_GET_FLASH_MID>
20024098:	6933      	ldr	r3, [r6, #16]
2002409a:	2100      	movs	r1, #0
2002409c:	f884 3044 	strb.w	r3, [r4, #68]	@ 0x44
200240a0:	68b3      	ldr	r3, [r6, #8]
200240a2:	4605      	mov	r5, r0
200240a4:	64a3      	str	r3, [r4, #72]	@ 0x48
200240a6:	68f3      	ldr	r3, [r6, #12]
200240a8:	f884 102c 	strb.w	r1, [r4, #44]	@ 0x2c
200240ac:	051b      	lsls	r3, r3, #20
200240ae:	64e3      	str	r3, [r4, #76]	@ 0x4c
200240b0:	2302      	movs	r3, #2
200240b2:	f884 3046 	strb.w	r3, [r4, #70]	@ 0x46
200240b6:	6933      	ldr	r3, [r6, #16]
200240b8:	f8c4 8008 	str.w	r8, [r4, #8]
200240bc:	1e5a      	subs	r2, r3, #1
200240be:	4253      	negs	r3, r2
200240c0:	4153      	adcs	r3, r2
200240c2:	f884 302b 	strb.w	r3, [r4, #43]	@ 0x2b
200240c6:	f1b8 0f00 	cmp.w	r8, #0
200240ca:	d058      	beq.n	2002417e <HAL_FLASH_Init+0x10a>
200240cc:	2f00      	cmp	r7, #0
200240ce:	d056      	beq.n	2002417e <HAL_FLASH_Init+0x10a>
200240d0:	683b      	ldr	r3, [r7, #0]
200240d2:	f8c8 3000 	str.w	r3, [r8]
200240d6:	68a3      	ldr	r3, [r4, #8]
200240d8:	68fa      	ldr	r2, [r7, #12]
200240da:	605a      	str	r2, [r3, #4]
200240dc:	2210      	movs	r2, #16
200240de:	68a3      	ldr	r3, [r4, #8]
200240e0:	609a      	str	r2, [r3, #8]
200240e2:	2280      	movs	r2, #128	@ 0x80
200240e4:	68a3      	ldr	r3, [r4, #8]
200240e6:	60d9      	str	r1, [r3, #12]
200240e8:	68a3      	ldr	r3, [r4, #8]
200240ea:	611a      	str	r2, [r3, #16]
200240ec:	f44f 5280 	mov.w	r2, #4096	@ 0x1000
200240f0:	68a3      	ldr	r3, [r4, #8]
200240f2:	6159      	str	r1, [r3, #20]
200240f4:	68a3      	ldr	r3, [r4, #8]
200240f6:	6199      	str	r1, [r3, #24]
200240f8:	68a3      	ldr	r3, [r4, #8]
200240fa:	61d9      	str	r1, [r3, #28]
200240fc:	68a3      	ldr	r3, [r4, #8]
200240fe:	621a      	str	r2, [r3, #32]
20024100:	68a3      	ldr	r3, [r4, #8]
20024102:	6259      	str	r1, [r3, #36]	@ 0x24
20024104:	b1c0      	cbz	r0, 20024138 <HAL_FLASH_Init+0xc4>
20024106:	f06f 437f 	mvn.w	r3, #4278190080	@ 0xff000000
2002410a:	4298      	cmp	r0, r3
2002410c:	d014      	beq.n	20024138 <HAL_FLASH_Init+0xc4>
2002410e:	2701      	movs	r7, #1
20024110:	f894 302b 	ldrb.w	r3, [r4, #43]	@ 0x2b
20024114:	2b00      	cmp	r3, #0
20024116:	d13d      	bne.n	20024194 <HAL_FLASH_Init+0x120>
20024118:	2f00      	cmp	r7, #0
2002411a:	d15a      	bne.n	200241d2 <HAL_FLASH_Init+0x15e>
2002411c:	4620      	mov	r0, r4
2002411e:	f7ff fad6 	bl	200236ce <HAL_FLASH_RELEASE_DPD>
20024122:	4638      	mov	r0, r7
20024124:	f7fe f869 	bl	200221fa <HAL_Delay_us>
20024128:	2032      	movs	r0, #50	@ 0x32
2002412a:	f7fe f866 	bl	200221fa <HAL_Delay_us>
2002412e:	4620      	mov	r0, r4
20024130:	f7ff ff2a 	bl	20023f88 <HAL_QSPI_READ_ID>
20024134:	4605      	mov	r5, r0
20024136:	e04c      	b.n	200241d2 <HAL_FLASH_Init+0x15e>
20024138:	2101      	movs	r1, #1
2002413a:	4620      	mov	r0, r4
2002413c:	f7fe fe73 	bl	20022e26 <HAL_FLASH_SET_TXSLOT>
20024140:	4bb3      	ldr	r3, [pc, #716]	@ (20024410 <HAL_FLASH_Init+0x39c>)
20024142:	69a2      	ldr	r2, [r4, #24]
20024144:	4620      	mov	r0, r4
20024146:	429a      	cmp	r2, r3
20024148:	f04f 0200 	mov.w	r2, #0
2002414c:	bf8c      	ite	hi
2002414e:	2101      	movhi	r1, #1
20024150:	4611      	movls	r1, r2
20024152:	f7ff faad 	bl	200236b0 <HAL_QSPI_SET_CLK_INV>
20024156:	4620      	mov	r0, r4
20024158:	f89d 1038 	ldrb.w	r1, [sp, #56]	@ 0x38
2002415c:	f7fe fe6a 	bl	20022e34 <HAL_FLASH_SET_CLK_rom>
20024160:	f894 3045 	ldrb.w	r3, [r4, #69]	@ 0x45
20024164:	b12b      	cbz	r3, 20024172 <HAL_FLASH_Init+0xfe>
20024166:	2b01      	cmp	r3, #1
20024168:	d110      	bne.n	2002418c <HAL_FLASH_Init+0x118>
2002416a:	2100      	movs	r1, #0
2002416c:	4620      	mov	r0, r4
2002416e:	f7fe ff79 	bl	20023064 <HAL_FLASH_SET_DUAL_MODE>
20024172:	2101      	movs	r1, #1
20024174:	4620      	mov	r0, r4
20024176:	f7fe ff02 	bl	20022f7e <HAL_FLASH_ENABLE_QSPI>
2002417a:	2700      	movs	r7, #0
2002417c:	e7c8      	b.n	20024110 <HAL_FLASH_Init+0x9c>
2002417e:	2d00      	cmp	r5, #0
20024180:	d0de      	beq.n	20024140 <HAL_FLASH_Init+0xcc>
20024182:	f06f 437f 	mvn.w	r3, #4278190080	@ 0xff000000
20024186:	429d      	cmp	r5, r3
20024188:	d1c1      	bne.n	2002410e <HAL_FLASH_Init+0x9a>
2002418a:	e7d9      	b.n	20024140 <HAL_FLASH_Init+0xcc>
2002418c:	2b02      	cmp	r3, #2
2002418e:	d1f0      	bne.n	20024172 <HAL_FLASH_Init+0xfe>
20024190:	2101      	movs	r1, #1
20024192:	e7eb      	b.n	2002416c <HAL_FLASH_Init+0xf8>
20024194:	6822      	ldr	r2, [r4, #0]
20024196:	2600      	movs	r6, #0
20024198:	6893      	ldr	r3, [r2, #8]
2002419a:	4631      	mov	r1, r6
2002419c:	f043 7370 	orr.w	r3, r3, #62914560	@ 0x3c00000
200241a0:	6093      	str	r3, [r2, #8]
200241a2:	2301      	movs	r3, #1
200241a4:	4632      	mov	r2, r6
200241a6:	4620      	mov	r0, r4
200241a8:	e9cd 6303 	strd	r6, r3, [sp, #12]
200241ac:	e9cd 6601 	strd	r6, r6, [sp, #4]
200241b0:	4633      	mov	r3, r6
200241b2:	9600      	str	r6, [sp, #0]
200241b4:	f7fe fe47 	bl	20022e46 <HAL_FLASH_MANUAL_CMD>
200241b8:	4632      	mov	r2, r6
200241ba:	21ff      	movs	r1, #255	@ 0xff
200241bc:	4620      	mov	r0, r4
200241be:	f7fe fdfd 	bl	20022dbc <HAL_FLASH_SET_CMD>
200241c2:	4630      	mov	r0, r6
200241c4:	f7fe f819 	bl	200221fa <HAL_Delay_us>
200241c8:	20c8      	movs	r0, #200	@ 0xc8
200241ca:	f7fe f816 	bl	200221fa <HAL_Delay_us>
200241ce:	2f00      	cmp	r7, #0
200241d0:	d0ad      	beq.n	2002412e <HAL_FLASH_Init+0xba>
200241d2:	f894 302b 	ldrb.w	r3, [r4, #43]	@ 0x2b
200241d6:	b2ee      	uxtb	r6, r5
200241d8:	f3c5 2807 	ubfx	r8, r5, #8, #8
200241dc:	6425      	str	r5, [r4, #64]	@ 0x40
200241de:	f3c5 4507 	ubfx	r5, r5, #16, #8
200241e2:	4642      	mov	r2, r8
200241e4:	4629      	mov	r1, r5
200241e6:	4630      	mov	r0, r6
200241e8:	b3ab      	cbz	r3, 20024256 <HAL_FLASH_Init+0x1e2>
200241ea:	f001 f9fd 	bl	200255e8 <spi_nand_get_cmd_by_id>
200241ee:	60e0      	str	r0, [r4, #12]
200241f0:	bba0      	cbnz	r0, 2002425c <HAL_FLASH_Init+0x1e8>
200241f2:	f894 302b 	ldrb.w	r3, [r4, #43]	@ 0x2b
200241f6:	b32b      	cbz	r3, 20024244 <HAL_FLASH_Init+0x1d0>
200241f8:	2108      	movs	r1, #8
200241fa:	4620      	mov	r0, r4
200241fc:	f7ff fb2b 	bl	20023856 <nand_read_id>
20024200:	f3c0 2807 	ubfx	r8, r0, #8, #8
20024204:	f3c0 4507 	ubfx	r5, r0, #16, #8
20024208:	b2c6      	uxtb	r6, r0
2002420a:	6420      	str	r0, [r4, #64]	@ 0x40
2002420c:	4642      	mov	r2, r8
2002420e:	4629      	mov	r1, r5
20024210:	4630      	mov	r0, r6
20024212:	f001 f9e9 	bl	200255e8 <spi_nand_get_cmd_by_id>
20024216:	60e0      	str	r0, [r4, #12]
20024218:	bb00      	cbnz	r0, 2002425c <HAL_FLASH_Init+0x1e8>
2002421a:	210f      	movs	r1, #15
2002421c:	4620      	mov	r0, r4
2002421e:	f7ff fb1a 	bl	20023856 <nand_read_id>
20024222:	f3c0 2807 	ubfx	r8, r0, #8, #8
20024226:	f3c0 4507 	ubfx	r5, r0, #16, #8
2002422a:	b2c6      	uxtb	r6, r0
2002422c:	6420      	str	r0, [r4, #64]	@ 0x40
2002422e:	4642      	mov	r2, r8
20024230:	4629      	mov	r1, r5
20024232:	4630      	mov	r0, r6
20024234:	f001 f9d8 	bl	200255e8 <spi_nand_get_cmd_by_id>
20024238:	60e0      	str	r0, [r4, #12]
2002423a:	b978      	cbnz	r0, 2002425c <HAL_FLASH_Init+0x1e8>
2002423c:	f001 f9ec 	bl	20025618 <spi_nand_get_default_ctable>
20024240:	60e0      	str	r0, [r4, #12]
20024242:	b958      	cbnz	r0, 2002425c <HAL_FLASH_Init+0x1e8>
20024244:	2100      	movs	r1, #0
20024246:	4620      	mov	r0, r4
20024248:	f7fe fe99 	bl	20022f7e <HAL_FLASH_ENABLE_QSPI>
2002424c:	2300      	movs	r3, #0
2002424e:	e9c4 3312 	strd	r3, r3, [r4, #72]	@ 0x48
20024252:	2001      	movs	r0, #1
20024254:	e053      	b.n	200242fe <HAL_FLASH_Init+0x28a>
20024256:	f001 f969 	bl	2002552c <spi_flash_get_cmd_by_id>
2002425a:	e7c8      	b.n	200241ee <HAL_FLASH_Init+0x17a>
2002425c:	f894 302b 	ldrb.w	r3, [r4, #43]	@ 0x2b
20024260:	4642      	mov	r2, r8
20024262:	4629      	mov	r1, r5
20024264:	4630      	mov	r0, r6
20024266:	2b00      	cmp	r3, #0
20024268:	d04c      	beq.n	20024304 <HAL_FLASH_Init+0x290>
2002426a:	f001 f9e3 	bl	20025634 <spi_nand_get_size_by_id>
2002426e:	4642      	mov	r2, r8
20024270:	4629      	mov	r1, r5
20024272:	4681      	mov	r9, r0
20024274:	4630      	mov	r0, r6
20024276:	f001 f9e7 	bl	20025648 <spi_nand_get_plane_select_flag>
2002427a:	4642      	mov	r2, r8
2002427c:	4629      	mov	r1, r5
2002427e:	f884 002f 	strb.w	r0, [r4, #47]	@ 0x2f
20024282:	4630      	mov	r0, r6
20024284:	f001 f9e9 	bl	2002565a <spi_nand_get_big_page_flag>
20024288:	4642      	mov	r2, r8
2002428a:	4629      	mov	r1, r5
2002428c:	f884 002c 	strb.w	r0, [r4, #44]	@ 0x2c
20024290:	4630      	mov	r0, r6
20024292:	f001 f9eb 	bl	2002566c <spi_nand_get_ecc_mode>
20024296:	f894 302c 	ldrb.w	r3, [r4, #44]	@ 0x2c
2002429a:	4642      	mov	r2, r8
2002429c:	ea43 1300 	orr.w	r3, r3, r0, lsl #4
200242a0:	4629      	mov	r1, r5
200242a2:	4630      	mov	r0, r6
200242a4:	f884 302c 	strb.w	r3, [r4, #44]	@ 0x2c
200242a8:	f001 f9b0 	bl	2002560c <spi_nand_get_ext_cfg_by_id>
200242ac:	63e0      	str	r0, [r4, #60]	@ 0x3c
200242ae:	f1b9 0f00 	cmp.w	r9, #0
200242b2:	d003      	beq.n	200242bc <HAL_FLASH_Init+0x248>
200242b4:	f8c4 904c 	str.w	r9, [r4, #76]	@ 0x4c
200242b8:	f8c4 9014 	str.w	r9, [r4, #20]
200242bc:	f894 302b 	ldrb.w	r3, [r4, #43]	@ 0x2b
200242c0:	2b00      	cmp	r3, #0
200242c2:	f040 8084 	bne.w	200243ce <HAL_FLASH_Init+0x35a>
200242c6:	2f00      	cmp	r7, #0
200242c8:	d17e      	bne.n	200243c8 <HAL_FLASH_Init+0x354>
200242ca:	4620      	mov	r0, r4
200242cc:	f7ff f960 	bl	20023590 <HAL_FLASH_CLR_PROTECT>
200242d0:	6963      	ldr	r3, [r4, #20]
200242d2:	f1b3 7f80 	cmp.w	r3, #16777216	@ 0x1000000
200242d6:	d948      	bls.n	2002436a <HAL_FLASH_Init+0x2f6>
200242d8:	463a      	mov	r2, r7
200242da:	2121      	movs	r1, #33	@ 0x21
200242dc:	4620      	mov	r0, r4
200242de:	f7fe ffe7 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
200242e2:	f894 3028 	ldrb.w	r3, [r4, #40]	@ 0x28
200242e6:	bb0b      	cbnz	r3, 2002432c <HAL_FLASH_Init+0x2b8>
200242e8:	4639      	mov	r1, r7
200242ea:	4620      	mov	r0, r4
200242ec:	f884 702e 	strb.w	r7, [r4, #46]	@ 0x2e
200242f0:	f7ff f928 	bl	20023544 <HAL_FLASH_FADDR_SET_QSPI>
200242f4:	2107      	movs	r1, #7
200242f6:	4620      	mov	r0, r4
200242f8:	f7fe fe9c 	bl	20023034 <HAL_FLASH_SET_ROW_BOUNDARY>
200242fc:	2000      	movs	r0, #0
200242fe:	b007      	add	sp, #28
20024300:	e8bd 83f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, pc}
20024304:	f001 f926 	bl	20025554 <spi_flash_get_size_by_id>
20024308:	4642      	mov	r2, r8
2002430a:	4629      	mov	r1, r5
2002430c:	4681      	mov	r9, r0
2002430e:	4630      	mov	r0, r6
20024310:	f001 f934 	bl	2002557c <spi_flash_get_otp_base>
20024314:	4642      	mov	r2, r8
20024316:	63a0      	str	r0, [r4, #56]	@ 0x38
20024318:	4629      	mov	r1, r5
2002431a:	4630      	mov	r0, r6
2002431c:	f001 f8dd 	bl	200254da <spi_nor_get_ext_cfg_by_id>
20024320:	63e0      	str	r0, [r4, #60]	@ 0x3c
20024322:	2800      	cmp	r0, #0
20024324:	d0c3      	beq.n	200242ae <HAL_FLASH_Init+0x23a>
20024326:	6803      	ldr	r3, [r0, #0]
20024328:	63a3      	str	r3, [r4, #56]	@ 0x38
2002432a:	e7c0      	b.n	200242ae <HAL_FLASH_Init+0x23a>
2002432c:	2101      	movs	r1, #1
2002432e:	4620      	mov	r0, r4
20024330:	f7ff f908 	bl	20023544 <HAL_FLASH_FADDR_SET_QSPI>
20024334:	f894 902e 	ldrb.w	r9, [r4, #46]	@ 0x2e
20024338:	f1b9 0f01 	cmp.w	r9, #1
2002433c:	d1da      	bne.n	200242f4 <HAL_FLASH_Init+0x280>
2002433e:	4642      	mov	r2, r8
20024340:	4629      	mov	r1, r5
20024342:	4630      	mov	r0, r6
20024344:	f001 f910 	bl	20025568 <spi_flash_is_support_dtr>
20024348:	b138      	cbz	r0, 2002435a <HAL_FLASH_Init+0x2e6>
2002434a:	4620      	mov	r0, r4
2002434c:	f7ff fe6e 	bl	2002402c <HAL_NOR_DTR_CAL>
20024350:	4649      	mov	r1, r9
20024352:	4620      	mov	r0, r4
20024354:	f7ff fe23 	bl	20023f9e <HAL_NOR_CFG_DTR>
20024358:	e7cc      	b.n	200242f4 <HAL_FLASH_Init+0x280>
2002435a:	463a      	mov	r2, r7
2002435c:	4639      	mov	r1, r7
2002435e:	4620      	mov	r0, r4
20024360:	f7fe fec6 	bl	200230f0 <HAL_MPI_CFG_DTR>
20024364:	f884 702e 	strb.w	r7, [r4, #46]	@ 0x2e
20024368:	e7c4      	b.n	200242f4 <HAL_FLASH_Init+0x280>
2002436a:	f894 3028 	ldrb.w	r3, [r4, #40]	@ 0x28
2002436e:	b933      	cbnz	r3, 2002437e <HAL_FLASH_Init+0x30a>
20024370:	4639      	mov	r1, r7
20024372:	4620      	mov	r0, r4
20024374:	f884 702e 	strb.w	r7, [r4, #46]	@ 0x2e
20024378:	f7ff f8d9 	bl	2002352e <HAL_FLASH_SET_QUAL_SPI>
2002437c:	e7be      	b.n	200242fc <HAL_FLASH_Init+0x288>
2002437e:	2101      	movs	r1, #1
20024380:	4620      	mov	r0, r4
20024382:	f7ff f8d4 	bl	2002352e <HAL_FLASH_SET_QUAL_SPI>
20024386:	f894 902e 	ldrb.w	r9, [r4, #46]	@ 0x2e
2002438a:	f1b9 0f01 	cmp.w	r9, #1
2002438e:	d115      	bne.n	200243bc <HAL_FLASH_Init+0x348>
20024390:	4642      	mov	r2, r8
20024392:	4629      	mov	r1, r5
20024394:	4630      	mov	r0, r6
20024396:	f001 f8e7 	bl	20025568 <spi_flash_is_support_dtr>
2002439a:	b138      	cbz	r0, 200243ac <HAL_FLASH_Init+0x338>
2002439c:	4620      	mov	r0, r4
2002439e:	f7ff fe45 	bl	2002402c <HAL_NOR_DTR_CAL>
200243a2:	4649      	mov	r1, r9
200243a4:	4620      	mov	r0, r4
200243a6:	f7ff fdfa 	bl	20023f9e <HAL_NOR_CFG_DTR>
200243aa:	e7a7      	b.n	200242fc <HAL_FLASH_Init+0x288>
200243ac:	463a      	mov	r2, r7
200243ae:	4639      	mov	r1, r7
200243b0:	4620      	mov	r0, r4
200243b2:	f7fe fe9d 	bl	200230f0 <HAL_MPI_CFG_DTR>
200243b6:	f884 702e 	strb.w	r7, [r4, #46]	@ 0x2e
200243ba:	e79f      	b.n	200242fc <HAL_FLASH_Init+0x288>
200243bc:	463a      	mov	r2, r7
200243be:	4639      	mov	r1, r7
200243c0:	4620      	mov	r0, r4
200243c2:	f7fe fe95 	bl	200230f0 <HAL_MPI_CFG_DTR>
200243c6:	e799      	b.n	200242fc <HAL_FLASH_Init+0x288>
200243c8:	f884 302e 	strb.w	r3, [r4, #46]	@ 0x2e
200243cc:	e796      	b.n	200242fc <HAL_FLASH_Init+0x288>
200243ce:	2101      	movs	r1, #1
200243d0:	4620      	mov	r0, r4
200243d2:	f7fe fcce 	bl	20022d72 <HAL_FLASH_WRITE_DLEN>
200243d6:	68e3      	ldr	r3, [r4, #12]
200243d8:	2102      	movs	r1, #2
200243da:	791a      	ldrb	r2, [r3, #4]
200243dc:	4620      	mov	r0, r4
200243de:	f7fe ff67 	bl	200232b0 <HAL_FLASH_ISSUE_CMD>
200243e2:	4620      	mov	r0, r4
200243e4:	f7fe fd1b 	bl	20022e1e <HAL_FLASH_READ32>
200243e8:	4605      	mov	r5, r0
200243ea:	200a      	movs	r0, #10
200243ec:	f7fd ff05 	bl	200221fa <HAL_Delay_us>
200243f0:	07eb      	lsls	r3, r5, #31
200243f2:	d4ec      	bmi.n	200243ce <HAL_FLASH_Init+0x35a>
200243f4:	4631      	mov	r1, r6
200243f6:	4620      	mov	r0, r4
200243f8:	f7ff fb79 	bl	20023aee <nand_clear_status>
200243fc:	f894 3028 	ldrb.w	r3, [r4, #40]	@ 0x28
20024400:	2b02      	cmp	r3, #2
20024402:	f47f af7b 	bne.w	200242fc <HAL_FLASH_Init+0x288>
20024406:	2101      	movs	r1, #1
20024408:	4620      	mov	r0, r4
2002440a:	f7ff fb3f 	bl	20023a8c <HAL_NAND_EN_QUAL>
2002440e:	e775      	b.n	200242fc <HAL_FLASH_Init+0x288>
20024410:	05f5e100 	.word	0x05f5e100

20024414 <HAL_Delay_us_psram>:
20024414:	b51f      	push	{r0, r1, r2, r3, r4, lr}
20024416:	9001      	str	r0, [sp, #4]
20024418:	9b01      	ldr	r3, [sp, #4]
2002441a:	4c11      	ldr	r4, [pc, #68]	@ (20024460 <HAL_Delay_us_psram+0x4c>)
2002441c:	b10b      	cbz	r3, 20024422 <HAL_Delay_us_psram+0xe>
2002441e:	6820      	ldr	r0, [r4, #0]
20024420:	b940      	cbnz	r0, 20024434 <HAL_Delay_us_psram+0x20>
20024422:	2000      	movs	r0, #0
20024424:	f000 feaa 	bl	2002517c <HAL_RCC_GetHCLKFreq>
20024428:	4b0e      	ldr	r3, [pc, #56]	@ (20024464 <HAL_Delay_us_psram+0x50>)
2002442a:	fbb0 f0f3 	udiv	r0, r0, r3
2002442e:	9b01      	ldr	r3, [sp, #4]
20024430:	6020      	str	r0, [r4, #0]
20024432:	b19b      	cbz	r3, 2002445c <HAL_Delay_us_psram+0x48>
20024434:	2830      	cmp	r0, #48	@ 0x30
20024436:	bf82      	ittt	hi
20024438:	9b01      	ldrhi	r3, [sp, #4]
2002443a:	f103 33ff 	addhi.w	r3, r3, #4294967295
2002443e:	9301      	strhi	r3, [sp, #4]
20024440:	9b01      	ldr	r3, [sp, #4]
20024442:	b15b      	cbz	r3, 2002445c <HAL_Delay_us_psram+0x48>
20024444:	2205      	movs	r2, #5
20024446:	9b01      	ldr	r3, [sp, #4]
20024448:	3b01      	subs	r3, #1
2002444a:	4343      	muls	r3, r0
2002444c:	fbb3 f3f2 	udiv	r3, r3, r2
20024450:	9303      	str	r3, [sp, #12]
20024452:	9b03      	ldr	r3, [sp, #12]
20024454:	1e5a      	subs	r2, r3, #1
20024456:	9203      	str	r2, [sp, #12]
20024458:	2b00      	cmp	r3, #0
2002445a:	d1fa      	bne.n	20024452 <HAL_Delay_us_psram+0x3e>
2002445c:	b004      	add	sp, #16
2002445e:	bd10      	pop	{r4, pc}
20024460:	2004cc6c 	.word	0x2004cc6c
20024464:	000f4240 	.word	0x000f4240

20024468 <HAL_MPI_OPSRAM_CAL_DELAY>:
20024468:	b570      	push	{r4, r5, r6, lr}
2002446a:	460e      	mov	r6, r1
2002446c:	4615      	mov	r5, r2
2002446e:	4604      	mov	r4, r0
20024470:	b358      	cbz	r0, 200244ca <HAL_MPI_OPSRAM_CAL_DELAY+0x62>
20024472:	2202      	movs	r2, #2
20024474:	6803      	ldr	r3, [r0, #0]
20024476:	60da      	str	r2, [r3, #12]
20024478:	6802      	ldr	r2, [r0, #0]
2002447a:	6d93      	ldr	r3, [r2, #88]	@ 0x58
2002447c:	f023 7300 	bic.w	r3, r3, #33554432	@ 0x2000000
20024480:	6593      	str	r3, [r2, #88]	@ 0x58
20024482:	6802      	ldr	r2, [r0, #0]
20024484:	2000      	movs	r0, #0
20024486:	f8d2 3094 	ldr.w	r3, [r2, #148]	@ 0x94
2002448a:	f043 4300 	orr.w	r3, r3, #2147483648	@ 0x80000000
2002448e:	f8c2 3094 	str.w	r3, [r2, #148]	@ 0x94
20024492:	f7ff ffbf 	bl	20024414 <HAL_Delay_us_psram>
20024496:	2014      	movs	r0, #20
20024498:	f7ff ffbc 	bl	20024414 <HAL_Delay_us_psram>
2002449c:	6820      	ldr	r0, [r4, #0]
2002449e:	f8d0 3094 	ldr.w	r3, [r0, #148]	@ 0x94
200244a2:	05db      	lsls	r3, r3, #23
200244a4:	d5fb      	bpl.n	2002449e <HAL_MPI_OPSRAM_CAL_DELAY+0x36>
200244a6:	f8d0 3094 	ldr.w	r3, [r0, #148]	@ 0x94
200244aa:	f8d0 2094 	ldr.w	r2, [r0, #148]	@ 0x94
200244ae:	b2db      	uxtb	r3, r3
200244b0:	f022 4200 	bic.w	r2, r2, #2147483648	@ 0x80000000
200244b4:	f8c0 2094 	str.w	r2, [r0, #148]	@ 0x94
200244b8:	1e5a      	subs	r2, r3, #1
200244ba:	7032      	strb	r2, [r6, #0]
200244bc:	2201      	movs	r2, #1
200244be:	2000      	movs	r0, #0
200244c0:	3b04      	subs	r3, #4
200244c2:	702b      	strb	r3, [r5, #0]
200244c4:	6823      	ldr	r3, [r4, #0]
200244c6:	60da      	str	r2, [r3, #12]
200244c8:	bd70      	pop	{r4, r5, r6, pc}
200244ca:	2001      	movs	r0, #1
200244cc:	e7fc      	b.n	200244c8 <HAL_MPI_OPSRAM_CAL_DELAY+0x60>
	...

200244d0 <HAL_SPI_PSRAM_Init>:
200244d0:	b537      	push	{r0, r1, r2, r4, r5, lr}
200244d2:	4614      	mov	r4, r2
200244d4:	4605      	mov	r5, r0
200244d6:	2800      	cmp	r0, #0
200244d8:	d043      	beq.n	20024562 <HAL_SPI_PSRAM_Init+0x92>
200244da:	2900      	cmp	r1, #0
200244dc:	d041      	beq.n	20024562 <HAL_SPI_PSRAM_Init+0x92>
200244de:	f7fe fbcf 	bl	20022c80 <HAL_QSPI_Init>
200244e2:	4628      	mov	r0, r5
200244e4:	b2e1      	uxtb	r1, r4
200244e6:	f7fe fca5 	bl	20022e34 <HAL_FLASH_SET_CLK_rom>
200244ea:	4628      	mov	r0, r5
200244ec:	f7ff fd3c 	bl	20023f68 <HAL_QSPI_GET_CLK>
200244f0:	4b1d      	ldr	r3, [pc, #116]	@ (20024568 <HAL_SPI_PSRAM_Init+0x98>)
200244f2:	4298      	cmp	r0, r3
200244f4:	d930      	bls.n	20024558 <HAL_SPI_PSRAM_Init+0x88>
200244f6:	4b1d      	ldr	r3, [pc, #116]	@ (2002456c <HAL_SPI_PSRAM_Init+0x9c>)
200244f8:	4298      	cmp	r0, r3
200244fa:	d92f      	bls.n	2002455c <HAL_SPI_PSRAM_Init+0x8c>
200244fc:	4b1c      	ldr	r3, [pc, #112]	@ (20024570 <HAL_SPI_PSRAM_Init+0xa0>)
200244fe:	4298      	cmp	r0, r3
20024500:	d922      	bls.n	20024548 <HAL_SPI_PSRAM_Init+0x78>
20024502:	f240 34b6 	movw	r4, #950	@ 0x3b6
20024506:	f240 4374 	movw	r3, #1140	@ 0x474
2002450a:	4a1a      	ldr	r2, [pc, #104]	@ (20024574 <HAL_SPI_PSRAM_Init+0xa4>)
2002450c:	4290      	cmp	r0, r2
2002450e:	bf88      	it	hi
20024510:	461c      	movhi	r4, r3
20024512:	2200      	movs	r2, #0
20024514:	2101      	movs	r1, #1
20024516:	4628      	mov	r0, r5
20024518:	f7ff f8ca 	bl	200236b0 <HAL_QSPI_SET_CLK_INV>
2002451c:	2100      	movs	r1, #0
2002451e:	4622      	mov	r2, r4
20024520:	2302      	movs	r3, #2
20024522:	4628      	mov	r0, r5
20024524:	9100      	str	r1, [sp, #0]
20024526:	f7fe fd70 	bl	2002300a <HAL_FLASH_SET_CS_TIME>
2002452a:	4604      	mov	r4, r0
2002452c:	b948      	cbnz	r0, 20024542 <HAL_SPI_PSRAM_Init+0x72>
2002452e:	2106      	movs	r1, #6
20024530:	4628      	mov	r0, r5
20024532:	f7fe fd7f 	bl	20023034 <HAL_FLASH_SET_ROW_BOUNDARY>
20024536:	4604      	mov	r4, r0
20024538:	b918      	cbnz	r0, 20024542 <HAL_SPI_PSRAM_Init+0x72>
2002453a:	2101      	movs	r1, #1
2002453c:	4628      	mov	r0, r5
2002453e:	f7fe fd1e 	bl	20022f7e <HAL_FLASH_ENABLE_QSPI>
20024542:	4620      	mov	r0, r4
20024544:	b003      	add	sp, #12
20024546:	bd30      	pop	{r4, r5, pc}
20024548:	4b0b      	ldr	r3, [pc, #44]	@ (20024578 <HAL_SPI_PSRAM_Init+0xa8>)
2002454a:	f44f 743e 	mov.w	r4, #760	@ 0x2f8
2002454e:	4298      	cmp	r0, r3
20024550:	d8df      	bhi.n	20024512 <HAL_SPI_PSRAM_Init+0x42>
20024552:	2200      	movs	r2, #0
20024554:	4611      	mov	r1, r2
20024556:	e7de      	b.n	20024516 <HAL_SPI_PSRAM_Init+0x46>
20024558:	24b4      	movs	r4, #180	@ 0xb4
2002455a:	e7fa      	b.n	20024552 <HAL_SPI_PSRAM_Init+0x82>
2002455c:	f44f 74be 	mov.w	r4, #380	@ 0x17c
20024560:	e7f7      	b.n	20024552 <HAL_SPI_PSRAM_Init+0x82>
20024562:	2401      	movs	r4, #1
20024564:	e7ed      	b.n	20024542 <HAL_SPI_PSRAM_Init+0x72>
20024566:	bf00      	nop
20024568:	016e3600 	.word	0x016e3600
2002456c:	02dc6c00 	.word	0x02dc6c00
20024570:	05b8d800 	.word	0x05b8d800
20024574:	07270e00 	.word	0x07270e00
20024578:	03938700 	.word	0x03938700

2002457c <HAL_MPI_MR_WRITE>:
2002457c:	b5f0      	push	{r4, r5, r6, r7, lr}
2002457e:	460e      	mov	r6, r1
20024580:	4617      	mov	r7, r2
20024582:	4605      	mov	r5, r0
20024584:	b087      	sub	sp, #28
20024586:	b1d8      	cbz	r0, 200245c0 <HAL_MPI_MR_WRITE+0x44>
20024588:	2207      	movs	r2, #7
2002458a:	2400      	movs	r4, #0
2002458c:	2303      	movs	r3, #3
2002458e:	e9cd 2203 	strd	r2, r2, [sp, #12]
20024592:	2101      	movs	r1, #1
20024594:	e9cd 4301 	strd	r4, r3, [sp, #4]
20024598:	9400      	str	r4, [sp, #0]
2002459a:	4623      	mov	r3, r4
2002459c:	f7fe fc53 	bl	20022e46 <HAL_FLASH_MANUAL_CMD>
200245a0:	2102      	movs	r1, #2
200245a2:	4628      	mov	r0, r5
200245a4:	f7fe fbe5 	bl	20022d72 <HAL_FLASH_WRITE_DLEN>
200245a8:	4639      	mov	r1, r7
200245aa:	4628      	mov	r0, r5
200245ac:	f7fe fbda 	bl	20022d64 <HAL_FLASH_WRITE_WORD>
200245b0:	4632      	mov	r2, r6
200245b2:	21c0      	movs	r1, #192	@ 0xc0
200245b4:	4628      	mov	r0, r5
200245b6:	f7fe fc01 	bl	20022dbc <HAL_FLASH_SET_CMD>
200245ba:	4620      	mov	r0, r4
200245bc:	b007      	add	sp, #28
200245be:	bdf0      	pop	{r4, r5, r6, r7, pc}
200245c0:	2001      	movs	r0, #1
200245c2:	e7fb      	b.n	200245bc <HAL_MPI_MR_WRITE+0x40>

200245c4 <HAL_MPI_SET_FIXLAT>:
200245c4:	e92d 41ff 	stmdb	sp!, {r0, r1, r2, r3, r4, r5, r6, r7, r8, lr}
200245c8:	460c      	mov	r4, r1
200245ca:	4616      	mov	r6, r2
200245cc:	461f      	mov	r7, r3
200245ce:	4605      	mov	r5, r0
200245d0:	2800      	cmp	r0, #0
200245d2:	d040      	beq.n	20024656 <HAL_MPI_SET_FIXLAT+0x92>
200245d4:	466b      	mov	r3, sp
200245d6:	4a21      	ldr	r2, [pc, #132]	@ (2002465c <HAL_MPI_SET_FIXLAT+0x98>)
200245d8:	6810      	ldr	r0, [r2, #0]
200245da:	6851      	ldr	r1, [r2, #4]
200245dc:	c303      	stmia	r3!, {r0, r1}
200245de:	6890      	ldr	r0, [r2, #8]
200245e0:	68d1      	ldr	r1, [r2, #12]
200245e2:	c303      	stmia	r3!, {r0, r1}
200245e4:	4628      	mov	r0, r5
200245e6:	b2e1      	uxtb	r1, r4
200245e8:	f7fe fd4a 	bl	20023080 <HAL_MPI_EN_FIXLAT>
200245ec:	f107 0310 	add.w	r3, r7, #16
200245f0:	446b      	add	r3, sp
200245f2:	f813 8c08 	ldrb.w	r8, [r3, #-8]
200245f6:	ea4f 1848 	mov.w	r8, r8, lsl #5
200245fa:	fa5f f888 	uxtb.w	r8, r8
200245fe:	b30c      	cbz	r4, 20024644 <HAL_MPI_SET_FIXLAT+0x80>
20024600:	ab04      	add	r3, sp, #16
20024602:	eb03 0356 	add.w	r3, r3, r6, lsr #1
20024606:	f813 4c10 	ldrb.w	r4, [r3, #-16]
2002460a:	00a4      	lsls	r4, r4, #2
2002460c:	f044 0421 	orr.w	r4, r4, #33	@ 0x21
20024610:	b264      	sxtb	r4, r4
20024612:	f004 02fd 	and.w	r2, r4, #253	@ 0xfd
20024616:	2100      	movs	r1, #0
20024618:	4628      	mov	r0, r5
2002461a:	f7ff ffaf 	bl	2002457c <HAL_MPI_MR_WRITE>
2002461e:	1e71      	subs	r1, r6, #1
20024620:	4628      	mov	r0, r5
20024622:	b249      	sxtb	r1, r1
20024624:	f7fe fd8a 	bl	2002313c <HAL_MPI_MODIFY_RCMD_DELAY>
20024628:	4642      	mov	r2, r8
2002462a:	2104      	movs	r1, #4
2002462c:	4628      	mov	r0, r5
2002462e:	f7ff ffa5 	bl	2002457c <HAL_MPI_MR_WRITE>
20024632:	1e79      	subs	r1, r7, #1
20024634:	4628      	mov	r0, r5
20024636:	b249      	sxtb	r1, r1
20024638:	f7fe fd89 	bl	2002314e <HAL_MPI_MODIFY_WCMD_DELAY>
2002463c:	2000      	movs	r0, #0
2002463e:	b004      	add	sp, #16
20024640:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}
20024644:	f106 0310 	add.w	r3, r6, #16
20024648:	446b      	add	r3, sp
2002464a:	f813 4c10 	ldrb.w	r4, [r3, #-16]
2002464e:	00a4      	lsls	r4, r4, #2
20024650:	f044 0401 	orr.w	r4, r4, #1
20024654:	e7dc      	b.n	20024610 <HAL_MPI_SET_FIXLAT+0x4c>
20024656:	2001      	movs	r0, #1
20024658:	e7f1      	b.n	2002463e <HAL_MPI_SET_FIXLAT+0x7a>
2002465a:	bf00      	nop
2002465c:	2002ba60 	.word	0x2002ba60

20024660 <HAL_LEGACY_MR_WRITE>:
20024660:	b5f0      	push	{r4, r5, r6, r7, lr}
20024662:	460e      	mov	r6, r1
20024664:	4617      	mov	r7, r2
20024666:	4605      	mov	r5, r0
20024668:	b087      	sub	sp, #28
2002466a:	b1d8      	cbz	r0, 200246a4 <HAL_LEGACY_MR_WRITE+0x44>
2002466c:	2207      	movs	r2, #7
2002466e:	2400      	movs	r4, #0
20024670:	2302      	movs	r3, #2
20024672:	e9cd 2203 	strd	r2, r2, [sp, #12]
20024676:	2101      	movs	r1, #1
20024678:	e9cd 4301 	strd	r4, r3, [sp, #4]
2002467c:	9400      	str	r4, [sp, #0]
2002467e:	4623      	mov	r3, r4
20024680:	f7fe fbe1 	bl	20022e46 <HAL_FLASH_MANUAL_CMD>
20024684:	2104      	movs	r1, #4
20024686:	4628      	mov	r0, r5
20024688:	f7fe fb73 	bl	20022d72 <HAL_FLASH_WRITE_DLEN>
2002468c:	4639      	mov	r1, r7
2002468e:	4628      	mov	r0, r5
20024690:	f7fe fb68 	bl	20022d64 <HAL_FLASH_WRITE_WORD>
20024694:	4632      	mov	r2, r6
20024696:	21c0      	movs	r1, #192	@ 0xc0
20024698:	4628      	mov	r0, r5
2002469a:	f7fe fb8f 	bl	20022dbc <HAL_FLASH_SET_CMD>
2002469e:	4620      	mov	r0, r4
200246a0:	b007      	add	sp, #28
200246a2:	bdf0      	pop	{r4, r5, r6, r7, pc}
200246a4:	2001      	movs	r0, #1
200246a6:	e7fb      	b.n	200246a0 <HAL_LEGACY_MR_WRITE+0x40>

200246a8 <HAL_LEGACY_CFG_READ>:
200246a8:	b530      	push	{r4, r5, lr}
200246aa:	4605      	mov	r5, r0
200246ac:	b085      	sub	sp, #20
200246ae:	b1a0      	cbz	r0, 200246da <HAL_LEGACY_CFG_READ+0x32>
200246b0:	2400      	movs	r4, #0
200246b2:	2107      	movs	r1, #7
200246b4:	2302      	movs	r3, #2
200246b6:	f890 202d 	ldrb.w	r2, [r0, #45]	@ 0x2d
200246ba:	e9cd 1102 	strd	r1, r1, [sp, #8]
200246be:	0052      	lsls	r2, r2, #1
200246c0:	e9cd 4300 	strd	r4, r3, [sp]
200246c4:	b252      	sxtb	r2, r2
200246c6:	4623      	mov	r3, r4
200246c8:	f7fe fb06 	bl	20022cd8 <HAL_FLASH_CFG_AHB_RCMD>
200246cc:	4621      	mov	r1, r4
200246ce:	4628      	mov	r0, r5
200246d0:	f7fe faf7 	bl	20022cc2 <HAL_FLASH_SET_AHB_RCMD>
200246d4:	4620      	mov	r0, r4
200246d6:	b005      	add	sp, #20
200246d8:	bd30      	pop	{r4, r5, pc}
200246da:	2001      	movs	r0, #1
200246dc:	e7fb      	b.n	200246d6 <HAL_LEGACY_CFG_READ+0x2e>

200246de <HAL_LEGACY_CFG_WRITE>:
200246de:	b530      	push	{r4, r5, lr}
200246e0:	4605      	mov	r5, r0
200246e2:	b085      	sub	sp, #20
200246e4:	b190      	cbz	r0, 2002470c <HAL_LEGACY_CFG_WRITE+0x2e>
200246e6:	2107      	movs	r1, #7
200246e8:	2400      	movs	r4, #0
200246ea:	2302      	movs	r3, #2
200246ec:	e9cd 1102 	strd	r1, r1, [sp, #8]
200246f0:	e9cd 4300 	strd	r4, r3, [sp]
200246f4:	4623      	mov	r3, r4
200246f6:	f990 202e 	ldrsb.w	r2, [r0, #46]	@ 0x2e
200246fa:	f7fe fb16 	bl	20022d2a <HAL_FLASH_CFG_AHB_WCMD>
200246fe:	2180      	movs	r1, #128	@ 0x80
20024700:	4628      	mov	r0, r5
20024702:	f7fe fb06 	bl	20022d12 <HAL_FLASH_SET_AHB_WCMD>
20024706:	4620      	mov	r0, r4
20024708:	b005      	add	sp, #20
2002470a:	bd30      	pop	{r4, r5, pc}
2002470c:	2001      	movs	r0, #1
2002470e:	e7fb      	b.n	20024708 <HAL_LEGACY_CFG_WRITE+0x2a>

20024710 <HAL_PSRAM_RESET>:
20024710:	b5f0      	push	{r4, r5, r6, r7, lr}
20024712:	4604      	mov	r4, r0
20024714:	b087      	sub	sp, #28
20024716:	2800      	cmp	r0, #0
20024718:	d03b      	beq.n	20024792 <HAL_PSRAM_RESET+0x82>
2002471a:	f890 302b 	ldrb.w	r3, [r0, #43]	@ 0x2b
2002471e:	2b05      	cmp	r3, #5
20024720:	d034      	beq.n	2002478c <HAL_PSRAM_RESET+0x7c>
20024722:	3b03      	subs	r3, #3
20024724:	2b01      	cmp	r3, #1
20024726:	d82e      	bhi.n	20024786 <HAL_PSRAM_RESET+0x76>
20024728:	2601      	movs	r6, #1
2002472a:	2703      	movs	r7, #3
2002472c:	2300      	movs	r3, #0
2002472e:	2507      	movs	r5, #7
20024730:	b276      	sxtb	r6, r6
20024732:	b27f      	sxtb	r7, r7
20024734:	461a      	mov	r2, r3
20024736:	2101      	movs	r1, #1
20024738:	4620      	mov	r0, r4
2002473a:	e9cd 5503 	strd	r5, r5, [sp, #12]
2002473e:	e9cd 5701 	strd	r5, r7, [sp, #4]
20024742:	9600      	str	r6, [sp, #0]
20024744:	f7fe fb7f 	bl	20022e46 <HAL_FLASH_MANUAL_CMD>
20024748:	2200      	movs	r2, #0
2002474a:	21ff      	movs	r1, #255	@ 0xff
2002474c:	4620      	mov	r0, r4
2002474e:	f7fe fb35 	bl	20022dbc <HAL_FLASH_SET_CMD>
20024752:	f894 302b 	ldrb.w	r3, [r4, #43]	@ 0x2b
20024756:	2b05      	cmp	r3, #5
20024758:	d10f      	bne.n	2002477a <HAL_PSRAM_RESET+0x6a>
2002475a:	2300      	movs	r3, #0
2002475c:	2101      	movs	r1, #1
2002475e:	461a      	mov	r2, r3
20024760:	4620      	mov	r0, r4
20024762:	e9cd 5503 	strd	r5, r5, [sp, #12]
20024766:	e9cd 5701 	strd	r5, r7, [sp, #4]
2002476a:	9600      	str	r6, [sp, #0]
2002476c:	f7fe fb6b 	bl	20022e46 <HAL_FLASH_MANUAL_CMD>
20024770:	2200      	movs	r2, #0
20024772:	21ff      	movs	r1, #255	@ 0xff
20024774:	4620      	mov	r0, r4
20024776:	f7fe fb21 	bl	20022dbc <HAL_FLASH_SET_CMD>
2002477a:	2000      	movs	r0, #0
2002477c:	f7fd fd3d 	bl	200221fa <HAL_Delay_us>
20024780:	2003      	movs	r0, #3
20024782:	f7fd fd3a 	bl	200221fa <HAL_Delay_us>
20024786:	2000      	movs	r0, #0
20024788:	b007      	add	sp, #28
2002478a:	bdf0      	pop	{r4, r5, r6, r7, pc}
2002478c:	2603      	movs	r6, #3
2002478e:	2702      	movs	r7, #2
20024790:	e7cc      	b.n	2002472c <HAL_PSRAM_RESET+0x1c>
20024792:	2001      	movs	r0, #1
20024794:	e7f8      	b.n	20024788 <HAL_PSRAM_RESET+0x78>
	...

20024798 <HAL_OPI_PSRAM_Init>:
20024798:	b530      	push	{r4, r5, lr}
2002479a:	4604      	mov	r4, r0
2002479c:	b085      	sub	sp, #20
2002479e:	2800      	cmp	r0, #0
200247a0:	d071      	beq.n	20024886 <HAL_OPI_PSRAM_Init+0xee>
200247a2:	2900      	cmp	r1, #0
200247a4:	d06f      	beq.n	20024886 <HAL_OPI_PSRAM_Init+0xee>
200247a6:	f7fe fa6b 	bl	20022c80 <HAL_QSPI_Init>
200247aa:	6823      	ldr	r3, [r4, #0]
200247ac:	2101      	movs	r1, #1
200247ae:	4620      	mov	r0, r4
200247b0:	681d      	ldr	r5, [r3, #0]
200247b2:	f7fe fb3f 	bl	20022e34 <HAL_FLASH_SET_CLK_rom>
200247b6:	4620      	mov	r0, r4
200247b8:	f7ff fbd6 	bl	20023f68 <HAL_QSPI_GET_CLK>
200247bc:	0840      	lsrs	r0, r0, #1
200247be:	61a0      	str	r0, [r4, #24]
200247c0:	f10d 020e 	add.w	r2, sp, #14
200247c4:	4620      	mov	r0, r4
200247c6:	f10d 010f 	add.w	r1, sp, #15
200247ca:	f7ff fe4d 	bl	20024468 <HAL_MPI_OPSRAM_CAL_DELAY>
200247ce:	69a3      	ldr	r3, [r4, #24]
200247d0:	4a2e      	ldr	r2, [pc, #184]	@ (2002488c <HAL_OPI_PSRAM_Init+0xf4>)
200247d2:	f005 0501 	and.w	r5, r5, #1
200247d6:	4293      	cmp	r3, r2
200247d8:	d836      	bhi.n	20024848 <HAL_OPI_PSRAM_Init+0xb0>
200247da:	2320      	movs	r3, #32
200247dc:	2103      	movs	r1, #3
200247de:	f88d 300e 	strb.w	r3, [sp, #14]
200247e2:	f88d 300f 	strb.w	r3, [sp, #15]
200247e6:	4608      	mov	r0, r1
200247e8:	2300      	movs	r3, #0
200247ea:	22b4      	movs	r2, #180	@ 0xb4
200247ec:	f884 102d 	strb.w	r1, [r4, #45]	@ 0x2d
200247f0:	f884 102e 	strb.w	r1, [r4, #46]	@ 0x2e
200247f4:	2106      	movs	r1, #6
200247f6:	9000      	str	r0, [sp, #0]
200247f8:	4620      	mov	r0, r4
200247fa:	f7fe fc06 	bl	2002300a <HAL_FLASH_SET_CS_TIME>
200247fe:	2107      	movs	r1, #7
20024800:	4620      	mov	r0, r4
20024802:	f7fe fc17 	bl	20023034 <HAL_FLASH_SET_ROW_BOUNDARY>
20024806:	2101      	movs	r1, #1
20024808:	4620      	mov	r0, r4
2002480a:	f7fe fc47 	bl	2002309c <HAL_MPI_ENABLE_DQS>
2002480e:	f89d 100e 	ldrb.w	r1, [sp, #14]
20024812:	4620      	mov	r0, r4
20024814:	f7fe fc50 	bl	200230b8 <HAL_MPI_SET_DQS_DELAY>
20024818:	2200      	movs	r2, #0
2002481a:	f89d 100f 	ldrb.w	r1, [sp, #15]
2002481e:	4620      	mov	r0, r4
20024820:	f7fe fc56 	bl	200230d0 <HAL_MPI_SET_SCK>
20024824:	2101      	movs	r1, #1
20024826:	4620      	mov	r0, r4
20024828:	f7fe fba9 	bl	20022f7e <HAL_FLASH_ENABLE_QSPI>
2002482c:	2101      	movs	r1, #1
2002482e:	4620      	mov	r0, r4
20024830:	f7fe fbb3 	bl	20022f9a <HAL_FLASH_ENABLE_OPI>
20024834:	b92d      	cbnz	r5, 20024842 <HAL_OPI_PSRAM_Init+0xaa>
20024836:	4b16      	ldr	r3, [pc, #88]	@ (20024890 <HAL_OPI_PSRAM_Init+0xf8>)
20024838:	681b      	ldr	r3, [r3, #0]
2002483a:	f003 0303 	and.w	r3, r3, #3
2002483e:	2b03      	cmp	r3, #3
20024840:	d11d      	bne.n	2002487e <HAL_OPI_PSRAM_Init+0xe6>
20024842:	2000      	movs	r0, #0
20024844:	b005      	add	sp, #20
20024846:	bd30      	pop	{r4, r5, pc}
20024848:	4a12      	ldr	r2, [pc, #72]	@ (20024894 <HAL_OPI_PSRAM_Init+0xfc>)
2002484a:	4293      	cmp	r3, r2
2002484c:	d90b      	bls.n	20024866 <HAL_OPI_PSRAM_Init+0xce>
2002484e:	f102 72b7 	add.w	r2, r2, #23986176	@ 0x16e0000
20024852:	f502 5258 	add.w	r2, r2, #13824	@ 0x3600
20024856:	4293      	cmp	r3, r2
20024858:	d90b      	bls.n	20024872 <HAL_OPI_PSRAM_Init+0xda>
2002485a:	2107      	movs	r1, #7
2002485c:	2014      	movs	r0, #20
2002485e:	2308      	movs	r3, #8
20024860:	f240 5232 	movw	r2, #1330	@ 0x532
20024864:	e7c2      	b.n	200247ec <HAL_OPI_PSRAM_Init+0x54>
20024866:	2105      	movs	r1, #5
20024868:	200e      	movs	r0, #14
2002486a:	2303      	movs	r3, #3
2002486c:	f240 32b6 	movw	r2, #950	@ 0x3b6
20024870:	e7bc      	b.n	200247ec <HAL_OPI_PSRAM_Init+0x54>
20024872:	2106      	movs	r1, #6
20024874:	2011      	movs	r0, #17
20024876:	2305      	movs	r3, #5
20024878:	f240 4274 	movw	r2, #1140	@ 0x474
2002487c:	e7b6      	b.n	200247ec <HAL_OPI_PSRAM_Init+0x54>
2002487e:	4620      	mov	r0, r4
20024880:	f7ff ff46 	bl	20024710 <HAL_PSRAM_RESET>
20024884:	e7dd      	b.n	20024842 <HAL_OPI_PSRAM_Init+0xaa>
20024886:	2001      	movs	r0, #1
20024888:	e7dc      	b.n	20024844 <HAL_OPI_PSRAM_Init+0xac>
2002488a:	bf00      	nop
2002488c:	016e3600 	.word	0x016e3600
20024890:	500c0000 	.word	0x500c0000
20024894:	07270e00 	.word	0x07270e00

20024898 <HAL_LEGACY_PSRAM_Init>:
20024898:	b5f0      	push	{r4, r5, r6, r7, lr}
2002489a:	4604      	mov	r4, r0
2002489c:	b085      	sub	sp, #20
2002489e:	2800      	cmp	r0, #0
200248a0:	f000 8097 	beq.w	200249d2 <HAL_LEGACY_PSRAM_Init+0x13a>
200248a4:	2900      	cmp	r1, #0
200248a6:	f000 8094 	beq.w	200249d2 <HAL_LEGACY_PSRAM_Init+0x13a>
200248aa:	f7fe f9e9 	bl	20022c80 <HAL_QSPI_Init>
200248ae:	6823      	ldr	r3, [r4, #0]
200248b0:	2101      	movs	r1, #1
200248b2:	4620      	mov	r0, r4
200248b4:	681e      	ldr	r6, [r3, #0]
200248b6:	f7fe fabd 	bl	20022e34 <HAL_FLASH_SET_CLK_rom>
200248ba:	4620      	mov	r0, r4
200248bc:	f7ff fb54 	bl	20023f68 <HAL_QSPI_GET_CLK>
200248c0:	0845      	lsrs	r5, r0, #1
200248c2:	61a5      	str	r5, [r4, #24]
200248c4:	4620      	mov	r0, r4
200248c6:	f10d 020e 	add.w	r2, sp, #14
200248ca:	f10d 010f 	add.w	r1, sp, #15
200248ce:	f7ff fdcb 	bl	20024468 <HAL_MPI_OPSRAM_CAL_DELAY>
200248d2:	4b41      	ldr	r3, [pc, #260]	@ (200249d8 <HAL_LEGACY_PSRAM_Init+0x140>)
200248d4:	4f41      	ldr	r7, [pc, #260]	@ (200249dc <HAL_LEGACY_PSRAM_Init+0x144>)
200248d6:	429d      	cmp	r5, r3
200248d8:	f006 0601 	and.w	r6, r6, #1
200248dc:	d850      	bhi.n	20024980 <HAL_LEGACY_PSRAM_Init+0xe8>
200248de:	2320      	movs	r3, #32
200248e0:	2103      	movs	r1, #3
200248e2:	f88d 300e 	strb.w	r3, [sp, #14]
200248e6:	f88d 300f 	strb.w	r3, [sp, #15]
200248ea:	22b4      	movs	r2, #180	@ 0xb4
200248ec:	2300      	movs	r3, #0
200248ee:	9100      	str	r1, [sp, #0]
200248f0:	4620      	mov	r0, r4
200248f2:	2106      	movs	r1, #6
200248f4:	f7fe fb89 	bl	2002300a <HAL_FLASH_SET_CS_TIME>
200248f8:	2107      	movs	r1, #7
200248fa:	4620      	mov	r0, r4
200248fc:	f7fe fb9a 	bl	20023034 <HAL_FLASH_SET_ROW_BOUNDARY>
20024900:	2101      	movs	r1, #1
20024902:	4620      	mov	r0, r4
20024904:	f7fe fbca 	bl	2002309c <HAL_MPI_ENABLE_DQS>
20024908:	f89d 100e 	ldrb.w	r1, [sp, #14]
2002490c:	4620      	mov	r0, r4
2002490e:	f7fe fbd3 	bl	200230b8 <HAL_MPI_SET_DQS_DELAY>
20024912:	2200      	movs	r2, #0
20024914:	f89d 100f 	ldrb.w	r1, [sp, #15]
20024918:	4620      	mov	r0, r4
2002491a:	f7fe fbd9 	bl	200230d0 <HAL_MPI_SET_SCK>
2002491e:	2101      	movs	r1, #1
20024920:	4620      	mov	r0, r4
20024922:	f7fe fb91 	bl	20023048 <HAL_FLASH_SET_LEGACY>
20024926:	2101      	movs	r1, #1
20024928:	4620      	mov	r0, r4
2002492a:	f7fe fb28 	bl	20022f7e <HAL_FLASH_ENABLE_QSPI>
2002492e:	2101      	movs	r1, #1
20024930:	4620      	mov	r0, r4
20024932:	f7fe fb32 	bl	20022f9a <HAL_FLASH_ENABLE_OPI>
20024936:	b92e      	cbnz	r6, 20024944 <HAL_LEGACY_PSRAM_Init+0xac>
20024938:	f894 302f 	ldrb.w	r3, [r4, #47]	@ 0x2f
2002493c:	b913      	cbnz	r3, 20024944 <HAL_LEGACY_PSRAM_Init+0xac>
2002493e:	4620      	mov	r0, r4
20024940:	f7ff fee6 	bl	20024710 <HAL_PSRAM_RESET>
20024944:	42bd      	cmp	r5, r7
20024946:	d93a      	bls.n	200249be <HAL_LEGACY_PSRAM_Init+0x126>
20024948:	4b25      	ldr	r3, [pc, #148]	@ (200249e0 <HAL_LEGACY_PSRAM_Init+0x148>)
2002494a:	429d      	cmp	r5, r3
2002494c:	d93c      	bls.n	200249c8 <HAL_LEGACY_PSRAM_Init+0x130>
2002494e:	2206      	movs	r2, #6
20024950:	2302      	movs	r3, #2
20024952:	2588      	movs	r5, #136	@ 0x88
20024954:	263b      	movs	r6, #59	@ 0x3b
20024956:	f884 302e 	strb.w	r3, [r4, #46]	@ 0x2e
2002495a:	2101      	movs	r1, #1
2002495c:	f884 202d 	strb.w	r2, [r4, #45]	@ 0x2d
20024960:	4620      	mov	r0, r4
20024962:	f7fe fb8d 	bl	20023080 <HAL_MPI_EN_FIXLAT>
20024966:	4632      	mov	r2, r6
20024968:	2100      	movs	r1, #0
2002496a:	4620      	mov	r0, r4
2002496c:	f7ff fe78 	bl	20024660 <HAL_LEGACY_MR_WRITE>
20024970:	462a      	mov	r2, r5
20024972:	2104      	movs	r1, #4
20024974:	4620      	mov	r0, r4
20024976:	f7ff fe73 	bl	20024660 <HAL_LEGACY_MR_WRITE>
2002497a:	2000      	movs	r0, #0
2002497c:	b005      	add	sp, #20
2002497e:	bdf0      	pop	{r4, r5, r6, r7, pc}
20024980:	42bd      	cmp	r5, r7
20024982:	d90d      	bls.n	200249a0 <HAL_LEGACY_PSRAM_Init+0x108>
20024984:	4b16      	ldr	r3, [pc, #88]	@ (200249e0 <HAL_LEGACY_PSRAM_Init+0x148>)
20024986:	429d      	cmp	r5, r3
20024988:	d90f      	bls.n	200249aa <HAL_LEGACY_PSRAM_Init+0x112>
2002498a:	f103 73b7 	add.w	r3, r3, #23986176	@ 0x16e0000
2002498e:	f503 5358 	add.w	r3, r3, #13824	@ 0x3600
20024992:	429d      	cmp	r5, r3
20024994:	d80e      	bhi.n	200249b4 <HAL_LEGACY_PSRAM_Init+0x11c>
20024996:	2114      	movs	r1, #20
20024998:	2308      	movs	r3, #8
2002499a:	f240 5232 	movw	r2, #1330	@ 0x532
2002499e:	e7a6      	b.n	200248ee <HAL_LEGACY_PSRAM_Init+0x56>
200249a0:	210e      	movs	r1, #14
200249a2:	2303      	movs	r3, #3
200249a4:	f240 32b6 	movw	r2, #950	@ 0x3b6
200249a8:	e7a1      	b.n	200248ee <HAL_LEGACY_PSRAM_Init+0x56>
200249aa:	2111      	movs	r1, #17
200249ac:	2305      	movs	r3, #5
200249ae:	f240 4274 	movw	r2, #1140	@ 0x474
200249b2:	e79c      	b.n	200248ee <HAL_LEGACY_PSRAM_Init+0x56>
200249b4:	2117      	movs	r1, #23
200249b6:	2309      	movs	r3, #9
200249b8:	f44f 62be 	mov.w	r2, #1520	@ 0x5f0
200249bc:	e797      	b.n	200248ee <HAL_LEGACY_PSRAM_Init+0x56>
200249be:	2204      	movs	r2, #4
200249c0:	2300      	movs	r3, #0
200249c2:	2508      	movs	r5, #8
200249c4:	2633      	movs	r6, #51	@ 0x33
200249c6:	e7c6      	b.n	20024956 <HAL_LEGACY_PSRAM_Init+0xbe>
200249c8:	2205      	movs	r2, #5
200249ca:	2300      	movs	r3, #0
200249cc:	2508      	movs	r5, #8
200249ce:	2637      	movs	r6, #55	@ 0x37
200249d0:	e7c1      	b.n	20024956 <HAL_LEGACY_PSRAM_Init+0xbe>
200249d2:	2001      	movs	r0, #1
200249d4:	e7d2      	b.n	2002497c <HAL_LEGACY_PSRAM_Init+0xe4>
200249d6:	bf00      	nop
200249d8:	016e3600 	.word	0x016e3600
200249dc:	07270e00 	.word	0x07270e00
200249e0:	08954400 	.word	0x08954400

200249e4 <HAL_HYPER_PSRAM_WriteCR>:
200249e4:	b570      	push	{r4, r5, r6, lr}
200249e6:	460e      	mov	r6, r1
200249e8:	4615      	mov	r5, r2
200249ea:	4604      	mov	r4, r0
200249ec:	b086      	sub	sp, #24
200249ee:	b1f8      	cbz	r0, 20024a30 <HAL_HYPER_PSRAM_WriteCR+0x4c>
200249f0:	2207      	movs	r2, #7
200249f2:	2303      	movs	r3, #3
200249f4:	e9cd 2301 	strd	r2, r3, [sp, #4]
200249f8:	2300      	movs	r3, #0
200249fa:	e9cd 2203 	strd	r2, r2, [sp, #12]
200249fe:	9300      	str	r3, [sp, #0]
20024a00:	2101      	movs	r1, #1
20024a02:	f7fe fa20 	bl	20022e46 <HAL_FLASH_MANUAL_CMD>
20024a06:	4631      	mov	r1, r6
20024a08:	4620      	mov	r0, r4
20024a0a:	f7fe f9c6 	bl	20022d9a <HAL_FLASH_WRITE_ABYTE>
20024a0e:	2102      	movs	r1, #2
20024a10:	4620      	mov	r0, r4
20024a12:	f7fe f9ae 	bl	20022d72 <HAL_FLASH_WRITE_DLEN>
20024a16:	4629      	mov	r1, r5
20024a18:	4620      	mov	r0, r4
20024a1a:	f7fe f9a3 	bl	20022d64 <HAL_FLASH_WRITE_WORD>
20024a1e:	f44f 3280 	mov.w	r2, #65536	@ 0x10000
20024a22:	2160      	movs	r1, #96	@ 0x60
20024a24:	4620      	mov	r0, r4
20024a26:	b006      	add	sp, #24
20024a28:	e8bd 4070 	ldmia.w	sp!, {r4, r5, r6, lr}
20024a2c:	f7fe b9c6 	b.w	20022dbc <HAL_FLASH_SET_CMD>
20024a30:	b006      	add	sp, #24
20024a32:	bd70      	pop	{r4, r5, r6, pc}

20024a34 <HAL_HYPER_PSRAM_Init>:
20024a34:	b538      	push	{r3, r4, r5, lr}
20024a36:	4604      	mov	r4, r0
20024a38:	2201      	movs	r2, #1
20024a3a:	f7ff fead 	bl	20024798 <HAL_OPI_PSRAM_Init>
20024a3e:	69a3      	ldr	r3, [r4, #24]
20024a40:	4a15      	ldr	r2, [pc, #84]	@ (20024a98 <HAL_HYPER_PSRAM_Init+0x64>)
20024a42:	4293      	cmp	r3, r2
20024a44:	d91f      	bls.n	20024a86 <HAL_HYPER_PSRAM_Init+0x52>
20024a46:	4a15      	ldr	r2, [pc, #84]	@ (20024a9c <HAL_HYPER_PSRAM_Init+0x68>)
20024a48:	4293      	cmp	r3, r2
20024a4a:	d91f      	bls.n	20024a8c <HAL_HYPER_PSRAM_Init+0x58>
20024a4c:	f502 0274 	add.w	r2, r2, #15990784	@ 0xf40000
20024a50:	f502 5210 	add.w	r2, r2, #9216	@ 0x2400
20024a54:	4293      	cmp	r3, r2
20024a56:	d91c      	bls.n	20024a92 <HAL_HYPER_PSRAM_Init+0x5e>
20024a58:	f242 758f 	movw	r5, #10127	@ 0x278f
20024a5c:	f241 728f 	movw	r2, #6031	@ 0x178f
20024a60:	490f      	ldr	r1, [pc, #60]	@ (20024aa0 <HAL_HYPER_PSRAM_Init+0x6c>)
20024a62:	428b      	cmp	r3, r1
20024a64:	bf98      	it	ls
20024a66:	4615      	movls	r5, r2
20024a68:	2101      	movs	r1, #1
20024a6a:	4620      	mov	r0, r4
20024a6c:	f7fe faa3 	bl	20022fb6 <HAL_FLASH_ENABLE_HYPER>
20024a70:	462a      	mov	r2, r5
20024a72:	4620      	mov	r0, r4
20024a74:	2100      	movs	r1, #0
20024a76:	f7ff ffb5 	bl	200249e4 <HAL_HYPER_PSRAM_WriteCR>
20024a7a:	2101      	movs	r1, #1
20024a7c:	4620      	mov	r0, r4
20024a7e:	f7fe faff 	bl	20023080 <HAL_MPI_EN_FIXLAT>
20024a82:	2000      	movs	r0, #0
20024a84:	bd38      	pop	{r3, r4, r5, pc}
20024a86:	f24e 758f 	movw	r5, #59279	@ 0xe78f
20024a8a:	e7ed      	b.n	20024a68 <HAL_HYPER_PSRAM_Init+0x34>
20024a8c:	f24f 758f 	movw	r5, #63375	@ 0xf78f
20024a90:	e7ea      	b.n	20024a68 <HAL_HYPER_PSRAM_Init+0x34>
20024a92:	f240 758f 	movw	r5, #1935	@ 0x78f
20024a96:	e7e7      	b.n	20024a68 <HAL_HYPER_PSRAM_Init+0x34>
20024a98:	0510ff40 	.word	0x0510ff40
20024a9c:	0632ea00 	.word	0x0632ea00
20024aa0:	08954400 	.word	0x08954400

20024aa4 <HAL_HYPER_CFG_READ>:
20024aa4:	b51f      	push	{r0, r1, r2, r3, r4, lr}
20024aa6:	b160      	cbz	r0, 20024ac2 <HAL_HYPER_CFG_READ+0x1e>
20024aa8:	2107      	movs	r1, #7
20024aaa:	2303      	movs	r3, #3
20024aac:	f890 202d 	ldrb.w	r2, [r0, #45]	@ 0x2d
20024ab0:	e9cd 1300 	strd	r1, r3, [sp]
20024ab4:	3a01      	subs	r2, #1
20024ab6:	2300      	movs	r3, #0
20024ab8:	e9cd 1102 	strd	r1, r1, [sp, #8]
20024abc:	b252      	sxtb	r2, r2
20024abe:	f7fe f90b 	bl	20022cd8 <HAL_FLASH_CFG_AHB_RCMD>
20024ac2:	b005      	add	sp, #20
20024ac4:	f85d fb04 	ldr.w	pc, [sp], #4

20024ac8 <HAL_HYPER_CFG_WRITE>:
20024ac8:	b51f      	push	{r0, r1, r2, r3, r4, lr}
20024aca:	b160      	cbz	r0, 20024ae6 <HAL_HYPER_CFG_WRITE+0x1e>
20024acc:	2107      	movs	r1, #7
20024ace:	2303      	movs	r3, #3
20024ad0:	f890 202e 	ldrb.w	r2, [r0, #46]	@ 0x2e
20024ad4:	e9cd 1300 	strd	r1, r3, [sp]
20024ad8:	3a01      	subs	r2, #1
20024ada:	2300      	movs	r3, #0
20024adc:	e9cd 1102 	strd	r1, r1, [sp, #8]
20024ae0:	b252      	sxtb	r2, r2
20024ae2:	f7fe f922 	bl	20022d2a <HAL_FLASH_CFG_AHB_WCMD>
20024ae6:	b005      	add	sp, #20
20024ae8:	f85d fb04 	ldr.w	pc, [sp], #4

20024aec <HAL_PIN_SetUartFunc.part.0>:
20024aec:	108b      	asrs	r3, r1, #2
20024aee:	f1a3 0248 	sub.w	r2, r3, #72	@ 0x48
20024af2:	b5f0      	push	{r4, r5, r6, r7, lr}
20024af4:	b2d6      	uxtb	r6, r2
20024af6:	2e04      	cmp	r6, #4
20024af8:	d849      	bhi.n	20024b8e <HAL_PIN_SetUartFunc.part.0+0xa2>
20024afa:	2e02      	cmp	r6, #2
20024afc:	d810      	bhi.n	20024b20 <HAL_PIN_SetUartFunc.part.0+0x34>
20024afe:	4d25      	ldr	r5, [pc, #148]	@ (20024b94 <HAL_PIN_SetUartFunc.part.0+0xa8>)
20024b00:	240e      	movs	r4, #14
20024b02:	eb05 0582 	add.w	r5, r5, r2, lsl #2
20024b06:	f240 22b2 	movw	r2, #690	@ 0x2b2
20024b0a:	eba1 0386 	sub.w	r3, r1, r6, lsl #2
20024b0e:	b29b      	uxth	r3, r3
20024b10:	f5a3 7390 	sub.w	r3, r3, #288	@ 0x120
20024b14:	2b03      	cmp	r3, #3
20024b16:	d83a      	bhi.n	20024b8e <HAL_PIN_SetUartFunc.part.0+0xa2>
20024b18:	e8df f003 	tbb	[pc, r3]
20024b1c:	20271a09 	.word	0x20271a09
20024b20:	4d1d      	ldr	r5, [pc, #116]	@ (20024b98 <HAL_PIN_SetUartFunc.part.0+0xac>)
20024b22:	009b      	lsls	r3, r3, #2
20024b24:	243d      	movs	r4, #61	@ 0x3d
20024b26:	f240 3221 	movw	r2, #801	@ 0x321
20024b2a:	441d      	add	r5, r3
20024b2c:	e7ed      	b.n	20024b0a <HAL_PIN_SetUartFunc.part.0+0x1e>
20024b2e:	2c0e      	cmp	r4, #14
20024b30:	f04f 0608 	mov.w	r6, #8
20024b34:	d120      	bne.n	20024b78 <HAL_PIN_SetUartFunc.part.0+0x8c>
20024b36:	f44f 517c 	mov.w	r1, #16128	@ 0x3f00
20024b3a:	682f      	ldr	r7, [r5, #0]
20024b3c:	1b03      	subs	r3, r0, r4
20024b3e:	40b3      	lsls	r3, r6
20024b40:	407b      	eors	r3, r7
20024b42:	400b      	ands	r3, r1
20024b44:	4410      	add	r0, r2
20024b46:	407b      	eors	r3, r7
20024b48:	1b00      	subs	r0, r0, r4
20024b4a:	602b      	str	r3, [r5, #0]
20024b4c:	b280      	uxth	r0, r0
20024b4e:	bdf0      	pop	{r4, r5, r6, r7, pc}
20024b50:	2c0e      	cmp	r4, #14
20024b52:	f04f 0600 	mov.w	r6, #0
20024b56:	d112      	bne.n	20024b7e <HAL_PIN_SetUartFunc.part.0+0x92>
20024b58:	213f      	movs	r1, #63	@ 0x3f
20024b5a:	e7ee      	b.n	20024b3a <HAL_PIN_SetUartFunc.part.0+0x4e>
20024b5c:	2c0e      	cmp	r4, #14
20024b5e:	f04f 0610 	mov.w	r6, #16
20024b62:	d10e      	bne.n	20024b82 <HAL_PIN_SetUartFunc.part.0+0x96>
20024b64:	f44f 117c 	mov.w	r1, #4128768	@ 0x3f0000
20024b68:	e7e7      	b.n	20024b3a <HAL_PIN_SetUartFunc.part.0+0x4e>
20024b6a:	2c0e      	cmp	r4, #14
20024b6c:	f04f 0618 	mov.w	r6, #24
20024b70:	d10a      	bne.n	20024b88 <HAL_PIN_SetUartFunc.part.0+0x9c>
20024b72:	f04f 517c 	mov.w	r1, #1056964608	@ 0x3f000000
20024b76:	e7e0      	b.n	20024b3a <HAL_PIN_SetUartFunc.part.0+0x4e>
20024b78:	f44f 61e0 	mov.w	r1, #1792	@ 0x700
20024b7c:	e7dd      	b.n	20024b3a <HAL_PIN_SetUartFunc.part.0+0x4e>
20024b7e:	2107      	movs	r1, #7
20024b80:	e7db      	b.n	20024b3a <HAL_PIN_SetUartFunc.part.0+0x4e>
20024b82:	f44f 21e0 	mov.w	r1, #458752	@ 0x70000
20024b86:	e7d8      	b.n	20024b3a <HAL_PIN_SetUartFunc.part.0+0x4e>
20024b88:	f04f 61e0 	mov.w	r1, #117440512	@ 0x7000000
20024b8c:	e7d5      	b.n	20024b3a <HAL_PIN_SetUartFunc.part.0+0x4e>
20024b8e:	2000      	movs	r0, #0
20024b90:	e7dd      	b.n	20024b4e <HAL_PIN_SetUartFunc.part.0+0x62>
20024b92:	bf00      	nop
20024b94:	5000b058 	.word	0x5000b058
20024b98:	4000ef0c 	.word	0x4000ef0c

20024b9c <HAL_PIN_SetAonPE>:
20024b9c:	2a00      	cmp	r2, #0
20024b9e:	d031      	beq.n	20024c04 <HAL_PIN_SetAonPE+0x68>
20024ba0:	282f      	cmp	r0, #47	@ 0x2f
20024ba2:	dd16      	ble.n	20024bd2 <HAL_PIN_SetAonPE+0x36>
20024ba4:	283a      	cmp	r0, #58	@ 0x3a
20024ba6:	dc2d      	bgt.n	20024c04 <HAL_PIN_SetAonPE+0x68>
20024ba8:	2301      	movs	r3, #1
20024baa:	4a17      	ldr	r2, [pc, #92]	@ (20024c08 <HAL_PIN_SetAonPE+0x6c>)
20024bac:	382a      	subs	r0, #42	@ 0x2a
20024bae:	4083      	lsls	r3, r0
20024bb0:	6f10      	ldr	r0, [r2, #112]	@ 0x70
20024bb2:	f011 0f20 	tst.w	r1, #32
20024bb6:	bf14      	ite	ne
20024bb8:	4318      	orrne	r0, r3
20024bba:	4398      	biceq	r0, r3
20024bbc:	6710      	str	r0, [r2, #112]	@ 0x70
20024bbe:	4a12      	ldr	r2, [pc, #72]	@ (20024c08 <HAL_PIN_SetAonPE+0x6c>)
20024bc0:	f011 0f10 	tst.w	r1, #16
20024bc4:	6ed1      	ldr	r1, [r2, #108]	@ 0x6c
20024bc6:	bf14      	ite	ne
20024bc8:	430b      	orrne	r3, r1
20024bca:	ea21 0303 	biceq.w	r3, r1, r3
20024bce:	66d3      	str	r3, [r2, #108]	@ 0x6c
20024bd0:	4770      	bx	lr
20024bd2:	3826      	subs	r0, #38	@ 0x26
20024bd4:	2803      	cmp	r0, #3
20024bd6:	d815      	bhi.n	20024c04 <HAL_PIN_SetAonPE+0x68>
20024bd8:	4b0c      	ldr	r3, [pc, #48]	@ (20024c0c <HAL_PIN_SetAonPE+0x70>)
20024bda:	f011 0f20 	tst.w	r1, #32
20024bde:	f853 2020 	ldr.w	r2, [r3, r0, lsl #2]
20024be2:	bf14      	ite	ne
20024be4:	f042 0210 	orrne.w	r2, r2, #16
20024be8:	f022 0210 	biceq.w	r2, r2, #16
20024bec:	f843 2020 	str.w	r2, [r3, r0, lsl #2]
20024bf0:	f853 2020 	ldr.w	r2, [r3, r0, lsl #2]
20024bf4:	06c9      	lsls	r1, r1, #27
20024bf6:	bf4c      	ite	mi
20024bf8:	f042 0208 	orrmi.w	r2, r2, #8
20024bfc:	f022 0208 	bicpl.w	r2, r2, #8
20024c00:	f843 2020 	str.w	r2, [r3, r0, lsl #2]
20024c04:	4770      	bx	lr
20024c06:	bf00      	nop
20024c08:	500cb000 	.word	0x500cb000
20024c0c:	500cb05c 	.word	0x500cb05c

20024c10 <HAL_PIN_Get_Base>:
20024c10:	b138      	cbz	r0, 20024c22 <HAL_PIN_Get_Base+0x12>
20024c12:	f04f 42a0 	mov.w	r2, #1342177280	@ 0x50000000
20024c16:	6893      	ldr	r3, [r2, #8]
20024c18:	4806      	ldr	r0, [pc, #24]	@ (20024c34 <HAL_PIN_Get_Base+0x24>)
20024c1a:	f043 0304 	orr.w	r3, r3, #4
20024c1e:	6093      	str	r3, [r2, #8]
20024c20:	4770      	bx	lr
20024c22:	f04f 4280 	mov.w	r2, #1073741824	@ 0x40000000
20024c26:	6853      	ldr	r3, [r2, #4]
20024c28:	4803      	ldr	r0, [pc, #12]	@ (20024c38 <HAL_PIN_Get_Base+0x28>)
20024c2a:	f043 0308 	orr.w	r3, r3, #8
20024c2e:	6053      	str	r3, [r2, #4]
20024c30:	4770      	bx	lr
20024c32:	bf00      	nop
20024c34:	50003000 	.word	0x50003000
20024c38:	40003000 	.word	0x40003000

20024c3c <HAL_PIN_Func2Idx>:
20024c3c:	283b      	cmp	r0, #59	@ 0x3b
20024c3e:	bfc8      	it	gt
20024c40:	383c      	subgt	r0, #60	@ 0x3c
20024c42:	0143      	lsls	r3, r0, #5
20024c44:	b162      	cbz	r2, 20024c60 <HAL_PIN_Func2Idx+0x24>
20024c46:	4a07      	ldr	r2, [pc, #28]	@ (20024c64 <HAL_PIN_Func2Idx+0x28>)
20024c48:	2000      	movs	r0, #0
20024c4a:	4413      	add	r3, r2
20024c4c:	f833 2010 	ldrh.w	r2, [r3, r0, lsl #1]
20024c50:	428a      	cmp	r2, r1
20024c52:	d004      	beq.n	20024c5e <HAL_PIN_Func2Idx+0x22>
20024c54:	3001      	adds	r0, #1
20024c56:	2810      	cmp	r0, #16
20024c58:	d1f8      	bne.n	20024c4c <HAL_PIN_Func2Idx+0x10>
20024c5a:	f04f 30ff 	mov.w	r0, #4294967295
20024c5e:	4770      	bx	lr
20024c60:	4a01      	ldr	r2, [pc, #4]	@ (20024c68 <HAL_PIN_Func2Idx+0x2c>)
20024c62:	e7f1      	b.n	20024c48 <HAL_PIN_Func2Idx+0xc>
20024c64:	2002b2fc 	.word	0x2002b2fc
20024c68:	2002b25c 	.word	0x2002b25c

20024c6c <HAL_PIN_Set>:
20024c6c:	e92d 47f0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, lr}
20024c70:	4615      	mov	r5, r2
20024c72:	4604      	mov	r4, r0
20024c74:	b918      	cbnz	r0, 20024c7e <HAL_PIN_Set+0x12>
20024c76:	f04f 30ff 	mov.w	r0, #4294967295
20024c7a:	e8bd 87f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, pc}
20024c7e:	283a      	cmp	r0, #58	@ 0x3a
20024c80:	bfcd      	iteet	gt
20024c82:	2700      	movgt	r7, #0
20024c84:	2701      	movle	r7, #1
20024c86:	4606      	movle	r6, r0
20024c88:	f1a0 063c 	subgt.w	r6, r0, #60	@ 0x3c
20024c8c:	4638      	mov	r0, r7
20024c8e:	f7ff ffbf 	bl	20024c10 <HAL_PIN_Get_Base>
20024c92:	4680      	mov	r8, r0
20024c94:	2f00      	cmp	r7, #0
20024c96:	f000 8150 	beq.w	20024f3a <HAL_PIN_Set+0x2ce>
20024c9a:	f1a4 0026 	sub.w	r0, r4, #38	@ 0x26
20024c9e:	2803      	cmp	r0, #3
20024ca0:	d80a      	bhi.n	20024cb8 <HAL_PIN_Set+0x4c>
20024ca2:	f8df c2c4 	ldr.w	ip, [pc, #708]	@ 20024f68 <HAL_PIN_Set+0x2fc>
20024ca6:	f104 4380 	add.w	r3, r4, #1073741824	@ 0x40000000
20024caa:	3b26      	subs	r3, #38	@ 0x26
20024cac:	f85c 2023 	ldr.w	r2, [ip, r3, lsl #2]
20024cb0:	f022 0202 	bic.w	r2, r2, #2
20024cb4:	f84c 2023 	str.w	r2, [ip, r3, lsl #2]
20024cb8:	f5a1 7390 	sub.w	r3, r1, #288	@ 0x120
20024cbc:	b29b      	uxth	r3, r3
20024cbe:	2b0b      	cmp	r3, #11
20024cc0:	d804      	bhi.n	20024ccc <HAL_PIN_Set+0x60>
20024cc2:	4620      	mov	r0, r4
20024cc4:	f7ff ff12 	bl	20024aec <HAL_PIN_SetUartFunc.part.0>
20024cc8:	4601      	mov	r1, r0
20024cca:	e025      	b.n	20024d18 <HAL_PIN_Set+0xac>
20024ccc:	f5a1 739c 	sub.w	r3, r1, #312	@ 0x138
20024cd0:	b29b      	uxth	r3, r3
20024cd2:	2b07      	cmp	r3, #7
20024cd4:	d844      	bhi.n	20024d60 <HAL_PIN_Set+0xf4>
20024cd6:	104a      	asrs	r2, r1, #1
20024cd8:	3a9c      	subs	r2, #156	@ 0x9c
20024cda:	eba1 0142 	sub.w	r1, r1, r2, lsl #1
20024cde:	b289      	uxth	r1, r1
20024ce0:	f5b1 7f9c 	cmp.w	r1, #312	@ 0x138
20024ce4:	d037      	beq.n	20024d56 <HAL_PIN_Set+0xea>
20024ce6:	f240 1339 	movw	r3, #313	@ 0x139
20024cea:	4299      	cmp	r1, r3
20024cec:	f040 812c 	bne.w	20024f48 <HAL_PIN_Set+0x2dc>
20024cf0:	f04f 0e08 	mov.w	lr, #8
20024cf4:	f44f 5c7c 	mov.w	ip, #16128	@ 0x3f00
20024cf8:	4994      	ldr	r1, [pc, #592]	@ (20024f4c <HAL_PIN_Set+0x2e0>)
20024cfa:	f1a4 030e 	sub.w	r3, r4, #14
20024cfe:	f851 0022 	ldr.w	r0, [r1, r2, lsl #2]
20024d02:	fa03 f30e 	lsl.w	r3, r3, lr
20024d06:	4043      	eors	r3, r0
20024d08:	ea03 030c 	and.w	r3, r3, ip
20024d0c:	4043      	eors	r3, r0
20024d0e:	f841 3022 	str.w	r3, [r1, r2, lsl #2]
20024d12:	f504 7129 	add.w	r1, r4, #676	@ 0x2a4
20024d16:	b289      	uxth	r1, r1
20024d18:	463a      	mov	r2, r7
20024d1a:	4620      	mov	r0, r4
20024d1c:	f7ff ff8e 	bl	20024c3c <HAL_PIN_Func2Idx>
20024d20:	f1b0 0900 	subs.w	r9, r0, #0
20024d24:	dba7      	blt.n	20024c76 <HAL_PIN_Set+0xa>
20024d26:	f106 4680 	add.w	r6, r6, #1073741824	@ 0x40000000
20024d2a:	4629      	mov	r1, r5
20024d2c:	4620      	mov	r0, r4
20024d2e:	3e01      	subs	r6, #1
20024d30:	463a      	mov	r2, r7
20024d32:	f7ff ff33 	bl	20024b9c <HAL_PIN_SetAonPE>
20024d36:	f858 3026 	ldr.w	r3, [r8, r6, lsl #2]
20024d3a:	f009 000f 	and.w	r0, r9, #15
20024d3e:	f005 0530 	and.w	r5, r5, #48	@ 0x30
20024d42:	4305      	orrs	r5, r0
20024d44:	f023 033f 	bic.w	r3, r3, #63	@ 0x3f
20024d48:	431d      	orrs	r5, r3
20024d4a:	f045 0540 	orr.w	r5, r5, #64	@ 0x40
20024d4e:	2000      	movs	r0, #0
20024d50:	f848 5026 	str.w	r5, [r8, r6, lsl #2]
20024d54:	e791      	b.n	20024c7a <HAL_PIN_Set+0xe>
20024d56:	f04f 0e00 	mov.w	lr, #0
20024d5a:	f04f 0c3f 	mov.w	ip, #63	@ 0x3f
20024d5e:	e7cb      	b.n	20024cf8 <HAL_PIN_Set+0x8c>
20024d60:	f5a1 73ec 	sub.w	r3, r1, #472	@ 0x1d8
20024d64:	b29a      	uxth	r2, r3
20024d66:	2a09      	cmp	r2, #9
20024d68:	d837      	bhi.n	20024dda <HAL_PIN_Set+0x16e>
20024d6a:	2205      	movs	r2, #5
20024d6c:	fbb3 f3f2 	udiv	r3, r3, r2
20024d70:	ebc3 3283 	rsb	r2, r3, r3, lsl #14
20024d74:	ebc3 0282 	rsb	r2, r3, r2, lsl #2
20024d78:	440a      	add	r2, r1
20024d7a:	b292      	uxth	r2, r2
20024d7c:	f5a2 71ec 	sub.w	r1, r2, #472	@ 0x1d8
20024d80:	b288      	uxth	r0, r1
20024d82:	2803      	cmp	r0, #3
20024d84:	d814      	bhi.n	20024db0 <HAL_PIN_Set+0x144>
20024d86:	f04f 0e3f 	mov.w	lr, #63	@ 0x3f
20024d8a:	4871      	ldr	r0, [pc, #452]	@ (20024f50 <HAL_PIN_Set+0x2e4>)
20024d8c:	00c9      	lsls	r1, r1, #3
20024d8e:	f850 c023 	ldr.w	ip, [r0, r3, lsl #2]
20024d92:	f1a4 020e 	sub.w	r2, r4, #14
20024d96:	408a      	lsls	r2, r1
20024d98:	ea82 020c 	eor.w	r2, r2, ip
20024d9c:	fa0e f101 	lsl.w	r1, lr, r1
20024da0:	400a      	ands	r2, r1
20024da2:	ea82 020c 	eor.w	r2, r2, ip
20024da6:	f840 2023 	str.w	r2, [r0, r3, lsl #2]
20024daa:	f204 2155 	addw	r1, r4, #597	@ 0x255
20024dae:	e7b2      	b.n	20024d16 <HAL_PIN_Set+0xaa>
20024db0:	f5b2 7fee 	cmp.w	r2, #476	@ 0x1dc
20024db4:	f040 80c8 	bne.w	20024f48 <HAL_PIN_Set+0x2dc>
20024db8:	213f      	movs	r1, #63	@ 0x3f
20024dba:	4866      	ldr	r0, [pc, #408]	@ (20024f54 <HAL_PIN_Set+0x2e8>)
20024dbc:	00da      	lsls	r2, r3, #3
20024dbe:	f8d0 c06c 	ldr.w	ip, [r0, #108]	@ 0x6c
20024dc2:	f1a4 030e 	sub.w	r3, r4, #14
20024dc6:	4093      	lsls	r3, r2
20024dc8:	ea83 030c 	eor.w	r3, r3, ip
20024dcc:	fa01 f202 	lsl.w	r2, r1, r2
20024dd0:	4013      	ands	r3, r2
20024dd2:	ea83 030c 	eor.w	r3, r3, ip
20024dd6:	66c3      	str	r3, [r0, #108]	@ 0x6c
20024dd8:	e7e7      	b.n	20024daa <HAL_PIN_Set+0x13e>
20024dda:	f46f 7c01 	mvn.w	ip, #516	@ 0x204
20024dde:	eb01 020c 	add.w	r2, r1, ip
20024de2:	b293      	uxth	r3, r2
20024de4:	2b05      	cmp	r3, #5
20024de6:	d828      	bhi.n	20024e3a <HAL_PIN_Set+0x1ce>
20024de8:	2303      	movs	r3, #3
20024dea:	fbb2 f2f3 	udiv	r2, r2, r3
20024dee:	ebc2 3382 	rsb	r3, r2, r2, lsl #14
20024df2:	eb02 0383 	add.w	r3, r2, r3, lsl #2
20024df6:	440b      	add	r3, r1
20024df8:	f46f 7101 	mvn.w	r1, #516	@ 0x204
20024dfc:	b29b      	uxth	r3, r3
20024dfe:	eb03 0c01 	add.w	ip, r3, r1
20024e02:	fa1f fc8c 	uxth.w	ip, ip
20024e06:	f1bc 0f02 	cmp.w	ip, #2
20024e0a:	f200 809d 	bhi.w	20024f48 <HAL_PIN_Set+0x2dc>
20024e0e:	00db      	lsls	r3, r3, #3
20024e10:	f5a3 5381 	sub.w	r3, r3, #4128	@ 0x1020
20024e14:	4950      	ldr	r1, [pc, #320]	@ (20024f58 <HAL_PIN_Set+0x2ec>)
20024e16:	f1a4 0e0e 	sub.w	lr, r4, #14
20024e1a:	3b08      	subs	r3, #8
20024e1c:	fa0e f303 	lsl.w	r3, lr, r3
20024e20:	f8df e148 	ldr.w	lr, [pc, #328]	@ 20024f6c <HAL_PIN_Set+0x300>
20024e24:	f851 0022 	ldr.w	r0, [r1, r2, lsl #2]
20024e28:	f85e c02c 	ldr.w	ip, [lr, ip, lsl #2]
20024e2c:	4043      	eors	r3, r0
20024e2e:	ea03 030c 	and.w	r3, r3, ip
20024e32:	4043      	eors	r3, r0
20024e34:	f841 3022 	str.w	r3, [r1, r2, lsl #2]
20024e38:	e7b7      	b.n	20024daa <HAL_PIN_Set+0x13e>
20024e3a:	f46f 72f8 	mvn.w	r2, #496	@ 0x1f0
20024e3e:	188b      	adds	r3, r1, r2
20024e40:	b29a      	uxth	r2, r3
20024e42:	2a09      	cmp	r2, #9
20024e44:	d82a      	bhi.n	20024e9c <HAL_PIN_Set+0x230>
20024e46:	f5b1 7ffc 	cmp.w	r1, #504	@ 0x1f8
20024e4a:	d216      	bcs.n	20024e7a <HAL_PIN_Set+0x20e>
20024e4c:	0859      	lsrs	r1, r3, #1
20024e4e:	f013 0f01 	tst.w	r3, #1
20024e52:	4b42      	ldr	r3, [pc, #264]	@ (20024f5c <HAL_PIN_Set+0x2f0>)
20024e54:	f04f 003f 	mov.w	r0, #63	@ 0x3f
20024e58:	4a41      	ldr	r2, [pc, #260]	@ (20024f60 <HAL_PIN_Set+0x2f4>)
20024e5a:	bf18      	it	ne
20024e5c:	461a      	movne	r2, r3
20024e5e:	00c9      	lsls	r1, r1, #3
20024e60:	4088      	lsls	r0, r1
20024e62:	f8d2 c000 	ldr.w	ip, [r2]
20024e66:	f1a4 030e 	sub.w	r3, r4, #14
20024e6a:	408b      	lsls	r3, r1
20024e6c:	ea83 030c 	eor.w	r3, r3, ip
20024e70:	4003      	ands	r3, r0
20024e72:	ea83 030c 	eor.w	r3, r3, ip
20024e76:	6013      	str	r3, [r2, #0]
20024e78:	e797      	b.n	20024daa <HAL_PIN_Set+0x13e>
20024e7a:	d007      	beq.n	20024e8c <HAL_PIN_Set+0x220>
20024e7c:	f240 13f9 	movw	r3, #505	@ 0x1f9
20024e80:	4299      	cmp	r1, r3
20024e82:	d107      	bne.n	20024e94 <HAL_PIN_Set+0x228>
20024e84:	2100      	movs	r1, #0
20024e86:	203f      	movs	r0, #63	@ 0x3f
20024e88:	4a36      	ldr	r2, [pc, #216]	@ (20024f64 <HAL_PIN_Set+0x2f8>)
20024e8a:	e7ea      	b.n	20024e62 <HAL_PIN_Set+0x1f6>
20024e8c:	2110      	movs	r1, #16
20024e8e:	f44f 107c 	mov.w	r0, #4128768	@ 0x3f0000
20024e92:	e7f9      	b.n	20024e88 <HAL_PIN_Set+0x21c>
20024e94:	2108      	movs	r1, #8
20024e96:	f44f 507c 	mov.w	r0, #16128	@ 0x3f00
20024e9a:	e7f5      	b.n	20024e88 <HAL_PIN_Set+0x21c>
20024e9c:	f46f 7358 	mvn.w	r3, #864	@ 0x360
20024ea0:	18cb      	adds	r3, r1, r3
20024ea2:	b29b      	uxth	r3, r3
20024ea4:	2b05      	cmp	r3, #5
20024ea6:	f63f af37 	bhi.w	20024d18 <HAL_PIN_Set+0xac>
20024eaa:	2803      	cmp	r0, #3
20024eac:	d84c      	bhi.n	20024f48 <HAL_PIN_Set+0x2dc>
20024eae:	f104 4380 	add.w	r3, r4, #1073741824	@ 0x40000000
20024eb2:	f2a1 3262 	subw	r2, r1, #866	@ 0x362
20024eb6:	f8df c0b0 	ldr.w	ip, [pc, #176]	@ 20024f68 <HAL_PIN_Set+0x2fc>
20024eba:	3b26      	subs	r3, #38	@ 0x26
20024ebc:	2a04      	cmp	r2, #4
20024ebe:	d815      	bhi.n	20024eec <HAL_PIN_Set+0x280>
20024ec0:	e8df f002 	tbb	[pc, r2]
20024ec4:	31032a38 	.word	0x31032a38
20024ec8:	23          	.byte	0x23
20024ec9:	00          	.byte	0x00
20024eca:	f44f 5240 	mov.w	r2, #12288	@ 0x3000
20024ece:	f04f 4ae0 	mov.w	sl, #1879048192	@ 0x70000000
20024ed2:	f04f 5e00 	mov.w	lr, #536870912	@ 0x20000000
20024ed6:	f8df 9098 	ldr.w	r9, [pc, #152]	@ 20024f70 <HAL_PIN_Set+0x304>
20024eda:	f8d9 0004 	ldr.w	r0, [r9, #4]
20024ede:	ea20 000a 	bic.w	r0, r0, sl
20024ee2:	ea40 000e 	orr.w	r0, r0, lr
20024ee6:	f8c9 0004 	str.w	r0, [r9, #4]
20024eea:	e000      	b.n	20024eee <HAL_PIN_Set+0x282>
20024eec:	2200      	movs	r2, #0
20024eee:	f85c 0023 	ldr.w	r0, [ip, r3, lsl #2]
20024ef2:	f420 40e0 	bic.w	r0, r0, #28672	@ 0x7000
20024ef6:	4302      	orrs	r2, r0
20024ef8:	f84c 2023 	str.w	r2, [ip, r3, lsl #2]
20024efc:	f85c 2023 	ldr.w	r2, [ip, r3, lsl #2]
20024f00:	f042 0202 	orr.w	r2, r2, #2
20024f04:	f84c 2023 	str.w	r2, [ip, r3, lsl #2]
20024f08:	e706      	b.n	20024d18 <HAL_PIN_Set+0xac>
20024f0a:	f44f 5240 	mov.w	r2, #12288	@ 0x3000
20024f0e:	f04f 4ae0 	mov.w	sl, #1879048192	@ 0x70000000
20024f12:	f04f 5e40 	mov.w	lr, #805306368	@ 0x30000000
20024f16:	e7de      	b.n	20024ed6 <HAL_PIN_Set+0x26a>
20024f18:	f44f 5200 	mov.w	r2, #8192	@ 0x2000
20024f1c:	f04f 6a60 	mov.w	sl, #234881024	@ 0xe000000
20024f20:	f04f 6e80 	mov.w	lr, #67108864	@ 0x4000000
20024f24:	e7d7      	b.n	20024ed6 <HAL_PIN_Set+0x26a>
20024f26:	f44f 5200 	mov.w	r2, #8192	@ 0x2000
20024f2a:	f04f 6a60 	mov.w	sl, #234881024	@ 0xe000000
20024f2e:	f04f 6ec0 	mov.w	lr, #100663296	@ 0x6000000
20024f32:	e7d0      	b.n	20024ed6 <HAL_PIN_Set+0x26a>
20024f34:	f44f 5280 	mov.w	r2, #4096	@ 0x1000
20024f38:	e7d9      	b.n	20024eee <HAL_PIN_Set+0x282>
20024f3a:	f5a1 7396 	sub.w	r3, r1, #300	@ 0x12c
20024f3e:	b29b      	uxth	r3, r3
20024f40:	2b07      	cmp	r3, #7
20024f42:	f63f aee9 	bhi.w	20024d18 <HAL_PIN_Set+0xac>
20024f46:	e6bc      	b.n	20024cc2 <HAL_PIN_Set+0x56>
20024f48:	2100      	movs	r1, #0
20024f4a:	e6e5      	b.n	20024d18 <HAL_PIN_Set+0xac>
20024f4c:	5000b048 	.word	0x5000b048
20024f50:	5000b064 	.word	0x5000b064
20024f54:	5000b000 	.word	0x5000b000
20024f58:	5000b070 	.word	0x5000b070
20024f5c:	5000b07c 	.word	0x5000b07c
20024f60:	5000b078 	.word	0x5000b078
20024f64:	5000b080 	.word	0x5000b080
20024f68:	500cb05c 	.word	0x500cb05c
20024f6c:	2002ba70 	.word	0x2002ba70
20024f70:	500c0000 	.word	0x500c0000

20024f74 <HAL_PIN_Set_Analog>:
20024f74:	283a      	cmp	r0, #58	@ 0x3a
20024f76:	b538      	push	{r3, r4, r5, lr}
20024f78:	bfcd      	iteet	gt
20024f7a:	2500      	movgt	r5, #0
20024f7c:	2501      	movle	r5, #1
20024f7e:	4601      	movle	r1, r0
20024f80:	f1a0 013c 	subgt.w	r1, r0, #60	@ 0x3c
20024f84:	4604      	mov	r4, r0
20024f86:	4628      	mov	r0, r5
20024f88:	f7ff fe42 	bl	20024c10 <HAL_PIN_Get_Base>
20024f8c:	f101 4380 	add.w	r3, r1, #1073741824	@ 0x40000000
20024f90:	3b01      	subs	r3, #1
20024f92:	f850 1023 	ldr.w	r1, [r0, r3, lsl #2]
20024f96:	462a      	mov	r2, r5
20024f98:	f021 015f 	bic.w	r1, r1, #95	@ 0x5f
20024f9c:	f041 010f 	orr.w	r1, r1, #15
20024fa0:	f840 1023 	str.w	r1, [r0, r3, lsl #2]
20024fa4:	4620      	mov	r0, r4
20024fa6:	2100      	movs	r1, #0
20024fa8:	f7ff fdf8 	bl	20024b9c <HAL_PIN_SetAonPE>
20024fac:	2000      	movs	r0, #0
20024fae:	bd38      	pop	{r3, r4, r5, pc}

20024fb0 <HAL_PMU_EnableDLL>:
20024fb0:	4b05      	ldr	r3, [pc, #20]	@ (20024fc8 <HAL_PMU_EnableDLL+0x18>)
20024fb2:	6e9a      	ldr	r2, [r3, #104]	@ 0x68
20024fb4:	b120      	cbz	r0, 20024fc0 <HAL_PMU_EnableDLL+0x10>
20024fb6:	f042 0220 	orr.w	r2, r2, #32
20024fba:	2000      	movs	r0, #0
20024fbc:	669a      	str	r2, [r3, #104]	@ 0x68
20024fbe:	4770      	bx	lr
20024fc0:	f022 0220 	bic.w	r2, r2, #32
20024fc4:	e7f9      	b.n	20024fba <HAL_PMU_EnableDLL+0xa>
20024fc6:	bf00      	nop
20024fc8:	500ca000 	.word	0x500ca000

20024fcc <HAL_RCC_HCPU_ConfigSxModeVolt>:
20024fcc:	b507      	push	{r0, r1, r2, lr}
20024fce:	4a13      	ldr	r2, [pc, #76]	@ (2002501c <HAL_RCC_HCPU_ConfigSxModeVolt+0x50>)
20024fd0:	4913      	ldr	r1, [pc, #76]	@ (20025020 <HAL_RCC_HCPU_ConfigSxModeVolt+0x54>)
20024fd2:	eb02 02c0 	add.w	r2, r2, r0, lsl #3
20024fd6:	f8d1 309c 	ldr.w	r3, [r1, #156]	@ 0x9c
20024fda:	7892      	ldrb	r2, [r2, #2]
20024fdc:	2802      	cmp	r0, #2
20024fde:	f362 0303 	bfi	r3, r2, #0, #4
20024fe2:	f8c1 309c 	str.w	r3, [r1, #156]	@ 0x9c
20024fe6:	f10d 0007 	add.w	r0, sp, #7
20024fea:	d111      	bne.n	20025010 <HAL_RCC_HCPU_ConfigSxModeVolt+0x44>
20024fec:	f007 faf6 	bl	2002c5dc <HAL_PMU_GetHpsysVoutRef>
20024ff0:	b110      	cbz	r0, 20024ff8 <HAL_RCC_HCPU_ConfigSxModeVolt+0x2c>
20024ff2:	230b      	movs	r3, #11
20024ff4:	f88d 3007 	strb.w	r3, [sp, #7]
20024ff8:	4a09      	ldr	r2, [pc, #36]	@ (20025020 <HAL_RCC_HCPU_ConfigSxModeVolt+0x54>)
20024ffa:	f89d 1007 	ldrb.w	r1, [sp, #7]
20024ffe:	f8d2 3094 	ldr.w	r3, [r2, #148]	@ 0x94
20025002:	f361 0303 	bfi	r3, r1, #0, #4
20025006:	f8c2 3094 	str.w	r3, [r2, #148]	@ 0x94
2002500a:	b003      	add	sp, #12
2002500c:	f85d fb04 	ldr.w	pc, [sp], #4
20025010:	f007 faf0 	bl	2002c5f4 <HAL_PMU_GetHpsysVoutRef2>
20025014:	2800      	cmp	r0, #0
20025016:	d0ef      	beq.n	20024ff8 <HAL_RCC_HCPU_ConfigSxModeVolt+0x2c>
20025018:	230d      	movs	r3, #13
2002501a:	e7eb      	b.n	20024ff4 <HAL_RCC_HCPU_ConfigSxModeVolt+0x28>
2002501c:	2002ba8c 	.word	0x2002ba8c
20025020:	500ca000 	.word	0x500ca000

20025024 <HAL_RCC_HCPU_GetClockSrc>:
20025024:	f04f 43a0 	mov.w	r3, #1342177280	@ 0x50000000
20025028:	280d      	cmp	r0, #13
2002502a:	6a1a      	ldr	r2, [r3, #32]
2002502c:	d80d      	bhi.n	2002504a <HAL_RCC_HCPU_GetClockSrc+0x26>
2002502e:	f642 73f1 	movw	r3, #12273	@ 0x2ff1
20025032:	40c3      	lsrs	r3, r0
20025034:	f013 0f01 	tst.w	r3, #1
20025038:	bf0c      	ite	eq
2002503a:	2301      	moveq	r3, #1
2002503c:	2303      	movne	r3, #3
2002503e:	4083      	lsls	r3, r0
20025040:	4013      	ands	r3, r2
20025042:	fa23 f000 	lsr.w	r0, r3, r0
20025046:	b2c0      	uxtb	r0, r0
20025048:	4770      	bx	lr
2002504a:	2301      	movs	r3, #1
2002504c:	e7f7      	b.n	2002503e <HAL_RCC_HCPU_GetClockSrc+0x1a>
	...

20025050 <HAL_RCC_HCPU_GetDLLFreq>:
20025050:	2801      	cmp	r0, #1
20025052:	d003      	beq.n	2002505c <HAL_RCC_HCPU_GetDLLFreq+0xc>
20025054:	2802      	cmp	r0, #2
20025056:	d00e      	beq.n	20025076 <HAL_RCC_HCPU_GetDLLFreq+0x26>
20025058:	2000      	movs	r0, #0
2002505a:	4770      	bx	lr
2002505c:	f04f 43a0 	mov.w	r3, #1342177280	@ 0x50000000
20025060:	6adb      	ldr	r3, [r3, #44]	@ 0x2c
20025062:	b163      	cbz	r3, 2002507e <HAL_RCC_HCPU_GetDLLFreq+0x2e>
20025064:	f013 0001 	ands.w	r0, r3, #1
20025068:	d00a      	beq.n	20025080 <HAL_RCC_HCPU_GetDLLFreq+0x30>
2002506a:	4806      	ldr	r0, [pc, #24]	@ (20025084 <HAL_RCC_HCPU_GetDLLFreq+0x34>)
2002506c:	f3c3 0383 	ubfx	r3, r3, #2, #4
20025070:	fb03 0000 	mla	r0, r3, r0, r0
20025074:	4770      	bx	lr
20025076:	f04f 43a0 	mov.w	r3, #1342177280	@ 0x50000000
2002507a:	6b1b      	ldr	r3, [r3, #48]	@ 0x30
2002507c:	e7f1      	b.n	20025062 <HAL_RCC_HCPU_GetDLLFreq+0x12>
2002507e:	4618      	mov	r0, r3
20025080:	4770      	bx	lr
20025082:	bf00      	nop
20025084:	016e3600 	.word	0x016e3600

20025088 <HAL_RCC_HCPU_GetDLL1Freq>:
20025088:	2001      	movs	r0, #1
2002508a:	f7ff bfe1 	b.w	20025050 <HAL_RCC_HCPU_GetDLLFreq>

2002508e <HAL_RCC_HCPU_GetDLL2Freq>:
2002508e:	2002      	movs	r0, #2
20025090:	f7ff bfde 	b.w	20025050 <HAL_RCC_HCPU_GetDLLFreq>

20025094 <HAL_RCC_HCPU_GetDLL3Freq>:
20025094:	2000      	movs	r0, #0
20025096:	4770      	bx	lr

20025098 <HAL_RCC_HCPU_EnableDLL>:
20025098:	4b23      	ldr	r3, [pc, #140]	@ (20025128 <HAL_RCC_HCPU_EnableDLL+0x90>)
2002509a:	f1a1 71b7 	sub.w	r1, r1, #23986176	@ 0x16e0000
2002509e:	f5a1 5158 	sub.w	r1, r1, #13824	@ 0x3600
200250a2:	4299      	cmp	r1, r3
200250a4:	b510      	push	{r4, lr}
200250a6:	d83c      	bhi.n	20025122 <HAL_RCC_HCPU_EnableDLL+0x8a>
200250a8:	2801      	cmp	r0, #1
200250aa:	d002      	beq.n	200250b2 <HAL_RCC_HCPU_EnableDLL+0x1a>
200250ac:	2802      	cmp	r0, #2
200250ae:	d036      	beq.n	2002511e <HAL_RCC_HCPU_EnableDLL+0x86>
200250b0:	e7fe      	b.n	200250b0 <HAL_RCC_HCPU_EnableDLL+0x18>
200250b2:	4c1e      	ldr	r4, [pc, #120]	@ (2002512c <HAL_RCC_HCPU_EnableDLL+0x94>)
200250b4:	4b1e      	ldr	r3, [pc, #120]	@ (20025130 <HAL_RCC_HCPU_EnableDLL+0x98>)
200250b6:	f8d3 2094 	ldr.w	r2, [r3, #148]	@ 0x94
200250ba:	0790      	lsls	r0, r2, #30
200250bc:	bf58      	it	pl
200250be:	f8d3 2094 	ldrpl.w	r2, [r3, #148]	@ 0x94
200250c2:	f04f 0000 	mov.w	r0, #0
200250c6:	bf5c      	itt	pl
200250c8:	f042 0202 	orrpl.w	r2, r2, #2
200250cc:	f8c3 2094 	strpl.w	r2, [r3, #148]	@ 0x94
200250d0:	f8d3 2094 	ldr.w	r2, [r3, #148]	@ 0x94
200250d4:	07d2      	lsls	r2, r2, #31
200250d6:	bf5e      	ittt	pl
200250d8:	f8d3 2094 	ldrpl.w	r2, [r3, #148]	@ 0x94
200250dc:	f042 0201 	orrpl.w	r2, r2, #1
200250e0:	f8c3 2094 	strpl.w	r2, [r3, #148]	@ 0x94
200250e4:	4a13      	ldr	r2, [pc, #76]	@ (20025134 <HAL_RCC_HCPU_EnableDLL+0x9c>)
200250e6:	6823      	ldr	r3, [r4, #0]
200250e8:	fbb1 f1f2 	udiv	r1, r1, r2
200250ec:	f023 0301 	bic.w	r3, r3, #1
200250f0:	6023      	str	r3, [r4, #0]
200250f2:	6823      	ldr	r3, [r4, #0]
200250f4:	f423 5300 	bic.w	r3, r3, #8192	@ 0x2000
200250f8:	f023 033c 	bic.w	r3, r3, #60	@ 0x3c
200250fc:	ea43 0381 	orr.w	r3, r3, r1, lsl #2
20025100:	f443 5380 	orr.w	r3, r3, #4096	@ 0x1000
20025104:	f043 0301 	orr.w	r3, r3, #1
20025108:	6023      	str	r3, [r4, #0]
2002510a:	f7fd f876 	bl	200221fa <HAL_Delay_us>
2002510e:	200a      	movs	r0, #10
20025110:	f7fd f873 	bl	200221fa <HAL_Delay_us>
20025114:	6823      	ldr	r3, [r4, #0]
20025116:	2b00      	cmp	r3, #0
20025118:	dafc      	bge.n	20025114 <HAL_RCC_HCPU_EnableDLL+0x7c>
2002511a:	2000      	movs	r0, #0
2002511c:	bd10      	pop	{r4, pc}
2002511e:	4c06      	ldr	r4, [pc, #24]	@ (20025138 <HAL_RCC_HCPU_EnableDLL+0xa0>)
20025120:	e7c8      	b.n	200250b4 <HAL_RCC_HCPU_EnableDLL+0x1c>
20025122:	2001      	movs	r0, #1
20025124:	e7fa      	b.n	2002511c <HAL_RCC_HCPU_EnableDLL+0x84>
20025126:	bf00      	nop
20025128:	15752a00 	.word	0x15752a00
2002512c:	5000002c 	.word	0x5000002c
20025130:	5000b000 	.word	0x5000b000
20025134:	016e3600 	.word	0x016e3600
20025138:	50000030 	.word	0x50000030

2002513c <HAL_RCC_HCPU_EnableDLL1>:
2002513c:	4601      	mov	r1, r0
2002513e:	2001      	movs	r0, #1
20025140:	f7ff bfaa 	b.w	20025098 <HAL_RCC_HCPU_EnableDLL>

20025144 <HAL_RCC_HCPU_EnableDLL2>:
20025144:	4601      	mov	r1, r0
20025146:	2002      	movs	r0, #2
20025148:	f7ff bfa6 	b.w	20025098 <HAL_RCC_HCPU_EnableDLL>

2002514c <HAL_RCC_HCPU_DisableDLL1>:
2002514c:	f04f 42a0 	mov.w	r2, #1342177280	@ 0x50000000
20025150:	6ad3      	ldr	r3, [r2, #44]	@ 0x2c
20025152:	2000      	movs	r0, #0
20025154:	f023 0301 	bic.w	r3, r3, #1
20025158:	62d3      	str	r3, [r2, #44]	@ 0x2c
2002515a:	4770      	bx	lr

2002515c <HAL_RCC_GetSysCLKFreq>:
2002515c:	2801      	cmp	r0, #1
2002515e:	d108      	bne.n	20025172 <HAL_RCC_GetSysCLKFreq+0x16>
20025160:	f04f 43a0 	mov.w	r3, #1342177280	@ 0x50000000
20025164:	6a1b      	ldr	r3, [r3, #32]
20025166:	f003 0303 	and.w	r3, r3, #3
2002516a:	2b03      	cmp	r3, #3
2002516c:	d101      	bne.n	20025172 <HAL_RCC_GetSysCLKFreq+0x16>
2002516e:	f7ff bf8b 	b.w	20025088 <HAL_RCC_HCPU_GetDLL1Freq>
20025172:	4801      	ldr	r0, [pc, #4]	@ (20025178 <HAL_RCC_GetSysCLKFreq+0x1c>)
20025174:	4770      	bx	lr
20025176:	bf00      	nop
20025178:	02dc6c00 	.word	0x02dc6c00

2002517c <HAL_RCC_GetHCLKFreq>:
2002517c:	1e02      	subs	r2, r0, #0
2002517e:	bf08      	it	eq
20025180:	2201      	moveq	r2, #1
20025182:	b508      	push	{r3, lr}
20025184:	4610      	mov	r0, r2
20025186:	f7ff ffe9 	bl	2002515c <HAL_RCC_GetSysCLKFreq>
2002518a:	2a01      	cmp	r2, #1
2002518c:	d002      	beq.n	20025194 <HAL_RCC_GetHCLKFreq+0x18>
2002518e:	2a02      	cmp	r2, #2
20025190:	d00a      	beq.n	200251a8 <HAL_RCC_GetHCLKFreq+0x2c>
20025192:	e7fe      	b.n	20025192 <HAL_RCC_GetHCLKFreq+0x16>
20025194:	f04f 43a0 	mov.w	r3, #1342177280	@ 0x50000000
20025198:	6a5b      	ldr	r3, [r3, #36]	@ 0x24
2002519a:	b2db      	uxtb	r3, r3
2002519c:	2b01      	cmp	r3, #1
2002519e:	bfb8      	it	lt
200251a0:	2301      	movlt	r3, #1
200251a2:	fbb0 f0f3 	udiv	r0, r0, r3
200251a6:	bd08      	pop	{r3, pc}
200251a8:	f04f 4380 	mov.w	r3, #1073741824	@ 0x40000000
200251ac:	695b      	ldr	r3, [r3, #20]
200251ae:	f003 033f 	and.w	r3, r3, #63	@ 0x3f
200251b2:	e7f3      	b.n	2002519c <HAL_RCC_GetHCLKFreq+0x20>

200251b4 <HAL_RCC_HCPU_ClockSelect>:
200251b4:	f04f 43a0 	mov.w	r3, #1342177280	@ 0x50000000
200251b8:	b510      	push	{r4, lr}
200251ba:	280d      	cmp	r0, #13
200251bc:	6a1b      	ldr	r3, [r3, #32]
200251be:	d818      	bhi.n	200251f2 <HAL_RCC_HCPU_ClockSelect+0x3e>
200251c0:	f642 72f1 	movw	r2, #12273	@ 0x2ff1
200251c4:	40c2      	lsrs	r2, r0
200251c6:	f012 0f01 	tst.w	r2, #1
200251ca:	bf0c      	ite	eq
200251cc:	2201      	moveq	r2, #1
200251ce:	2203      	movne	r2, #3
200251d0:	fa02 f400 	lsl.w	r4, r2, r0
200251d4:	4011      	ands	r1, r2
200251d6:	f04f 42a0 	mov.w	r2, #1342177280	@ 0x50000000
200251da:	ea23 0304 	bic.w	r3, r3, r4
200251de:	4081      	lsls	r1, r0
200251e0:	430b      	orrs	r3, r1
200251e2:	6213      	str	r3, [r2, #32]
200251e4:	b920      	cbnz	r0, 200251f0 <HAL_RCC_HCPU_ClockSelect+0x3c>
200251e6:	2001      	movs	r0, #1
200251e8:	f7ff ffc8 	bl	2002517c <HAL_RCC_GetHCLKFreq>
200251ec:	4b02      	ldr	r3, [pc, #8]	@ (200251f8 <HAL_RCC_HCPU_ClockSelect+0x44>)
200251ee:	6018      	str	r0, [r3, #0]
200251f0:	bd10      	pop	{r4, pc}
200251f2:	2201      	movs	r2, #1
200251f4:	e7ec      	b.n	200251d0 <HAL_RCC_HCPU_ClockSelect+0x1c>
200251f6:	bf00      	nop
200251f8:	20042c10 	.word	0x20042c10

200251fc <HAL_RCC_HCPU_SetDiv>:
200251fc:	2800      	cmp	r0, #0
200251fe:	bfd8      	it	le
20025200:	2000      	movle	r0, #0
20025202:	b508      	push	{r3, lr}
20025204:	bfcc      	ite	gt
20025206:	23ff      	movgt	r3, #255	@ 0xff
20025208:	4603      	movle	r3, r0
2002520a:	2900      	cmp	r1, #0
2002520c:	db12      	blt.n	20025234 <HAL_RCC_HCPU_SetDiv+0x38>
2002520e:	2a00      	cmp	r2, #0
20025210:	f443 63e0 	orr.w	r3, r3, #1792	@ 0x700
20025214:	ea40 2001 	orr.w	r0, r0, r1, lsl #8
20025218:	da0e      	bge.n	20025238 <HAL_RCC_HCPU_SetDiv+0x3c>
2002521a:	f04f 41a0 	mov.w	r1, #1342177280	@ 0x50000000
2002521e:	6a4a      	ldr	r2, [r1, #36]	@ 0x24
20025220:	ea22 0303 	bic.w	r3, r2, r3
20025224:	4303      	orrs	r3, r0
20025226:	624b      	str	r3, [r1, #36]	@ 0x24
20025228:	2001      	movs	r0, #1
2002522a:	f7ff ffa7 	bl	2002517c <HAL_RCC_GetHCLKFreq>
2002522e:	4b07      	ldr	r3, [pc, #28]	@ (2002524c <HAL_RCC_HCPU_SetDiv+0x50>)
20025230:	6018      	str	r0, [r3, #0]
20025232:	bd08      	pop	{r3, pc}
20025234:	2a00      	cmp	r2, #0
20025236:	db04      	blt.n	20025242 <HAL_RCC_HCPU_SetDiv+0x46>
20025238:	f443 43e0 	orr.w	r3, r3, #28672	@ 0x7000
2002523c:	ea40 3002 	orr.w	r0, r0, r2, lsl #12
20025240:	e7eb      	b.n	2002521a <HAL_RCC_HCPU_SetDiv+0x1e>
20025242:	2b00      	cmp	r3, #0
20025244:	d0f0      	beq.n	20025228 <HAL_RCC_HCPU_SetDiv+0x2c>
20025246:	23ff      	movs	r3, #255	@ 0xff
20025248:	e7e7      	b.n	2002521a <HAL_RCC_HCPU_SetDiv+0x1e>
2002524a:	bf00      	nop
2002524c:	20042c10 	.word	0x20042c10

20025250 <HAL_RCC_HCPU_SwitchDvfsD2S>:
20025250:	b570      	push	{r4, r5, r6, lr}
20025252:	460c      	mov	r4, r1
20025254:	4d19      	ldr	r5, [pc, #100]	@ (200252bc <HAL_RCC_HCPU_SwitchDvfsD2S+0x6c>)
20025256:	4606      	mov	r6, r0
20025258:	f7ff feb8 	bl	20024fcc <HAL_RCC_HCPU_ConfigSxModeVolt>
2002525c:	692b      	ldr	r3, [r5, #16]
2002525e:	20fa      	movs	r0, #250	@ 0xfa
20025260:	f023 0304 	bic.w	r3, r3, #4
20025264:	612b      	str	r3, [r5, #16]
20025266:	f7fc ffc8 	bl	200221fa <HAL_Delay_us>
2002526a:	2c30      	cmp	r4, #48	@ 0x30
2002526c:	d80d      	bhi.n	2002528a <HAL_RCC_HCPU_SwitchDvfsD2S+0x3a>
2002526e:	2100      	movs	r1, #0
20025270:	4608      	mov	r0, r1
20025272:	f7ff ff9f 	bl	200251b4 <HAL_RCC_HCPU_ClockSelect>
20025276:	2030      	movs	r0, #48	@ 0x30
20025278:	2204      	movs	r2, #4
2002527a:	2100      	movs	r1, #0
2002527c:	fbb0 f0f4 	udiv	r0, r0, r4
20025280:	f7ff ffbc 	bl	200251fc <HAL_RCC_HCPU_SetDiv>
20025284:	2400      	movs	r4, #0
20025286:	4620      	mov	r0, r4
20025288:	bd70      	pop	{r4, r5, r6, pc}
2002528a:	f7fd fce5 	bl	20022c58 <HAL_HPAON_EnableXT48>
2002528e:	480c      	ldr	r0, [pc, #48]	@ (200252c0 <HAL_RCC_HCPU_SwitchDvfsD2S+0x70>)
20025290:	eb00 00c6 	add.w	r0, r0, r6, lsl #3
20025294:	6843      	ldr	r3, [r0, #4]
20025296:	480b      	ldr	r0, [pc, #44]	@ (200252c4 <HAL_RCC_HCPU_SwitchDvfsD2S+0x74>)
20025298:	61eb      	str	r3, [r5, #28]
2002529a:	4360      	muls	r0, r4
2002529c:	f7ff ff4e 	bl	2002513c <HAL_RCC_HCPU_EnableDLL1>
200252a0:	4604      	mov	r4, r0
200252a2:	2800      	cmp	r0, #0
200252a4:	d1ef      	bne.n	20025286 <HAL_RCC_HCPU_SwitchDvfsD2S+0x36>
200252a6:	2101      	movs	r1, #1
200252a8:	2206      	movs	r2, #6
200252aa:	4608      	mov	r0, r1
200252ac:	f7ff ffa6 	bl	200251fc <HAL_RCC_HCPU_SetDiv>
200252b0:	2103      	movs	r1, #3
200252b2:	4620      	mov	r0, r4
200252b4:	f7ff ff7e 	bl	200251b4 <HAL_RCC_HCPU_ClockSelect>
200252b8:	e7e4      	b.n	20025284 <HAL_RCC_HCPU_SwitchDvfsD2S+0x34>
200252ba:	bf00      	nop
200252bc:	5000b000 	.word	0x5000b000
200252c0:	2002ba8c 	.word	0x2002ba8c
200252c4:	000f4240 	.word	0x000f4240

200252c8 <HAL_RCC_HCPU_SwitchDvfsS2D.isra.0>:
200252c8:	e92d 41f3 	stmdb	sp!, {r0, r1, r4, r5, r6, r7, r8, lr}
200252cc:	4c1d      	ldr	r4, [pc, #116]	@ (20025344 <HAL_RCC_HCPU_SwitchDvfsS2D.isra.0+0x7c>)
200252ce:	4f1e      	ldr	r7, [pc, #120]	@ (20025348 <HAL_RCC_HCPU_SwitchDvfsS2D.isra.0+0x80>)
200252d0:	eb04 02c0 	add.w	r2, r4, r0, lsl #3
200252d4:	6b3b      	ldr	r3, [r7, #48]	@ 0x30
200252d6:	7892      	ldrb	r2, [r2, #2]
200252d8:	4605      	mov	r5, r0
200252da:	f362 5317 	bfi	r3, r2, #20, #4
200252de:	ea4f 08c0 	mov.w	r8, r0, lsl #3
200252e2:	633b      	str	r3, [r7, #48]	@ 0x30
200252e4:	f10d 0007 	add.w	r0, sp, #7
200252e8:	460e      	mov	r6, r1
200252ea:	f007 f977 	bl	2002c5dc <HAL_PMU_GetHpsysVoutRef>
200252ee:	b110      	cbz	r0, 200252f6 <HAL_RCC_HCPU_SwitchDvfsS2D.isra.0+0x2e>
200252f0:	230b      	movs	r3, #11
200252f2:	f88d 3007 	strb.w	r3, [sp, #7]
200252f6:	f89d 1007 	ldrb.w	r1, [sp, #7]
200252fa:	f914 2035 	ldrsb.w	r2, [r4, r5, lsl #3]
200252fe:	6cfb      	ldr	r3, [r7, #76]	@ 0x4c
20025300:	440a      	add	r2, r1
20025302:	2100      	movs	r1, #0
20025304:	f362 0385 	bfi	r3, r2, #2, #4
20025308:	4608      	mov	r0, r1
2002530a:	64fb      	str	r3, [r7, #76]	@ 0x4c
2002530c:	f7ff ff52 	bl	200251b4 <HAL_RCC_HCPU_ClockSelect>
20025310:	2e30      	cmp	r6, #48	@ 0x30
20025312:	d900      	bls.n	20025316 <HAL_RCC_HCPU_SwitchDvfsS2D.isra.0+0x4e>
20025314:	e7fe      	b.n	20025314 <HAL_RCC_HCPU_SwitchDvfsS2D.isra.0+0x4c>
20025316:	2030      	movs	r0, #48	@ 0x30
20025318:	2204      	movs	r2, #4
2002531a:	2100      	movs	r1, #0
2002531c:	fbb0 f0f6 	udiv	r0, r0, r6
20025320:	f7ff ff6c 	bl	200251fc <HAL_RCC_HCPU_SetDiv>
20025324:	f7ff ff12 	bl	2002514c <HAL_RCC_HCPU_DisableDLL1>
20025328:	f7fd fca2 	bl	20022c70 <HAL_HPAON_DisableXT48>
2002532c:	4444      	add	r4, r8
2002532e:	4b07      	ldr	r3, [pc, #28]	@ (2002534c <HAL_RCC_HCPU_SwitchDvfsS2D.isra.0+0x84>)
20025330:	6862      	ldr	r2, [r4, #4]
20025332:	61da      	str	r2, [r3, #28]
20025334:	691a      	ldr	r2, [r3, #16]
20025336:	f042 0204 	orr.w	r2, r2, #4
2002533a:	611a      	str	r2, [r3, #16]
2002533c:	b002      	add	sp, #8
2002533e:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}
20025342:	bf00      	nop
20025344:	2002ba8c 	.word	0x2002ba8c
20025348:	500ca000 	.word	0x500ca000
2002534c:	5000b000 	.word	0x5000b000

20025350 <HAL_RCC_HCPU_ConfigDvfs>:
20025350:	b570      	push	{r4, r5, r6, lr}
20025352:	4e31      	ldr	r6, [pc, #196]	@ (20025418 <HAL_RCC_HCPU_ConfigDvfs+0xc8>)
20025354:	4605      	mov	r5, r0
20025356:	7833      	ldrb	r3, [r6, #0]
20025358:	460c      	mov	r4, r1
2002535a:	2b01      	cmp	r3, #1
2002535c:	d943      	bls.n	200253e6 <HAL_RCC_HCPU_ConfigDvfs+0x96>
2002535e:	3b02      	subs	r3, #2
20025360:	2b01      	cmp	r3, #1
20025362:	d902      	bls.n	2002536a <HAL_RCC_HCPU_ConfigDvfs+0x1a>
20025364:	2501      	movs	r5, #1
20025366:	4628      	mov	r0, r5
20025368:	bd70      	pop	{r4, r5, r6, pc}
2002536a:	4b2c      	ldr	r3, [pc, #176]	@ (2002541c <HAL_RCC_HCPU_ConfigDvfs+0xcc>)
2002536c:	f853 2021 	ldr.w	r2, [r3, r1, lsl #2]
20025370:	f7ff fe8d 	bl	2002508e <HAL_RCC_HCPU_GetDLL2Freq>
20025374:	4290      	cmp	r0, r2
20025376:	d8f5      	bhi.n	20025364 <HAL_RCC_HCPU_ConfigDvfs+0x14>
20025378:	2901      	cmp	r1, #1
2002537a:	d805      	bhi.n	20025388 <HAL_RCC_HCPU_ConfigDvfs+0x38>
2002537c:	4629      	mov	r1, r5
2002537e:	4620      	mov	r0, r4
20025380:	f7ff ffa2 	bl	200252c8 <HAL_RCC_HCPU_SwitchDvfsS2D.isra.0>
20025384:	2500      	movs	r5, #0
20025386:	e035      	b.n	200253f4 <HAL_RCC_HCPU_ConfigDvfs+0xa4>
20025388:	2100      	movs	r1, #0
2002538a:	4608      	mov	r0, r1
2002538c:	f7ff ff12 	bl	200251b4 <HAL_RCC_HCPU_ClockSelect>
20025390:	4620      	mov	r0, r4
20025392:	f7ff fe1b 	bl	20024fcc <HAL_RCC_HCPU_ConfigSxModeVolt>
20025396:	20fa      	movs	r0, #250	@ 0xfa
20025398:	f7fc ff2f 	bl	200221fa <HAL_Delay_us>
2002539c:	f7ff fed6 	bl	2002514c <HAL_RCC_HCPU_DisableDLL1>
200253a0:	2d30      	cmp	r5, #48	@ 0x30
200253a2:	d80d      	bhi.n	200253c0 <HAL_RCC_HCPU_ConfigDvfs+0x70>
200253a4:	f7fd fc64 	bl	20022c70 <HAL_HPAON_DisableXT48>
200253a8:	2100      	movs	r1, #0
200253aa:	4608      	mov	r0, r1
200253ac:	f7ff ff02 	bl	200251b4 <HAL_RCC_HCPU_ClockSelect>
200253b0:	2204      	movs	r2, #4
200253b2:	2100      	movs	r1, #0
200253b4:	2030      	movs	r0, #48	@ 0x30
200253b6:	fbb0 f0f5 	udiv	r0, r0, r5
200253ba:	f7ff ff1f 	bl	200251fc <HAL_RCC_HCPU_SetDiv>
200253be:	e7e1      	b.n	20025384 <HAL_RCC_HCPU_ConfigDvfs+0x34>
200253c0:	f7fd fc4a 	bl	20022c58 <HAL_HPAON_EnableXT48>
200253c4:	4816      	ldr	r0, [pc, #88]	@ (20025420 <HAL_RCC_HCPU_ConfigDvfs+0xd0>)
200253c6:	4368      	muls	r0, r5
200253c8:	f7ff feb8 	bl	2002513c <HAL_RCC_HCPU_EnableDLL1>
200253cc:	4605      	mov	r5, r0
200253ce:	2800      	cmp	r0, #0
200253d0:	d1c8      	bne.n	20025364 <HAL_RCC_HCPU_ConfigDvfs+0x14>
200253d2:	2101      	movs	r1, #1
200253d4:	2206      	movs	r2, #6
200253d6:	4608      	mov	r0, r1
200253d8:	f7ff ff10 	bl	200251fc <HAL_RCC_HCPU_SetDiv>
200253dc:	2103      	movs	r1, #3
200253de:	4628      	mov	r0, r5
200253e0:	f7ff fee8 	bl	200251b4 <HAL_RCC_HCPU_ClockSelect>
200253e4:	e7ce      	b.n	20025384 <HAL_RCC_HCPU_ConfigDvfs+0x34>
200253e6:	2901      	cmp	r1, #1
200253e8:	d909      	bls.n	200253fe <HAL_RCC_HCPU_ConfigDvfs+0xae>
200253ea:	4601      	mov	r1, r0
200253ec:	4620      	mov	r0, r4
200253ee:	f7ff ff2f 	bl	20025250 <HAL_RCC_HCPU_SwitchDvfsD2S>
200253f2:	4605      	mov	r5, r0
200253f4:	2000      	movs	r0, #0
200253f6:	7034      	strb	r4, [r6, #0]
200253f8:	f7fc feff 	bl	200221fa <HAL_Delay_us>
200253fc:	e7b3      	b.n	20025366 <HAL_RCC_HCPU_ConfigDvfs+0x16>
200253fe:	428b      	cmp	r3, r1
20025400:	d103      	bne.n	2002540a <HAL_RCC_HCPU_ConfigDvfs+0xba>
20025402:	f04f 32ff 	mov.w	r2, #4294967295
20025406:	4611      	mov	r1, r2
20025408:	e7d4      	b.n	200253b4 <HAL_RCC_HCPU_ConfigDvfs+0x64>
2002540a:	2190      	movs	r1, #144	@ 0x90
2002540c:	2002      	movs	r0, #2
2002540e:	f7ff ff1f 	bl	20025250 <HAL_RCC_HCPU_SwitchDvfsD2S>
20025412:	2800      	cmp	r0, #0
20025414:	d1a6      	bne.n	20025364 <HAL_RCC_HCPU_ConfigDvfs+0x14>
20025416:	e7b1      	b.n	2002537c <HAL_RCC_HCPU_ConfigDvfs+0x2c>
20025418:	20042c14 	.word	0x20042c14
2002541c:	2002ba7c 	.word	0x2002ba7c
20025420:	000f4240 	.word	0x000f4240

20025424 <HAL_RCC_Reset_and_Halt_LCPU>:
20025424:	4a13      	ldr	r2, [pc, #76]	@ (20025474 <HAL_RCC_Reset_and_Halt_LCPU+0x50>)
20025426:	6813      	ldr	r3, [r2, #0]
20025428:	0759      	lsls	r1, r3, #29
2002542a:	d421      	bmi.n	20025470 <HAL_RCC_Reset_and_Halt_LCPU+0x4c>
2002542c:	6811      	ldr	r1, [r2, #0]
2002542e:	2800      	cmp	r0, #0
20025430:	bf0c      	ite	eq
20025432:	2301      	moveq	r3, #1
20025434:	f04f 33ff 	movne.w	r3, #4294967295
20025438:	f041 0104 	orr.w	r1, r1, #4
2002543c:	6011      	str	r1, [r2, #0]
2002543e:	f04f 4280 	mov.w	r2, #1073741824	@ 0x40000000
20025442:	f443 1380 	orr.w	r3, r3, #1048576	@ 0x100000
20025446:	6013      	str	r3, [r2, #0]
20025448:	6811      	ldr	r1, [r2, #0]
2002544a:	2900      	cmp	r1, #0
2002544c:	d0fc      	beq.n	20025448 <HAL_RCC_Reset_and_Halt_LCPU+0x24>
2002544e:	4a09      	ldr	r2, [pc, #36]	@ (20025474 <HAL_RCC_Reset_and_Halt_LCPU+0x50>)
20025450:	6c11      	ldr	r1, [r2, #64]	@ 0x40
20025452:	06c8      	lsls	r0, r1, #27
20025454:	d506      	bpl.n	20025464 <HAL_RCC_Reset_and_Halt_LCPU+0x40>
20025456:	6c11      	ldr	r1, [r2, #64]	@ 0x40
20025458:	f041 0102 	orr.w	r1, r1, #2
2002545c:	6411      	str	r1, [r2, #64]	@ 0x40
2002545e:	6c11      	ldr	r1, [r2, #64]	@ 0x40
20025460:	06c9      	lsls	r1, r1, #27
20025462:	d4fc      	bmi.n	2002545e <HAL_RCC_Reset_and_Halt_LCPU+0x3a>
20025464:	f04f 4180 	mov.w	r1, #1073741824	@ 0x40000000
20025468:	680a      	ldr	r2, [r1, #0]
2002546a:	ea22 0303 	bic.w	r3, r2, r3
2002546e:	600b      	str	r3, [r1, #0]
20025470:	4770      	bx	lr
20025472:	bf00      	nop
20025474:	40040000 	.word	0x40040000

20025478 <HAL_RCC_EnableModule>:
20025478:	1c43      	adds	r3, r0, #1
2002547a:	d013      	beq.n	200254a4 <HAL_RCC_EnableModule+0x2c>
2002547c:	f010 0fe0 	tst.w	r0, #224	@ 0xe0
20025480:	b281      	uxth	r1, r0
20025482:	d000      	beq.n	20025486 <HAL_RCC_EnableModule+0xe>
20025484:	e7fe      	b.n	20025484 <HAL_RCC_EnableModule+0xc>
20025486:	f410 6f40 	tst.w	r0, #3072	@ 0xc00
2002548a:	f3c0 2281 	ubfx	r2, r0, #10, #2
2002548e:	f3c0 2301 	ubfx	r3, r0, #8, #2
20025492:	d108      	bne.n	200254a6 <HAL_RCC_EnableModule+0x2e>
20025494:	009b      	lsls	r3, r3, #2
20025496:	f103 43a0 	add.w	r3, r3, #1342177280	@ 0x50000000
2002549a:	3310      	adds	r3, #16
2002549c:	2201      	movs	r2, #1
2002549e:	b2c9      	uxtb	r1, r1
200254a0:	408a      	lsls	r2, r1
200254a2:	601a      	str	r2, [r3, #0]
200254a4:	4770      	bx	lr
200254a6:	2a01      	cmp	r2, #1
200254a8:	d104      	bne.n	200254b4 <HAL_RCC_EnableModule+0x3c>
200254aa:	009b      	lsls	r3, r3, #2
200254ac:	f103 4380 	add.w	r3, r3, #1073741824	@ 0x40000000
200254b0:	3308      	adds	r3, #8
200254b2:	e7f3      	b.n	2002549c <HAL_RCC_EnableModule+0x24>
200254b4:	e7fe      	b.n	200254b4 <HAL_RCC_EnableModule+0x3c>

200254b6 <HAL_RCC_HCPU_ConfigHCLK>:
200254b6:	28f0      	cmp	r0, #240	@ 0xf0
200254b8:	d80d      	bhi.n	200254d6 <HAL_RCC_HCPU_ConfigHCLK+0x20>
200254ba:	2890      	cmp	r0, #144	@ 0x90
200254bc:	d807      	bhi.n	200254ce <HAL_RCC_HCPU_ConfigHCLK+0x18>
200254be:	2830      	cmp	r0, #48	@ 0x30
200254c0:	d807      	bhi.n	200254d2 <HAL_RCC_HCPU_ConfigHCLK+0x1c>
200254c2:	2818      	cmp	r0, #24
200254c4:	bf94      	ite	ls
200254c6:	2100      	movls	r1, #0
200254c8:	2101      	movhi	r1, #1
200254ca:	f7ff bf41 	b.w	20025350 <HAL_RCC_HCPU_ConfigDvfs>
200254ce:	2103      	movs	r1, #3
200254d0:	e7fb      	b.n	200254ca <HAL_RCC_HCPU_ConfigHCLK+0x14>
200254d2:	2102      	movs	r1, #2
200254d4:	e7f9      	b.n	200254ca <HAL_RCC_HCPU_ConfigHCLK+0x14>
200254d6:	2001      	movs	r0, #1
200254d8:	4770      	bx	lr

200254da <spi_nor_get_ext_cfg_by_id>:
200254da:	2000      	movs	r0, #0
200254dc:	4770      	bx	lr

200254de <spi_nor_get_user_flash_cfg>:
200254de:	2000      	movs	r0, #0
200254e0:	4770      	bx	lr
	...

200254e4 <spi_flash_get_rdid>:
200254e4:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
200254e6:	4604      	mov	r4, r0
200254e8:	3801      	subs	r0, #1
200254ea:	b2c0      	uxtb	r0, r0
200254ec:	28fd      	cmp	r0, #253	@ 0xfd
200254ee:	d816      	bhi.n	2002551e <spi_flash_get_rdid+0x3a>
200254f0:	2500      	movs	r5, #0
200254f2:	4e0d      	ldr	r6, [pc, #52]	@ (20025528 <spi_flash_get_rdid+0x44>)
200254f4:	f856 0b04 	ldr.w	r0, [r6], #4
200254f8:	7807      	ldrb	r7, [r0, #0]
200254fa:	b937      	cbnz	r7, 2002550a <spi_flash_get_rdid+0x26>
200254fc:	3501      	adds	r5, #1
200254fe:	2d06      	cmp	r5, #6
20025500:	d1f8      	bne.n	200254f4 <spi_flash_get_rdid+0x10>
20025502:	4620      	mov	r0, r4
20025504:	f7ff ffeb 	bl	200254de <spi_nor_get_user_flash_cfg>
20025508:	e00d      	b.n	20025526 <spi_flash_get_rdid+0x42>
2002550a:	42a7      	cmp	r7, r4
2002550c:	d105      	bne.n	2002551a <spi_flash_get_rdid+0x36>
2002550e:	7847      	ldrb	r7, [r0, #1]
20025510:	4297      	cmp	r7, r2
20025512:	d102      	bne.n	2002551a <spi_flash_get_rdid+0x36>
20025514:	7887      	ldrb	r7, [r0, #2]
20025516:	428f      	cmp	r7, r1
20025518:	d003      	beq.n	20025522 <spi_flash_get_rdid+0x3e>
2002551a:	3008      	adds	r0, #8
2002551c:	e7ec      	b.n	200254f8 <spi_flash_get_rdid+0x14>
2002551e:	2000      	movs	r0, #0
20025520:	e001      	b.n	20025526 <spi_flash_get_rdid+0x42>
20025522:	b103      	cbz	r3, 20025526 <spi_flash_get_rdid+0x42>
20025524:	701d      	strb	r5, [r3, #0]
20025526:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
20025528:	20042c18 	.word	0x20042c18

2002552c <spi_flash_get_cmd_by_id>:
2002552c:	b507      	push	{r0, r1, r2, lr}
2002552e:	f10d 0307 	add.w	r3, sp, #7
20025532:	f7ff ffd7 	bl	200254e4 <spi_flash_get_rdid>
20025536:	4b06      	ldr	r3, [pc, #24]	@ (20025550 <spi_flash_get_cmd_by_id+0x24>)
20025538:	b140      	cbz	r0, 2002554c <spi_flash_get_cmd_by_id+0x20>
2002553a:	f44f 7105 	mov.w	r1, #532	@ 0x214
2002553e:	f89d 2007 	ldrb.w	r2, [sp, #7]
20025542:	fb01 3002 	mla	r0, r1, r2, r3
20025546:	b003      	add	sp, #12
20025548:	f85d fb04 	ldr.w	pc, [sp], #4
2002554c:	4618      	mov	r0, r3
2002554e:	e7fa      	b.n	20025546 <spi_flash_get_cmd_by_id+0x1a>
20025550:	20042e60 	.word	0x20042e60

20025554 <spi_flash_get_size_by_id>:
20025554:	b508      	push	{r3, lr}
20025556:	2300      	movs	r3, #0
20025558:	f7ff ffc4 	bl	200254e4 <spi_flash_get_rdid>
2002555c:	b108      	cbz	r0, 20025562 <spi_flash_get_size_by_id+0xe>
2002555e:	6840      	ldr	r0, [r0, #4]
20025560:	bd08      	pop	{r3, pc}
20025562:	f44f 2000 	mov.w	r0, #524288	@ 0x80000
20025566:	e7fb      	b.n	20025560 <spi_flash_get_size_by_id+0xc>

20025568 <spi_flash_is_support_dtr>:
20025568:	b508      	push	{r3, lr}
2002556a:	2300      	movs	r3, #0
2002556c:	f7ff ffba 	bl	200254e4 <spi_flash_get_rdid>
20025570:	b110      	cbz	r0, 20025578 <spi_flash_is_support_dtr+0x10>
20025572:	78c0      	ldrb	r0, [r0, #3]
20025574:	f000 0001 	and.w	r0, r0, #1
20025578:	bd08      	pop	{r3, pc}
	...

2002557c <spi_flash_get_otp_base>:
2002557c:	b508      	push	{r3, lr}
2002557e:	2300      	movs	r3, #0
20025580:	f7ff ffb0 	bl	200254e4 <spi_flash_get_rdid>
20025584:	b130      	cbz	r0, 20025594 <spi_flash_get_otp_base+0x18>
20025586:	78c3      	ldrb	r3, [r0, #3]
20025588:	4803      	ldr	r0, [pc, #12]	@ (20025598 <spi_flash_get_otp_base+0x1c>)
2002558a:	f003 0306 	and.w	r3, r3, #6
2002558e:	2b02      	cmp	r3, #2
20025590:	bf18      	it	ne
20025592:	2000      	movne	r0, #0
20025594:	bd08      	pop	{r3, pc}
20025596:	bf00      	nop
20025598:	00ffc000 	.word	0x00ffc000

2002559c <spi_nand_get_user_flash_cfg>:
2002559c:	2000      	movs	r0, #0
2002559e:	4770      	bx	lr

200255a0 <spi_nand_get_rdid>:
200255a0:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
200255a2:	4604      	mov	r4, r0
200255a4:	3801      	subs	r0, #1
200255a6:	b2c0      	uxtb	r0, r0
200255a8:	28fd      	cmp	r0, #253	@ 0xfd
200255aa:	d816      	bhi.n	200255da <spi_nand_get_rdid+0x3a>
200255ac:	2500      	movs	r5, #0
200255ae:	4e0d      	ldr	r6, [pc, #52]	@ (200255e4 <spi_nand_get_rdid+0x44>)
200255b0:	f856 0b04 	ldr.w	r0, [r6], #4
200255b4:	7807      	ldrb	r7, [r0, #0]
200255b6:	b937      	cbnz	r7, 200255c6 <spi_nand_get_rdid+0x26>
200255b8:	3501      	adds	r5, #1
200255ba:	2d06      	cmp	r5, #6
200255bc:	d1f8      	bne.n	200255b0 <spi_nand_get_rdid+0x10>
200255be:	4620      	mov	r0, r4
200255c0:	f7ff ffec 	bl	2002559c <spi_nand_get_user_flash_cfg>
200255c4:	e00d      	b.n	200255e2 <spi_nand_get_rdid+0x42>
200255c6:	42a7      	cmp	r7, r4
200255c8:	d105      	bne.n	200255d6 <spi_nand_get_rdid+0x36>
200255ca:	7847      	ldrb	r7, [r0, #1]
200255cc:	4297      	cmp	r7, r2
200255ce:	d102      	bne.n	200255d6 <spi_nand_get_rdid+0x36>
200255d0:	7887      	ldrb	r7, [r0, #2]
200255d2:	428f      	cmp	r7, r1
200255d4:	d003      	beq.n	200255de <spi_nand_get_rdid+0x3e>
200255d6:	3008      	adds	r0, #8
200255d8:	e7ec      	b.n	200255b4 <spi_nand_get_rdid+0x14>
200255da:	2000      	movs	r0, #0
200255dc:	e001      	b.n	200255e2 <spi_nand_get_rdid+0x42>
200255de:	b103      	cbz	r3, 200255e2 <spi_nand_get_rdid+0x42>
200255e0:	701d      	strb	r5, [r3, #0]
200255e2:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
200255e4:	20043ad8 	.word	0x20043ad8

200255e8 <spi_nand_get_cmd_by_id>:
200255e8:	b507      	push	{r0, r1, r2, lr}
200255ea:	f10d 0307 	add.w	r3, sp, #7
200255ee:	f7ff ffd7 	bl	200255a0 <spi_nand_get_rdid>
200255f2:	b130      	cbz	r0, 20025602 <spi_nand_get_cmd_by_id+0x1a>
200255f4:	f44f 7205 	mov.w	r2, #532	@ 0x214
200255f8:	f89d 3007 	ldrb.w	r3, [sp, #7]
200255fc:	4802      	ldr	r0, [pc, #8]	@ (20025608 <spi_nand_get_cmd_by_id+0x20>)
200255fe:	fb02 0003 	mla	r0, r2, r3, r0
20025602:	b003      	add	sp, #12
20025604:	f85d fb04 	ldr.w	pc, [sp], #4
20025608:	20043d20 	.word	0x20043d20

2002560c <spi_nand_get_ext_cfg_by_id>:
2002560c:	2000      	movs	r0, #0
2002560e:	4770      	bx	lr

20025610 <HAL_GET_NAND_FLASH_DEFAUT_IDX>:
20025610:	f04f 30ff 	mov.w	r0, #4294967295
20025614:	4770      	bx	lr
	...

20025618 <spi_nand_get_default_ctable>:
20025618:	b508      	push	{r3, lr}
2002561a:	f7ff fff9 	bl	20025610 <HAL_GET_NAND_FLASH_DEFAUT_IDX>
2002561e:	1e03      	subs	r3, r0, #0
20025620:	bfa5      	ittet	ge
20025622:	f44f 7205 	movge.w	r2, #532	@ 0x214
20025626:	4802      	ldrge	r0, [pc, #8]	@ (20025630 <spi_nand_get_default_ctable+0x18>)
20025628:	2000      	movlt	r0, #0
2002562a:	fb02 0003 	mlage	r0, r2, r3, r0
2002562e:	bd08      	pop	{r3, pc}
20025630:	20043d20 	.word	0x20043d20

20025634 <spi_nand_get_size_by_id>:
20025634:	b508      	push	{r3, lr}
20025636:	2300      	movs	r3, #0
20025638:	f7ff ffb2 	bl	200255a0 <spi_nand_get_rdid>
2002563c:	b108      	cbz	r0, 20025642 <spi_nand_get_size_by_id+0xe>
2002563e:	6840      	ldr	r0, [r0, #4]
20025640:	bd08      	pop	{r3, pc}
20025642:	f04f 6080 	mov.w	r0, #67108864	@ 0x4000000
20025646:	e7fb      	b.n	20025640 <spi_nand_get_size_by_id+0xc>

20025648 <spi_nand_get_plane_select_flag>:
20025648:	b508      	push	{r3, lr}
2002564a:	2300      	movs	r3, #0
2002564c:	f7ff ffa8 	bl	200255a0 <spi_nand_get_rdid>
20025650:	b110      	cbz	r0, 20025658 <spi_nand_get_plane_select_flag+0x10>
20025652:	78c0      	ldrb	r0, [r0, #3]
20025654:	f3c0 0040 	ubfx	r0, r0, #1, #1
20025658:	bd08      	pop	{r3, pc}

2002565a <spi_nand_get_big_page_flag>:
2002565a:	b508      	push	{r3, lr}
2002565c:	2300      	movs	r3, #0
2002565e:	f7ff ff9f 	bl	200255a0 <spi_nand_get_rdid>
20025662:	b110      	cbz	r0, 2002566a <spi_nand_get_big_page_flag+0x10>
20025664:	78c0      	ldrb	r0, [r0, #3]
20025666:	f3c0 0081 	ubfx	r0, r0, #2, #2
2002566a:	bd08      	pop	{r3, pc}

2002566c <spi_nand_get_ecc_mode>:
2002566c:	b508      	push	{r3, lr}
2002566e:	2300      	movs	r3, #0
20025670:	f7ff ff96 	bl	200255a0 <spi_nand_get_rdid>
20025674:	b108      	cbz	r0, 2002567a <spi_nand_get_ecc_mode+0xe>
20025676:	78c0      	ldrb	r0, [r0, #3]
20025678:	0900      	lsrs	r0, r0, #4
2002567a:	bd08      	pop	{r3, pc}

2002567c <bbm_map_check.part.0>:
2002567c:	b5f7      	push	{r0, r1, r2, r4, r5, r6, r7, lr}
2002567e:	4b21      	ldr	r3, [pc, #132]	@ (20025704 <bbm_map_check.part.0+0x88>)
20025680:	4606      	mov	r6, r0
20025682:	681d      	ldr	r5, [r3, #0]
20025684:	4b20      	ldr	r3, [pc, #128]	@ (20025708 <bbm_map_check.part.0+0x8c>)
20025686:	3d04      	subs	r5, #4
20025688:	681f      	ldr	r7, [r3, #0]
2002568a:	2300      	movs	r3, #0
2002568c:	f100 0e1a 	add.w	lr, r0, #26
20025690:	42ab      	cmp	r3, r5
20025692:	db02      	blt.n	2002569a <bbm_map_check.part.0+0x1e>
20025694:	2000      	movs	r0, #0
20025696:	b003      	add	sp, #12
20025698:	bdf0      	pop	{r4, r5, r6, r7, pc}
2002569a:	8b31      	ldrh	r1, [r6, #24]
2002569c:	b321      	cbz	r1, 200256e8 <bbm_map_check.part.0+0x6c>
2002569e:	8b72      	ldrh	r2, [r6, #26]
200256a0:	b33a      	cbz	r2, 200256f2 <bbm_map_check.part.0+0x76>
200256a2:	42b9      	cmp	r1, r7
200256a4:	d201      	bcs.n	200256aa <bbm_map_check.part.0+0x2e>
200256a6:	4297      	cmp	r7, r2
200256a8:	d905      	bls.n	200256b6 <bbm_map_check.part.0+0x3a>
200256aa:	4b18      	ldr	r3, [pc, #96]	@ (2002570c <bbm_map_check.part.0+0x90>)
200256ac:	681b      	ldr	r3, [r3, #0]
200256ae:	b10b      	cbz	r3, 200256b4 <bbm_map_check.part.0+0x38>
200256b0:	4817      	ldr	r0, [pc, #92]	@ (20025710 <bbm_map_check.part.0+0x94>)
200256b2:	4798      	blx	r3
200256b4:	e7fe      	b.n	200256b4 <bbm_map_check.part.0+0x38>
200256b6:	3301      	adds	r3, #1
200256b8:	461c      	mov	r4, r3
200256ba:	42ac      	cmp	r4, r5
200256bc:	db01      	blt.n	200256c2 <bbm_map_check.part.0+0x46>
200256be:	3604      	adds	r6, #4
200256c0:	e7e6      	b.n	20025690 <bbm_map_check.part.0+0x14>
200256c2:	f83e c024 	ldrh.w	ip, [lr, r4, lsl #2]
200256c6:	f1bc 0f00 	cmp.w	ip, #0
200256ca:	d0f8      	beq.n	200256be <bbm_map_check.part.0+0x42>
200256cc:	4562      	cmp	r2, ip
200256ce:	d109      	bne.n	200256e4 <bbm_map_check.part.0+0x68>
200256d0:	4b0e      	ldr	r3, [pc, #56]	@ (2002570c <bbm_map_check.part.0+0x90>)
200256d2:	681d      	ldr	r5, [r3, #0]
200256d4:	b12d      	cbz	r5, 200256e2 <bbm_map_check.part.0+0x66>
200256d6:	3406      	adds	r4, #6
200256d8:	f830 3024 	ldrh.w	r3, [r0, r4, lsl #2]
200256dc:	480d      	ldr	r0, [pc, #52]	@ (20025714 <bbm_map_check.part.0+0x98>)
200256de:	9200      	str	r2, [sp, #0]
200256e0:	47a8      	blx	r5
200256e2:	e7fe      	b.n	200256e2 <bbm_map_check.part.0+0x66>
200256e4:	3401      	adds	r4, #1
200256e6:	e7e8      	b.n	200256ba <bbm_map_check.part.0+0x3e>
200256e8:	eb00 0283 	add.w	r2, r0, r3, lsl #2
200256ec:	8b52      	ldrh	r2, [r2, #26]
200256ee:	2a00      	cmp	r2, #0
200256f0:	d0d0      	beq.n	20025694 <bbm_map_check.part.0+0x18>
200256f2:	4a06      	ldr	r2, [pc, #24]	@ (2002570c <bbm_map_check.part.0+0x90>)
200256f4:	6814      	ldr	r4, [r2, #0]
200256f6:	b124      	cbz	r4, 20025702 <bbm_map_check.part.0+0x86>
200256f8:	eb00 0383 	add.w	r3, r0, r3, lsl #2
200256fc:	8b5a      	ldrh	r2, [r3, #26]
200256fe:	4806      	ldr	r0, [pc, #24]	@ (20025718 <bbm_map_check.part.0+0x9c>)
20025700:	47a0      	blx	r4
20025702:	e7fe      	b.n	20025702 <bbm_map_check.part.0+0x86>
20025704:	2004cc90 	.word	0x2004cc90
20025708:	2004cc94 	.word	0x2004cc94
2002570c:	2004cc80 	.word	0x2004cc80
20025710:	2002ac1c 	.word	0x2002ac1c
20025714:	2002ac39 	.word	0x2002ac39
20025718:	2002ac86 	.word	0x2002ac86

2002571c <bbm_crc_check>:
2002571c:	f04f 32ff 	mov.w	r2, #4294967295
20025720:	b510      	push	{r4, lr}
20025722:	4c07      	ldr	r4, [pc, #28]	@ (20025740 <bbm_crc_check+0x24>)
20025724:	4401      	add	r1, r0
20025726:	4288      	cmp	r0, r1
20025728:	d101      	bne.n	2002572e <bbm_crc_check+0x12>
2002572a:	43d0      	mvns	r0, r2
2002572c:	bd10      	pop	{r4, pc}
2002572e:	f810 3b01 	ldrb.w	r3, [r0], #1
20025732:	4053      	eors	r3, r2
20025734:	b2db      	uxtb	r3, r3
20025736:	f854 3023 	ldr.w	r3, [r4, r3, lsl #2]
2002573a:	ea83 2212 	eor.w	r2, r3, r2, lsr #8
2002573e:	e7f2      	b.n	20025726 <bbm_crc_check+0xa>
20025740:	2002baac 	.word	0x2002baac

20025744 <bbm_get_phy_blk>:
20025744:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
20025746:	4b14      	ldr	r3, [pc, #80]	@ (20025798 <bbm_get_phy_blk+0x54>)
20025748:	4601      	mov	r1, r0
2002574a:	681e      	ldr	r6, [r3, #0]
2002574c:	42b0      	cmp	r0, r6
2002574e:	d21e      	bcs.n	2002578e <bbm_get_phy_blk+0x4a>
20025750:	b138      	cbz	r0, 20025762 <bbm_get_phy_blk+0x1e>
20025752:	4b12      	ldr	r3, [pc, #72]	@ (2002579c <bbm_get_phy_blk+0x58>)
20025754:	2200      	movs	r2, #0
20025756:	681c      	ldr	r4, [r3, #0]
20025758:	4b11      	ldr	r3, [pc, #68]	@ (200257a0 <bbm_get_phy_blk+0x5c>)
2002575a:	3c04      	subs	r4, #4
2002575c:	461d      	mov	r5, r3
2002575e:	4294      	cmp	r4, r2
20025760:	dc00      	bgt.n	20025764 <bbm_get_phy_blk+0x20>
20025762:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
20025764:	8b1f      	ldrh	r7, [r3, #24]
20025766:	428f      	cmp	r7, r1
20025768:	d10a      	bne.n	20025780 <bbm_get_phy_blk+0x3c>
2002576a:	eb05 0582 	add.w	r5, r5, r2, lsl #2
2002576e:	8b6a      	ldrh	r2, [r5, #26]
20025770:	4296      	cmp	r6, r2
20025772:	dd0f      	ble.n	20025794 <bbm_get_phy_blk+0x50>
20025774:	4b0b      	ldr	r3, [pc, #44]	@ (200257a4 <bbm_get_phy_blk+0x60>)
20025776:	681b      	ldr	r3, [r3, #0]
20025778:	b10b      	cbz	r3, 2002577e <bbm_get_phy_blk+0x3a>
2002577a:	480b      	ldr	r0, [pc, #44]	@ (200257a8 <bbm_get_phy_blk+0x64>)
2002577c:	4798      	blx	r3
2002577e:	e7fe      	b.n	2002577e <bbm_get_phy_blk+0x3a>
20025780:	b917      	cbnz	r7, 20025788 <bbm_get_phy_blk+0x44>
20025782:	8b5f      	ldrh	r7, [r3, #26]
20025784:	2f00      	cmp	r7, #0
20025786:	d0ec      	beq.n	20025762 <bbm_get_phy_blk+0x1e>
20025788:	3201      	adds	r2, #1
2002578a:	3304      	adds	r3, #4
2002578c:	e7e7      	b.n	2002575e <bbm_get_phy_blk+0x1a>
2002578e:	f04f 30ff 	mov.w	r0, #4294967295
20025792:	e7e6      	b.n	20025762 <bbm_get_phy_blk+0x1e>
20025794:	4610      	mov	r0, r2
20025796:	e7e4      	b.n	20025762 <bbm_get_phy_blk+0x1e>
20025798:	2004cc94 	.word	0x2004cc94
2002579c:	2004cc90 	.word	0x2004cc90
200257a0:	2004cc98 	.word	0x2004cc98
200257a4:	2004cc80 	.word	0x2004cc80
200257a8:	2002aca4 	.word	0x2002aca4

200257ac <bbm_get_version_inblk>:
200257ac:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
200257b0:	4607      	mov	r7, r0
200257b2:	4688      	mov	r8, r1
200257b4:	b087      	sub	sp, #28
200257b6:	2900      	cmp	r1, #0
200257b8:	d14b      	bne.n	20025852 <bbm_get_version_inblk+0xa6>
200257ba:	2500      	movs	r5, #0
200257bc:	4628      	mov	r0, r5
200257be:	b007      	add	sp, #28
200257c0:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
200257c4:	2200      	movs	r2, #0
200257c6:	e9cd 2201 	strd	r2, r2, [sp, #4]
200257ca:	4e26      	ldr	r6, [pc, #152]	@ (20025864 <bbm_get_version_inblk+0xb8>)
200257cc:	9100      	str	r1, [sp, #0]
200257ce:	4638      	mov	r0, r7
200257d0:	4621      	mov	r1, r4
200257d2:	6833      	ldr	r3, [r6, #0]
200257d4:	f7fb f9ec 	bl	20020bb0 <port_read_page>
200257d8:	2800      	cmp	r0, #0
200257da:	dd32      	ble.n	20025842 <bbm_get_version_inblk+0x96>
200257dc:	6832      	ldr	r2, [r6, #0]
200257de:	6813      	ldr	r3, [r2, #0]
200257e0:	455b      	cmp	r3, fp
200257e2:	d123      	bne.n	2002582c <bbm_get_version_inblk+0x80>
200257e4:	6856      	ldr	r6, [r2, #4]
200257e6:	f3c6 061e 	ubfx	r6, r6, #0, #31
200257ea:	42ae      	cmp	r6, r5
200257ec:	dd15      	ble.n	2002581a <bbm_get_version_inblk+0x6e>
200257ee:	4610      	mov	r0, r2
200257f0:	2110      	movs	r1, #16
200257f2:	9205      	str	r2, [sp, #20]
200257f4:	f7ff ff92 	bl	2002571c <bbm_crc_check>
200257f8:	9a05      	ldr	r2, [sp, #20]
200257fa:	6913      	ldr	r3, [r2, #16]
200257fc:	4283      	cmp	r3, r0
200257fe:	d113      	bne.n	20025828 <bbm_get_version_inblk+0x7c>
20025800:	f8c8 4000 	str.w	r4, [r8]
20025804:	4635      	mov	r5, r6
20025806:	3401      	adds	r4, #1
20025808:	f8da 1000 	ldr.w	r1, [sl]
2002580c:	f8d9 3000 	ldr.w	r3, [r9]
20025810:	fbb3 f3f1 	udiv	r3, r3, r1
20025814:	42a3      	cmp	r3, r4
20025816:	d8d5      	bhi.n	200257c4 <bbm_get_version_inblk+0x18>
20025818:	e7d0      	b.n	200257bc <bbm_get_version_inblk+0x10>
2002581a:	4b13      	ldr	r3, [pc, #76]	@ (20025868 <bbm_get_version_inblk+0xbc>)
2002581c:	681b      	ldr	r3, [r3, #0]
2002581e:	b11b      	cbz	r3, 20025828 <bbm_get_version_inblk+0x7c>
20025820:	4632      	mov	r2, r6
20025822:	4629      	mov	r1, r5
20025824:	4811      	ldr	r0, [pc, #68]	@ (2002586c <bbm_get_version_inblk+0xc0>)
20025826:	4798      	blx	r3
20025828:	462e      	mov	r6, r5
2002582a:	e7eb      	b.n	20025804 <bbm_get_version_inblk+0x58>
2002582c:	1c5a      	adds	r2, r3, #1
2002582e:	d0c5      	beq.n	200257bc <bbm_get_version_inblk+0x10>
20025830:	4a0d      	ldr	r2, [pc, #52]	@ (20025868 <bbm_get_version_inblk+0xbc>)
20025832:	6815      	ldr	r5, [r2, #0]
20025834:	2d00      	cmp	r5, #0
20025836:	d0c0      	beq.n	200257ba <bbm_get_version_inblk+0xe>
20025838:	4622      	mov	r2, r4
2002583a:	4639      	mov	r1, r7
2002583c:	480c      	ldr	r0, [pc, #48]	@ (20025870 <bbm_get_version_inblk+0xc4>)
2002583e:	47a8      	blx	r5
20025840:	e7bb      	b.n	200257ba <bbm_get_version_inblk+0xe>
20025842:	4b09      	ldr	r3, [pc, #36]	@ (20025868 <bbm_get_version_inblk+0xbc>)
20025844:	681b      	ldr	r3, [r3, #0]
20025846:	2b00      	cmp	r3, #0
20025848:	d0ee      	beq.n	20025828 <bbm_get_version_inblk+0x7c>
2002584a:	4622      	mov	r2, r4
2002584c:	4639      	mov	r1, r7
2002584e:	4809      	ldr	r0, [pc, #36]	@ (20025874 <bbm_get_version_inblk+0xc8>)
20025850:	e7e9      	b.n	20025826 <bbm_get_version_inblk+0x7a>
20025852:	2400      	movs	r4, #0
20025854:	f8df a020 	ldr.w	sl, [pc, #32]	@ 20025878 <bbm_get_version_inblk+0xcc>
20025858:	4625      	mov	r5, r4
2002585a:	f8df 9020 	ldr.w	r9, [pc, #32]	@ 2002587c <bbm_get_version_inblk+0xd0>
2002585e:	f8df b020 	ldr.w	fp, [pc, #32]	@ 20025880 <bbm_get_version_inblk+0xd4>
20025862:	e7d1      	b.n	20025808 <bbm_get_version_inblk+0x5c>
20025864:	2004cc84 	.word	0x2004cc84
20025868:	2004cc80 	.word	0x2004cc80
2002586c:	2002acc3 	.word	0x2002acc3
20025870:	2002acf0 	.word	0x2002acf0
20025874:	2002ad21 	.word	0x2002ad21
20025878:	20044998 	.word	0x20044998
2002587c:	2004499c 	.word	0x2004499c
20025880:	5366424d 	.word	0x5366424d

20025884 <bbm_get_map_table>:
20025884:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
20025888:	2801      	cmp	r0, #1
2002588a:	4607      	mov	r7, r0
2002588c:	f8df b15c 	ldr.w	fp, [pc, #348]	@ 200259ec <bbm_get_map_table+0x168>
20025890:	b087      	sub	sp, #28
20025892:	dd0a      	ble.n	200258aa <bbm_get_map_table+0x26>
20025894:	f8db 3000 	ldr.w	r3, [fp]
20025898:	b91b      	cbnz	r3, 200258a2 <bbm_get_map_table+0x1e>
2002589a:	2000      	movs	r0, #0
2002589c:	b007      	add	sp, #28
2002589e:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
200258a2:	4601      	mov	r1, r0
200258a4:	4847      	ldr	r0, [pc, #284]	@ (200259c4 <bbm_get_map_table+0x140>)
200258a6:	4798      	blx	r3
200258a8:	e7f7      	b.n	2002589a <bbm_get_map_table+0x16>
200258aa:	f8df 8144 	ldr.w	r8, [pc, #324]	@ 200259f0 <bbm_get_map_table+0x16c>
200258ae:	2800      	cmp	r0, #0
200258b0:	d163      	bne.n	2002597a <bbm_get_map_table+0xf6>
200258b2:	f8b8 6000 	ldrh.w	r6, [r8]
200258b6:	f8b8 5002 	ldrh.w	r5, [r8, #2]
200258ba:	2e00      	cmp	r6, #0
200258bc:	d062      	beq.n	20025984 <bbm_get_map_table+0x100>
200258be:	4630      	mov	r0, r6
200258c0:	a904      	add	r1, sp, #16
200258c2:	f7ff ff73 	bl	200257ac <bbm_get_version_inblk>
200258c6:	4681      	mov	r9, r0
200258c8:	2d00      	cmp	r5, #0
200258ca:	d05d      	beq.n	20025988 <bbm_get_map_table+0x104>
200258cc:	4628      	mov	r0, r5
200258ce:	a905      	add	r1, sp, #20
200258d0:	f7ff ff6c 	bl	200257ac <bbm_get_version_inblk>
200258d4:	4604      	mov	r4, r0
200258d6:	f8db a000 	ldr.w	sl, [fp]
200258da:	f1ba 0f00 	cmp.w	sl, #0
200258de:	d005      	beq.n	200258ec <bbm_get_map_table+0x68>
200258e0:	4623      	mov	r3, r4
200258e2:	4632      	mov	r2, r6
200258e4:	4649      	mov	r1, r9
200258e6:	4838      	ldr	r0, [pc, #224]	@ (200259c8 <bbm_get_map_table+0x144>)
200258e8:	9500      	str	r5, [sp, #0]
200258ea:	47d0      	blx	sl
200258ec:	45a1      	cmp	r9, r4
200258ee:	d0d4      	beq.n	2002589a <bbm_get_map_table+0x16>
200258f0:	f04f 0200 	mov.w	r2, #0
200258f4:	bf98      	it	ls
200258f6:	462e      	movls	r6, r5
200258f8:	f107 0308 	add.w	r3, r7, #8
200258fc:	bf94      	ite	ls
200258fe:	f828 5013 	strhls.w	r5, [r8, r3, lsl #1]
20025902:	f828 6013 	strhhi.w	r6, [r8, r3, lsl #1]
20025906:	e9cd 2201 	strd	r2, r2, [sp, #4]
2002590a:	4b30      	ldr	r3, [pc, #192]	@ (200259cc <bbm_get_map_table+0x148>)
2002590c:	bf88      	it	hi
2002590e:	f8dd a010 	ldrhi.w	sl, [sp, #16]
20025912:	681b      	ldr	r3, [r3, #0]
20025914:	bf98      	it	ls
20025916:	f8dd a014 	ldrls.w	sl, [sp, #20]
2002591a:	f8df 80d8 	ldr.w	r8, [pc, #216]	@ 200259f4 <bbm_get_map_table+0x170>
2002591e:	9300      	str	r3, [sp, #0]
20025920:	4651      	mov	r1, sl
20025922:	4630      	mov	r0, r6
20025924:	f8d8 3000 	ldr.w	r3, [r8]
20025928:	bf88      	it	hi
2002592a:	464c      	movhi	r4, r9
2002592c:	f7fb f940 	bl	20020bb0 <port_read_page>
20025930:	2800      	cmp	r0, #0
20025932:	f8db 5000 	ldr.w	r5, [fp]
20025936:	dd38      	ble.n	200259aa <bbm_get_map_table+0x126>
20025938:	f8d8 8000 	ldr.w	r8, [r8]
2002593c:	4b24      	ldr	r3, [pc, #144]	@ (200259d0 <bbm_get_map_table+0x14c>)
2002593e:	f8d8 2000 	ldr.w	r2, [r8]
20025942:	429a      	cmp	r2, r3
20025944:	d12b      	bne.n	2002599e <bbm_get_map_table+0x11a>
20025946:	2110      	movs	r1, #16
20025948:	4640      	mov	r0, r8
2002594a:	f7ff fee7 	bl	2002571c <bbm_crc_check>
2002594e:	f8d8 2010 	ldr.w	r2, [r8, #16]
20025952:	4601      	mov	r1, r0
20025954:	4282      	cmp	r2, r0
20025956:	d11e      	bne.n	20025996 <bbm_get_map_table+0x112>
20025958:	f8d8 1004 	ldr.w	r1, [r8, #4]
2002595c:	f3c1 011e 	ubfx	r1, r1, #0, #31
20025960:	42a1      	cmp	r1, r4
20025962:	d113      	bne.n	2002598c <bbm_get_map_table+0x108>
20025964:	f44f 7202 	mov.w	r2, #520	@ 0x208
20025968:	481a      	ldr	r0, [pc, #104]	@ (200259d4 <bbm_get_map_table+0x150>)
2002596a:	4641      	mov	r1, r8
2002596c:	fb02 0007 	mla	r0, r2, r7, r0
20025970:	f005 f88a 	bl	2002aa88 <memcpy>
20025974:	bb0d      	cbnz	r5, 200259ba <bbm_get_map_table+0x136>
20025976:	4620      	mov	r0, r4
20025978:	e790      	b.n	2002589c <bbm_get_map_table+0x18>
2002597a:	f8b8 6004 	ldrh.w	r6, [r8, #4]
2002597e:	f8b8 5006 	ldrh.w	r5, [r8, #6]
20025982:	e79a      	b.n	200258ba <bbm_get_map_table+0x36>
20025984:	46b1      	mov	r9, r6
20025986:	e79f      	b.n	200258c8 <bbm_get_map_table+0x44>
20025988:	462c      	mov	r4, r5
2002598a:	e7a4      	b.n	200258d6 <bbm_get_map_table+0x52>
2002598c:	b115      	cbz	r5, 20025994 <bbm_get_map_table+0x110>
2002598e:	4622      	mov	r2, r4
20025990:	4811      	ldr	r0, [pc, #68]	@ (200259d8 <bbm_get_map_table+0x154>)
20025992:	47a8      	blx	r5
20025994:	e7fe      	b.n	20025994 <bbm_get_map_table+0x110>
20025996:	b10d      	cbz	r5, 2002599c <bbm_get_map_table+0x118>
20025998:	4810      	ldr	r0, [pc, #64]	@ (200259dc <bbm_get_map_table+0x158>)
2002599a:	47a8      	blx	r5
2002599c:	e7fe      	b.n	2002599c <bbm_get_map_table+0x118>
2002599e:	b11d      	cbz	r5, 200259a8 <bbm_get_map_table+0x124>
200259a0:	4652      	mov	r2, sl
200259a2:	4631      	mov	r1, r6
200259a4:	480e      	ldr	r0, [pc, #56]	@ (200259e0 <bbm_get_map_table+0x15c>)
200259a6:	47a8      	blx	r5
200259a8:	e7fe      	b.n	200259a8 <bbm_get_map_table+0x124>
200259aa:	2d00      	cmp	r5, #0
200259ac:	f43f af75 	beq.w	2002589a <bbm_get_map_table+0x16>
200259b0:	4652      	mov	r2, sl
200259b2:	4631      	mov	r1, r6
200259b4:	480b      	ldr	r0, [pc, #44]	@ (200259e4 <bbm_get_map_table+0x160>)
200259b6:	47a8      	blx	r5
200259b8:	e76f      	b.n	2002589a <bbm_get_map_table+0x16>
200259ba:	4621      	mov	r1, r4
200259bc:	480a      	ldr	r0, [pc, #40]	@ (200259e8 <bbm_get_map_table+0x164>)
200259be:	47a8      	blx	r5
200259c0:	e7d9      	b.n	20025976 <bbm_get_map_table+0xf2>
200259c2:	bf00      	nop
200259c4:	2002ad3f 	.word	0x2002ad3f
200259c8:	2002ad53 	.word	0x2002ad53
200259cc:	20044998 	.word	0x20044998
200259d0:	5366424d 	.word	0x5366424d
200259d4:	2004cc98 	.word	0x2004cc98
200259d8:	2002ad79 	.word	0x2002ad79
200259dc:	2002adc3 	.word	0x2002adc3
200259e0:	2002add5 	.word	0x2002add5
200259e4:	2002ae0a 	.word	0x2002ae0a
200259e8:	2002ae36 	.word	0x2002ae36
200259ec:	2004cc80 	.word	0x2004cc80
200259f0:	2004d0a8 	.word	0x2004d0a8
200259f4:	2004cc84 	.word	0x2004cc84

200259f8 <bbm_get_page_num>:
200259f8:	e92d 43f0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, lr}
200259fc:	4605      	mov	r5, r0
200259fe:	2400      	movs	r4, #0
20025a00:	4f13      	ldr	r7, [pc, #76]	@ (20025a50 <bbm_get_page_num+0x58>)
20025a02:	4e14      	ldr	r6, [pc, #80]	@ (20025a54 <bbm_get_page_num+0x5c>)
20025a04:	f8df 8050 	ldr.w	r8, [pc, #80]	@ 20025a58 <bbm_get_page_num+0x60>
20025a08:	b085      	sub	sp, #20
20025a0a:	6839      	ldr	r1, [r7, #0]
20025a0c:	6833      	ldr	r3, [r6, #0]
20025a0e:	fbb3 f3f1 	udiv	r3, r3, r1
20025a12:	42a3      	cmp	r3, r4
20025a14:	d802      	bhi.n	20025a1c <bbm_get_page_num+0x24>
20025a16:	f04f 34ff 	mov.w	r4, #4294967295
20025a1a:	e015      	b.n	20025a48 <bbm_get_page_num+0x50>
20025a1c:	2200      	movs	r2, #0
20025a1e:	e9cd 2201 	strd	r2, r2, [sp, #4]
20025a22:	f8df 9038 	ldr.w	r9, [pc, #56]	@ 20025a5c <bbm_get_page_num+0x64>
20025a26:	9100      	str	r1, [sp, #0]
20025a28:	4628      	mov	r0, r5
20025a2a:	4621      	mov	r1, r4
20025a2c:	f8d9 3000 	ldr.w	r3, [r9]
20025a30:	f7fb f8be 	bl	20020bb0 <port_read_page>
20025a34:	b120      	cbz	r0, 20025a40 <bbm_get_page_num+0x48>
20025a36:	f8d9 3000 	ldr.w	r3, [r9]
20025a3a:	681b      	ldr	r3, [r3, #0]
20025a3c:	4543      	cmp	r3, r8
20025a3e:	d101      	bne.n	20025a44 <bbm_get_page_num+0x4c>
20025a40:	3401      	adds	r4, #1
20025a42:	e7e2      	b.n	20025a0a <bbm_get_page_num+0x12>
20025a44:	3301      	adds	r3, #1
20025a46:	d1fb      	bne.n	20025a40 <bbm_get_page_num+0x48>
20025a48:	4620      	mov	r0, r4
20025a4a:	b005      	add	sp, #20
20025a4c:	e8bd 83f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, pc}
20025a50:	20044998 	.word	0x20044998
20025a54:	2004499c 	.word	0x2004499c
20025a58:	5366424d 	.word	0x5366424d
20025a5c:	2004cc84 	.word	0x2004cc84

20025a60 <bbm_read_page>:
20025a60:	b5f0      	push	{r4, r5, r6, r7, lr}
20025a62:	4604      	mov	r4, r0
20025a64:	b085      	sub	sp, #20
20025a66:	b280      	uxth	r0, r0
20025a68:	461f      	mov	r7, r3
20025a6a:	460d      	mov	r5, r1
20025a6c:	4616      	mov	r6, r2
20025a6e:	f7ff fe69 	bl	20025744 <bbm_get_phy_blk>
20025a72:	1c43      	adds	r3, r0, #1
20025a74:	d108      	bne.n	20025a88 <bbm_read_page+0x28>
20025a76:	4b0a      	ldr	r3, [pc, #40]	@ (20025aa0 <bbm_read_page+0x40>)
20025a78:	681b      	ldr	r3, [r3, #0]
20025a7a:	b113      	cbz	r3, 20025a82 <bbm_read_page+0x22>
20025a7c:	4621      	mov	r1, r4
20025a7e:	4809      	ldr	r0, [pc, #36]	@ (20025aa4 <bbm_read_page+0x44>)
20025a80:	4798      	blx	r3
20025a82:	2000      	movs	r0, #0
20025a84:	b005      	add	sp, #20
20025a86:	bdf0      	pop	{r4, r5, r6, r7, pc}
20025a88:	9b0c      	ldr	r3, [sp, #48]	@ 0x30
20025a8a:	4632      	mov	r2, r6
20025a8c:	9302      	str	r3, [sp, #8]
20025a8e:	9b0b      	ldr	r3, [sp, #44]	@ 0x2c
20025a90:	4629      	mov	r1, r5
20025a92:	9301      	str	r3, [sp, #4]
20025a94:	9b0a      	ldr	r3, [sp, #40]	@ 0x28
20025a96:	9300      	str	r3, [sp, #0]
20025a98:	463b      	mov	r3, r7
20025a9a:	f7fb f889 	bl	20020bb0 <port_read_page>
20025a9e:	e7f1      	b.n	20025a84 <bbm_read_page+0x24>
20025aa0:	2004cc80 	.word	0x2004cc80
20025aa4:	2002ae49 	.word	0x2002ae49

20025aa8 <port_write_page>:
20025aa8:	4b01      	ldr	r3, [pc, #4]	@ (20025ab0 <port_write_page+0x8>)
20025aaa:	6818      	ldr	r0, [r3, #0]
20025aac:	4770      	bx	lr
20025aae:	bf00      	nop
20025ab0:	20044998 	.word	0x20044998

20025ab4 <bbm_write_talbe.isra.0>:
20025ab4:	b5f7      	push	{r0, r1, r2, r4, r5, r6, r7, lr}
20025ab6:	4604      	mov	r4, r0
20025ab8:	4608      	mov	r0, r1
20025aba:	460e      	mov	r6, r1
20025abc:	f7ff ff9c 	bl	200259f8 <bbm_get_page_num>
20025ac0:	1e05      	subs	r5, r0, #0
20025ac2:	db25      	blt.n	20025b10 <bbm_write_talbe.isra.0+0x5c>
20025ac4:	4b13      	ldr	r3, [pc, #76]	@ (20025b14 <bbm_write_talbe.isra.0+0x60>)
20025ac6:	681a      	ldr	r2, [r3, #0]
20025ac8:	4b13      	ldr	r3, [pc, #76]	@ (20025b18 <bbm_write_talbe.isra.0+0x64>)
20025aca:	681b      	ldr	r3, [r3, #0]
20025acc:	fbb3 f3f2 	udiv	r3, r3, r2
20025ad0:	429d      	cmp	r5, r3
20025ad2:	da1d      	bge.n	20025b10 <bbm_write_talbe.isra.0+0x5c>
20025ad4:	4f11      	ldr	r7, [pc, #68]	@ (20025b1c <bbm_write_talbe.isra.0+0x68>)
20025ad6:	21ff      	movs	r1, #255	@ 0xff
20025ad8:	6838      	ldr	r0, [r7, #0]
20025ada:	f004 ffbb 	bl	2002aa54 <memset>
20025ade:	4264      	negs	r4, r4
20025ae0:	490f      	ldr	r1, [pc, #60]	@ (20025b20 <bbm_write_talbe.isra.0+0x6c>)
20025ae2:	f404 7402 	and.w	r4, r4, #520	@ 0x208
20025ae6:	f44f 7202 	mov.w	r2, #520	@ 0x208
20025aea:	6838      	ldr	r0, [r7, #0]
20025aec:	4421      	add	r1, r4
20025aee:	f004 ffcb 	bl	2002aa88 <memcpy>
20025af2:	6838      	ldr	r0, [r7, #0]
20025af4:	b160      	cbz	r0, 20025b10 <bbm_write_talbe.isra.0+0x5c>
20025af6:	6802      	ldr	r2, [r0, #0]
20025af8:	4b0a      	ldr	r3, [pc, #40]	@ (20025b24 <bbm_write_talbe.isra.0+0x70>)
20025afa:	429a      	cmp	r2, r3
20025afc:	d108      	bne.n	20025b10 <bbm_write_talbe.isra.0+0x5c>
20025afe:	f7ff fdbd 	bl	2002567c <bbm_map_check.part.0>
20025b02:	2300      	movs	r3, #0
20025b04:	9300      	str	r3, [sp, #0]
20025b06:	4629      	mov	r1, r5
20025b08:	4630      	mov	r0, r6
20025b0a:	683a      	ldr	r2, [r7, #0]
20025b0c:	f7ff ffcc 	bl	20025aa8 <port_write_page>
20025b10:	b003      	add	sp, #12
20025b12:	bdf0      	pop	{r4, r5, r6, r7, pc}
20025b14:	20044998 	.word	0x20044998
20025b18:	2004499c 	.word	0x2004499c
20025b1c:	2004cc84 	.word	0x2004cc84
20025b20:	2004cc98 	.word	0x2004cc98
20025b24:	5366424d 	.word	0x5366424d

20025b28 <port_erase_block>:
20025b28:	2000      	movs	r0, #0
20025b2a:	4770      	bx	lr

20025b2c <bbm_init_table>:
20025b2c:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
20025b30:	4c7d      	ldr	r4, [pc, #500]	@ (20025d28 <bbm_init_table+0x1fc>)
20025b32:	4b7e      	ldr	r3, [pc, #504]	@ (20025d2c <bbm_init_table+0x200>)
20025b34:	6822      	ldr	r2, [r4, #0]
20025b36:	b085      	sub	sp, #20
20025b38:	429a      	cmp	r2, r3
20025b3a:	f000 80ef 	beq.w	20025d1c <bbm_init_table+0x1f0>
20025b3e:	f8d4 2208 	ldr.w	r2, [r4, #520]	@ 0x208
20025b42:	429a      	cmp	r2, r3
20025b44:	f000 80ea 	beq.w	20025d1c <bbm_init_table+0x1f0>
20025b48:	6023      	str	r3, [r4, #0]
20025b4a:	2301      	movs	r3, #1
20025b4c:	6063      	str	r3, [r4, #4]
20025b4e:	2300      	movs	r3, #0
20025b50:	f8df 9210 	ldr.w	r9, [pc, #528]	@ 20025d64 <bbm_init_table+0x238>
20025b54:	8123      	strh	r3, [r4, #8]
20025b56:	f8d9 3000 	ldr.w	r3, [r9]
20025b5a:	4f75      	ldr	r7, [pc, #468]	@ (20025d30 <bbm_init_table+0x204>)
20025b5c:	3b04      	subs	r3, #4
20025b5e:	f8df a208 	ldr.w	sl, [pc, #520]	@ 20025d68 <bbm_init_table+0x23c>
20025b62:	8163      	strh	r3, [r4, #10]
20025b64:	683b      	ldr	r3, [r7, #0]
20025b66:	f8da 5000 	ldr.w	r5, [sl]
20025b6a:	3b01      	subs	r3, #1
20025b6c:	4e71      	ldr	r6, [pc, #452]	@ (20025d34 <bbm_init_table+0x208>)
20025b6e:	81a3      	strh	r3, [r4, #12]
20025b70:	81e5      	strh	r5, [r4, #14]
20025b72:	683b      	ldr	r3, [r7, #0]
20025b74:	429d      	cmp	r5, r3
20025b76:	db10      	blt.n	20025b9a <bbm_init_table+0x6e>
20025b78:	2500      	movs	r5, #0
20025b7a:	46a8      	mov	r8, r5
20025b7c:	f8df b1b4 	ldr.w	fp, [pc, #436]	@ 20025d34 <bbm_init_table+0x208>
20025b80:	f8da 6000 	ldr.w	r6, [sl]
20025b84:	42b5      	cmp	r5, r6
20025b86:	db20      	blt.n	20025bca <bbm_init_table+0x9e>
20025b88:	8963      	ldrh	r3, [r4, #10]
20025b8a:	2b00      	cmp	r3, #0
20025b8c:	d14d      	bne.n	20025c2a <bbm_init_table+0xfe>
20025b8e:	4b69      	ldr	r3, [pc, #420]	@ (20025d34 <bbm_init_table+0x208>)
20025b90:	681b      	ldr	r3, [r3, #0]
20025b92:	b10b      	cbz	r3, 20025b98 <bbm_init_table+0x6c>
20025b94:	4868      	ldr	r0, [pc, #416]	@ (20025d38 <bbm_init_table+0x20c>)
20025b96:	4798      	blx	r3
20025b98:	e7fe      	b.n	20025b98 <bbm_init_table+0x6c>
20025b9a:	4628      	mov	r0, r5
20025b9c:	f7fb f86c 	bl	20020c78 <bbm_get_bb>
20025ba0:	b968      	cbnz	r0, 20025bbe <bbm_init_table+0x92>
20025ba2:	4628      	mov	r0, r5
20025ba4:	f7ff ffc0 	bl	20025b28 <port_erase_block>
20025ba8:	b138      	cbz	r0, 20025bba <bbm_init_table+0x8e>
20025baa:	6833      	ldr	r3, [r6, #0]
20025bac:	b113      	cbz	r3, 20025bb4 <bbm_init_table+0x88>
20025bae:	4629      	mov	r1, r5
20025bb0:	4862      	ldr	r0, [pc, #392]	@ (20025d3c <bbm_init_table+0x210>)
20025bb2:	4798      	blx	r3
20025bb4:	8963      	ldrh	r3, [r4, #10]
20025bb6:	3b01      	subs	r3, #1
20025bb8:	8163      	strh	r3, [r4, #10]
20025bba:	3501      	adds	r5, #1
20025bbc:	e7d9      	b.n	20025b72 <bbm_init_table+0x46>
20025bbe:	6833      	ldr	r3, [r6, #0]
20025bc0:	2b00      	cmp	r3, #0
20025bc2:	d0f7      	beq.n	20025bb4 <bbm_init_table+0x88>
20025bc4:	4629      	mov	r1, r5
20025bc6:	485e      	ldr	r0, [pc, #376]	@ (20025d40 <bbm_init_table+0x214>)
20025bc8:	e7f3      	b.n	20025bb2 <bbm_init_table+0x86>
20025bca:	4628      	mov	r0, r5
20025bcc:	f7fb f854 	bl	20020c78 <bbm_get_bb>
20025bd0:	b348      	cbz	r0, 20025c26 <bbm_init_table+0xfa>
20025bd2:	f8db 3000 	ldr.w	r3, [fp]
20025bd6:	b113      	cbz	r3, 20025bde <bbm_init_table+0xb2>
20025bd8:	4629      	mov	r1, r5
20025bda:	485a      	ldr	r0, [pc, #360]	@ (20025d44 <bbm_init_table+0x218>)
20025bdc:	4798      	blx	r3
20025bde:	89a0      	ldrh	r0, [r4, #12]
20025be0:	f7fb f84a 	bl	20020c78 <bbm_get_bb>
20025be4:	89a3      	ldrh	r3, [r4, #12]
20025be6:	4606      	mov	r6, r0
20025be8:	3b01      	subs	r3, #1
20025bea:	81a3      	strh	r3, [r4, #12]
20025bec:	8963      	ldrh	r3, [r4, #10]
20025bee:	3b01      	subs	r3, #1
20025bf0:	b29b      	uxth	r3, r3
20025bf2:	8163      	strh	r3, [r4, #10]
20025bf4:	b108      	cbz	r0, 20025bfa <bbm_init_table+0xce>
20025bf6:	2b00      	cmp	r3, #0
20025bf8:	d1f1      	bne.n	20025bde <bbm_init_table+0xb2>
20025bfa:	f8db 3000 	ldr.w	r3, [fp]
20025bfe:	b11b      	cbz	r3, 20025c08 <bbm_init_table+0xdc>
20025c00:	4642      	mov	r2, r8
20025c02:	4629      	mov	r1, r5
20025c04:	4850      	ldr	r0, [pc, #320]	@ (20025d48 <bbm_init_table+0x21c>)
20025c06:	4798      	blx	r3
20025c08:	b946      	cbnz	r6, 20025c1c <bbm_init_table+0xf0>
20025c0a:	89a2      	ldrh	r2, [r4, #12]
20025c0c:	f108 0306 	add.w	r3, r8, #6
20025c10:	f824 5023 	strh.w	r5, [r4, r3, lsl #2]
20025c14:	3201      	adds	r2, #1
20025c16:	eb04 0383 	add.w	r3, r4, r3, lsl #2
20025c1a:	805a      	strh	r2, [r3, #2]
20025c1c:	8923      	ldrh	r3, [r4, #8]
20025c1e:	f108 0801 	add.w	r8, r8, #1
20025c22:	3301      	adds	r3, #1
20025c24:	8123      	strh	r3, [r4, #8]
20025c26:	3501      	adds	r5, #1
20025c28:	e7aa      	b.n	20025b80 <bbm_init_table+0x54>
20025c2a:	2110      	movs	r1, #16
20025c2c:	483e      	ldr	r0, [pc, #248]	@ (20025d28 <bbm_init_table+0x1fc>)
20025c2e:	f7ff fd75 	bl	2002571c <bbm_crc_check>
20025c32:	f8d9 1000 	ldr.w	r1, [r9]
20025c36:	6120      	str	r0, [r4, #16]
20025c38:	3904      	subs	r1, #4
20025c3a:	0089      	lsls	r1, r1, #2
20025c3c:	4843      	ldr	r0, [pc, #268]	@ (20025d4c <bbm_init_table+0x220>)
20025c3e:	f7ff fd6d 	bl	2002571c <bbm_crc_check>
20025c42:	f44f 7202 	mov.w	r2, #520	@ 0x208
20025c46:	4938      	ldr	r1, [pc, #224]	@ (20025d28 <bbm_init_table+0x1fc>)
20025c48:	6160      	str	r0, [r4, #20]
20025c4a:	1888      	adds	r0, r1, r2
20025c4c:	f004 ff1c 	bl	2002aa88 <memcpy>
20025c50:	f894 320f 	ldrb.w	r3, [r4, #527]	@ 0x20f
20025c54:	2110      	movs	r1, #16
20025c56:	f043 0380 	orr.w	r3, r3, #128	@ 0x80
20025c5a:	f884 320f 	strb.w	r3, [r4, #527]	@ 0x20f
20025c5e:	483c      	ldr	r0, [pc, #240]	@ (20025d50 <bbm_init_table+0x224>)
20025c60:	f7ff fd5c 	bl	2002571c <bbm_crc_check>
20025c64:	f8c4 0218 	str.w	r0, [r4, #536]	@ 0x218
20025c68:	2400      	movs	r4, #0
20025c6a:	f8df 9100 	ldr.w	r9, [pc, #256]	@ 20025d6c <bbm_init_table+0x240>
20025c6e:	f8df 8100 	ldr.w	r8, [pc, #256]	@ 20025d70 <bbm_init_table+0x244>
20025c72:	683b      	ldr	r3, [r7, #0]
20025c74:	429e      	cmp	r6, r3
20025c76:	db08      	blt.n	20025c8a <bbm_init_table+0x15e>
20025c78:	2c03      	cmp	r4, #3
20025c7a:	dc30      	bgt.n	20025cde <bbm_init_table+0x1b2>
20025c7c:	4b2d      	ldr	r3, [pc, #180]	@ (20025d34 <bbm_init_table+0x208>)
20025c7e:	681b      	ldr	r3, [r3, #0]
20025c80:	b113      	cbz	r3, 20025c88 <bbm_init_table+0x15c>
20025c82:	4621      	mov	r1, r4
20025c84:	4833      	ldr	r0, [pc, #204]	@ (20025d54 <bbm_init_table+0x228>)
20025c86:	4798      	blx	r3
20025c88:	e7fe      	b.n	20025c88 <bbm_init_table+0x15c>
20025c8a:	4630      	mov	r0, r6
20025c8c:	f7fa fff4 	bl	20020c78 <bbm_get_bb>
20025c90:	4605      	mov	r5, r0
20025c92:	bb10      	cbnz	r0, 20025cda <bbm_init_table+0x1ae>
20025c94:	f8d9 a000 	ldr.w	sl, [r9]
20025c98:	21ff      	movs	r1, #255	@ 0xff
20025c9a:	4652      	mov	r2, sl
20025c9c:	f8d8 0000 	ldr.w	r0, [r8]
20025ca0:	f004 fed8 	bl	2002aa54 <memset>
20025ca4:	e9cd 5501 	strd	r5, r5, [sp, #4]
20025ca8:	f8cd a000 	str.w	sl, [sp]
20025cac:	f8d8 3000 	ldr.w	r3, [r8]
20025cb0:	462a      	mov	r2, r5
20025cb2:	4629      	mov	r1, r5
20025cb4:	4630      	mov	r0, r6
20025cb6:	f7fa ff7b 	bl	20020bb0 <port_read_page>
20025cba:	f8d9 3000 	ldr.w	r3, [r9]
20025cbe:	4298      	cmp	r0, r3
20025cc0:	d109      	bne.n	20025cd6 <bbm_init_table+0x1aa>
20025cc2:	f8d8 3000 	ldr.w	r3, [r8]
20025cc6:	681b      	ldr	r3, [r3, #0]
20025cc8:	3301      	adds	r3, #1
20025cca:	bf01      	itttt	eq
20025ccc:	4b22      	ldreq	r3, [pc, #136]	@ (20025d58 <bbm_init_table+0x22c>)
20025cce:	1d22      	addeq	r2, r4, #4
20025cd0:	f823 6012 	strheq.w	r6, [r3, r2, lsl #1]
20025cd4:	3401      	addeq	r4, #1
20025cd6:	2c03      	cmp	r4, #3
20025cd8:	dc01      	bgt.n	20025cde <bbm_init_table+0x1b2>
20025cda:	3601      	adds	r6, #1
20025cdc:	e7c9      	b.n	20025c72 <bbm_init_table+0x146>
20025cde:	2500      	movs	r5, #0
20025ce0:	4c1d      	ldr	r4, [pc, #116]	@ (20025d58 <bbm_init_table+0x22c>)
20025ce2:	2000      	movs	r0, #0
20025ce4:	8921      	ldrh	r1, [r4, #8]
20025ce6:	f7ff fee5 	bl	20025ab4 <bbm_write_talbe.isra.0>
20025cea:	8923      	ldrh	r3, [r4, #8]
20025cec:	2001      	movs	r0, #1
20025cee:	8961      	ldrh	r1, [r4, #10]
20025cf0:	8023      	strh	r3, [r4, #0]
20025cf2:	8223      	strh	r3, [r4, #16]
20025cf4:	8125      	strh	r5, [r4, #8]
20025cf6:	f7ff fedd 	bl	20025ab4 <bbm_write_talbe.isra.0>
20025cfa:	8963      	ldrh	r3, [r4, #10]
20025cfc:	8165      	strh	r5, [r4, #10]
20025cfe:	80a3      	strh	r3, [r4, #4]
20025d00:	8263      	strh	r3, [r4, #18]
20025d02:	89a3      	ldrh	r3, [r4, #12]
20025d04:	8063      	strh	r3, [r4, #2]
20025d06:	89e3      	ldrh	r3, [r4, #14]
20025d08:	80e3      	strh	r3, [r4, #6]
20025d0a:	4b0a      	ldr	r3, [pc, #40]	@ (20025d34 <bbm_init_table+0x208>)
20025d0c:	681b      	ldr	r3, [r3, #0]
20025d0e:	b10b      	cbz	r3, 20025d14 <bbm_init_table+0x1e8>
20025d10:	4812      	ldr	r0, [pc, #72]	@ (20025d5c <bbm_init_table+0x230>)
20025d12:	4798      	blx	r3
20025d14:	2000      	movs	r0, #0
20025d16:	b005      	add	sp, #20
20025d18:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
20025d1c:	4b05      	ldr	r3, [pc, #20]	@ (20025d34 <bbm_init_table+0x208>)
20025d1e:	681b      	ldr	r3, [r3, #0]
20025d20:	b10b      	cbz	r3, 20025d26 <bbm_init_table+0x1fa>
20025d22:	480f      	ldr	r0, [pc, #60]	@ (20025d60 <bbm_init_table+0x234>)
20025d24:	4798      	blx	r3
20025d26:	e7fe      	b.n	20025d26 <bbm_init_table+0x1fa>
20025d28:	2004cc98 	.word	0x2004cc98
20025d2c:	5366424d 	.word	0x5366424d
20025d30:	2004cc8c 	.word	0x2004cc8c
20025d34:	2004cc80 	.word	0x2004cc80
20025d38:	2002aede 	.word	0x2002aede
20025d3c:	2002ae6c 	.word	0x2002ae6c
20025d40:	2002ae8e 	.word	0x2002ae8e
20025d44:	2002aeab 	.word	0x2002aeab
20025d48:	2002aeca 	.word	0x2002aeca
20025d4c:	2004ccb0 	.word	0x2004ccb0
20025d50:	2004cea0 	.word	0x2004cea0
20025d54:	2002aef8 	.word	0x2002aef8
20025d58:	2004d0a8 	.word	0x2004d0a8
20025d5c:	2002af1f 	.word	0x2002af1f
20025d60:	2002af3b 	.word	0x2002af3b
20025d64:	2004cc90 	.word	0x2004cc90
20025d68:	2004cc94 	.word	0x2004cc94
20025d6c:	20044998 	.word	0x20044998
20025d70:	2004cc84 	.word	0x2004cc84

20025d74 <sif_bbm_init>:
20025d74:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
20025d78:	b087      	sub	sp, #28
20025d7a:	2900      	cmp	r1, #0
20025d7c:	f000 8129 	beq.w	20025fd2 <sif_bbm_init+0x25e>
20025d80:	4b95      	ldr	r3, [pc, #596]	@ (20025fd8 <sif_bbm_init+0x264>)
20025d82:	681a      	ldr	r2, [r3, #0]
20025d84:	2a01      	cmp	r2, #1
20025d86:	d108      	bne.n	20025d9a <sif_bbm_init+0x26>
20025d88:	4b94      	ldr	r3, [pc, #592]	@ (20025fdc <sif_bbm_init+0x268>)
20025d8a:	681b      	ldr	r3, [r3, #0]
20025d8c:	b10b      	cbz	r3, 20025d92 <sif_bbm_init+0x1e>
20025d8e:	4894      	ldr	r0, [pc, #592]	@ (20025fe0 <sif_bbm_init+0x26c>)
20025d90:	4798      	blx	r3
20025d92:	2000      	movs	r0, #0
20025d94:	b007      	add	sp, #28
20025d96:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
20025d9a:	2201      	movs	r2, #1
20025d9c:	601a      	str	r2, [r3, #0]
20025d9e:	4b91      	ldr	r3, [pc, #580]	@ (20025fe4 <sif_bbm_init+0x270>)
20025da0:	681c      	ldr	r4, [r3, #0]
20025da2:	b904      	cbnz	r4, 20025da6 <sif_bbm_init+0x32>
20025da4:	e7fe      	b.n	20025da4 <sif_bbm_init+0x30>
20025da6:	f8df a27c 	ldr.w	sl, [pc, #636]	@ 20026024 <sif_bbm_init+0x2b0>
20025daa:	f8da 2000 	ldr.w	r2, [sl]
20025dae:	b902      	cbnz	r2, 20025db2 <sif_bbm_init+0x3e>
20025db0:	e7fe      	b.n	20025db0 <sif_bbm_init+0x3c>
20025db2:	fbb0 f4f4 	udiv	r4, r0, r4
20025db6:	f04f 0800 	mov.w	r8, #0
20025dba:	4a8b      	ldr	r2, [pc, #556]	@ (20025fe8 <sif_bbm_init+0x274>)
20025dbc:	f8df b268 	ldr.w	fp, [pc, #616]	@ 20026028 <sif_bbm_init+0x2b4>
20025dc0:	0963      	lsrs	r3, r4, #5
20025dc2:	f8df 9268 	ldr.w	r9, [pc, #616]	@ 2002602c <sif_bbm_init+0x2b8>
20025dc6:	6013      	str	r3, [r2, #0]
20025dc8:	f8cb 4000 	str.w	r4, [fp]
20025dcc:	1ae4      	subs	r4, r4, r3
20025dce:	4b87      	ldr	r3, [pc, #540]	@ (20025fec <sif_bbm_init+0x278>)
20025dd0:	2218      	movs	r2, #24
20025dd2:	f8c9 1000 	str.w	r1, [r9]
20025dd6:	4886      	ldr	r0, [pc, #536]	@ (20025ff0 <sif_bbm_init+0x27c>)
20025dd8:	2100      	movs	r1, #0
20025dda:	601c      	str	r4, [r3, #0]
20025ddc:	f004 fe3a 	bl	2002aa54 <memset>
20025de0:	f44f 6282 	mov.w	r2, #1040	@ 0x410
20025de4:	2100      	movs	r1, #0
20025de6:	4883      	ldr	r0, [pc, #524]	@ (20025ff4 <sif_bbm_init+0x280>)
20025de8:	f004 fe34 	bl	2002aa54 <memset>
20025dec:	4647      	mov	r7, r8
20025dee:	4646      	mov	r6, r8
20025df0:	f8db 3000 	ldr.w	r3, [fp]
20025df4:	429c      	cmp	r4, r3
20025df6:	db02      	blt.n	20025dfe <sif_bbm_init+0x8a>
20025df8:	f04f 35ff 	mov.w	r5, #4294967295
20025dfc:	e064      	b.n	20025ec8 <sif_bbm_init+0x154>
20025dfe:	4620      	mov	r0, r4
20025e00:	f7fa ff3a 	bl	20020c78 <bbm_get_bb>
20025e04:	4605      	mov	r5, r0
20025e06:	b138      	cbz	r0, 20025e18 <sif_bbm_init+0xa4>
20025e08:	4b74      	ldr	r3, [pc, #464]	@ (20025fdc <sif_bbm_init+0x268>)
20025e0a:	681b      	ldr	r3, [r3, #0]
20025e0c:	b113      	cbz	r3, 20025e14 <sif_bbm_init+0xa0>
20025e0e:	4621      	mov	r1, r4
20025e10:	4879      	ldr	r0, [pc, #484]	@ (20025ff8 <sif_bbm_init+0x284>)
20025e12:	4798      	blx	r3
20025e14:	3401      	adds	r4, #1
20025e16:	e7eb      	b.n	20025df0 <sif_bbm_init+0x7c>
20025e18:	f8da 2000 	ldr.w	r2, [sl]
20025e1c:	21ff      	movs	r1, #255	@ 0xff
20025e1e:	f8d9 0000 	ldr.w	r0, [r9]
20025e22:	9205      	str	r2, [sp, #20]
20025e24:	f004 fe16 	bl	2002aa54 <memset>
20025e28:	9a05      	ldr	r2, [sp, #20]
20025e2a:	e9cd 5501 	strd	r5, r5, [sp, #4]
20025e2e:	9200      	str	r2, [sp, #0]
20025e30:	f8d9 3000 	ldr.w	r3, [r9]
20025e34:	462a      	mov	r2, r5
20025e36:	4629      	mov	r1, r5
20025e38:	4620      	mov	r0, r4
20025e3a:	f7fa feb9 	bl	20020bb0 <port_read_page>
20025e3e:	f8da 3000 	ldr.w	r3, [sl]
20025e42:	4298      	cmp	r0, r3
20025e44:	d12e      	bne.n	20025ea4 <sif_bbm_init+0x130>
20025e46:	f8d9 1000 	ldr.w	r1, [r9]
20025e4a:	486c      	ldr	r0, [pc, #432]	@ (20025ffc <sif_bbm_init+0x288>)
20025e4c:	680b      	ldr	r3, [r1, #0]
20025e4e:	b2a2      	uxth	r2, r4
20025e50:	4283      	cmp	r3, r0
20025e52:	4b67      	ldr	r3, [pc, #412]	@ (20025ff0 <sif_bbm_init+0x27c>)
20025e54:	d11f      	bne.n	20025e96 <sif_bbm_init+0x122>
20025e56:	f991 1007 	ldrsb.w	r1, [r1, #7]
20025e5a:	2900      	cmp	r1, #0
20025e5c:	bfb5      	itete	lt
20025e5e:	eb03 0147 	addlt.w	r1, r3, r7, lsl #1
20025e62:	f823 2016 	strhge.w	r2, [r3, r6, lsl #1]
20025e66:	808a      	strhlt	r2, [r1, #4]
20025e68:	3601      	addge	r6, #1
20025e6a:	bfb8      	it	lt
20025e6c:	3701      	addlt	r7, #1
20025e6e:	eb06 0208 	add.w	r2, r6, r8
20025e72:	443a      	add	r2, r7
20025e74:	2a03      	cmp	r2, #3
20025e76:	ddcd      	ble.n	20025e14 <sif_bbm_init+0xa0>
20025e78:	2e00      	cmp	r6, #0
20025e7a:	f000 8081 	beq.w	20025f80 <sif_bbm_init+0x20c>
20025e7e:	2f00      	cmp	r7, #0
20025e80:	d07e      	beq.n	20025f80 <sif_bbm_init+0x20c>
20025e82:	2e01      	cmp	r6, #1
20025e84:	d001      	beq.n	20025e8a <sif_bbm_init+0x116>
20025e86:	2f01      	cmp	r7, #1
20025e88:	d11e      	bne.n	20025ec8 <sif_bbm_init+0x154>
20025e8a:	8819      	ldrh	r1, [r3, #0]
20025e8c:	891a      	ldrh	r2, [r3, #8]
20025e8e:	b981      	cbnz	r1, 20025eb2 <sif_bbm_init+0x13e>
20025e90:	801a      	strh	r2, [r3, #0]
20025e92:	895a      	ldrh	r2, [r3, #10]
20025e94:	e013      	b.n	20025ebe <sif_bbm_init+0x14a>
20025e96:	f108 0104 	add.w	r1, r8, #4
20025e9a:	f823 2011 	strh.w	r2, [r3, r1, lsl #1]
20025e9e:	f108 0801 	add.w	r8, r8, #1
20025ea2:	e7e4      	b.n	20025e6e <sif_bbm_init+0xfa>
20025ea4:	4b4d      	ldr	r3, [pc, #308]	@ (20025fdc <sif_bbm_init+0x268>)
20025ea6:	681b      	ldr	r3, [r3, #0]
20025ea8:	2b00      	cmp	r3, #0
20025eaa:	d0b3      	beq.n	20025e14 <sif_bbm_init+0xa0>
20025eac:	4854      	ldr	r0, [pc, #336]	@ (20026000 <sif_bbm_init+0x28c>)
20025eae:	1c61      	adds	r1, r4, #1
20025eb0:	e7af      	b.n	20025e12 <sif_bbm_init+0x9e>
20025eb2:	8859      	ldrh	r1, [r3, #2]
20025eb4:	b909      	cbnz	r1, 20025eba <sif_bbm_init+0x146>
20025eb6:	805a      	strh	r2, [r3, #2]
20025eb8:	e7eb      	b.n	20025e92 <sif_bbm_init+0x11e>
20025eba:	2a00      	cmp	r2, #0
20025ebc:	d0e9      	beq.n	20025e92 <sif_bbm_init+0x11e>
20025ebe:	8899      	ldrh	r1, [r3, #4]
20025ec0:	2900      	cmp	r1, #0
20025ec2:	d158      	bne.n	20025f76 <sif_bbm_init+0x202>
20025ec4:	809a      	strh	r2, [r3, #4]
20025ec6:	2502      	movs	r5, #2
20025ec8:	f8df 9110 	ldr.w	r9, [pc, #272]	@ 20025fdc <sif_bbm_init+0x268>
20025ecc:	f8d9 4000 	ldr.w	r4, [r9]
20025ed0:	b124      	cbz	r4, 20025edc <sif_bbm_init+0x168>
20025ed2:	4643      	mov	r3, r8
20025ed4:	463a      	mov	r2, r7
20025ed6:	4631      	mov	r1, r6
20025ed8:	484a      	ldr	r0, [pc, #296]	@ (20026004 <sif_bbm_init+0x290>)
20025eda:	47a0      	blx	r4
20025edc:	f8d9 3000 	ldr.w	r3, [r9]
20025ee0:	b113      	cbz	r3, 20025ee8 <sif_bbm_init+0x174>
20025ee2:	4629      	mov	r1, r5
20025ee4:	4848      	ldr	r0, [pc, #288]	@ (20026008 <sif_bbm_init+0x294>)
20025ee6:	4798      	blx	r3
20025ee8:	f035 0002 	bics.w	r0, r5, #2
20025eec:	d164      	bne.n	20025fb8 <sif_bbm_init+0x244>
20025eee:	f7ff fcc9 	bl	20025884 <bbm_get_map_table>
20025ef2:	4605      	mov	r5, r0
20025ef4:	2001      	movs	r0, #1
20025ef6:	f7ff fcc5 	bl	20025884 <bbm_get_map_table>
20025efa:	f8d9 6000 	ldr.w	r6, [r9]
20025efe:	4604      	mov	r4, r0
20025f00:	b13e      	cbz	r6, 20025f12 <sif_bbm_init+0x19e>
20025f02:	4a3b      	ldr	r2, [pc, #236]	@ (20025ff0 <sif_bbm_init+0x27c>)
20025f04:	4629      	mov	r1, r5
20025f06:	8a53      	ldrh	r3, [r2, #18]
20025f08:	9300      	str	r3, [sp, #0]
20025f0a:	8a12      	ldrh	r2, [r2, #16]
20025f0c:	4603      	mov	r3, r0
20025f0e:	483f      	ldr	r0, [pc, #252]	@ (2002600c <sif_bbm_init+0x298>)
20025f10:	47b0      	blx	r6
20025f12:	42a5      	cmp	r5, r4
20025f14:	4c37      	ldr	r4, [pc, #220]	@ (20025ff4 <sif_bbm_init+0x280>)
20025f16:	dd35      	ble.n	20025f84 <sif_bbm_init+0x210>
20025f18:	f44f 7202 	mov.w	r2, #520	@ 0x208
20025f1c:	4621      	mov	r1, r4
20025f1e:	18a0      	adds	r0, r4, r2
20025f20:	f004 fdb2 	bl	2002aa88 <memcpy>
20025f24:	f894 320f 	ldrb.w	r3, [r4, #527]	@ 0x20f
20025f28:	2110      	movs	r1, #16
20025f2a:	f043 0380 	orr.w	r3, r3, #128	@ 0x80
20025f2e:	f884 320f 	strb.w	r3, [r4, #527]	@ 0x20f
20025f32:	f504 7002 	add.w	r0, r4, #520	@ 0x208
20025f36:	f7ff fbf1 	bl	2002571c <bbm_crc_check>
20025f3a:	f8c4 0218 	str.w	r0, [r4, #536]	@ 0x218
20025f3e:	2001      	movs	r0, #1
20025f40:	4b2b      	ldr	r3, [pc, #172]	@ (20025ff0 <sif_bbm_init+0x27c>)
20025f42:	8a59      	ldrh	r1, [r3, #18]
20025f44:	f7ff fdb6 	bl	20025ab4 <bbm_write_talbe.isra.0>
20025f48:	6822      	ldr	r2, [r4, #0]
20025f4a:	4b2c      	ldr	r3, [pc, #176]	@ (20025ffc <sif_bbm_init+0x288>)
20025f4c:	429a      	cmp	r2, r3
20025f4e:	d12d      	bne.n	20025fac <sif_bbm_init+0x238>
20025f50:	4828      	ldr	r0, [pc, #160]	@ (20025ff4 <sif_bbm_init+0x280>)
20025f52:	f7ff fb93 	bl	2002567c <bbm_map_check.part.0>
20025f56:	f8d9 4000 	ldr.w	r4, [r9]
20025f5a:	b12c      	cbz	r4, 20025f68 <sif_bbm_init+0x1f4>
20025f5c:	4b2c      	ldr	r3, [pc, #176]	@ (20026010 <sif_bbm_init+0x29c>)
20025f5e:	4924      	ldr	r1, [pc, #144]	@ (20025ff0 <sif_bbm_init+0x27c>)
20025f60:	482c      	ldr	r0, [pc, #176]	@ (20026014 <sif_bbm_init+0x2a0>)
20025f62:	f5a3 7202 	sub.w	r2, r3, #520	@ 0x208
20025f66:	47a0      	blx	r4
20025f68:	f8d9 3000 	ldr.w	r3, [r9]
20025f6c:	2b00      	cmp	r3, #0
20025f6e:	f43f af10 	beq.w	20025d92 <sif_bbm_init+0x1e>
20025f72:	4829      	ldr	r0, [pc, #164]	@ (20026018 <sif_bbm_init+0x2a4>)
20025f74:	e70c      	b.n	20025d90 <sif_bbm_init+0x1c>
20025f76:	88d9      	ldrh	r1, [r3, #6]
20025f78:	2900      	cmp	r1, #0
20025f7a:	d1a4      	bne.n	20025ec6 <sif_bbm_init+0x152>
20025f7c:	80da      	strh	r2, [r3, #6]
20025f7e:	e7a2      	b.n	20025ec6 <sif_bbm_init+0x152>
20025f80:	2501      	movs	r5, #1
20025f82:	e7a1      	b.n	20025ec8 <sif_bbm_init+0x154>
20025f84:	dae0      	bge.n	20025f48 <sif_bbm_init+0x1d4>
20025f86:	f44f 7202 	mov.w	r2, #520	@ 0x208
20025f8a:	4620      	mov	r0, r4
20025f8c:	18a1      	adds	r1, r4, r2
20025f8e:	f004 fd7b 	bl	2002aa88 <memcpy>
20025f92:	79e3      	ldrb	r3, [r4, #7]
20025f94:	2110      	movs	r1, #16
20025f96:	f023 0380 	bic.w	r3, r3, #128	@ 0x80
20025f9a:	71e3      	strb	r3, [r4, #7]
20025f9c:	4620      	mov	r0, r4
20025f9e:	f7ff fbbd 	bl	2002571c <bbm_crc_check>
20025fa2:	4b13      	ldr	r3, [pc, #76]	@ (20025ff0 <sif_bbm_init+0x27c>)
20025fa4:	6120      	str	r0, [r4, #16]
20025fa6:	8a19      	ldrh	r1, [r3, #16]
20025fa8:	2000      	movs	r0, #0
20025faa:	e7cb      	b.n	20025f44 <sif_bbm_init+0x1d0>
20025fac:	f8d9 3000 	ldr.w	r3, [r9]
20025fb0:	b10b      	cbz	r3, 20025fb6 <sif_bbm_init+0x242>
20025fb2:	481a      	ldr	r0, [pc, #104]	@ (2002601c <sif_bbm_init+0x2a8>)
20025fb4:	4798      	blx	r3
20025fb6:	e7fe      	b.n	20025fb6 <sif_bbm_init+0x242>
20025fb8:	2d01      	cmp	r5, #1
20025fba:	d102      	bne.n	20025fc2 <sif_bbm_init+0x24e>
20025fbc:	f7ff fdb6 	bl	20025b2c <bbm_init_table>
20025fc0:	e7c9      	b.n	20025f56 <sif_bbm_init+0x1e2>
20025fc2:	f8d9 3000 	ldr.w	r3, [r9]
20025fc6:	b11b      	cbz	r3, 20025fd0 <sif_bbm_init+0x25c>
20025fc8:	f04f 31ff 	mov.w	r1, #4294967295
20025fcc:	4814      	ldr	r0, [pc, #80]	@ (20026020 <sif_bbm_init+0x2ac>)
20025fce:	4798      	blx	r3
20025fd0:	e7fe      	b.n	20025fd0 <sif_bbm_init+0x25c>
20025fd2:	f04f 30ff 	mov.w	r0, #4294967295
20025fd6:	e6dd      	b.n	20025d94 <sif_bbm_init+0x20>
20025fd8:	2004cc88 	.word	0x2004cc88
20025fdc:	2004cc80 	.word	0x2004cc80
20025fe0:	2002af4f 	.word	0x2002af4f
20025fe4:	2004499c 	.word	0x2004499c
20025fe8:	2004cc90 	.word	0x2004cc90
20025fec:	2004cc94 	.word	0x2004cc94
20025ff0:	2004d0a8 	.word	0x2004d0a8
20025ff4:	2004cc98 	.word	0x2004cc98
20025ff8:	2002af7d 	.word	0x2002af7d
20025ffc:	5366424d 	.word	0x5366424d
20026000:	2002af89 	.word	0x2002af89
20026004:	2002afa8 	.word	0x2002afa8
20026008:	2002afc7 	.word	0x2002afc7
2002600c:	2002afd9 	.word	0x2002afd9
20026010:	2004cea0 	.word	0x2004cea0
20026014:	2002b034 	.word	0x2002b034
20026018:	2002b058 	.word	0x2002b058
2002601c:	2002affd 	.word	0x2002affd
20026020:	2002b013 	.word	0x2002b013
20026024:	20044998 	.word	0x20044998
20026028:	2004cc8c 	.word	0x2004cc8c
2002602c:	2004cc84 	.word	0x2004cc84

20026030 <bbm_set_page_size>:
20026030:	4b01      	ldr	r3, [pc, #4]	@ (20026038 <bbm_set_page_size+0x8>)
20026032:	6018      	str	r0, [r3, #0]
20026034:	4770      	bx	lr
20026036:	bf00      	nop
20026038:	20044998 	.word	0x20044998

2002603c <bbm_set_blk_size>:
2002603c:	4b01      	ldr	r3, [pc, #4]	@ (20026044 <bbm_set_blk_size+0x8>)
2002603e:	6018      	str	r0, [r3, #0]
20026040:	4770      	bx	lr
20026042:	bf00      	nop
20026044:	2004499c 	.word	0x2004499c

20026048 <mbedtls_md_info_from_type>:
20026048:	3805      	subs	r0, #5
2002604a:	b2c0      	uxtb	r0, r0
2002604c:	2803      	cmp	r0, #3
2002604e:	bf9a      	itte	ls
20026050:	4b02      	ldrls	r3, [pc, #8]	@ (2002605c <mbedtls_md_info_from_type+0x14>)
20026052:	f853 0020 	ldrls.w	r0, [r3, r0, lsl #2]
20026056:	2000      	movhi	r0, #0
20026058:	4770      	bx	lr
2002605a:	bf00      	nop
2002605c:	2002beac 	.word	0x2002beac

20026060 <mbedtls_md_get_size>:
20026060:	b100      	cbz	r0, 20026064 <mbedtls_md_get_size+0x4>
20026062:	7a00      	ldrb	r0, [r0, #8]
20026064:	4770      	bx	lr

20026066 <sha224_process_wrap>:
20026066:	f000 b8a9 	b.w	200261bc <mbedtls_sha256_process>

2002606a <sha224_clone_wrap>:
2002606a:	f000 b85a 	b.w	20026122 <mbedtls_sha256_clone>

2002606e <sha224_ctx_free>:
2002606e:	b510      	push	{r4, lr}
20026070:	4604      	mov	r4, r0
20026072:	f000 f84c 	bl	2002610e <mbedtls_sha256_free>
20026076:	4620      	mov	r0, r4
20026078:	e8bd 4010 	ldmia.w	sp!, {r4, lr}
2002607c:	f004 bc24 	b.w	2002a8c8 <free>

20026080 <sha224_ctx_alloc>:
20026080:	b510      	push	{r4, lr}
20026082:	216c      	movs	r1, #108	@ 0x6c
20026084:	2001      	movs	r0, #1
20026086:	f004 fc03 	bl	2002a890 <calloc>
2002608a:	4604      	mov	r4, r0
2002608c:	b108      	cbz	r0, 20026092 <sha224_ctx_alloc+0x12>
2002608e:	f000 f83a 	bl	20026106 <mbedtls_sha256_init>
20026092:	4620      	mov	r0, r4
20026094:	bd10      	pop	{r4, pc}

20026096 <sha224_wrap>:
20026096:	2301      	movs	r3, #1
20026098:	f000 bc94 	b.w	200269c4 <mbedtls_sha256>

2002609c <sha256_wrap>:
2002609c:	2300      	movs	r3, #0
2002609e:	f000 bc91 	b.w	200269c4 <mbedtls_sha256>

200260a2 <sha224_finish_wrap>:
200260a2:	f000 bc21 	b.w	200268e8 <mbedtls_sha256_finish>

200260a6 <sha224_update_wrap>:
200260a6:	f000 bc1b 	b.w	200268e0 <mbedtls_sha256_update>

200260aa <sha224_starts_wrap>:
200260aa:	2101      	movs	r1, #1
200260ac:	f000 b83e 	b.w	2002612c <mbedtls_sha256_starts>

200260b0 <sha256_starts_wrap>:
200260b0:	2100      	movs	r1, #0
200260b2:	f000 b83b 	b.w	2002612c <mbedtls_sha256_starts>

200260b6 <sha384_process_wrap>:
200260b6:	f000 bd8f 	b.w	20026bd8 <mbedtls_sha512_process>

200260ba <sha384_clone_wrap>:
200260ba:	f000 bcf5 	b.w	20026aa8 <mbedtls_sha512_clone>

200260be <sha384_ctx_free>:
200260be:	b510      	push	{r4, lr}
200260c0:	4604      	mov	r4, r0
200260c2:	f000 fce7 	bl	20026a94 <mbedtls_sha512_free>
200260c6:	4620      	mov	r0, r4
200260c8:	e8bd 4010 	ldmia.w	sp!, {r4, lr}
200260cc:	f004 bbfc 	b.w	2002a8c8 <free>

200260d0 <sha384_ctx_alloc>:
200260d0:	b510      	push	{r4, lr}
200260d2:	21d8      	movs	r1, #216	@ 0xd8
200260d4:	2001      	movs	r0, #1
200260d6:	f004 fbdb 	bl	2002a890 <calloc>
200260da:	4604      	mov	r4, r0
200260dc:	b108      	cbz	r0, 200260e2 <sha384_ctx_alloc+0x12>
200260de:	f000 fcd5 	bl	20026a8c <mbedtls_sha512_init>
200260e2:	4620      	mov	r0, r4
200260e4:	bd10      	pop	{r4, pc}

200260e6 <sha384_wrap>:
200260e6:	2301      	movs	r3, #1
200260e8:	f001 bbfa 	b.w	200278e0 <mbedtls_sha512>

200260ec <sha512_wrap>:
200260ec:	2300      	movs	r3, #0
200260ee:	f001 bbf7 	b.w	200278e0 <mbedtls_sha512>

200260f2 <sha384_finish_wrap>:
200260f2:	f001 baef 	b.w	200276d4 <mbedtls_sha512_finish>

200260f6 <sha384_update_wrap>:
200260f6:	f001 bae8 	b.w	200276ca <mbedtls_sha512_update>

200260fa <sha384_starts_wrap>:
200260fa:	2101      	movs	r1, #1
200260fc:	f000 bcdc 	b.w	20026ab8 <mbedtls_sha512_starts>

20026100 <sha512_starts_wrap>:
20026100:	2100      	movs	r1, #0
20026102:	f000 bcd9 	b.w	20026ab8 <mbedtls_sha512_starts>

20026106 <mbedtls_sha256_init>:
20026106:	226c      	movs	r2, #108	@ 0x6c
20026108:	2100      	movs	r1, #0
2002610a:	f004 bca3 	b.w	2002aa54 <memset>

2002610e <mbedtls_sha256_free>:
2002610e:	b138      	cbz	r0, 20026120 <mbedtls_sha256_free+0x12>
20026110:	2100      	movs	r1, #0
20026112:	f100 036c 	add.w	r3, r0, #108	@ 0x6c
20026116:	4602      	mov	r2, r0
20026118:	3001      	adds	r0, #1
2002611a:	4298      	cmp	r0, r3
2002611c:	7011      	strb	r1, [r2, #0]
2002611e:	d1fa      	bne.n	20026116 <mbedtls_sha256_free+0x8>
20026120:	4770      	bx	lr

20026122 <mbedtls_sha256_clone>:
20026122:	b508      	push	{r3, lr}
20026124:	226c      	movs	r2, #108	@ 0x6c
20026126:	f004 fcaf 	bl	2002aa88 <memcpy>
2002612a:	bd08      	pop	{r3, pc}

2002612c <mbedtls_sha256_starts>:
2002612c:	e92d 41f0 	stmdb	sp!, {r4, r5, r6, r7, r8, lr}
20026130:	b1c1      	cbz	r1, 20026164 <mbedtls_sha256_starts+0x38>
20026132:	f8df e078 	ldr.w	lr, [pc, #120]	@ 200261ac <mbedtls_sha256_starts+0x80>
20026136:	f8df c078 	ldr.w	ip, [pc, #120]	@ 200261b0 <mbedtls_sha256_starts+0x84>
2002613a:	4f10      	ldr	r7, [pc, #64]	@ (2002617c <mbedtls_sha256_starts+0x50>)
2002613c:	4e10      	ldr	r6, [pc, #64]	@ (20026180 <mbedtls_sha256_starts+0x54>)
2002613e:	4d11      	ldr	r5, [pc, #68]	@ (20026184 <mbedtls_sha256_starts+0x58>)
20026140:	4c11      	ldr	r4, [pc, #68]	@ (20026188 <mbedtls_sha256_starts+0x5c>)
20026142:	4a12      	ldr	r2, [pc, #72]	@ (2002618c <mbedtls_sha256_starts+0x60>)
20026144:	4b12      	ldr	r3, [pc, #72]	@ (20026190 <mbedtls_sha256_starts+0x64>)
20026146:	f04f 0800 	mov.w	r8, #0
2002614a:	e9c0 ec02 	strd	lr, ip, [r0, #8]
2002614e:	e9c0 8800 	strd	r8, r8, [r0]
20026152:	e9c0 7604 	strd	r7, r6, [r0, #16]
20026156:	e9c0 5406 	strd	r5, r4, [r0, #24]
2002615a:	e9c0 2308 	strd	r2, r3, [r0, #32]
2002615e:	6681      	str	r1, [r0, #104]	@ 0x68
20026160:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}
20026164:	f8df e04c 	ldr.w	lr, [pc, #76]	@ 200261b4 <mbedtls_sha256_starts+0x88>
20026168:	f8df c04c 	ldr.w	ip, [pc, #76]	@ 200261b8 <mbedtls_sha256_starts+0x8c>
2002616c:	4f09      	ldr	r7, [pc, #36]	@ (20026194 <mbedtls_sha256_starts+0x68>)
2002616e:	4e0a      	ldr	r6, [pc, #40]	@ (20026198 <mbedtls_sha256_starts+0x6c>)
20026170:	4d0a      	ldr	r5, [pc, #40]	@ (2002619c <mbedtls_sha256_starts+0x70>)
20026172:	4c0b      	ldr	r4, [pc, #44]	@ (200261a0 <mbedtls_sha256_starts+0x74>)
20026174:	4a0b      	ldr	r2, [pc, #44]	@ (200261a4 <mbedtls_sha256_starts+0x78>)
20026176:	4b0c      	ldr	r3, [pc, #48]	@ (200261a8 <mbedtls_sha256_starts+0x7c>)
20026178:	e7e5      	b.n	20026146 <mbedtls_sha256_starts+0x1a>
2002617a:	bf00      	nop
2002617c:	3070dd17 	.word	0x3070dd17
20026180:	f70e5939 	.word	0xf70e5939
20026184:	ffc00b31 	.word	0xffc00b31
20026188:	68581511 	.word	0x68581511
2002618c:	64f98fa7 	.word	0x64f98fa7
20026190:	befa4fa4 	.word	0xbefa4fa4
20026194:	3c6ef372 	.word	0x3c6ef372
20026198:	a54ff53a 	.word	0xa54ff53a
2002619c:	510e527f 	.word	0x510e527f
200261a0:	9b05688c 	.word	0x9b05688c
200261a4:	1f83d9ab 	.word	0x1f83d9ab
200261a8:	5be0cd19 	.word	0x5be0cd19
200261ac:	c1059ed8 	.word	0xc1059ed8
200261b0:	367cd507 	.word	0x367cd507
200261b4:	6a09e667 	.word	0x6a09e667
200261b8:	bb67ae85 	.word	0xbb67ae85

200261bc <mbedtls_sha256_process>:
200261bc:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
200261c0:	b0cf      	sub	sp, #316	@ 0x13c
200261c2:	aa06      	add	r2, sp, #24
200261c4:	460b      	mov	r3, r1
200261c6:	4616      	mov	r6, r2
200261c8:	9004      	str	r0, [sp, #16]
200261ca:	f100 0408 	add.w	r4, r0, #8
200261ce:	f100 0728 	add.w	r7, r0, #40	@ 0x28
200261d2:	4635      	mov	r5, r6
200261d4:	6820      	ldr	r0, [r4, #0]
200261d6:	6861      	ldr	r1, [r4, #4]
200261d8:	3408      	adds	r4, #8
200261da:	c503      	stmia	r5!, {r0, r1}
200261dc:	42bc      	cmp	r4, r7
200261de:	462e      	mov	r6, r5
200261e0:	d1f7      	bne.n	200261d2 <mbedtls_sha256_process+0x16>
200261e2:	f10d 0a38 	add.w	sl, sp, #56	@ 0x38
200261e6:	4619      	mov	r1, r3
200261e8:	4650      	mov	r0, sl
200261ea:	f103 0440 	add.w	r4, r3, #64	@ 0x40
200261ee:	784b      	ldrb	r3, [r1, #1]
200261f0:	780d      	ldrb	r5, [r1, #0]
200261f2:	041b      	lsls	r3, r3, #16
200261f4:	ea43 6305 	orr.w	r3, r3, r5, lsl #24
200261f8:	78cd      	ldrb	r5, [r1, #3]
200261fa:	3104      	adds	r1, #4
200261fc:	432b      	orrs	r3, r5
200261fe:	f811 5c02 	ldrb.w	r5, [r1, #-2]
20026202:	428c      	cmp	r4, r1
20026204:	ea43 2305 	orr.w	r3, r3, r5, lsl #8
20026208:	f840 3b04 	str.w	r3, [r0], #4
2002620c:	d1ef      	bne.n	200261ee <mbedtls_sha256_process+0x32>
2002620e:	4996      	ldr	r1, [pc, #600]	@ (20026468 <mbedtls_sha256_process+0x2ac>)
20026210:	46d4      	mov	ip, sl
20026212:	e9d2 e705 	ldrd	lr, r7, [r2, #20]
20026216:	e9d2 9600 	ldrd	r9, r6, [r2]
2002621a:	460d      	mov	r5, r1
2002621c:	9100      	str	r1, [sp, #0]
2002621e:	f8d2 801c 	ldr.w	r8, [r2, #28]
20026222:	f8d2 b010 	ldr.w	fp, [r2, #16]
20026226:	e9d2 3202 	ldrd	r3, r2, [r2, #8]
2002622a:	6829      	ldr	r1, [r5, #0]
2002622c:	f8dc 0000 	ldr.w	r0, [ip]
20026230:	ea4f 24fb 	mov.w	r4, fp, ror #11
20026234:	ea84 14bb 	eor.w	r4, r4, fp, ror #6
20026238:	4401      	add	r1, r0
2002623a:	ea87 000e 	eor.w	r0, r7, lr
2002623e:	ea84 647b 	eor.w	r4, r4, fp, ror #25
20026242:	ea00 000b 	and.w	r0, r0, fp
20026246:	4078      	eors	r0, r7
20026248:	4421      	add	r1, r4
2002624a:	4401      	add	r1, r0
2002624c:	4441      	add	r1, r8
2002624e:	ea4f 3879 	mov.w	r8, r9, ror #13
20026252:	ea88 08b9 	eor.w	r8, r8, r9, ror #2
20026256:	ea88 58b9 	eor.w	r8, r8, r9, ror #22
2002625a:	440a      	add	r2, r1
2002625c:	4488      	add	r8, r1
2002625e:	ea49 0106 	orr.w	r1, r9, r6
20026262:	ea09 0006 	and.w	r0, r9, r6
20026266:	4019      	ands	r1, r3
20026268:	4301      	orrs	r1, r0
2002626a:	4488      	add	r8, r1
2002626c:	f8dc 0004 	ldr.w	r0, [ip, #4]
20026270:	6869      	ldr	r1, [r5, #4]
20026272:	ea4f 3478 	mov.w	r4, r8, ror #13
20026276:	4401      	add	r1, r0
20026278:	ea8b 000e 	eor.w	r0, fp, lr
2002627c:	4010      	ands	r0, r2
2002627e:	ea80 000e 	eor.w	r0, r0, lr
20026282:	4439      	add	r1, r7
20026284:	4401      	add	r1, r0
20026286:	ea4f 20f2 	mov.w	r0, r2, ror #11
2002628a:	ea80 10b2 	eor.w	r0, r0, r2, ror #6
2002628e:	ea80 6072 	eor.w	r0, r0, r2, ror #25
20026292:	ea84 04b8 	eor.w	r4, r4, r8, ror #2
20026296:	4401      	add	r1, r0
20026298:	ea84 54b8 	eor.w	r4, r4, r8, ror #22
2002629c:	440b      	add	r3, r1
2002629e:	440c      	add	r4, r1
200262a0:	ea48 0109 	orr.w	r1, r8, r9
200262a4:	ea08 0009 	and.w	r0, r8, r9
200262a8:	4031      	ands	r1, r6
200262aa:	4301      	orrs	r1, r0
200262ac:	440c      	add	r4, r1
200262ae:	f8dc 0008 	ldr.w	r0, [ip, #8]
200262b2:	68a9      	ldr	r1, [r5, #8]
200262b4:	ea82 0703 	eor.w	r7, r2, r3
200262b8:	4401      	add	r1, r0
200262ba:	ea82 000b 	eor.w	r0, r2, fp
200262be:	4018      	ands	r0, r3
200262c0:	ea80 000b 	eor.w	r0, r0, fp
200262c4:	4471      	add	r1, lr
200262c6:	4401      	add	r1, r0
200262c8:	ea4f 20f3 	mov.w	r0, r3, ror #11
200262cc:	ea80 10b3 	eor.w	r0, r0, r3, ror #6
200262d0:	ea80 6073 	eor.w	r0, r0, r3, ror #25
200262d4:	4401      	add	r1, r0
200262d6:	ea4f 3074 	mov.w	r0, r4, ror #13
200262da:	ea80 00b4 	eor.w	r0, r0, r4, ror #2
200262de:	ea80 50b4 	eor.w	r0, r0, r4, ror #22
200262e2:	eb06 0e01 	add.w	lr, r6, r1
200262e6:	4408      	add	r0, r1
200262e8:	ea48 0104 	orr.w	r1, r8, r4
200262ec:	ea08 0604 	and.w	r6, r8, r4
200262f0:	ea01 0109 	and.w	r1, r1, r9
200262f4:	4331      	orrs	r1, r6
200262f6:	4408      	add	r0, r1
200262f8:	f8dc 600c 	ldr.w	r6, [ip, #12]
200262fc:	68e9      	ldr	r1, [r5, #12]
200262fe:	ea07 070e 	and.w	r7, r7, lr
20026302:	440e      	add	r6, r1
20026304:	ea4f 21fe 	mov.w	r1, lr, ror #11
20026308:	4057      	eors	r7, r2
2002630a:	445e      	add	r6, fp
2002630c:	ea81 11be 	eor.w	r1, r1, lr, ror #6
20026310:	ea81 617e 	eor.w	r1, r1, lr, ror #25
20026314:	443e      	add	r6, r7
20026316:	440e      	add	r6, r1
20026318:	ea4f 3170 	mov.w	r1, r0, ror #13
2002631c:	ea81 01b0 	eor.w	r1, r1, r0, ror #2
20026320:	ea81 51b0 	eor.w	r1, r1, r0, ror #22
20026324:	44b1      	add	r9, r6
20026326:	4431      	add	r1, r6
20026328:	ea44 0600 	orr.w	r6, r4, r0
2002632c:	ea04 0700 	and.w	r7, r4, r0
20026330:	ea06 0608 	and.w	r6, r6, r8
20026334:	433e      	orrs	r6, r7
20026336:	4431      	add	r1, r6
20026338:	f8dc 7010 	ldr.w	r7, [ip, #16]
2002633c:	692e      	ldr	r6, [r5, #16]
2002633e:	3520      	adds	r5, #32
20026340:	443e      	add	r6, r7
20026342:	4416      	add	r6, r2
20026344:	ea83 020e 	eor.w	r2, r3, lr
20026348:	ea02 0209 	and.w	r2, r2, r9
2002634c:	405a      	eors	r2, r3
2002634e:	4416      	add	r6, r2
20026350:	ea4f 22f9 	mov.w	r2, r9, ror #11
20026354:	ea82 12b9 	eor.w	r2, r2, r9, ror #6
20026358:	ea82 6279 	eor.w	r2, r2, r9, ror #25
2002635c:	4416      	add	r6, r2
2002635e:	ea4f 3271 	mov.w	r2, r1, ror #13
20026362:	ea82 02b1 	eor.w	r2, r2, r1, ror #2
20026366:	ea82 52b1 	eor.w	r2, r2, r1, ror #22
2002636a:	44b0      	add	r8, r6
2002636c:	4432      	add	r2, r6
2002636e:	ea40 0601 	orr.w	r6, r0, r1
20026372:	ea00 0701 	and.w	r7, r0, r1
20026376:	4026      	ands	r6, r4
20026378:	433e      	orrs	r6, r7
2002637a:	4432      	add	r2, r6
2002637c:	f8dc 7014 	ldr.w	r7, [ip, #20]
20026380:	f855 6c0c 	ldr.w	r6, [r5, #-12]
20026384:	f10c 0c20 	add.w	ip, ip, #32
20026388:	443e      	add	r6, r7
2002638a:	441e      	add	r6, r3
2002638c:	ea8e 0309 	eor.w	r3, lr, r9
20026390:	ea03 0308 	and.w	r3, r3, r8
20026394:	ea83 030e 	eor.w	r3, r3, lr
20026398:	441e      	add	r6, r3
2002639a:	ea4f 23f8 	mov.w	r3, r8, ror #11
2002639e:	ea83 13b8 	eor.w	r3, r3, r8, ror #6
200263a2:	ea83 6378 	eor.w	r3, r3, r8, ror #25
200263a6:	441e      	add	r6, r3
200263a8:	ea4f 3372 	mov.w	r3, r2, ror #13
200263ac:	ea83 03b2 	eor.w	r3, r3, r2, ror #2
200263b0:	19a7      	adds	r7, r4, r6
200263b2:	ea83 53b2 	eor.w	r3, r3, r2, ror #22
200263b6:	ea41 0402 	orr.w	r4, r1, r2
200263ba:	4433      	add	r3, r6
200263bc:	4004      	ands	r4, r0
200263be:	ea01 0602 	and.w	r6, r1, r2
200263c2:	4334      	orrs	r4, r6
200263c4:	4423      	add	r3, r4
200263c6:	f85c 6c08 	ldr.w	r6, [ip, #-8]
200263ca:	f855 4c08 	ldr.w	r4, [r5, #-8]
200263ce:	4434      	add	r4, r6
200263d0:	ea89 0608 	eor.w	r6, r9, r8
200263d4:	403e      	ands	r6, r7
200263d6:	ea86 0609 	eor.w	r6, r6, r9
200263da:	4474      	add	r4, lr
200263dc:	4434      	add	r4, r6
200263de:	ea4f 26f7 	mov.w	r6, r7, ror #11
200263e2:	ea86 16b7 	eor.w	r6, r6, r7, ror #6
200263e6:	ea86 6677 	eor.w	r6, r6, r7, ror #25
200263ea:	4434      	add	r4, r6
200263ec:	eb00 0e04 	add.w	lr, r0, r4
200263f0:	ea4f 3073 	mov.w	r0, r3, ror #13
200263f4:	ea80 00b3 	eor.w	r0, r0, r3, ror #2
200263f8:	ea80 50b3 	eor.w	r0, r0, r3, ror #22
200263fc:	4420      	add	r0, r4
200263fe:	ea42 0403 	orr.w	r4, r2, r3
20026402:	400c      	ands	r4, r1
20026404:	ea02 0603 	and.w	r6, r2, r3
20026408:	4334      	orrs	r4, r6
2002640a:	1906      	adds	r6, r0, r4
2002640c:	f855 0c04 	ldr.w	r0, [r5, #-4]
20026410:	f85c 4c04 	ldr.w	r4, [ip, #-4]
20026414:	4420      	add	r0, r4
20026416:	ea88 0407 	eor.w	r4, r8, r7
2002641a:	ea04 040e 	and.w	r4, r4, lr
2002641e:	4448      	add	r0, r9
20026420:	ea84 0408 	eor.w	r4, r4, r8
20026424:	4420      	add	r0, r4
20026426:	ea4f 24fe 	mov.w	r4, lr, ror #11
2002642a:	ea84 14be 	eor.w	r4, r4, lr, ror #6
2002642e:	ea84 647e 	eor.w	r4, r4, lr, ror #25
20026432:	4420      	add	r0, r4
20026434:	eb01 0b00 	add.w	fp, r1, r0
20026438:	ea4f 3176 	mov.w	r1, r6, ror #13
2002643c:	ea81 01b6 	eor.w	r1, r1, r6, ror #2
20026440:	ea81 51b6 	eor.w	r1, r1, r6, ror #22
20026444:	4401      	add	r1, r0
20026446:	ea43 0006 	orr.w	r0, r3, r6
2002644a:	4010      	ands	r0, r2
2002644c:	ea03 0406 	and.w	r4, r3, r6
20026450:	4320      	orrs	r0, r4
20026452:	eb01 0900 	add.w	r9, r1, r0
20026456:	4905      	ldr	r1, [pc, #20]	@ (2002646c <mbedtls_sha256_process+0x2b0>)
20026458:	42a9      	cmp	r1, r5
2002645a:	f47f aee6 	bne.w	2002622a <mbedtls_sha256_process+0x6e>
2002645e:	f10a 01c0 	add.w	r1, sl, #192	@ 0xc0
20026462:	9105      	str	r1, [sp, #20]
20026464:	e004      	b.n	20026470 <mbedtls_sha256_process+0x2b4>
20026466:	bf00      	nop
20026468:	2002bfbc 	.word	0x2002bfbc
2002646c:	2002bffc 	.word	0x2002bffc
20026470:	f8da 1038 	ldr.w	r1, [sl, #56]	@ 0x38
20026474:	f8da 5004 	ldr.w	r5, [sl, #4]
20026478:	ea4f 44f1 	mov.w	r4, r1, ror #19
2002647c:	ea84 4471 	eor.w	r4, r4, r1, ror #17
20026480:	f8da 0000 	ldr.w	r0, [sl]
20026484:	ea84 2491 	eor.w	r4, r4, r1, lsr #10
20026488:	f8da 1024 	ldr.w	r1, [sl, #36]	@ 0x24
2002648c:	f10a 0a20 	add.w	sl, sl, #32
20026490:	4401      	add	r1, r0
20026492:	ea4f 40b5 	mov.w	r0, r5, ror #18
20026496:	ea80 10f5 	eor.w	r0, r0, r5, ror #7
2002649a:	ea80 00d5 	eor.w	r0, r0, r5, lsr #3
2002649e:	4421      	add	r1, r4
200264a0:	4401      	add	r1, r0
200264a2:	9103      	str	r1, [sp, #12]
200264a4:	ea87 000e 	eor.w	r0, r7, lr
200264a8:	9900      	ldr	r1, [sp, #0]
200264aa:	ea4f 24fb 	mov.w	r4, fp, ror #11
200264ae:	ea84 14bb 	eor.w	r4, r4, fp, ror #6
200264b2:	ea00 000b 	and.w	r0, r0, fp
200264b6:	ea84 647b 	eor.w	r4, r4, fp, ror #25
200264ba:	6c09      	ldr	r1, [r1, #64]	@ 0x40
200264bc:	4078      	eors	r0, r7
200264be:	4420      	add	r0, r4
200264c0:	4401      	add	r1, r0
200264c2:	9803      	ldr	r0, [sp, #12]
200264c4:	ea4f 3479 	mov.w	r4, r9, ror #13
200264c8:	4401      	add	r1, r0
200264ca:	4441      	add	r1, r8
200264cc:	eb02 0801 	add.w	r8, r2, r1
200264d0:	ea49 0206 	orr.w	r2, r9, r6
200264d4:	f8ca 0020 	str.w	r0, [sl, #32]
200264d8:	ea84 04b9 	eor.w	r4, r4, r9, ror #2
200264dc:	ea09 0006 	and.w	r0, r9, r6
200264e0:	401a      	ands	r2, r3
200264e2:	4302      	orrs	r2, r0
200264e4:	ea84 54b9 	eor.w	r4, r4, r9, ror #22
200264e8:	4414      	add	r4, r2
200264ea:	f8da 201c 	ldr.w	r2, [sl, #28]
200264ee:	440c      	add	r4, r1
200264f0:	ea4f 4cf2 	mov.w	ip, r2, ror #19
200264f4:	ea8c 4c72 	eor.w	ip, ip, r2, ror #17
200264f8:	f85a 1c18 	ldr.w	r1, [sl, #-24]
200264fc:	ea8c 2c92 	eor.w	ip, ip, r2, lsr #10
20026500:	f8da 2008 	ldr.w	r2, [sl, #8]
20026504:	18a8      	adds	r0, r5, r2
20026506:	ea4f 42b1 	mov.w	r2, r1, ror #18
2002650a:	ea82 12f1 	eor.w	r2, r2, r1, ror #7
2002650e:	ea82 02d1 	eor.w	r2, r2, r1, lsr #3
20026512:	4460      	add	r0, ip
20026514:	4410      	add	r0, r2
20026516:	9a00      	ldr	r2, [sp, #0]
20026518:	ea8b 050e 	eor.w	r5, fp, lr
2002651c:	6c52      	ldr	r2, [r2, #68]	@ 0x44
2002651e:	ea05 0508 	and.w	r5, r5, r8
20026522:	443a      	add	r2, r7
20026524:	4402      	add	r2, r0
20026526:	ea85 050e 	eor.w	r5, r5, lr
2002652a:	4415      	add	r5, r2
2002652c:	ea4f 22f8 	mov.w	r2, r8, ror #11
20026530:	ea82 12b8 	eor.w	r2, r2, r8, ror #6
20026534:	ea82 6278 	eor.w	r2, r2, r8, ror #25
20026538:	442a      	add	r2, r5
2002653a:	4413      	add	r3, r2
2002653c:	9301      	str	r3, [sp, #4]
2002653e:	ea49 0504 	orr.w	r5, r9, r4
20026542:	ea4f 3374 	mov.w	r3, r4, ror #13
20026546:	ea09 0704 	and.w	r7, r9, r4
2002654a:	ea83 03b4 	eor.w	r3, r3, r4, ror #2
2002654e:	4035      	ands	r5, r6
20026550:	433d      	orrs	r5, r7
20026552:	ea83 53b4 	eor.w	r3, r3, r4, ror #22
20026556:	442b      	add	r3, r5
20026558:	4413      	add	r3, r2
2002655a:	9a03      	ldr	r2, [sp, #12]
2002655c:	f85a 5c14 	ldr.w	r5, [sl, #-20]
20026560:	ea4f 4cf2 	mov.w	ip, r2, ror #19
20026564:	ea8c 4c72 	eor.w	ip, ip, r2, ror #17
20026568:	ea8c 2c92 	eor.w	ip, ip, r2, lsr #10
2002656c:	f8da 200c 	ldr.w	r2, [sl, #12]
20026570:	f8ca 0024 	str.w	r0, [sl, #36]	@ 0x24
20026574:	188f      	adds	r7, r1, r2
20026576:	ea4f 42b5 	mov.w	r2, r5, ror #18
2002657a:	ea82 12f5 	eor.w	r2, r2, r5, ror #7
2002657e:	ea82 02d5 	eor.w	r2, r2, r5, lsr #3
20026582:	4467      	add	r7, ip
20026584:	4417      	add	r7, r2
20026586:	9a01      	ldr	r2, [sp, #4]
20026588:	ea8b 0108 	eor.w	r1, fp, r8
2002658c:	4011      	ands	r1, r2
2002658e:	9a00      	ldr	r2, [sp, #0]
20026590:	ea81 010b 	eor.w	r1, r1, fp
20026594:	6c92      	ldr	r2, [r2, #72]	@ 0x48
20026596:	f8ca 7028 	str.w	r7, [sl, #40]	@ 0x28
2002659a:	4472      	add	r2, lr
2002659c:	443a      	add	r2, r7
2002659e:	eb01 0c02 	add.w	ip, r1, r2
200265a2:	9a01      	ldr	r2, [sp, #4]
200265a4:	9901      	ldr	r1, [sp, #4]
200265a6:	ea4f 22f2 	mov.w	r2, r2, ror #11
200265aa:	ea82 12b1 	eor.w	r2, r2, r1, ror #6
200265ae:	ea82 6271 	eor.w	r2, r2, r1, ror #25
200265b2:	4462      	add	r2, ip
200265b4:	18b1      	adds	r1, r6, r2
200265b6:	9102      	str	r1, [sp, #8]
200265b8:	ea44 0603 	orr.w	r6, r4, r3
200265bc:	ea4f 3173 	mov.w	r1, r3, ror #13
200265c0:	ea04 0c03 	and.w	ip, r4, r3
200265c4:	ea81 01b3 	eor.w	r1, r1, r3, ror #2
200265c8:	ea06 0609 	and.w	r6, r6, r9
200265cc:	ea46 060c 	orr.w	r6, r6, ip
200265d0:	ea81 51b3 	eor.w	r1, r1, r3, ror #22
200265d4:	4431      	add	r1, r6
200265d6:	4411      	add	r1, r2
200265d8:	ea4f 42f0 	mov.w	r2, r0, ror #19
200265dc:	ea82 4270 	eor.w	r2, r2, r0, ror #17
200265e0:	f85a 6c10 	ldr.w	r6, [sl, #-16]
200265e4:	ea82 2090 	eor.w	r0, r2, r0, lsr #10
200265e8:	f8da 2010 	ldr.w	r2, [sl, #16]
200265ec:	ea03 0e01 	and.w	lr, r3, r1
200265f0:	4415      	add	r5, r2
200265f2:	ea4f 42b6 	mov.w	r2, r6, ror #18
200265f6:	ea82 12f6 	eor.w	r2, r2, r6, ror #7
200265fa:	ea82 02d6 	eor.w	r2, r2, r6, lsr #3
200265fe:	4405      	add	r5, r0
20026600:	4415      	add	r5, r2
20026602:	9a01      	ldr	r2, [sp, #4]
20026604:	ea88 0002 	eor.w	r0, r8, r2
20026608:	9a02      	ldr	r2, [sp, #8]
2002660a:	4010      	ands	r0, r2
2002660c:	9a00      	ldr	r2, [sp, #0]
2002660e:	ea80 0008 	eor.w	r0, r0, r8
20026612:	6cd2      	ldr	r2, [r2, #76]	@ 0x4c
20026614:	f8ca 502c 	str.w	r5, [sl, #44]	@ 0x2c
20026618:	445a      	add	r2, fp
2002661a:	442a      	add	r2, r5
2002661c:	eb00 0c02 	add.w	ip, r0, r2
20026620:	9a02      	ldr	r2, [sp, #8]
20026622:	9802      	ldr	r0, [sp, #8]
20026624:	ea4f 22f2 	mov.w	r2, r2, ror #11
20026628:	ea82 12b0 	eor.w	r2, r2, r0, ror #6
2002662c:	ea82 6270 	eor.w	r2, r2, r0, ror #25
20026630:	4462      	add	r2, ip
20026632:	ea4f 3071 	mov.w	r0, r1, ror #13
20026636:	ea43 0c01 	orr.w	ip, r3, r1
2002663a:	ea80 00b1 	eor.w	r0, r0, r1, ror #2
2002663e:	ea0c 0c04 	and.w	ip, ip, r4
20026642:	ea4c 0c0e 	orr.w	ip, ip, lr
20026646:	ea80 50b1 	eor.w	r0, r0, r1, ror #22
2002664a:	4460      	add	r0, ip
2002664c:	4410      	add	r0, r2
2002664e:	4491      	add	r9, r2
20026650:	ea4f 42f7 	mov.w	r2, r7, ror #19
20026654:	ea82 4277 	eor.w	r2, r2, r7, ror #17
20026658:	f85a cc0c 	ldr.w	ip, [sl, #-12]
2002665c:	ea82 2797 	eor.w	r7, r2, r7, lsr #10
20026660:	f8da 2014 	ldr.w	r2, [sl, #20]
20026664:	ea01 0e00 	and.w	lr, r1, r0
20026668:	4416      	add	r6, r2
2002666a:	ea4f 42bc 	mov.w	r2, ip, ror #18
2002666e:	ea82 12fc 	eor.w	r2, r2, ip, ror #7
20026672:	ea82 02dc 	eor.w	r2, r2, ip, lsr #3
20026676:	443e      	add	r6, r7
20026678:	4416      	add	r6, r2
2002667a:	e9dd 2701 	ldrd	r2, r7, [sp, #4]
2002667e:	4057      	eors	r7, r2
20026680:	ea07 0709 	and.w	r7, r7, r9
20026684:	4057      	eors	r7, r2
20026686:	9a00      	ldr	r2, [sp, #0]
20026688:	f8ca 6030 	str.w	r6, [sl, #48]	@ 0x30
2002668c:	6d12      	ldr	r2, [r2, #80]	@ 0x50
2002668e:	4432      	add	r2, r6
20026690:	4442      	add	r2, r8
20026692:	443a      	add	r2, r7
20026694:	ea4f 27f9 	mov.w	r7, r9, ror #11
20026698:	ea87 17b9 	eor.w	r7, r7, r9, ror #6
2002669c:	ea87 6779 	eor.w	r7, r7, r9, ror #25
200266a0:	4417      	add	r7, r2
200266a2:	eb04 0807 	add.w	r8, r4, r7
200266a6:	ea4f 3270 	mov.w	r2, r0, ror #13
200266aa:	ea41 0400 	orr.w	r4, r1, r0
200266ae:	ea82 02b0 	eor.w	r2, r2, r0, ror #2
200266b2:	401c      	ands	r4, r3
200266b4:	ea44 040e 	orr.w	r4, r4, lr
200266b8:	ea82 52b0 	eor.w	r2, r2, r0, ror #22
200266bc:	4422      	add	r2, r4
200266be:	ea4f 44f5 	mov.w	r4, r5, ror #19
200266c2:	ea84 4475 	eor.w	r4, r4, r5, ror #17
200266c6:	ea84 2495 	eor.w	r4, r4, r5, lsr #10
200266ca:	f8da 5018 	ldr.w	r5, [sl, #24]
200266ce:	f85a ec08 	ldr.w	lr, [sl, #-8]
200266d2:	4465      	add	r5, ip
200266d4:	4425      	add	r5, r4
200266d6:	ea4f 44be 	mov.w	r4, lr, ror #18
200266da:	ea84 14fe 	eor.w	r4, r4, lr, ror #7
200266de:	ea84 04de 	eor.w	r4, r4, lr, lsr #3
200266e2:	4425      	add	r5, r4
200266e4:	9c02      	ldr	r4, [sp, #8]
200266e6:	443a      	add	r2, r7
200266e8:	ea84 0709 	eor.w	r7, r4, r9
200266ec:	ea07 0708 	and.w	r7, r7, r8
200266f0:	ea87 0c04 	eor.w	ip, r7, r4
200266f4:	9c00      	ldr	r4, [sp, #0]
200266f6:	9f01      	ldr	r7, [sp, #4]
200266f8:	6d64      	ldr	r4, [r4, #84]	@ 0x54
200266fa:	ea00 0b02 	and.w	fp, r0, r2
200266fe:	442c      	add	r4, r5
20026700:	443c      	add	r4, r7
20026702:	eb0c 0704 	add.w	r7, ip, r4
20026706:	ea4f 24f8 	mov.w	r4, r8, ror #11
2002670a:	ea84 14b8 	eor.w	r4, r4, r8, ror #6
2002670e:	ea84 6478 	eor.w	r4, r4, r8, ror #25
20026712:	443c      	add	r4, r7
20026714:	191f      	adds	r7, r3, r4
20026716:	ea40 0c02 	orr.w	ip, r0, r2
2002671a:	ea4f 3372 	mov.w	r3, r2, ror #13
2002671e:	ea0c 0c01 	and.w	ip, ip, r1
20026722:	ea83 03b2 	eor.w	r3, r3, r2, ror #2
20026726:	ea4c 0c0b 	orr.w	ip, ip, fp
2002672a:	ea83 53b2 	eor.w	r3, r3, r2, ror #22
2002672e:	4463      	add	r3, ip
20026730:	4423      	add	r3, r4
20026732:	ea4f 44f6 	mov.w	r4, r6, ror #19
20026736:	ea84 4476 	eor.w	r4, r4, r6, ror #17
2002673a:	ea84 2496 	eor.w	r4, r4, r6, lsr #10
2002673e:	f8da 601c 	ldr.w	r6, [sl, #28]
20026742:	f85a cc04 	ldr.w	ip, [sl, #-4]
20026746:	4476      	add	r6, lr
20026748:	4426      	add	r6, r4
2002674a:	ea4f 44bc 	mov.w	r4, ip, ror #18
2002674e:	ea84 14fc 	eor.w	r4, r4, ip, ror #7
20026752:	ea84 04dc 	eor.w	r4, r4, ip, lsr #3
20026756:	eb06 0b04 	add.w	fp, r6, r4
2002675a:	9c00      	ldr	r4, [sp, #0]
2002675c:	9e02      	ldr	r6, [sp, #8]
2002675e:	6da4      	ldr	r4, [r4, #88]	@ 0x58
20026760:	ea89 0e08 	eor.w	lr, r9, r8
20026764:	445c      	add	r4, fp
20026766:	4434      	add	r4, r6
20026768:	ea0e 0e07 	and.w	lr, lr, r7
2002676c:	ea4f 26f7 	mov.w	r6, r7, ror #11
20026770:	ea8e 0e09 	eor.w	lr, lr, r9
20026774:	ea86 16b7 	eor.w	r6, r6, r7, ror #6
20026778:	4474      	add	r4, lr
2002677a:	ea86 6677 	eor.w	r6, r6, r7, ror #25
2002677e:	4434      	add	r4, r6
20026780:	eb01 0e04 	add.w	lr, r1, r4
20026784:	ea42 0603 	orr.w	r6, r2, r3
20026788:	ea4f 3173 	mov.w	r1, r3, ror #13
2002678c:	f8ca b038 	str.w	fp, [sl, #56]	@ 0x38
20026790:	4006      	ands	r6, r0
20026792:	ea02 0b03 	and.w	fp, r2, r3
20026796:	ea81 01b3 	eor.w	r1, r1, r3, ror #2
2002679a:	ea46 060b 	orr.w	r6, r6, fp
2002679e:	ea81 51b3 	eor.w	r1, r1, r3, ror #22
200267a2:	4431      	add	r1, r6
200267a4:	190e      	adds	r6, r1, r4
200267a6:	ea4f 41f5 	mov.w	r1, r5, ror #19
200267aa:	ea81 4175 	eor.w	r1, r1, r5, ror #17
200267ae:	f8ca 5034 	str.w	r5, [sl, #52]	@ 0x34
200267b2:	ea81 2195 	eor.w	r1, r1, r5, lsr #10
200267b6:	9d03      	ldr	r5, [sp, #12]
200267b8:	f8da 4000 	ldr.w	r4, [sl]
200267bc:	4465      	add	r5, ip
200267be:	4429      	add	r1, r5
200267c0:	ea4f 45b4 	mov.w	r5, r4, ror #18
200267c4:	ea85 15f4 	eor.w	r5, r5, r4, ror #7
200267c8:	ea85 05d4 	eor.w	r5, r5, r4, lsr #3
200267cc:	194c      	adds	r4, r1, r5
200267ce:	9900      	ldr	r1, [sp, #0]
200267d0:	ea88 0507 	eor.w	r5, r8, r7
200267d4:	6dc9      	ldr	r1, [r1, #92]	@ 0x5c
200267d6:	ea05 050e 	and.w	r5, r5, lr
200267da:	4421      	add	r1, r4
200267dc:	4449      	add	r1, r9
200267de:	ea85 0508 	eor.w	r5, r5, r8
200267e2:	440d      	add	r5, r1
200267e4:	ea4f 21fe 	mov.w	r1, lr, ror #11
200267e8:	ea81 11be 	eor.w	r1, r1, lr, ror #6
200267ec:	ea81 617e 	eor.w	r1, r1, lr, ror #25
200267f0:	4429      	add	r1, r5
200267f2:	f8ca 403c 	str.w	r4, [sl, #60]	@ 0x3c
200267f6:	eb00 0b01 	add.w	fp, r0, r1
200267fa:	ea43 0406 	orr.w	r4, r3, r6
200267fe:	ea4f 3076 	mov.w	r0, r6, ror #13
20026802:	ea80 00b6 	eor.w	r0, r0, r6, ror #2
20026806:	4014      	ands	r4, r2
20026808:	ea03 0506 	and.w	r5, r3, r6
2002680c:	ea80 50b6 	eor.w	r0, r0, r6, ror #22
20026810:	432c      	orrs	r4, r5
20026812:	4420      	add	r0, r4
20026814:	eb00 0901 	add.w	r9, r0, r1
20026818:	9900      	ldr	r1, [sp, #0]
2002681a:	3120      	adds	r1, #32
2002681c:	9100      	str	r1, [sp, #0]
2002681e:	9905      	ldr	r1, [sp, #20]
20026820:	4551      	cmp	r1, sl
20026822:	f47f ae25 	bne.w	20026470 <mbedtls_sha256_process+0x2b4>
20026826:	9308      	str	r3, [sp, #32]
20026828:	9b04      	ldr	r3, [sp, #16]
2002682a:	a906      	add	r1, sp, #24
2002682c:	60ca      	str	r2, [r1, #12]
2002682e:	f8c1 801c 	str.w	r8, [r1, #28]
20026832:	1d1a      	adds	r2, r3, #4
20026834:	618f      	str	r7, [r1, #24]
20026836:	3324      	adds	r3, #36	@ 0x24
20026838:	f8c1 e014 	str.w	lr, [r1, #20]
2002683c:	604e      	str	r6, [r1, #4]
2002683e:	f8c1 b010 	str.w	fp, [r1, #16]
20026842:	f8c1 9000 	str.w	r9, [r1]
20026846:	f852 0f04 	ldr.w	r0, [r2, #4]!
2002684a:	f851 4b04 	ldr.w	r4, [r1], #4
2002684e:	4293      	cmp	r3, r2
20026850:	4420      	add	r0, r4
20026852:	6010      	str	r0, [r2, #0]
20026854:	d1f7      	bne.n	20026846 <mbedtls_sha256_process+0x68a>
20026856:	b04f      	add	sp, #316	@ 0x13c
20026858:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}

2002685c <mbedtls_sha256_update.part.0>:
2002685c:	e92d 43f8 	stmdb	sp!, {r3, r4, r5, r6, r7, r8, r9, lr}
20026860:	6803      	ldr	r3, [r0, #0]
20026862:	4605      	mov	r5, r0
20026864:	f003 073f 	and.w	r7, r3, #63	@ 0x3f
20026868:	189b      	adds	r3, r3, r2
2002686a:	6003      	str	r3, [r0, #0]
2002686c:	bf28      	it	cs
2002686e:	6843      	ldrcs	r3, [r0, #4]
20026870:	460e      	mov	r6, r1
20026872:	bf28      	it	cs
20026874:	3301      	addcs	r3, #1
20026876:	4614      	mov	r4, r2
20026878:	bf28      	it	cs
2002687a:	6043      	strcs	r3, [r0, #4]
2002687c:	b197      	cbz	r7, 200268a4 <mbedtls_sha256_update.part.0+0x48>
2002687e:	f1c7 0940 	rsb	r9, r7, #64	@ 0x40
20026882:	4591      	cmp	r9, r2
20026884:	d80e      	bhi.n	200268a4 <mbedtls_sha256_update.part.0+0x48>
20026886:	f100 0828 	add.w	r8, r0, #40	@ 0x28
2002688a:	464a      	mov	r2, r9
2002688c:	eb08 0007 	add.w	r0, r8, r7
20026890:	f004 f8fa 	bl	2002aa88 <memcpy>
20026894:	3c40      	subs	r4, #64	@ 0x40
20026896:	4641      	mov	r1, r8
20026898:	4628      	mov	r0, r5
2002689a:	443c      	add	r4, r7
2002689c:	f7ff fc8e 	bl	200261bc <mbedtls_sha256_process>
200268a0:	2700      	movs	r7, #0
200268a2:	444e      	add	r6, r9
200268a4:	46a0      	mov	r8, r4
200268a6:	eb04 0906 	add.w	r9, r4, r6
200268aa:	e004      	b.n	200268b6 <mbedtls_sha256_update.part.0+0x5a>
200268ac:	4628      	mov	r0, r5
200268ae:	f7ff fc85 	bl	200261bc <mbedtls_sha256_process>
200268b2:	f1a8 0840 	sub.w	r8, r8, #64	@ 0x40
200268b6:	f1b8 0f3f 	cmp.w	r8, #63	@ 0x3f
200268ba:	eba9 0108 	sub.w	r1, r9, r8
200268be:	d8f5      	bhi.n	200268ac <mbedtls_sha256_update.part.0+0x50>
200268c0:	f06f 033f 	mvn.w	r3, #63	@ 0x3f
200268c4:	09a1      	lsrs	r1, r4, #6
200268c6:	4359      	muls	r1, r3
200268c8:	1862      	adds	r2, r4, r1
200268ca:	d007      	beq.n	200268dc <mbedtls_sha256_update.part.0+0x80>
200268cc:	f105 0028 	add.w	r0, r5, #40	@ 0x28
200268d0:	1a71      	subs	r1, r6, r1
200268d2:	4438      	add	r0, r7
200268d4:	e8bd 43f8 	ldmia.w	sp!, {r3, r4, r5, r6, r7, r8, r9, lr}
200268d8:	f004 b8d6 	b.w	2002aa88 <memcpy>
200268dc:	e8bd 83f8 	ldmia.w	sp!, {r3, r4, r5, r6, r7, r8, r9, pc}

200268e0 <mbedtls_sha256_update>:
200268e0:	b10a      	cbz	r2, 200268e6 <mbedtls_sha256_update+0x6>
200268e2:	f7ff bfbb 	b.w	2002685c <mbedtls_sha256_update.part.0>
200268e6:	4770      	bx	lr

200268e8 <mbedtls_sha256_finish>:
200268e8:	b537      	push	{r0, r1, r2, r4, r5, lr}
200268ea:	4604      	mov	r4, r0
200268ec:	460d      	mov	r5, r1
200268ee:	e9d0 2100 	ldrd	r2, r1, [r0]
200268f2:	0f53      	lsrs	r3, r2, #29
200268f4:	ea43 03c1 	orr.w	r3, r3, r1, lsl #3
200268f8:	ba1b      	rev	r3, r3
200268fa:	9300      	str	r3, [sp, #0]
200268fc:	00d3      	lsls	r3, r2, #3
200268fe:	f002 023f 	and.w	r2, r2, #63	@ 0x3f
20026902:	2a37      	cmp	r2, #55	@ 0x37
20026904:	ba1b      	rev	r3, r3
20026906:	bf94      	ite	ls
20026908:	f1c2 0238 	rsbls	r2, r2, #56	@ 0x38
2002690c:	f1c2 0278 	rsbhi	r2, r2, #120	@ 0x78
20026910:	492b      	ldr	r1, [pc, #172]	@ (200269c0 <mbedtls_sha256_finish+0xd8>)
20026912:	9301      	str	r3, [sp, #4]
20026914:	f7ff ffe4 	bl	200268e0 <mbedtls_sha256_update>
20026918:	2208      	movs	r2, #8
2002691a:	4669      	mov	r1, sp
2002691c:	4620      	mov	r0, r4
2002691e:	f7ff ff9d 	bl	2002685c <mbedtls_sha256_update.part.0>
20026922:	7ae3      	ldrb	r3, [r4, #11]
20026924:	702b      	strb	r3, [r5, #0]
20026926:	8963      	ldrh	r3, [r4, #10]
20026928:	706b      	strb	r3, [r5, #1]
2002692a:	68a3      	ldr	r3, [r4, #8]
2002692c:	0a1b      	lsrs	r3, r3, #8
2002692e:	70ab      	strb	r3, [r5, #2]
20026930:	68a3      	ldr	r3, [r4, #8]
20026932:	70eb      	strb	r3, [r5, #3]
20026934:	7be3      	ldrb	r3, [r4, #15]
20026936:	712b      	strb	r3, [r5, #4]
20026938:	89e3      	ldrh	r3, [r4, #14]
2002693a:	716b      	strb	r3, [r5, #5]
2002693c:	68e3      	ldr	r3, [r4, #12]
2002693e:	0a1b      	lsrs	r3, r3, #8
20026940:	71ab      	strb	r3, [r5, #6]
20026942:	68e3      	ldr	r3, [r4, #12]
20026944:	71eb      	strb	r3, [r5, #7]
20026946:	7ce3      	ldrb	r3, [r4, #19]
20026948:	722b      	strb	r3, [r5, #8]
2002694a:	8a63      	ldrh	r3, [r4, #18]
2002694c:	726b      	strb	r3, [r5, #9]
2002694e:	6923      	ldr	r3, [r4, #16]
20026950:	0a1b      	lsrs	r3, r3, #8
20026952:	72ab      	strb	r3, [r5, #10]
20026954:	6923      	ldr	r3, [r4, #16]
20026956:	72eb      	strb	r3, [r5, #11]
20026958:	7de3      	ldrb	r3, [r4, #23]
2002695a:	732b      	strb	r3, [r5, #12]
2002695c:	8ae3      	ldrh	r3, [r4, #22]
2002695e:	736b      	strb	r3, [r5, #13]
20026960:	6963      	ldr	r3, [r4, #20]
20026962:	0a1b      	lsrs	r3, r3, #8
20026964:	73ab      	strb	r3, [r5, #14]
20026966:	6963      	ldr	r3, [r4, #20]
20026968:	73eb      	strb	r3, [r5, #15]
2002696a:	7ee3      	ldrb	r3, [r4, #27]
2002696c:	742b      	strb	r3, [r5, #16]
2002696e:	8b63      	ldrh	r3, [r4, #26]
20026970:	746b      	strb	r3, [r5, #17]
20026972:	69a3      	ldr	r3, [r4, #24]
20026974:	0a1b      	lsrs	r3, r3, #8
20026976:	74ab      	strb	r3, [r5, #18]
20026978:	69a3      	ldr	r3, [r4, #24]
2002697a:	74eb      	strb	r3, [r5, #19]
2002697c:	7fe3      	ldrb	r3, [r4, #31]
2002697e:	752b      	strb	r3, [r5, #20]
20026980:	8be3      	ldrh	r3, [r4, #30]
20026982:	756b      	strb	r3, [r5, #21]
20026984:	69e3      	ldr	r3, [r4, #28]
20026986:	0a1b      	lsrs	r3, r3, #8
20026988:	75ab      	strb	r3, [r5, #22]
2002698a:	69e3      	ldr	r3, [r4, #28]
2002698c:	75eb      	strb	r3, [r5, #23]
2002698e:	f894 3023 	ldrb.w	r3, [r4, #35]	@ 0x23
20026992:	762b      	strb	r3, [r5, #24]
20026994:	8c63      	ldrh	r3, [r4, #34]	@ 0x22
20026996:	766b      	strb	r3, [r5, #25]
20026998:	6a23      	ldr	r3, [r4, #32]
2002699a:	0a1b      	lsrs	r3, r3, #8
2002699c:	76ab      	strb	r3, [r5, #26]
2002699e:	6a23      	ldr	r3, [r4, #32]
200269a0:	76eb      	strb	r3, [r5, #27]
200269a2:	6ea3      	ldr	r3, [r4, #104]	@ 0x68
200269a4:	b94b      	cbnz	r3, 200269ba <mbedtls_sha256_finish+0xd2>
200269a6:	f894 3027 	ldrb.w	r3, [r4, #39]	@ 0x27
200269aa:	772b      	strb	r3, [r5, #28]
200269ac:	8ce3      	ldrh	r3, [r4, #38]	@ 0x26
200269ae:	776b      	strb	r3, [r5, #29]
200269b0:	6a63      	ldr	r3, [r4, #36]	@ 0x24
200269b2:	0a1b      	lsrs	r3, r3, #8
200269b4:	77ab      	strb	r3, [r5, #30]
200269b6:	6a63      	ldr	r3, [r4, #36]	@ 0x24
200269b8:	77eb      	strb	r3, [r5, #31]
200269ba:	b003      	add	sp, #12
200269bc:	bd30      	pop	{r4, r5, pc}
200269be:	bf00      	nop
200269c0:	2002bf7c 	.word	0x2002bf7c

200269c4 <mbedtls_sha256>:
200269c4:	e92d 47f0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, lr}
200269c8:	461d      	mov	r5, r3
200269ca:	b09c      	sub	sp, #112	@ 0x70
200269cc:	4607      	mov	r7, r0
200269ce:	a801      	add	r0, sp, #4
200269d0:	4688      	mov	r8, r1
200269d2:	4616      	mov	r6, r2
200269d4:	f7ff fb97 	bl	20026106 <mbedtls_sha256_init>
200269d8:	b355      	cbz	r5, 20026a30 <mbedtls_sha256+0x6c>
200269da:	f8df a090 	ldr.w	sl, [pc, #144]	@ 20026a6c <mbedtls_sha256+0xa8>
200269de:	f8df 9090 	ldr.w	r9, [pc, #144]	@ 20026a70 <mbedtls_sha256+0xac>
200269e2:	f8df e090 	ldr.w	lr, [pc, #144]	@ 20026a74 <mbedtls_sha256+0xb0>
200269e6:	f8df c090 	ldr.w	ip, [pc, #144]	@ 20026a78 <mbedtls_sha256+0xb4>
200269ea:	4818      	ldr	r0, [pc, #96]	@ (20026a4c <mbedtls_sha256+0x88>)
200269ec:	4918      	ldr	r1, [pc, #96]	@ (20026a50 <mbedtls_sha256+0x8c>)
200269ee:	4a19      	ldr	r2, [pc, #100]	@ (20026a54 <mbedtls_sha256+0x90>)
200269f0:	4b19      	ldr	r3, [pc, #100]	@ (20026a58 <mbedtls_sha256+0x94>)
200269f2:	2400      	movs	r4, #0
200269f4:	e9cd 2309 	strd	r2, r3, [sp, #36]	@ 0x24
200269f8:	e9cd 0107 	strd	r0, r1, [sp, #28]
200269fc:	4642      	mov	r2, r8
200269fe:	4639      	mov	r1, r7
20026a00:	a801      	add	r0, sp, #4
20026a02:	e9cd ec05 	strd	lr, ip, [sp, #20]
20026a06:	e9cd 4401 	strd	r4, r4, [sp, #4]
20026a0a:	e9cd a903 	strd	sl, r9, [sp, #12]
20026a0e:	951b      	str	r5, [sp, #108]	@ 0x6c
20026a10:	f7ff ff66 	bl	200268e0 <mbedtls_sha256_update>
20026a14:	4631      	mov	r1, r6
20026a16:	a801      	add	r0, sp, #4
20026a18:	f7ff ff66 	bl	200268e8 <mbedtls_sha256_finish>
20026a1c:	4623      	mov	r3, r4
20026a1e:	4622      	mov	r2, r4
20026a20:	a901      	add	r1, sp, #4
20026a22:	54ca      	strb	r2, [r1, r3]
20026a24:	3301      	adds	r3, #1
20026a26:	2b6c      	cmp	r3, #108	@ 0x6c
20026a28:	d1fa      	bne.n	20026a20 <mbedtls_sha256+0x5c>
20026a2a:	b01c      	add	sp, #112	@ 0x70
20026a2c:	e8bd 87f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, pc}
20026a30:	f8df a048 	ldr.w	sl, [pc, #72]	@ 20026a7c <mbedtls_sha256+0xb8>
20026a34:	f8df 9048 	ldr.w	r9, [pc, #72]	@ 20026a80 <mbedtls_sha256+0xbc>
20026a38:	f8df e048 	ldr.w	lr, [pc, #72]	@ 20026a84 <mbedtls_sha256+0xc0>
20026a3c:	f8df c048 	ldr.w	ip, [pc, #72]	@ 20026a88 <mbedtls_sha256+0xc4>
20026a40:	4806      	ldr	r0, [pc, #24]	@ (20026a5c <mbedtls_sha256+0x98>)
20026a42:	4907      	ldr	r1, [pc, #28]	@ (20026a60 <mbedtls_sha256+0x9c>)
20026a44:	4a07      	ldr	r2, [pc, #28]	@ (20026a64 <mbedtls_sha256+0xa0>)
20026a46:	4b08      	ldr	r3, [pc, #32]	@ (20026a68 <mbedtls_sha256+0xa4>)
20026a48:	e7d3      	b.n	200269f2 <mbedtls_sha256+0x2e>
20026a4a:	bf00      	nop
20026a4c:	ffc00b31 	.word	0xffc00b31
20026a50:	68581511 	.word	0x68581511
20026a54:	64f98fa7 	.word	0x64f98fa7
20026a58:	befa4fa4 	.word	0xbefa4fa4
20026a5c:	510e527f 	.word	0x510e527f
20026a60:	9b05688c 	.word	0x9b05688c
20026a64:	1f83d9ab 	.word	0x1f83d9ab
20026a68:	5be0cd19 	.word	0x5be0cd19
20026a6c:	c1059ed8 	.word	0xc1059ed8
20026a70:	367cd507 	.word	0x367cd507
20026a74:	3070dd17 	.word	0x3070dd17
20026a78:	f70e5939 	.word	0xf70e5939
20026a7c:	6a09e667 	.word	0x6a09e667
20026a80:	bb67ae85 	.word	0xbb67ae85
20026a84:	3c6ef372 	.word	0x3c6ef372
20026a88:	a54ff53a 	.word	0xa54ff53a

20026a8c <mbedtls_sha512_init>:
20026a8c:	22d8      	movs	r2, #216	@ 0xd8
20026a8e:	2100      	movs	r1, #0
20026a90:	f003 bfe0 	b.w	2002aa54 <memset>

20026a94 <mbedtls_sha512_free>:
20026a94:	b138      	cbz	r0, 20026aa6 <mbedtls_sha512_free+0x12>
20026a96:	2100      	movs	r1, #0
20026a98:	f100 03d8 	add.w	r3, r0, #216	@ 0xd8
20026a9c:	4602      	mov	r2, r0
20026a9e:	3001      	adds	r0, #1
20026aa0:	4298      	cmp	r0, r3
20026aa2:	7011      	strb	r1, [r2, #0]
20026aa4:	d1fa      	bne.n	20026a9c <mbedtls_sha512_free+0x8>
20026aa6:	4770      	bx	lr

20026aa8 <mbedtls_sha512_clone>:
20026aa8:	b508      	push	{r3, lr}
20026aaa:	22d8      	movs	r2, #216	@ 0xd8
20026aac:	f003 ffec 	bl	2002aa88 <memcpy>
20026ab0:	bd08      	pop	{r3, pc}
20026ab2:	0000      	movs	r0, r0
20026ab4:	0000      	movs	r0, r0
	...

20026ab8 <mbedtls_sha512_starts>:
20026ab8:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
20026abc:	b381      	cbz	r1, 20026b20 <mbedtls_sha512_starts+0x68>
20026abe:	f20f 0bc8 	addw	fp, pc, #200	@ 0xc8
20026ac2:	e9db ab00 	ldrd	sl, fp, [fp]
20026ac6:	f20f 09c8 	addw	r9, pc, #200	@ 0xc8
20026aca:	e9d9 8900 	ldrd	r8, r9, [r9]
20026ace:	a732      	add	r7, pc, #200	@ (adr r7, 20026b98 <mbedtls_sha512_starts+0xe0>)
20026ad0:	e9d7 6700 	ldrd	r6, r7, [r7]
20026ad4:	a532      	add	r5, pc, #200	@ (adr r5, 20026ba0 <mbedtls_sha512_starts+0xe8>)
20026ad6:	e9d5 4500 	ldrd	r4, r5, [r5]
20026ada:	a333      	add	r3, pc, #204	@ (adr r3, 20026ba8 <mbedtls_sha512_starts+0xf0>)
20026adc:	e9d3 2300 	ldrd	r2, r3, [r3]
20026ae0:	ed9f 5b1b 	vldr	d5, [pc, #108]	@ 20026b50 <mbedtls_sha512_starts+0x98>
20026ae4:	ed9f 6b1c 	vldr	d6, [pc, #112]	@ 20026b58 <mbedtls_sha512_starts+0xa0>
20026ae8:	ed9f 7b1d 	vldr	d7, [pc, #116]	@ 20026b60 <mbedtls_sha512_starts+0xa8>
20026aec:	ed9f 4b1e 	vldr	d4, [pc, #120]	@ 20026b68 <mbedtls_sha512_starts+0xb0>
20026af0:	ed80 5b04 	vstr	d5, [r0, #16]
20026af4:	ed80 4b00 	vstr	d4, [r0]
20026af8:	ed80 4b02 	vstr	d4, [r0, #8]
20026afc:	ed80 6b06 	vstr	d6, [r0, #24]
20026b00:	ed80 7b08 	vstr	d7, [r0, #32]
20026b04:	e9c0 ab0a 	strd	sl, fp, [r0, #40]	@ 0x28
20026b08:	e9c0 890c 	strd	r8, r9, [r0, #48]	@ 0x30
20026b0c:	e9c0 670e 	strd	r6, r7, [r0, #56]	@ 0x38
20026b10:	e9c0 4510 	strd	r4, r5, [r0, #64]	@ 0x40
20026b14:	e9c0 2312 	strd	r2, r3, [r0, #72]	@ 0x48
20026b18:	f8c0 10d0 	str.w	r1, [r0, #208]	@ 0xd0
20026b1c:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
20026b20:	ed9f 5b13 	vldr	d5, [pc, #76]	@ 20026b70 <mbedtls_sha512_starts+0xb8>
20026b24:	f20f 0b88 	addw	fp, pc, #136	@ 0x88
20026b28:	e9db ab00 	ldrd	sl, fp, [fp]
20026b2c:	f20f 0988 	addw	r9, pc, #136	@ 0x88
20026b30:	e9d9 8900 	ldrd	r8, r9, [r9]
20026b34:	a722      	add	r7, pc, #136	@ (adr r7, 20026bc0 <mbedtls_sha512_starts+0x108>)
20026b36:	e9d7 6700 	ldrd	r6, r7, [r7]
20026b3a:	a523      	add	r5, pc, #140	@ (adr r5, 20026bc8 <mbedtls_sha512_starts+0x110>)
20026b3c:	e9d5 4500 	ldrd	r4, r5, [r5]
20026b40:	a323      	add	r3, pc, #140	@ (adr r3, 20026bd0 <mbedtls_sha512_starts+0x118>)
20026b42:	e9d3 2300 	ldrd	r2, r3, [r3]
20026b46:	ed9f 6b0c 	vldr	d6, [pc, #48]	@ 20026b78 <mbedtls_sha512_starts+0xc0>
20026b4a:	ed9f 7b0d 	vldr	d7, [pc, #52]	@ 20026b80 <mbedtls_sha512_starts+0xc8>
20026b4e:	e7cd      	b.n	20026aec <mbedtls_sha512_starts+0x34>
20026b50:	c1059ed8 	.word	0xc1059ed8
20026b54:	cbbb9d5d 	.word	0xcbbb9d5d
20026b58:	367cd507 	.word	0x367cd507
20026b5c:	629a292a 	.word	0x629a292a
20026b60:	3070dd17 	.word	0x3070dd17
20026b64:	9159015a 	.word	0x9159015a
	...
20026b70:	f3bcc908 	.word	0xf3bcc908
20026b74:	6a09e667 	.word	0x6a09e667
20026b78:	84caa73b 	.word	0x84caa73b
20026b7c:	bb67ae85 	.word	0xbb67ae85
20026b80:	fe94f82b 	.word	0xfe94f82b
20026b84:	3c6ef372 	.word	0x3c6ef372
20026b88:	f70e5939 	.word	0xf70e5939
20026b8c:	152fecd8 	.word	0x152fecd8
20026b90:	ffc00b31 	.word	0xffc00b31
20026b94:	67332667 	.word	0x67332667
20026b98:	68581511 	.word	0x68581511
20026b9c:	8eb44a87 	.word	0x8eb44a87
20026ba0:	64f98fa7 	.word	0x64f98fa7
20026ba4:	db0c2e0d 	.word	0xdb0c2e0d
20026ba8:	befa4fa4 	.word	0xbefa4fa4
20026bac:	47b5481d 	.word	0x47b5481d
20026bb0:	5f1d36f1 	.word	0x5f1d36f1
20026bb4:	a54ff53a 	.word	0xa54ff53a
20026bb8:	ade682d1 	.word	0xade682d1
20026bbc:	510e527f 	.word	0x510e527f
20026bc0:	2b3e6c1f 	.word	0x2b3e6c1f
20026bc4:	9b05688c 	.word	0x9b05688c
20026bc8:	fb41bd6b 	.word	0xfb41bd6b
20026bcc:	1f83d9ab 	.word	0x1f83d9ab
20026bd0:	137e2179 	.word	0x137e2179
20026bd4:	5be0cd19 	.word	0x5be0cd19

20026bd8 <mbedtls_sha512_process>:
20026bd8:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
20026bdc:	f5ad 7d3f 	sub.w	sp, sp, #764	@ 0x2fc
20026be0:	4682      	mov	sl, r0
20026be2:	a81e      	add	r0, sp, #120	@ 0x78
20026be4:	4604      	mov	r4, r0
20026be6:	f101 0580 	add.w	r5, r1, #128	@ 0x80
20026bea:	784b      	ldrb	r3, [r1, #1]
20026bec:	780a      	ldrb	r2, [r1, #0]
20026bee:	041b      	lsls	r3, r3, #16
20026bf0:	790f      	ldrb	r7, [r1, #4]
20026bf2:	ea43 6302 	orr.w	r3, r3, r2, lsl #24
20026bf6:	79ca      	ldrb	r2, [r1, #7]
20026bf8:	788e      	ldrb	r6, [r1, #2]
20026bfa:	ea42 6207 	orr.w	r2, r2, r7, lsl #24
20026bfe:	794f      	ldrb	r7, [r1, #5]
20026c00:	ea43 2306 	orr.w	r3, r3, r6, lsl #8
20026c04:	ea42 4207 	orr.w	r2, r2, r7, lsl #16
20026c08:	78ce      	ldrb	r6, [r1, #3]
20026c0a:	798f      	ldrb	r7, [r1, #6]
20026c0c:	3108      	adds	r1, #8
20026c0e:	ea42 2207 	orr.w	r2, r2, r7, lsl #8
20026c12:	4333      	orrs	r3, r6
20026c14:	428d      	cmp	r5, r1
20026c16:	e9c4 2300 	strd	r2, r3, [r4]
20026c1a:	f104 0408 	add.w	r4, r4, #8
20026c1e:	d1e4      	bne.n	20026bea <mbedtls_sha512_process+0x12>
20026c20:	4601      	mov	r1, r0
20026c22:	2610      	movs	r6, #16
20026c24:	e9d1 4c1c 	ldrd	r4, ip, [r1, #112]	@ 0x70
20026c28:	e9d1 2502 	ldrd	r2, r5, [r1, #8]
20026c2c:	468e      	mov	lr, r1
20026c2e:	0ce3      	lsrs	r3, r4, #19
20026c30:	ea4f 47dc 	mov.w	r7, ip, lsr #19
20026c34:	ea4f 09c4 	mov.w	r9, r4, lsl #3
20026c38:	ea4f 08cc 	mov.w	r8, ip, lsl #3
20026c3c:	ea48 7854 	orr.w	r8, r8, r4, lsr #29
20026c40:	ea43 334c 	orr.w	r3, r3, ip, lsl #13
20026c44:	ea47 3744 	orr.w	r7, r7, r4, lsl #13
20026c48:	ea49 795c 	orr.w	r9, r9, ip, lsr #29
20026c4c:	09a4      	lsrs	r4, r4, #6
20026c4e:	ea87 0708 	eor.w	r7, r7, r8
20026c52:	ea44 648c 	orr.w	r4, r4, ip, lsl #26
20026c56:	ea83 0309 	eor.w	r3, r3, r9
20026c5a:	4063      	eors	r3, r4
20026c5c:	ea87 179c 	eor.w	r7, r7, ip, lsr #6
20026c60:	e9de 4c12 	ldrd	r4, ip, [lr, #72]	@ 0x48
20026c64:	e9de 8e00 	ldrd	r8, lr, [lr]
20026c68:	eb14 0408 	adds.w	r4, r4, r8
20026c6c:	eb4c 0c0e 	adc.w	ip, ip, lr
20026c70:	191b      	adds	r3, r3, r4
20026c72:	eb47 070c 	adc.w	r7, r7, ip
20026c76:	0854      	lsrs	r4, r2, #1
20026c78:	ea4f 2812 	mov.w	r8, r2, lsr #8
20026c7c:	ea4f 0c55 	mov.w	ip, r5, lsr #1
20026c80:	ea4f 2e15 	mov.w	lr, r5, lsr #8
20026c84:	ea4c 7cc2 	orr.w	ip, ip, r2, lsl #31
20026c88:	ea4e 6e02 	orr.w	lr, lr, r2, lsl #24
20026c8c:	ea44 74c5 	orr.w	r4, r4, r5, lsl #31
20026c90:	ea48 6805 	orr.w	r8, r8, r5, lsl #24
20026c94:	09d2      	lsrs	r2, r2, #7
20026c96:	ea84 0408 	eor.w	r4, r4, r8
20026c9a:	ea42 6245 	orr.w	r2, r2, r5, lsl #25
20026c9e:	4062      	eors	r2, r4
20026ca0:	ea8c 0c0e 	eor.w	ip, ip, lr
20026ca4:	189b      	adds	r3, r3, r2
20026ca6:	ea8c 14d5 	eor.w	r4, ip, r5, lsr #7
20026caa:	f106 0601 	add.w	r6, r6, #1
20026cae:	eb47 0704 	adc.w	r7, r7, r4
20026cb2:	3108      	adds	r1, #8
20026cb4:	2e50      	cmp	r6, #80	@ 0x50
20026cb6:	e9c1 371e 	strd	r3, r7, [r1, #120]	@ 0x78
20026cba:	d1b3      	bne.n	20026c24 <mbedtls_sha512_process+0x4c>
20026cbc:	f8da 3010 	ldr.w	r3, [sl, #16]
20026cc0:	930e      	str	r3, [sp, #56]	@ 0x38
20026cc2:	f8da 3014 	ldr.w	r3, [sl, #20]
20026cc6:	930f      	str	r3, [sp, #60]	@ 0x3c
20026cc8:	f8da 3018 	ldr.w	r3, [sl, #24]
20026ccc:	9310      	str	r3, [sp, #64]	@ 0x40
20026cce:	f8da 301c 	ldr.w	r3, [sl, #28]
20026cd2:	9311      	str	r3, [sp, #68]	@ 0x44
20026cd4:	f8da 3020 	ldr.w	r3, [sl, #32]
20026cd8:	9312      	str	r3, [sp, #72]	@ 0x48
20026cda:	f8da 3024 	ldr.w	r3, [sl, #36]	@ 0x24
20026cde:	9313      	str	r3, [sp, #76]	@ 0x4c
20026ce0:	f8da 3028 	ldr.w	r3, [sl, #40]	@ 0x28
20026ce4:	9314      	str	r3, [sp, #80]	@ 0x50
20026ce6:	f8da 302c 	ldr.w	r3, [sl, #44]	@ 0x2c
20026cea:	9315      	str	r3, [sp, #84]	@ 0x54
20026cec:	f8da 3030 	ldr.w	r3, [sl, #48]	@ 0x30
20026cf0:	9316      	str	r3, [sp, #88]	@ 0x58
20026cf2:	f8da 3034 	ldr.w	r3, [sl, #52]	@ 0x34
20026cf6:	9317      	str	r3, [sp, #92]	@ 0x5c
20026cf8:	f8da 3038 	ldr.w	r3, [sl, #56]	@ 0x38
20026cfc:	9318      	str	r3, [sp, #96]	@ 0x60
20026cfe:	f8da 303c 	ldr.w	r3, [sl, #60]	@ 0x3c
20026d02:	9319      	str	r3, [sp, #100]	@ 0x64
20026d04:	f8da 3040 	ldr.w	r3, [sl, #64]	@ 0x40
20026d08:	931a      	str	r3, [sp, #104]	@ 0x68
20026d0a:	f8da 3044 	ldr.w	r3, [sl, #68]	@ 0x44
20026d0e:	931b      	str	r3, [sp, #108]	@ 0x6c
20026d10:	f8da 3048 	ldr.w	r3, [sl, #72]	@ 0x48
20026d14:	931c      	str	r3, [sp, #112]	@ 0x70
20026d16:	f8da 304c 	ldr.w	r3, [sl, #76]	@ 0x4c
20026d1a:	931d      	str	r3, [sp, #116]	@ 0x74
20026d1c:	4b0f      	ldr	r3, [pc, #60]	@ (20026d5c <mbedtls_sha512_process+0x184>)
20026d1e:	9300      	str	r3, [sp, #0]
20026d20:	9b1c      	ldr	r3, [sp, #112]	@ 0x70
20026d22:	f8dd b054 	ldr.w	fp, [sp, #84]	@ 0x54
20026d26:	930a      	str	r3, [sp, #40]	@ 0x28
20026d28:	9b1d      	ldr	r3, [sp, #116]	@ 0x74
20026d2a:	e9dd ce10 	ldrd	ip, lr, [sp, #64]	@ 0x40
20026d2e:	930b      	str	r3, [sp, #44]	@ 0x2c
20026d30:	9b1a      	ldr	r3, [sp, #104]	@ 0x68
20026d32:	9308      	str	r3, [sp, #32]
20026d34:	9b1b      	ldr	r3, [sp, #108]	@ 0x6c
20026d36:	9309      	str	r3, [sp, #36]	@ 0x24
20026d38:	9b18      	ldr	r3, [sp, #96]	@ 0x60
20026d3a:	9306      	str	r3, [sp, #24]
20026d3c:	9b19      	ldr	r3, [sp, #100]	@ 0x64
20026d3e:	9307      	str	r3, [sp, #28]
20026d40:	9b16      	ldr	r3, [sp, #88]	@ 0x58
20026d42:	9304      	str	r3, [sp, #16]
20026d44:	9b17      	ldr	r3, [sp, #92]	@ 0x5c
20026d46:	9305      	str	r3, [sp, #20]
20026d48:	9b14      	ldr	r3, [sp, #80]	@ 0x50
20026d4a:	9303      	str	r3, [sp, #12]
20026d4c:	9b12      	ldr	r3, [sp, #72]	@ 0x48
20026d4e:	9301      	str	r3, [sp, #4]
20026d50:	9b13      	ldr	r3, [sp, #76]	@ 0x4c
20026d52:	9302      	str	r3, [sp, #8]
20026d54:	e9dd 320e 	ldrd	r3, r2, [sp, #56]	@ 0x38
20026d58:	e002      	b.n	20026d60 <mbedtls_sha512_process+0x188>
20026d5a:	bf00      	nop
20026d5c:	2002c140 	.word	0x2002c140
20026d60:	9c04      	ldr	r4, [sp, #16]
20026d62:	9e04      	ldr	r6, [sp, #16]
20026d64:	ea4f 3894 	mov.w	r8, r4, lsr #14
20026d68:	9c05      	ldr	r4, [sp, #20]
20026d6a:	9900      	ldr	r1, [sp, #0]
20026d6c:	ea48 4884 	orr.w	r8, r8, r4, lsl #18
20026d70:	ea4f 3994 	mov.w	r9, r4, lsr #14
20026d74:	9c04      	ldr	r4, [sp, #16]
20026d76:	ea49 4984 	orr.w	r9, r9, r4, lsl #18
20026d7a:	0ca5      	lsrs	r5, r4, #18
20026d7c:	9c05      	ldr	r4, [sp, #20]
20026d7e:	ea45 3584 	orr.w	r5, r5, r4, lsl #14
20026d82:	0ca4      	lsrs	r4, r4, #18
20026d84:	ea44 3486 	orr.w	r4, r4, r6, lsl #14
20026d88:	ea89 0904 	eor.w	r9, r9, r4
20026d8c:	9c05      	ldr	r4, [sp, #20]
20026d8e:	ea88 0805 	eor.w	r8, r8, r5
20026d92:	05f5      	lsls	r5, r6, #23
20026d94:	ea45 2554 	orr.w	r5, r5, r4, lsr #9
20026d98:	05e4      	lsls	r4, r4, #23
20026d9a:	ea44 2456 	orr.w	r4, r4, r6, lsr #9
20026d9e:	ea88 0805 	eor.w	r8, r8, r5
20026da2:	ea89 0904 	eor.w	r9, r9, r4
20026da6:	e9d1 5700 	ldrd	r5, r7, [r1]
20026daa:	e9d0 6400 	ldrd	r6, r4, [r0]
20026dae:	19ad      	adds	r5, r5, r6
20026db0:	eb47 0404 	adc.w	r4, r7, r4
20026db4:	9e06      	ldr	r6, [sp, #24]
20026db6:	9f08      	ldr	r7, [sp, #32]
20026db8:	9909      	ldr	r1, [sp, #36]	@ 0x24
20026dba:	407e      	eors	r6, r7
20026dbc:	9f07      	ldr	r7, [sp, #28]
20026dbe:	eb18 0505 	adds.w	r5, r8, r5
20026dc2:	ea87 0701 	eor.w	r7, r7, r1
20026dc6:	9904      	ldr	r1, [sp, #16]
20026dc8:	eb49 0404 	adc.w	r4, r9, r4
20026dcc:	400e      	ands	r6, r1
20026dce:	9905      	ldr	r1, [sp, #20]
20026dd0:	ea4f 7813 	mov.w	r8, r3, lsr #28
20026dd4:	400f      	ands	r7, r1
20026dd6:	9908      	ldr	r1, [sp, #32]
20026dd8:	ea4f 7983 	mov.w	r9, r3, lsl #30
20026ddc:	404e      	eors	r6, r1
20026dde:	9909      	ldr	r1, [sp, #36]	@ 0x24
20026de0:	19ad      	adds	r5, r5, r6
20026de2:	ea87 0701 	eor.w	r7, r7, r1
20026de6:	990a      	ldr	r1, [sp, #40]	@ 0x28
20026de8:	eb44 0407 	adc.w	r4, r4, r7
20026dec:	186d      	adds	r5, r5, r1
20026dee:	990b      	ldr	r1, [sp, #44]	@ 0x2c
20026df0:	ea4f 7712 	mov.w	r7, r2, lsr #28
20026df4:	eb41 0404 	adc.w	r4, r1, r4
20026df8:	9903      	ldr	r1, [sp, #12]
20026dfa:	0796      	lsls	r6, r2, #30
20026dfc:	1949      	adds	r1, r1, r5
20026dfe:	ea46 0693 	orr.w	r6, r6, r3, lsr #2
20026e02:	ea47 1703 	orr.w	r7, r7, r3, lsl #4
20026e06:	910a      	str	r1, [sp, #40]	@ 0x28
20026e08:	ea87 0706 	eor.w	r7, r7, r6
20026e0c:	eb4b 0104 	adc.w	r1, fp, r4
20026e10:	0656      	lsls	r6, r2, #25
20026e12:	ea49 0992 	orr.w	r9, r9, r2, lsr #2
20026e16:	ea46 16d3 	orr.w	r6, r6, r3, lsr #7
20026e1a:	910b      	str	r1, [sp, #44]	@ 0x2c
20026e1c:	ea48 1802 	orr.w	r8, r8, r2, lsl #4
20026e20:	9901      	ldr	r1, [sp, #4]
20026e22:	ea88 0809 	eor.w	r8, r8, r9
20026e26:	4077      	eors	r7, r6
20026e28:	ea4f 6943 	mov.w	r9, r3, lsl #25
20026e2c:	ea43 060c 	orr.w	r6, r3, ip
20026e30:	ea49 19d2 	orr.w	r9, r9, r2, lsr #7
20026e34:	400e      	ands	r6, r1
20026e36:	9902      	ldr	r1, [sp, #8]
20026e38:	ea03 0b0c 	and.w	fp, r3, ip
20026e3c:	ea88 0809 	eor.w	r8, r8, r9
20026e40:	ea42 090e 	orr.w	r9, r2, lr
20026e44:	ea09 0901 	and.w	r9, r9, r1
20026e48:	ea46 060b 	orr.w	r6, r6, fp
20026e4c:	ea02 010e 	and.w	r1, r2, lr
20026e50:	eb18 0606 	adds.w	r6, r8, r6
20026e54:	ea49 0901 	orr.w	r9, r9, r1
20026e58:	eb47 0709 	adc.w	r7, r7, r9
20026e5c:	1971      	adds	r1, r6, r5
20026e5e:	9103      	str	r1, [sp, #12]
20026e60:	9900      	ldr	r1, [sp, #0]
20026e62:	eb44 0b07 	adc.w	fp, r4, r7
20026e66:	e9d0 6702 	ldrd	r6, r7, [r0, #8]
20026e6a:	e9d1 4502 	ldrd	r4, r5, [r1, #8]
20026e6e:	9908      	ldr	r1, [sp, #32]
20026e70:	19a4      	adds	r4, r4, r6
20026e72:	eb45 0507 	adc.w	r5, r5, r7
20026e76:	1864      	adds	r4, r4, r1
20026e78:	9909      	ldr	r1, [sp, #36]	@ 0x24
20026e7a:	9e06      	ldr	r6, [sp, #24]
20026e7c:	eb41 0505 	adc.w	r5, r1, r5
20026e80:	9904      	ldr	r1, [sp, #16]
20026e82:	ea81 0706 	eor.w	r7, r1, r6
20026e86:	9905      	ldr	r1, [sp, #20]
20026e88:	9e07      	ldr	r6, [sp, #28]
20026e8a:	404e      	eors	r6, r1
20026e8c:	990a      	ldr	r1, [sp, #40]	@ 0x28
20026e8e:	400f      	ands	r7, r1
20026e90:	990b      	ldr	r1, [sp, #44]	@ 0x2c
20026e92:	400e      	ands	r6, r1
20026e94:	9906      	ldr	r1, [sp, #24]
20026e96:	404f      	eors	r7, r1
20026e98:	9907      	ldr	r1, [sp, #28]
20026e9a:	19e4      	adds	r4, r4, r7
20026e9c:	ea86 0601 	eor.w	r6, r6, r1
20026ea0:	990a      	ldr	r1, [sp, #40]	@ 0x28
20026ea2:	eb45 0506 	adc.w	r5, r5, r6
20026ea6:	0b8f      	lsrs	r7, r1, #14
20026ea8:	990b      	ldr	r1, [sp, #44]	@ 0x2c
20026eaa:	ea47 4781 	orr.w	r7, r7, r1, lsl #18
20026eae:	ea4f 3891 	mov.w	r8, r1, lsr #14
20026eb2:	990a      	ldr	r1, [sp, #40]	@ 0x28
20026eb4:	ea48 4881 	orr.w	r8, r8, r1, lsl #18
20026eb8:	ea4f 4991 	mov.w	r9, r1, lsr #18
20026ebc:	990b      	ldr	r1, [sp, #44]	@ 0x2c
20026ebe:	ea49 3981 	orr.w	r9, r9, r1, lsl #14
20026ec2:	0c8e      	lsrs	r6, r1, #18
20026ec4:	990a      	ldr	r1, [sp, #40]	@ 0x28
20026ec6:	ea87 0709 	eor.w	r7, r7, r9
20026eca:	ea46 3681 	orr.w	r6, r6, r1, lsl #14
20026ece:	ea88 0806 	eor.w	r8, r8, r6
20026ed2:	05ce      	lsls	r6, r1, #23
20026ed4:	990b      	ldr	r1, [sp, #44]	@ 0x2c
20026ed6:	ea46 2651 	orr.w	r6, r6, r1, lsr #9
20026eda:	ea4f 59c1 	mov.w	r9, r1, lsl #23
20026ede:	990a      	ldr	r1, [sp, #40]	@ 0x28
20026ee0:	407e      	eors	r6, r7
20026ee2:	ea49 2951 	orr.w	r9, r9, r1, lsr #9
20026ee6:	9901      	ldr	r1, [sp, #4]
20026ee8:	19a4      	adds	r4, r4, r6
20026eea:	ea88 0809 	eor.w	r8, r8, r9
20026eee:	eb45 0808 	adc.w	r8, r5, r8
20026ef2:	1909      	adds	r1, r1, r4
20026ef4:	9108      	str	r1, [sp, #32]
20026ef6:	9902      	ldr	r1, [sp, #8]
20026ef8:	ea4f 761b 	mov.w	r6, fp, lsr #28
20026efc:	eb41 0108 	adc.w	r1, r1, r8
20026f00:	9109      	str	r1, [sp, #36]	@ 0x24
20026f02:	9903      	ldr	r1, [sp, #12]
20026f04:	ea4f 758b 	mov.w	r5, fp, lsl #30
20026f08:	ea45 0591 	orr.w	r5, r5, r1, lsr #2
20026f0c:	0f0f      	lsrs	r7, r1, #28
20026f0e:	ea46 1601 	orr.w	r6, r6, r1, lsl #4
20026f12:	ea4f 7981 	mov.w	r9, r1, lsl #30
20026f16:	ea49 099b 	orr.w	r9, r9, fp, lsr #2
20026f1a:	ea47 170b 	orr.w	r7, r7, fp, lsl #4
20026f1e:	406e      	eors	r6, r5
20026f20:	ea4f 654b 	mov.w	r5, fp, lsl #25
20026f24:	ea45 15d1 	orr.w	r5, r5, r1, lsr #7
20026f28:	ea87 0709 	eor.w	r7, r7, r9
20026f2c:	ea4f 6941 	mov.w	r9, r1, lsl #25
20026f30:	ea49 19db 	orr.w	r9, r9, fp, lsr #7
20026f34:	406e      	eors	r6, r5
20026f36:	ea43 0501 	orr.w	r5, r3, r1
20026f3a:	ea87 0709 	eor.w	r7, r7, r9
20026f3e:	4019      	ands	r1, r3
20026f40:	ea42 090b 	orr.w	r9, r2, fp
20026f44:	ea05 050c 	and.w	r5, r5, ip
20026f48:	ea09 090e 	and.w	r9, r9, lr
20026f4c:	430d      	orrs	r5, r1
20026f4e:	ea02 010b 	and.w	r1, r2, fp
20026f52:	197d      	adds	r5, r7, r5
20026f54:	ea49 0901 	orr.w	r9, r9, r1
20026f58:	eb46 0609 	adc.w	r6, r6, r9
20026f5c:	1929      	adds	r1, r5, r4
20026f5e:	9101      	str	r1, [sp, #4]
20026f60:	eb48 0106 	adc.w	r1, r8, r6
20026f64:	9102      	str	r1, [sp, #8]
20026f66:	9900      	ldr	r1, [sp, #0]
20026f68:	e9d0 6704 	ldrd	r6, r7, [r0, #16]
20026f6c:	e9d1 4504 	ldrd	r4, r5, [r1, #16]
20026f70:	9906      	ldr	r1, [sp, #24]
20026f72:	19a4      	adds	r4, r4, r6
20026f74:	eb45 0507 	adc.w	r5, r5, r7
20026f78:	1864      	adds	r4, r4, r1
20026f7a:	9907      	ldr	r1, [sp, #28]
20026f7c:	eb41 0505 	adc.w	r5, r1, r5
20026f80:	9904      	ldr	r1, [sp, #16]
20026f82:	9e0a      	ldr	r6, [sp, #40]	@ 0x28
20026f84:	ea81 0706 	eor.w	r7, r1, r6
20026f88:	9905      	ldr	r1, [sp, #20]
20026f8a:	9e0b      	ldr	r6, [sp, #44]	@ 0x2c
20026f8c:	404e      	eors	r6, r1
20026f8e:	9908      	ldr	r1, [sp, #32]
20026f90:	400f      	ands	r7, r1
20026f92:	9909      	ldr	r1, [sp, #36]	@ 0x24
20026f94:	400e      	ands	r6, r1
20026f96:	9904      	ldr	r1, [sp, #16]
20026f98:	404f      	eors	r7, r1
20026f9a:	9905      	ldr	r1, [sp, #20]
20026f9c:	19e4      	adds	r4, r4, r7
20026f9e:	ea86 0601 	eor.w	r6, r6, r1
20026fa2:	9908      	ldr	r1, [sp, #32]
20026fa4:	eb45 0506 	adc.w	r5, r5, r6
20026fa8:	0b8f      	lsrs	r7, r1, #14
20026faa:	9909      	ldr	r1, [sp, #36]	@ 0x24
20026fac:	ea47 4781 	orr.w	r7, r7, r1, lsl #18
20026fb0:	ea4f 3891 	mov.w	r8, r1, lsr #14
20026fb4:	9908      	ldr	r1, [sp, #32]
20026fb6:	ea48 4881 	orr.w	r8, r8, r1, lsl #18
20026fba:	ea4f 4991 	mov.w	r9, r1, lsr #18
20026fbe:	9909      	ldr	r1, [sp, #36]	@ 0x24
20026fc0:	ea49 3981 	orr.w	r9, r9, r1, lsl #14
20026fc4:	0c8e      	lsrs	r6, r1, #18
20026fc6:	9908      	ldr	r1, [sp, #32]
20026fc8:	ea87 0709 	eor.w	r7, r7, r9
20026fcc:	ea46 3681 	orr.w	r6, r6, r1, lsl #14
20026fd0:	ea88 0806 	eor.w	r8, r8, r6
20026fd4:	05ce      	lsls	r6, r1, #23
20026fd6:	9909      	ldr	r1, [sp, #36]	@ 0x24
20026fd8:	ea46 2651 	orr.w	r6, r6, r1, lsr #9
20026fdc:	ea4f 59c1 	mov.w	r9, r1, lsl #23
20026fe0:	9908      	ldr	r1, [sp, #32]
20026fe2:	407e      	eors	r6, r7
20026fe4:	ea49 2951 	orr.w	r9, r9, r1, lsr #9
20026fe8:	19a4      	adds	r4, r4, r6
20026fea:	ea88 0809 	eor.w	r8, r8, r9
20026fee:	eb45 0808 	adc.w	r8, r5, r8
20026ff2:	eb1c 0104 	adds.w	r1, ip, r4
20026ff6:	9106      	str	r1, [sp, #24]
20026ff8:	eb4e 0108 	adc.w	r1, lr, r8
20026ffc:	9107      	str	r1, [sp, #28]
20026ffe:	9901      	ldr	r1, [sp, #4]
20027000:	0f0f      	lsrs	r7, r1, #28
20027002:	9902      	ldr	r1, [sp, #8]
20027004:	ea47 1701 	orr.w	r7, r7, r1, lsl #4
20027008:	0f0e      	lsrs	r6, r1, #28
2002700a:	9901      	ldr	r1, [sp, #4]
2002700c:	ea46 1601 	orr.w	r6, r6, r1, lsl #4
20027010:	ea4f 7c81 	mov.w	ip, r1, lsl #30
20027014:	9902      	ldr	r1, [sp, #8]
20027016:	ea4c 0c91 	orr.w	ip, ip, r1, lsr #2
2002701a:	078d      	lsls	r5, r1, #30
2002701c:	9901      	ldr	r1, [sp, #4]
2002701e:	ea87 070c 	eor.w	r7, r7, ip
20027022:	ea45 0591 	orr.w	r5, r5, r1, lsr #2
20027026:	ea4f 6c41 	mov.w	ip, r1, lsl #25
2002702a:	9902      	ldr	r1, [sp, #8]
2002702c:	406e      	eors	r6, r5
2002702e:	ea4c 1cd1 	orr.w	ip, ip, r1, lsr #7
20027032:	064d      	lsls	r5, r1, #25
20027034:	9901      	ldr	r1, [sp, #4]
20027036:	ea87 070c 	eor.w	r7, r7, ip
2002703a:	ea45 15d1 	orr.w	r5, r5, r1, lsr #7
2002703e:	406e      	eors	r6, r5
20027040:	9903      	ldr	r1, [sp, #12]
20027042:	9d01      	ldr	r5, [sp, #4]
20027044:	430d      	orrs	r5, r1
20027046:	9902      	ldr	r1, [sp, #8]
20027048:	ea4b 0c01 	orr.w	ip, fp, r1
2002704c:	ea05 0103 	and.w	r1, r5, r3
20027050:	910c      	str	r1, [sp, #48]	@ 0x30
20027052:	9d01      	ldr	r5, [sp, #4]
20027054:	9903      	ldr	r1, [sp, #12]
20027056:	ea0c 0c02 	and.w	ip, ip, r2
2002705a:	ea01 0905 	and.w	r9, r1, r5
2002705e:	9902      	ldr	r1, [sp, #8]
20027060:	ea0b 0e01 	and.w	lr, fp, r1
20027064:	990c      	ldr	r1, [sp, #48]	@ 0x30
20027066:	ea4c 0c0e 	orr.w	ip, ip, lr
2002706a:	ea41 0509 	orr.w	r5, r1, r9
2002706e:	9900      	ldr	r1, [sp, #0]
20027070:	197d      	adds	r5, r7, r5
20027072:	eb46 060c 	adc.w	r6, r6, ip
20027076:	eb15 0904 	adds.w	r9, r5, r4
2002707a:	e9d1 4506 	ldrd	r4, r5, [r1, #24]
2002707e:	9904      	ldr	r1, [sp, #16]
20027080:	eb48 0806 	adc.w	r8, r8, r6
20027084:	e9d0 6706 	ldrd	r6, r7, [r0, #24]
20027088:	19a4      	adds	r4, r4, r6
2002708a:	eb45 0507 	adc.w	r5, r5, r7
2002708e:	1864      	adds	r4, r4, r1
20027090:	9905      	ldr	r1, [sp, #20]
20027092:	9e08      	ldr	r6, [sp, #32]
20027094:	eb41 0505 	adc.w	r5, r1, r5
20027098:	990a      	ldr	r1, [sp, #40]	@ 0x28
2002709a:	ea81 0706 	eor.w	r7, r1, r6
2002709e:	990b      	ldr	r1, [sp, #44]	@ 0x2c
200270a0:	9e09      	ldr	r6, [sp, #36]	@ 0x24
200270a2:	404e      	eors	r6, r1
200270a4:	9906      	ldr	r1, [sp, #24]
200270a6:	400f      	ands	r7, r1
200270a8:	9907      	ldr	r1, [sp, #28]
200270aa:	400e      	ands	r6, r1
200270ac:	990a      	ldr	r1, [sp, #40]	@ 0x28
200270ae:	404f      	eors	r7, r1
200270b0:	990b      	ldr	r1, [sp, #44]	@ 0x2c
200270b2:	19e4      	adds	r4, r4, r7
200270b4:	ea86 0601 	eor.w	r6, r6, r1
200270b8:	9906      	ldr	r1, [sp, #24]
200270ba:	eb45 0506 	adc.w	r5, r5, r6
200270be:	ea4f 3c91 	mov.w	ip, r1, lsr #14
200270c2:	9907      	ldr	r1, [sp, #28]
200270c4:	ea4c 4c81 	orr.w	ip, ip, r1, lsl #18
200270c8:	0b8e      	lsrs	r6, r1, #14
200270ca:	9906      	ldr	r1, [sp, #24]
200270cc:	ea46 4681 	orr.w	r6, r6, r1, lsl #18
200270d0:	ea4f 4e91 	mov.w	lr, r1, lsr #18
200270d4:	9907      	ldr	r1, [sp, #28]
200270d6:	ea4e 3e81 	orr.w	lr, lr, r1, lsl #14
200270da:	0c8f      	lsrs	r7, r1, #18
200270dc:	9906      	ldr	r1, [sp, #24]
200270de:	ea8c 0c0e 	eor.w	ip, ip, lr
200270e2:	ea47 3781 	orr.w	r7, r7, r1, lsl #14
200270e6:	407e      	eors	r6, r7
200270e8:	05cf      	lsls	r7, r1, #23
200270ea:	9907      	ldr	r1, [sp, #28]
200270ec:	ea47 2751 	orr.w	r7, r7, r1, lsr #9
200270f0:	ea4f 5ec1 	mov.w	lr, r1, lsl #23
200270f4:	9906      	ldr	r1, [sp, #24]
200270f6:	ea8c 0707 	eor.w	r7, ip, r7
200270fa:	ea4e 2e51 	orr.w	lr, lr, r1, lsr #9
200270fe:	19e4      	adds	r4, r4, r7
20027100:	ea86 060e 	eor.w	r6, r6, lr
20027104:	eb45 0606 	adc.w	r6, r5, r6
20027108:	191b      	adds	r3, r3, r4
2002710a:	930c      	str	r3, [sp, #48]	@ 0x30
2002710c:	eb42 0306 	adc.w	r3, r2, r6
20027110:	930d      	str	r3, [sp, #52]	@ 0x34
20027112:	ea4f 7218 	mov.w	r2, r8, lsr #28
20027116:	ea4f 7388 	mov.w	r3, r8, lsl #30
2002711a:	ea43 0399 	orr.w	r3, r3, r9, lsr #2
2002711e:	ea4f 7519 	mov.w	r5, r9, lsr #28
20027122:	ea42 1209 	orr.w	r2, r2, r9, lsl #4
20027126:	ea4f 7789 	mov.w	r7, r9, lsl #30
2002712a:	ea47 0798 	orr.w	r7, r7, r8, lsr #2
2002712e:	ea45 1508 	orr.w	r5, r5, r8, lsl #4
20027132:	405a      	eors	r2, r3
20027134:	ea4f 6348 	mov.w	r3, r8, lsl #25
20027138:	9902      	ldr	r1, [sp, #8]
2002713a:	ea43 13d9 	orr.w	r3, r3, r9, lsr #7
2002713e:	407d      	eors	r5, r7
20027140:	ea4f 6749 	mov.w	r7, r9, lsl #25
20027144:	ea47 17d8 	orr.w	r7, r7, r8, lsr #7
20027148:	405a      	eors	r2, r3
2002714a:	9b01      	ldr	r3, [sp, #4]
2002714c:	407d      	eors	r5, r7
2002714e:	ea41 0708 	orr.w	r7, r1, r8
20027152:	9903      	ldr	r1, [sp, #12]
20027154:	ea43 0309 	orr.w	r3, r3, r9
20027158:	400b      	ands	r3, r1
2002715a:	9901      	ldr	r1, [sp, #4]
2002715c:	ea07 070b 	and.w	r7, r7, fp
20027160:	ea01 0e09 	and.w	lr, r1, r9
20027164:	9902      	ldr	r1, [sp, #8]
20027166:	ea43 030e 	orr.w	r3, r3, lr
2002716a:	ea01 0c08 	and.w	ip, r1, r8
2002716e:	ea47 070c 	orr.w	r7, r7, ip
20027172:	18eb      	adds	r3, r5, r3
20027174:	eb42 0207 	adc.w	r2, r2, r7
20027178:	191b      	adds	r3, r3, r4
2002717a:	9304      	str	r3, [sp, #16]
2002717c:	eb46 0302 	adc.w	r3, r6, r2
20027180:	9305      	str	r3, [sp, #20]
20027182:	9b00      	ldr	r3, [sp, #0]
20027184:	6a1b      	ldr	r3, [r3, #32]
20027186:	9a00      	ldr	r2, [sp, #0]
20027188:	990a      	ldr	r1, [sp, #40]	@ 0x28
2002718a:	6a52      	ldr	r2, [r2, #36]	@ 0x24
2002718c:	e9d0 4508 	ldrd	r4, r5, [r0, #32]
20027190:	191b      	adds	r3, r3, r4
20027192:	eb42 0205 	adc.w	r2, r2, r5
20027196:	185b      	adds	r3, r3, r1
20027198:	990b      	ldr	r1, [sp, #44]	@ 0x2c
2002719a:	9c06      	ldr	r4, [sp, #24]
2002719c:	eb41 0202 	adc.w	r2, r1, r2
200271a0:	9908      	ldr	r1, [sp, #32]
200271a2:	ea81 0504 	eor.w	r5, r1, r4
200271a6:	9909      	ldr	r1, [sp, #36]	@ 0x24
200271a8:	9c07      	ldr	r4, [sp, #28]
200271aa:	404c      	eors	r4, r1
200271ac:	990c      	ldr	r1, [sp, #48]	@ 0x30
200271ae:	400d      	ands	r5, r1
200271b0:	990d      	ldr	r1, [sp, #52]	@ 0x34
200271b2:	400c      	ands	r4, r1
200271b4:	9908      	ldr	r1, [sp, #32]
200271b6:	404d      	eors	r5, r1
200271b8:	9909      	ldr	r1, [sp, #36]	@ 0x24
200271ba:	195b      	adds	r3, r3, r5
200271bc:	ea84 0401 	eor.w	r4, r4, r1
200271c0:	990c      	ldr	r1, [sp, #48]	@ 0x30
200271c2:	eb42 0204 	adc.w	r2, r2, r4
200271c6:	0b8e      	lsrs	r6, r1, #14
200271c8:	990d      	ldr	r1, [sp, #52]	@ 0x34
200271ca:	ea46 4681 	orr.w	r6, r6, r1, lsl #18
200271ce:	0b8c      	lsrs	r4, r1, #14
200271d0:	990c      	ldr	r1, [sp, #48]	@ 0x30
200271d2:	ea44 4481 	orr.w	r4, r4, r1, lsl #18
200271d6:	0c8f      	lsrs	r7, r1, #18
200271d8:	990d      	ldr	r1, [sp, #52]	@ 0x34
200271da:	ea47 3781 	orr.w	r7, r7, r1, lsl #14
200271de:	0c8d      	lsrs	r5, r1, #18
200271e0:	990c      	ldr	r1, [sp, #48]	@ 0x30
200271e2:	407e      	eors	r6, r7
200271e4:	ea45 3581 	orr.w	r5, r5, r1, lsl #14
200271e8:	406c      	eors	r4, r5
200271ea:	05cd      	lsls	r5, r1, #23
200271ec:	990d      	ldr	r1, [sp, #52]	@ 0x34
200271ee:	ea45 2551 	orr.w	r5, r5, r1, lsr #9
200271f2:	05cf      	lsls	r7, r1, #23
200271f4:	990c      	ldr	r1, [sp, #48]	@ 0x30
200271f6:	4075      	eors	r5, r6
200271f8:	ea47 2751 	orr.w	r7, r7, r1, lsr #9
200271fc:	9903      	ldr	r1, [sp, #12]
200271fe:	195b      	adds	r3, r3, r5
20027200:	ea84 0407 	eor.w	r4, r4, r7
20027204:	eb42 0204 	adc.w	r2, r2, r4
20027208:	18c9      	adds	r1, r1, r3
2002720a:	910a      	str	r1, [sp, #40]	@ 0x28
2002720c:	eb4b 0102 	adc.w	r1, fp, r2
20027210:	910b      	str	r1, [sp, #44]	@ 0x2c
20027212:	9904      	ldr	r1, [sp, #16]
20027214:	0f0e      	lsrs	r6, r1, #28
20027216:	9905      	ldr	r1, [sp, #20]
20027218:	ea46 1601 	orr.w	r6, r6, r1, lsl #4
2002721c:	0f0d      	lsrs	r5, r1, #28
2002721e:	9904      	ldr	r1, [sp, #16]
20027220:	ea45 1501 	orr.w	r5, r5, r1, lsl #4
20027224:	078f      	lsls	r7, r1, #30
20027226:	9905      	ldr	r1, [sp, #20]
20027228:	ea47 0791 	orr.w	r7, r7, r1, lsr #2
2002722c:	078c      	lsls	r4, r1, #30
2002722e:	9904      	ldr	r1, [sp, #16]
20027230:	407e      	eors	r6, r7
20027232:	ea44 0491 	orr.w	r4, r4, r1, lsr #2
20027236:	064f      	lsls	r7, r1, #25
20027238:	9905      	ldr	r1, [sp, #20]
2002723a:	4065      	eors	r5, r4
2002723c:	ea47 17d1 	orr.w	r7, r7, r1, lsr #7
20027240:	064c      	lsls	r4, r1, #25
20027242:	9904      	ldr	r1, [sp, #16]
20027244:	407e      	eors	r6, r7
20027246:	ea44 14d1 	orr.w	r4, r4, r1, lsr #7
2002724a:	4065      	eors	r5, r4
2002724c:	ea49 0401 	orr.w	r4, r9, r1
20027250:	9905      	ldr	r1, [sp, #20]
20027252:	ea48 0701 	orr.w	r7, r8, r1
20027256:	9901      	ldr	r1, [sp, #4]
20027258:	400c      	ands	r4, r1
2002725a:	9902      	ldr	r1, [sp, #8]
2002725c:	400f      	ands	r7, r1
2002725e:	9904      	ldr	r1, [sp, #16]
20027260:	ea09 0e01 	and.w	lr, r9, r1
20027264:	9905      	ldr	r1, [sp, #20]
20027266:	ea44 040e 	orr.w	r4, r4, lr
2002726a:	ea08 0c01 	and.w	ip, r8, r1
2002726e:	1934      	adds	r4, r6, r4
20027270:	ea47 070c 	orr.w	r7, r7, ip
20027274:	eb45 0507 	adc.w	r5, r5, r7
20027278:	18e3      	adds	r3, r4, r3
2002727a:	9303      	str	r3, [sp, #12]
2002727c:	9b00      	ldr	r3, [sp, #0]
2002727e:	eb42 0b05 	adc.w	fp, r2, r5
20027282:	9a00      	ldr	r2, [sp, #0]
20027284:	6a9b      	ldr	r3, [r3, #40]	@ 0x28
20027286:	9908      	ldr	r1, [sp, #32]
20027288:	6ad2      	ldr	r2, [r2, #44]	@ 0x2c
2002728a:	e9d0 450a 	ldrd	r4, r5, [r0, #40]	@ 0x28
2002728e:	191b      	adds	r3, r3, r4
20027290:	eb42 0205 	adc.w	r2, r2, r5
20027294:	185b      	adds	r3, r3, r1
20027296:	9909      	ldr	r1, [sp, #36]	@ 0x24
20027298:	9c0c      	ldr	r4, [sp, #48]	@ 0x30
2002729a:	eb41 0202 	adc.w	r2, r1, r2
2002729e:	9906      	ldr	r1, [sp, #24]
200272a0:	ea81 0504 	eor.w	r5, r1, r4
200272a4:	9907      	ldr	r1, [sp, #28]
200272a6:	9c0d      	ldr	r4, [sp, #52]	@ 0x34
200272a8:	404c      	eors	r4, r1
200272aa:	990a      	ldr	r1, [sp, #40]	@ 0x28
200272ac:	400d      	ands	r5, r1
200272ae:	990b      	ldr	r1, [sp, #44]	@ 0x2c
200272b0:	400c      	ands	r4, r1
200272b2:	9906      	ldr	r1, [sp, #24]
200272b4:	404d      	eors	r5, r1
200272b6:	9907      	ldr	r1, [sp, #28]
200272b8:	195b      	adds	r3, r3, r5
200272ba:	ea84 0401 	eor.w	r4, r4, r1
200272be:	990a      	ldr	r1, [sp, #40]	@ 0x28
200272c0:	eb42 0204 	adc.w	r2, r2, r4
200272c4:	0b8e      	lsrs	r6, r1, #14
200272c6:	990b      	ldr	r1, [sp, #44]	@ 0x2c
200272c8:	ea46 4681 	orr.w	r6, r6, r1, lsl #18
200272cc:	0b8c      	lsrs	r4, r1, #14
200272ce:	990a      	ldr	r1, [sp, #40]	@ 0x28
200272d0:	ea44 4481 	orr.w	r4, r4, r1, lsl #18
200272d4:	0c8f      	lsrs	r7, r1, #18
200272d6:	990b      	ldr	r1, [sp, #44]	@ 0x2c
200272d8:	ea47 3781 	orr.w	r7, r7, r1, lsl #14
200272dc:	0c8d      	lsrs	r5, r1, #18
200272de:	990a      	ldr	r1, [sp, #40]	@ 0x28
200272e0:	407e      	eors	r6, r7
200272e2:	ea45 3581 	orr.w	r5, r5, r1, lsl #14
200272e6:	406c      	eors	r4, r5
200272e8:	05cd      	lsls	r5, r1, #23
200272ea:	990b      	ldr	r1, [sp, #44]	@ 0x2c
200272ec:	ea45 2551 	orr.w	r5, r5, r1, lsr #9
200272f0:	05cf      	lsls	r7, r1, #23
200272f2:	990a      	ldr	r1, [sp, #40]	@ 0x28
200272f4:	4075      	eors	r5, r6
200272f6:	ea47 2751 	orr.w	r7, r7, r1, lsr #9
200272fa:	9901      	ldr	r1, [sp, #4]
200272fc:	195b      	adds	r3, r3, r5
200272fe:	ea84 0407 	eor.w	r4, r4, r7
20027302:	eb42 0204 	adc.w	r2, r2, r4
20027306:	18c9      	adds	r1, r1, r3
20027308:	9108      	str	r1, [sp, #32]
2002730a:	9902      	ldr	r1, [sp, #8]
2002730c:	ea4f 751b 	mov.w	r5, fp, lsr #28
20027310:	eb41 0102 	adc.w	r1, r1, r2
20027314:	9109      	str	r1, [sp, #36]	@ 0x24
20027316:	9903      	ldr	r1, [sp, #12]
20027318:	ea4f 748b 	mov.w	r4, fp, lsl #30
2002731c:	ea44 0491 	orr.w	r4, r4, r1, lsr #2
20027320:	ea45 1501 	orr.w	r5, r5, r1, lsl #4
20027324:	0f0e      	lsrs	r6, r1, #28
20027326:	078f      	lsls	r7, r1, #30
20027328:	4065      	eors	r5, r4
2002732a:	ea4f 644b 	mov.w	r4, fp, lsl #25
2002732e:	ea47 079b 	orr.w	r7, r7, fp, lsr #2
20027332:	ea44 14d1 	orr.w	r4, r4, r1, lsr #7
20027336:	ea46 160b 	orr.w	r6, r6, fp, lsl #4
2002733a:	407e      	eors	r6, r7
2002733c:	4065      	eors	r5, r4
2002733e:	064f      	lsls	r7, r1, #25
20027340:	e9dd 4103 	ldrd	r4, r1, [sp, #12]
20027344:	430c      	orrs	r4, r1
20027346:	9905      	ldr	r1, [sp, #20]
20027348:	ea47 17db 	orr.w	r7, r7, fp, lsr #7
2002734c:	407e      	eors	r6, r7
2002734e:	ea41 070b 	orr.w	r7, r1, fp
20027352:	ea04 0109 	and.w	r1, r4, r9
20027356:	9101      	str	r1, [sp, #4]
20027358:	e9dd 4103 	ldrd	r4, r1, [sp, #12]
2002735c:	ea01 0e04 	and.w	lr, r1, r4
20027360:	9905      	ldr	r1, [sp, #20]
20027362:	ea07 0708 	and.w	r7, r7, r8
20027366:	ea01 0c0b 	and.w	ip, r1, fp
2002736a:	9901      	ldr	r1, [sp, #4]
2002736c:	ea47 070c 	orr.w	r7, r7, ip
20027370:	ea41 040e 	orr.w	r4, r1, lr
20027374:	1934      	adds	r4, r6, r4
20027376:	eb45 0507 	adc.w	r5, r5, r7
2002737a:	18e3      	adds	r3, r4, r3
2002737c:	9301      	str	r3, [sp, #4]
2002737e:	eb42 0305 	adc.w	r3, r2, r5
20027382:	9302      	str	r3, [sp, #8]
20027384:	9b00      	ldr	r3, [sp, #0]
20027386:	9a00      	ldr	r2, [sp, #0]
20027388:	6b1b      	ldr	r3, [r3, #48]	@ 0x30
2002738a:	9906      	ldr	r1, [sp, #24]
2002738c:	6b52      	ldr	r2, [r2, #52]	@ 0x34
2002738e:	e9d0 450c 	ldrd	r4, r5, [r0, #48]	@ 0x30
20027392:	191b      	adds	r3, r3, r4
20027394:	eb42 0205 	adc.w	r2, r2, r5
20027398:	185b      	adds	r3, r3, r1
2002739a:	9907      	ldr	r1, [sp, #28]
2002739c:	9c0a      	ldr	r4, [sp, #40]	@ 0x28
2002739e:	eb41 0202 	adc.w	r2, r1, r2
200273a2:	990c      	ldr	r1, [sp, #48]	@ 0x30
200273a4:	ea81 0504 	eor.w	r5, r1, r4
200273a8:	990d      	ldr	r1, [sp, #52]	@ 0x34
200273aa:	9c0b      	ldr	r4, [sp, #44]	@ 0x2c
200273ac:	404c      	eors	r4, r1
200273ae:	9908      	ldr	r1, [sp, #32]
200273b0:	400d      	ands	r5, r1
200273b2:	9909      	ldr	r1, [sp, #36]	@ 0x24
200273b4:	400c      	ands	r4, r1
200273b6:	990c      	ldr	r1, [sp, #48]	@ 0x30
200273b8:	404d      	eors	r5, r1
200273ba:	990d      	ldr	r1, [sp, #52]	@ 0x34
200273bc:	195b      	adds	r3, r3, r5
200273be:	ea84 0401 	eor.w	r4, r4, r1
200273c2:	9908      	ldr	r1, [sp, #32]
200273c4:	eb42 0204 	adc.w	r2, r2, r4
200273c8:	0b8e      	lsrs	r6, r1, #14
200273ca:	9909      	ldr	r1, [sp, #36]	@ 0x24
200273cc:	ea46 4681 	orr.w	r6, r6, r1, lsl #18
200273d0:	0b8c      	lsrs	r4, r1, #14
200273d2:	9908      	ldr	r1, [sp, #32]
200273d4:	ea44 4481 	orr.w	r4, r4, r1, lsl #18
200273d8:	0c8f      	lsrs	r7, r1, #18
200273da:	9909      	ldr	r1, [sp, #36]	@ 0x24
200273dc:	ea47 3781 	orr.w	r7, r7, r1, lsl #14
200273e0:	0c8d      	lsrs	r5, r1, #18
200273e2:	9908      	ldr	r1, [sp, #32]
200273e4:	407e      	eors	r6, r7
200273e6:	ea45 3581 	orr.w	r5, r5, r1, lsl #14
200273ea:	406c      	eors	r4, r5
200273ec:	05cd      	lsls	r5, r1, #23
200273ee:	9909      	ldr	r1, [sp, #36]	@ 0x24
200273f0:	ea45 2551 	orr.w	r5, r5, r1, lsr #9
200273f4:	05cf      	lsls	r7, r1, #23
200273f6:	9908      	ldr	r1, [sp, #32]
200273f8:	4075      	eors	r5, r6
200273fa:	ea47 2751 	orr.w	r7, r7, r1, lsr #9
200273fe:	195b      	adds	r3, r3, r5
20027400:	ea84 0407 	eor.w	r4, r4, r7
20027404:	eb42 0204 	adc.w	r2, r2, r4
20027408:	eb19 0103 	adds.w	r1, r9, r3
2002740c:	9106      	str	r1, [sp, #24]
2002740e:	eb48 0102 	adc.w	r1, r8, r2
20027412:	9107      	str	r1, [sp, #28]
20027414:	9901      	ldr	r1, [sp, #4]
20027416:	0f0e      	lsrs	r6, r1, #28
20027418:	9902      	ldr	r1, [sp, #8]
2002741a:	ea46 1601 	orr.w	r6, r6, r1, lsl #4
2002741e:	0f0d      	lsrs	r5, r1, #28
20027420:	9901      	ldr	r1, [sp, #4]
20027422:	ea45 1501 	orr.w	r5, r5, r1, lsl #4
20027426:	078f      	lsls	r7, r1, #30
20027428:	9902      	ldr	r1, [sp, #8]
2002742a:	ea47 0791 	orr.w	r7, r7, r1, lsr #2
2002742e:	078c      	lsls	r4, r1, #30
20027430:	9901      	ldr	r1, [sp, #4]
20027432:	407e      	eors	r6, r7
20027434:	ea44 0491 	orr.w	r4, r4, r1, lsr #2
20027438:	064f      	lsls	r7, r1, #25
2002743a:	9902      	ldr	r1, [sp, #8]
2002743c:	4065      	eors	r5, r4
2002743e:	ea47 17d1 	orr.w	r7, r7, r1, lsr #7
20027442:	064c      	lsls	r4, r1, #25
20027444:	9901      	ldr	r1, [sp, #4]
20027446:	407e      	eors	r6, r7
20027448:	ea44 14d1 	orr.w	r4, r4, r1, lsr #7
2002744c:	4065      	eors	r5, r4
2002744e:	9903      	ldr	r1, [sp, #12]
20027450:	9c01      	ldr	r4, [sp, #4]
20027452:	430c      	orrs	r4, r1
20027454:	9902      	ldr	r1, [sp, #8]
20027456:	ea4b 0701 	orr.w	r7, fp, r1
2002745a:	9904      	ldr	r1, [sp, #16]
2002745c:	ea04 0801 	and.w	r8, r4, r1
20027460:	9905      	ldr	r1, [sp, #20]
20027462:	9c01      	ldr	r4, [sp, #4]
20027464:	400f      	ands	r7, r1
20027466:	9903      	ldr	r1, [sp, #12]
20027468:	ea01 0e04 	and.w	lr, r1, r4
2002746c:	9902      	ldr	r1, [sp, #8]
2002746e:	ea48 040e 	orr.w	r4, r8, lr
20027472:	ea0b 0c01 	and.w	ip, fp, r1
20027476:	1934      	adds	r4, r6, r4
20027478:	ea47 070c 	orr.w	r7, r7, ip
2002747c:	eb45 0507 	adc.w	r5, r5, r7
20027480:	eb14 0c03 	adds.w	ip, r4, r3
20027484:	9b00      	ldr	r3, [sp, #0]
20027486:	eb42 0e05 	adc.w	lr, r2, r5
2002748a:	6b9b      	ldr	r3, [r3, #56]	@ 0x38
2002748c:	9a00      	ldr	r2, [sp, #0]
2002748e:	e9d0 450e 	ldrd	r4, r5, [r0, #56]	@ 0x38
20027492:	6bd2      	ldr	r2, [r2, #60]	@ 0x3c
20027494:	191c      	adds	r4, r3, r4
20027496:	9b0c      	ldr	r3, [sp, #48]	@ 0x30
20027498:	eb42 0205 	adc.w	r2, r2, r5
2002749c:	18e4      	adds	r4, r4, r3
2002749e:	9b0d      	ldr	r3, [sp, #52]	@ 0x34
200274a0:	9908      	ldr	r1, [sp, #32]
200274a2:	eb43 0202 	adc.w	r2, r3, r2
200274a6:	9b0a      	ldr	r3, [sp, #40]	@ 0x28
200274a8:	3040      	adds	r0, #64	@ 0x40
200274aa:	ea83 0501 	eor.w	r5, r3, r1
200274ae:	9909      	ldr	r1, [sp, #36]	@ 0x24
200274b0:	9b0b      	ldr	r3, [sp, #44]	@ 0x2c
200274b2:	404b      	eors	r3, r1
200274b4:	9906      	ldr	r1, [sp, #24]
200274b6:	400d      	ands	r5, r1
200274b8:	9907      	ldr	r1, [sp, #28]
200274ba:	400b      	ands	r3, r1
200274bc:	990a      	ldr	r1, [sp, #40]	@ 0x28
200274be:	404d      	eors	r5, r1
200274c0:	990b      	ldr	r1, [sp, #44]	@ 0x2c
200274c2:	1964      	adds	r4, r4, r5
200274c4:	ea83 0301 	eor.w	r3, r3, r1
200274c8:	eb42 0203 	adc.w	r2, r2, r3
200274cc:	9b06      	ldr	r3, [sp, #24]
200274ce:	9906      	ldr	r1, [sp, #24]
200274d0:	0b9e      	lsrs	r6, r3, #14
200274d2:	9b07      	ldr	r3, [sp, #28]
200274d4:	0c8f      	lsrs	r7, r1, #18
200274d6:	ea46 4683 	orr.w	r6, r6, r3, lsl #18
200274da:	0b9b      	lsrs	r3, r3, #14
200274dc:	ea43 4381 	orr.w	r3, r3, r1, lsl #18
200274e0:	9907      	ldr	r1, [sp, #28]
200274e2:	ea47 3781 	orr.w	r7, r7, r1, lsl #14
200274e6:	0c8d      	lsrs	r5, r1, #18
200274e8:	9906      	ldr	r1, [sp, #24]
200274ea:	407e      	eors	r6, r7
200274ec:	ea45 3581 	orr.w	r5, r5, r1, lsl #14
200274f0:	406b      	eors	r3, r5
200274f2:	05cd      	lsls	r5, r1, #23
200274f4:	9907      	ldr	r1, [sp, #28]
200274f6:	ea45 2551 	orr.w	r5, r5, r1, lsr #9
200274fa:	05cf      	lsls	r7, r1, #23
200274fc:	9906      	ldr	r1, [sp, #24]
200274fe:	4075      	eors	r5, r6
20027500:	ea47 2751 	orr.w	r7, r7, r1, lsr #9
20027504:	1964      	adds	r4, r4, r5
20027506:	ea83 0307 	eor.w	r3, r3, r7
2002750a:	eb42 0203 	adc.w	r2, r2, r3
2002750e:	9b04      	ldr	r3, [sp, #16]
20027510:	ea4f 751e 	mov.w	r5, lr, lsr #28
20027514:	191b      	adds	r3, r3, r4
20027516:	9304      	str	r3, [sp, #16]
20027518:	9b05      	ldr	r3, [sp, #20]
2002751a:	ea4f 761c 	mov.w	r6, ip, lsr #28
2002751e:	eb43 0302 	adc.w	r3, r3, r2
20027522:	9305      	str	r3, [sp, #20]
20027524:	ea4f 738e 	mov.w	r3, lr, lsl #30
20027528:	ea43 039c 	orr.w	r3, r3, ip, lsr #2
2002752c:	ea45 150c 	orr.w	r5, r5, ip, lsl #4
20027530:	ea4f 778c 	mov.w	r7, ip, lsl #30
20027534:	ea47 079e 	orr.w	r7, r7, lr, lsr #2
20027538:	405d      	eors	r5, r3
2002753a:	ea46 160e 	orr.w	r6, r6, lr, lsl #4
2002753e:	ea4f 634e 	mov.w	r3, lr, lsl #25
20027542:	9902      	ldr	r1, [sp, #8]
20027544:	407e      	eors	r6, r7
20027546:	ea43 13dc 	orr.w	r3, r3, ip, lsr #7
2002754a:	ea4f 674c 	mov.w	r7, ip, lsl #25
2002754e:	ea47 17de 	orr.w	r7, r7, lr, lsr #7
20027552:	405d      	eors	r5, r3
20027554:	9b01      	ldr	r3, [sp, #4]
20027556:	407e      	eors	r6, r7
20027558:	ea41 070e 	orr.w	r7, r1, lr
2002755c:	9903      	ldr	r1, [sp, #12]
2002755e:	ea43 030c 	orr.w	r3, r3, ip
20027562:	400b      	ands	r3, r1
20027564:	9901      	ldr	r1, [sp, #4]
20027566:	ea07 070b 	and.w	r7, r7, fp
2002756a:	ea01 090c 	and.w	r9, r1, ip
2002756e:	9902      	ldr	r1, [sp, #8]
20027570:	ea43 0309 	orr.w	r3, r3, r9
20027574:	ea01 080e 	and.w	r8, r1, lr
20027578:	9900      	ldr	r1, [sp, #0]
2002757a:	18f3      	adds	r3, r6, r3
2002757c:	f101 0140 	add.w	r1, r1, #64	@ 0x40
20027580:	9100      	str	r1, [sp, #0]
20027582:	ea47 0708 	orr.w	r7, r7, r8
20027586:	eb45 0507 	adc.w	r5, r5, r7
2002758a:	4928      	ldr	r1, [pc, #160]	@ (2002762c <mbedtls_sha512_process+0xa54>)
2002758c:	191b      	adds	r3, r3, r4
2002758e:	9c00      	ldr	r4, [sp, #0]
20027590:	eb42 0205 	adc.w	r2, r2, r5
20027594:	42a1      	cmp	r1, r4
20027596:	f47f abe3 	bne.w	20026d60 <mbedtls_sha512_process+0x188>
2002759a:	990e      	ldr	r1, [sp, #56]	@ 0x38
2002759c:	18cb      	adds	r3, r1, r3
2002759e:	990f      	ldr	r1, [sp, #60]	@ 0x3c
200275a0:	eb42 0201 	adc.w	r2, r2, r1
200275a4:	e9ca 3204 	strd	r3, r2, [sl, #16]
200275a8:	9b10      	ldr	r3, [sp, #64]	@ 0x40
200275aa:	9a11      	ldr	r2, [sp, #68]	@ 0x44
200275ac:	eb13 030c 	adds.w	r3, r3, ip
200275b0:	eb4e 0202 	adc.w	r2, lr, r2
200275b4:	e9ca 3206 	strd	r3, r2, [sl, #24]
200275b8:	9a01      	ldr	r2, [sp, #4]
200275ba:	9b12      	ldr	r3, [sp, #72]	@ 0x48
200275bc:	9913      	ldr	r1, [sp, #76]	@ 0x4c
200275be:	189b      	adds	r3, r3, r2
200275c0:	9a02      	ldr	r2, [sp, #8]
200275c2:	eb42 0201 	adc.w	r2, r2, r1
200275c6:	e9ca 3208 	strd	r3, r2, [sl, #32]
200275ca:	9a03      	ldr	r2, [sp, #12]
200275cc:	9b14      	ldr	r3, [sp, #80]	@ 0x50
200275ce:	9917      	ldr	r1, [sp, #92]	@ 0x5c
200275d0:	189b      	adds	r3, r3, r2
200275d2:	9a15      	ldr	r2, [sp, #84]	@ 0x54
200275d4:	eb4b 0202 	adc.w	r2, fp, r2
200275d8:	e9ca 320a 	strd	r3, r2, [sl, #40]	@ 0x28
200275dc:	9a04      	ldr	r2, [sp, #16]
200275de:	9b16      	ldr	r3, [sp, #88]	@ 0x58
200275e0:	189b      	adds	r3, r3, r2
200275e2:	9a05      	ldr	r2, [sp, #20]
200275e4:	eb42 0201 	adc.w	r2, r2, r1
200275e8:	e9ca 320c 	strd	r3, r2, [sl, #48]	@ 0x30
200275ec:	9b18      	ldr	r3, [sp, #96]	@ 0x60
200275ee:	9a06      	ldr	r2, [sp, #24]
200275f0:	9919      	ldr	r1, [sp, #100]	@ 0x64
200275f2:	189a      	adds	r2, r3, r2
200275f4:	9b07      	ldr	r3, [sp, #28]
200275f6:	eb43 0301 	adc.w	r3, r3, r1
200275fa:	e9ca 230e 	strd	r2, r3, [sl, #56]	@ 0x38
200275fe:	9b1a      	ldr	r3, [sp, #104]	@ 0x68
20027600:	9a08      	ldr	r2, [sp, #32]
20027602:	991b      	ldr	r1, [sp, #108]	@ 0x6c
20027604:	189a      	adds	r2, r3, r2
20027606:	9b09      	ldr	r3, [sp, #36]	@ 0x24
20027608:	eb43 0301 	adc.w	r3, r3, r1
2002760c:	e9ca 2310 	strd	r2, r3, [sl, #64]	@ 0x40
20027610:	9b1c      	ldr	r3, [sp, #112]	@ 0x70
20027612:	9a0a      	ldr	r2, [sp, #40]	@ 0x28
20027614:	991d      	ldr	r1, [sp, #116]	@ 0x74
20027616:	189a      	adds	r2, r3, r2
20027618:	9b0b      	ldr	r3, [sp, #44]	@ 0x2c
2002761a:	eb43 0301 	adc.w	r3, r3, r1
2002761e:	e9ca 2312 	strd	r2, r3, [sl, #72]	@ 0x48
20027622:	f50d 7d3f 	add.w	sp, sp, #764	@ 0x2fc
20027626:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
2002762a:	bf00      	nop
2002762c:	2002c3c0 	.word	0x2002c3c0

20027630 <mbedtls_sha512_update.part.0>:
20027630:	e92d 43f8 	stmdb	sp!, {r3, r4, r5, r6, r7, r8, r9, lr}
20027634:	4615      	mov	r5, r2
20027636:	e9d0 3200 	ldrd	r3, r2, [r0]
2002763a:	f003 077f 	and.w	r7, r3, #127	@ 0x7f
2002763e:	195b      	adds	r3, r3, r5
20027640:	f152 0200 	adcs.w	r2, r2, #0
20027644:	460e      	mov	r6, r1
20027646:	f04f 0100 	mov.w	r1, #0
2002764a:	bf28      	it	cs
2002764c:	2101      	movcs	r1, #1
2002764e:	4604      	mov	r4, r0
20027650:	e9c0 3200 	strd	r3, r2, [r0]
20027654:	b131      	cbz	r1, 20027664 <mbedtls_sha512_update.part.0+0x34>
20027656:	e9d0 3202 	ldrd	r3, r2, [r0, #8]
2002765a:	3301      	adds	r3, #1
2002765c:	f142 0200 	adc.w	r2, r2, #0
20027660:	e9c0 3202 	strd	r3, r2, [r0, #8]
20027664:	b19f      	cbz	r7, 2002768e <mbedtls_sha512_update.part.0+0x5e>
20027666:	f1c7 0980 	rsb	r9, r7, #128	@ 0x80
2002766a:	45a9      	cmp	r9, r5
2002766c:	d80f      	bhi.n	2002768e <mbedtls_sha512_update.part.0+0x5e>
2002766e:	f104 0850 	add.w	r8, r4, #80	@ 0x50
20027672:	4631      	mov	r1, r6
20027674:	464a      	mov	r2, r9
20027676:	eb08 0007 	add.w	r0, r8, r7
2002767a:	f003 fa05 	bl	2002aa88 <memcpy>
2002767e:	3d80      	subs	r5, #128	@ 0x80
20027680:	4641      	mov	r1, r8
20027682:	4620      	mov	r0, r4
20027684:	443d      	add	r5, r7
20027686:	f7ff faa7 	bl	20026bd8 <mbedtls_sha512_process>
2002768a:	2700      	movs	r7, #0
2002768c:	444e      	add	r6, r9
2002768e:	46a8      	mov	r8, r5
20027690:	eb05 0906 	add.w	r9, r5, r6
20027694:	e004      	b.n	200276a0 <mbedtls_sha512_update.part.0+0x70>
20027696:	4620      	mov	r0, r4
20027698:	f7ff fa9e 	bl	20026bd8 <mbedtls_sha512_process>
2002769c:	f1a8 0880 	sub.w	r8, r8, #128	@ 0x80
200276a0:	f1b8 0f7f 	cmp.w	r8, #127	@ 0x7f
200276a4:	eba9 0108 	sub.w	r1, r9, r8
200276a8:	d8f5      	bhi.n	20027696 <mbedtls_sha512_update.part.0+0x66>
200276aa:	f06f 037f 	mvn.w	r3, #127	@ 0x7f
200276ae:	09e9      	lsrs	r1, r5, #7
200276b0:	4359      	muls	r1, r3
200276b2:	186a      	adds	r2, r5, r1
200276b4:	d007      	beq.n	200276c6 <mbedtls_sha512_update.part.0+0x96>
200276b6:	f104 0050 	add.w	r0, r4, #80	@ 0x50
200276ba:	1a71      	subs	r1, r6, r1
200276bc:	4438      	add	r0, r7
200276be:	e8bd 43f8 	ldmia.w	sp!, {r3, r4, r5, r6, r7, r8, r9, lr}
200276c2:	f003 b9e1 	b.w	2002aa88 <memcpy>
200276c6:	e8bd 83f8 	ldmia.w	sp!, {r3, r4, r5, r6, r7, r8, r9, pc}

200276ca <mbedtls_sha512_update>:
200276ca:	b10a      	cbz	r2, 200276d0 <mbedtls_sha512_update+0x6>
200276cc:	f7ff bfb0 	b.w	20027630 <mbedtls_sha512_update.part.0>
200276d0:	4770      	bx	lr
	...

200276d4 <mbedtls_sha512_finish>:
200276d4:	b5f0      	push	{r4, r5, r6, r7, lr}
200276d6:	4604      	mov	r4, r0
200276d8:	e9d0 2300 	ldrd	r2, r3, [r0]
200276dc:	460d      	mov	r5, r1
200276de:	e9d0 6102 	ldrd	r6, r1, [r0, #8]
200276e2:	00c9      	lsls	r1, r1, #3
200276e4:	ea41 7156 	orr.w	r1, r1, r6, lsr #29
200276e8:	b085      	sub	sp, #20
200276ea:	0e0f      	lsrs	r7, r1, #24
200276ec:	0f58      	lsrs	r0, r3, #29
200276ee:	00db      	lsls	r3, r3, #3
200276f0:	ea43 7352 	orr.w	r3, r3, r2, lsr #29
200276f4:	f88d 7000 	strb.w	r7, [sp]
200276f8:	0c0f      	lsrs	r7, r1, #16
200276fa:	f88d 7001 	strb.w	r7, [sp, #1]
200276fe:	f88d 1003 	strb.w	r1, [sp, #3]
20027702:	0a0f      	lsrs	r7, r1, #8
20027704:	0e19      	lsrs	r1, r3, #24
20027706:	ea40 00c6 	orr.w	r0, r0, r6, lsl #3
2002770a:	f88d 1008 	strb.w	r1, [sp, #8]
2002770e:	00d6      	lsls	r6, r2, #3
20027710:	0c19      	lsrs	r1, r3, #16
20027712:	f002 027f 	and.w	r2, r2, #127	@ 0x7f
20027716:	2a6f      	cmp	r2, #111	@ 0x6f
20027718:	ba00      	rev	r0, r0
2002771a:	f88d 1009 	strb.w	r1, [sp, #9]
2002771e:	ea4f 2113 	mov.w	r1, r3, lsr #8
20027722:	bf94      	ite	ls
20027724:	f1c2 0270 	rsbls	r2, r2, #112	@ 0x70
20027728:	f1c2 02f0 	rsbhi	r2, r2, #240	@ 0xf0
2002772c:	9001      	str	r0, [sp, #4]
2002772e:	f88d 100a 	strb.w	r1, [sp, #10]
20027732:	4620      	mov	r0, r4
20027734:	4969      	ldr	r1, [pc, #420]	@ (200278dc <mbedtls_sha512_finish+0x208>)
20027736:	ba36      	rev	r6, r6
20027738:	f88d 300b 	strb.w	r3, [sp, #11]
2002773c:	f88d 7002 	strb.w	r7, [sp, #2]
20027740:	9603      	str	r6, [sp, #12]
20027742:	f7ff ffc2 	bl	200276ca <mbedtls_sha512_update>
20027746:	2210      	movs	r2, #16
20027748:	4669      	mov	r1, sp
2002774a:	4620      	mov	r0, r4
2002774c:	f7ff ff70 	bl	20027630 <mbedtls_sha512_update.part.0>
20027750:	7de3      	ldrb	r3, [r4, #23]
20027752:	702b      	strb	r3, [r5, #0]
20027754:	8ae3      	ldrh	r3, [r4, #22]
20027756:	706b      	strb	r3, [r5, #1]
20027758:	6963      	ldr	r3, [r4, #20]
2002775a:	0a1b      	lsrs	r3, r3, #8
2002775c:	70ab      	strb	r3, [r5, #2]
2002775e:	6963      	ldr	r3, [r4, #20]
20027760:	70eb      	strb	r3, [r5, #3]
20027762:	7ce3      	ldrb	r3, [r4, #19]
20027764:	712b      	strb	r3, [r5, #4]
20027766:	8a63      	ldrh	r3, [r4, #18]
20027768:	716b      	strb	r3, [r5, #5]
2002776a:	6923      	ldr	r3, [r4, #16]
2002776c:	0a1b      	lsrs	r3, r3, #8
2002776e:	71ab      	strb	r3, [r5, #6]
20027770:	6923      	ldr	r3, [r4, #16]
20027772:	71eb      	strb	r3, [r5, #7]
20027774:	7fe3      	ldrb	r3, [r4, #31]
20027776:	722b      	strb	r3, [r5, #8]
20027778:	8be3      	ldrh	r3, [r4, #30]
2002777a:	726b      	strb	r3, [r5, #9]
2002777c:	69e3      	ldr	r3, [r4, #28]
2002777e:	0a1b      	lsrs	r3, r3, #8
20027780:	72ab      	strb	r3, [r5, #10]
20027782:	69e3      	ldr	r3, [r4, #28]
20027784:	72eb      	strb	r3, [r5, #11]
20027786:	7ee3      	ldrb	r3, [r4, #27]
20027788:	732b      	strb	r3, [r5, #12]
2002778a:	8b63      	ldrh	r3, [r4, #26]
2002778c:	736b      	strb	r3, [r5, #13]
2002778e:	69a3      	ldr	r3, [r4, #24]
20027790:	0a1b      	lsrs	r3, r3, #8
20027792:	73ab      	strb	r3, [r5, #14]
20027794:	69a3      	ldr	r3, [r4, #24]
20027796:	73eb      	strb	r3, [r5, #15]
20027798:	f894 3027 	ldrb.w	r3, [r4, #39]	@ 0x27
2002779c:	742b      	strb	r3, [r5, #16]
2002779e:	8ce3      	ldrh	r3, [r4, #38]	@ 0x26
200277a0:	746b      	strb	r3, [r5, #17]
200277a2:	6a63      	ldr	r3, [r4, #36]	@ 0x24
200277a4:	0a1b      	lsrs	r3, r3, #8
200277a6:	74ab      	strb	r3, [r5, #18]
200277a8:	6a63      	ldr	r3, [r4, #36]	@ 0x24
200277aa:	74eb      	strb	r3, [r5, #19]
200277ac:	f894 3023 	ldrb.w	r3, [r4, #35]	@ 0x23
200277b0:	752b      	strb	r3, [r5, #20]
200277b2:	8c63      	ldrh	r3, [r4, #34]	@ 0x22
200277b4:	756b      	strb	r3, [r5, #21]
200277b6:	6a23      	ldr	r3, [r4, #32]
200277b8:	0a1b      	lsrs	r3, r3, #8
200277ba:	75ab      	strb	r3, [r5, #22]
200277bc:	6a23      	ldr	r3, [r4, #32]
200277be:	75eb      	strb	r3, [r5, #23]
200277c0:	f894 302f 	ldrb.w	r3, [r4, #47]	@ 0x2f
200277c4:	762b      	strb	r3, [r5, #24]
200277c6:	8de3      	ldrh	r3, [r4, #46]	@ 0x2e
200277c8:	766b      	strb	r3, [r5, #25]
200277ca:	6ae3      	ldr	r3, [r4, #44]	@ 0x2c
200277cc:	0a1b      	lsrs	r3, r3, #8
200277ce:	76ab      	strb	r3, [r5, #26]
200277d0:	6ae3      	ldr	r3, [r4, #44]	@ 0x2c
200277d2:	76eb      	strb	r3, [r5, #27]
200277d4:	f894 302b 	ldrb.w	r3, [r4, #43]	@ 0x2b
200277d8:	772b      	strb	r3, [r5, #28]
200277da:	8d63      	ldrh	r3, [r4, #42]	@ 0x2a
200277dc:	776b      	strb	r3, [r5, #29]
200277de:	6aa3      	ldr	r3, [r4, #40]	@ 0x28
200277e0:	0a1b      	lsrs	r3, r3, #8
200277e2:	77ab      	strb	r3, [r5, #30]
200277e4:	6aa3      	ldr	r3, [r4, #40]	@ 0x28
200277e6:	77eb      	strb	r3, [r5, #31]
200277e8:	f894 3037 	ldrb.w	r3, [r4, #55]	@ 0x37
200277ec:	f885 3020 	strb.w	r3, [r5, #32]
200277f0:	8ee3      	ldrh	r3, [r4, #54]	@ 0x36
200277f2:	f885 3021 	strb.w	r3, [r5, #33]	@ 0x21
200277f6:	6b63      	ldr	r3, [r4, #52]	@ 0x34
200277f8:	0a1b      	lsrs	r3, r3, #8
200277fa:	f885 3022 	strb.w	r3, [r5, #34]	@ 0x22
200277fe:	6b63      	ldr	r3, [r4, #52]	@ 0x34
20027800:	f885 3023 	strb.w	r3, [r5, #35]	@ 0x23
20027804:	f894 3033 	ldrb.w	r3, [r4, #51]	@ 0x33
20027808:	f885 3024 	strb.w	r3, [r5, #36]	@ 0x24
2002780c:	8e63      	ldrh	r3, [r4, #50]	@ 0x32
2002780e:	f885 3025 	strb.w	r3, [r5, #37]	@ 0x25
20027812:	6b23      	ldr	r3, [r4, #48]	@ 0x30
20027814:	0a1b      	lsrs	r3, r3, #8
20027816:	f885 3026 	strb.w	r3, [r5, #38]	@ 0x26
2002781a:	6b23      	ldr	r3, [r4, #48]	@ 0x30
2002781c:	f885 3027 	strb.w	r3, [r5, #39]	@ 0x27
20027820:	f894 303f 	ldrb.w	r3, [r4, #63]	@ 0x3f
20027824:	f885 3028 	strb.w	r3, [r5, #40]	@ 0x28
20027828:	8fe3      	ldrh	r3, [r4, #62]	@ 0x3e
2002782a:	f885 3029 	strb.w	r3, [r5, #41]	@ 0x29
2002782e:	6be3      	ldr	r3, [r4, #60]	@ 0x3c
20027830:	0a1b      	lsrs	r3, r3, #8
20027832:	f885 302a 	strb.w	r3, [r5, #42]	@ 0x2a
20027836:	6be3      	ldr	r3, [r4, #60]	@ 0x3c
20027838:	f885 302b 	strb.w	r3, [r5, #43]	@ 0x2b
2002783c:	f894 303b 	ldrb.w	r3, [r4, #59]	@ 0x3b
20027840:	f885 302c 	strb.w	r3, [r5, #44]	@ 0x2c
20027844:	8f63      	ldrh	r3, [r4, #58]	@ 0x3a
20027846:	f885 302d 	strb.w	r3, [r5, #45]	@ 0x2d
2002784a:	6ba3      	ldr	r3, [r4, #56]	@ 0x38
2002784c:	0a1b      	lsrs	r3, r3, #8
2002784e:	f885 302e 	strb.w	r3, [r5, #46]	@ 0x2e
20027852:	6ba3      	ldr	r3, [r4, #56]	@ 0x38
20027854:	f885 302f 	strb.w	r3, [r5, #47]	@ 0x2f
20027858:	f8d4 30d0 	ldr.w	r3, [r4, #208]	@ 0xd0
2002785c:	2b00      	cmp	r3, #0
2002785e:	d13b      	bne.n	200278d8 <mbedtls_sha512_finish+0x204>
20027860:	f894 3047 	ldrb.w	r3, [r4, #71]	@ 0x47
20027864:	f885 3030 	strb.w	r3, [r5, #48]	@ 0x30
20027868:	f8b4 3046 	ldrh.w	r3, [r4, #70]	@ 0x46
2002786c:	f885 3031 	strb.w	r3, [r5, #49]	@ 0x31
20027870:	6c63      	ldr	r3, [r4, #68]	@ 0x44
20027872:	0a1b      	lsrs	r3, r3, #8
20027874:	f885 3032 	strb.w	r3, [r5, #50]	@ 0x32
20027878:	6c63      	ldr	r3, [r4, #68]	@ 0x44
2002787a:	f885 3033 	strb.w	r3, [r5, #51]	@ 0x33
2002787e:	f894 3043 	ldrb.w	r3, [r4, #67]	@ 0x43
20027882:	f885 3034 	strb.w	r3, [r5, #52]	@ 0x34
20027886:	f8b4 3042 	ldrh.w	r3, [r4, #66]	@ 0x42
2002788a:	f885 3035 	strb.w	r3, [r5, #53]	@ 0x35
2002788e:	6c23      	ldr	r3, [r4, #64]	@ 0x40
20027890:	0a1b      	lsrs	r3, r3, #8
20027892:	f885 3036 	strb.w	r3, [r5, #54]	@ 0x36
20027896:	6c23      	ldr	r3, [r4, #64]	@ 0x40
20027898:	f885 3037 	strb.w	r3, [r5, #55]	@ 0x37
2002789c:	f894 304f 	ldrb.w	r3, [r4, #79]	@ 0x4f
200278a0:	f885 3038 	strb.w	r3, [r5, #56]	@ 0x38
200278a4:	f8b4 304e 	ldrh.w	r3, [r4, #78]	@ 0x4e
200278a8:	f885 3039 	strb.w	r3, [r5, #57]	@ 0x39
200278ac:	6ce3      	ldr	r3, [r4, #76]	@ 0x4c
200278ae:	0a1b      	lsrs	r3, r3, #8
200278b0:	f885 303a 	strb.w	r3, [r5, #58]	@ 0x3a
200278b4:	6ce3      	ldr	r3, [r4, #76]	@ 0x4c
200278b6:	f885 303b 	strb.w	r3, [r5, #59]	@ 0x3b
200278ba:	f894 304b 	ldrb.w	r3, [r4, #75]	@ 0x4b
200278be:	f885 303c 	strb.w	r3, [r5, #60]	@ 0x3c
200278c2:	f8b4 304a 	ldrh.w	r3, [r4, #74]	@ 0x4a
200278c6:	f885 303d 	strb.w	r3, [r5, #61]	@ 0x3d
200278ca:	6ca3      	ldr	r3, [r4, #72]	@ 0x48
200278cc:	0a1b      	lsrs	r3, r3, #8
200278ce:	f885 303e 	strb.w	r3, [r5, #62]	@ 0x3e
200278d2:	6ca3      	ldr	r3, [r4, #72]	@ 0x48
200278d4:	f885 303f 	strb.w	r3, [r5, #63]	@ 0x3f
200278d8:	b005      	add	sp, #20
200278da:	bdf0      	pop	{r4, r5, r6, r7, pc}
200278dc:	2002c0bc 	.word	0x2002c0bc

200278e0 <mbedtls_sha512>:
200278e0:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
200278e4:	461c      	mov	r4, r3
200278e6:	b0b7      	sub	sp, #220	@ 0xdc
200278e8:	4606      	mov	r6, r0
200278ea:	4668      	mov	r0, sp
200278ec:	460f      	mov	r7, r1
200278ee:	4615      	mov	r5, r2
200278f0:	f7ff f8cc 	bl	20026a8c <mbedtls_sha512_init>
200278f4:	2c00      	cmp	r4, #0
200278f6:	d03f      	beq.n	20027978 <mbedtls_sha512+0x98>
200278f8:	f20f 0bf4 	addw	fp, pc, #244	@ 0xf4
200278fc:	e9db ab00 	ldrd	sl, fp, [fp]
20027900:	f20f 09f4 	addw	r9, pc, #244	@ 0xf4
20027904:	e9d9 8900 	ldrd	r8, r9, [r9]
20027908:	a13d      	add	r1, pc, #244	@ (adr r1, 20027a00 <mbedtls_sha512+0x120>)
2002790a:	e9d1 0100 	ldrd	r0, r1, [r1]
2002790e:	a33e      	add	r3, pc, #248	@ (adr r3, 20027a08 <mbedtls_sha512+0x128>)
20027910:	e9d3 2300 	ldrd	r2, r3, [r3]
20027914:	ed9f 4b24 	vldr	d4, [pc, #144]	@ 200279a8 <mbedtls_sha512+0xc8>
20027918:	ed9f 5b25 	vldr	d5, [pc, #148]	@ 200279b0 <mbedtls_sha512+0xd0>
2002791c:	ed9f 6b26 	vldr	d6, [pc, #152]	@ 200279b8 <mbedtls_sha512+0xd8>
20027920:	ed9f 7b27 	vldr	d7, [pc, #156]	@ 200279c0 <mbedtls_sha512+0xe0>
20027924:	ed9f 3b28 	vldr	d3, [pc, #160]	@ 200279c8 <mbedtls_sha512+0xe8>
20027928:	e9cd 2312 	strd	r2, r3, [sp, #72]	@ 0x48
2002792c:	e9cd 0110 	strd	r0, r1, [sp, #64]	@ 0x40
20027930:	463a      	mov	r2, r7
20027932:	4631      	mov	r1, r6
20027934:	4668      	mov	r0, sp
20027936:	ed8d 3b00 	vstr	d3, [sp]
2002793a:	ed8d 3b02 	vstr	d3, [sp, #8]
2002793e:	ed8d 4b04 	vstr	d4, [sp, #16]
20027942:	ed8d 5b06 	vstr	d5, [sp, #24]
20027946:	ed8d 6b08 	vstr	d6, [sp, #32]
2002794a:	ed8d 7b0a 	vstr	d7, [sp, #40]	@ 0x28
2002794e:	e9cd ab0c 	strd	sl, fp, [sp, #48]	@ 0x30
20027952:	e9cd 890e 	strd	r8, r9, [sp, #56]	@ 0x38
20027956:	9434      	str	r4, [sp, #208]	@ 0xd0
20027958:	f7ff feb7 	bl	200276ca <mbedtls_sha512_update>
2002795c:	4629      	mov	r1, r5
2002795e:	4668      	mov	r0, sp
20027960:	f7ff feb8 	bl	200276d4 <mbedtls_sha512_finish>
20027964:	2300      	movs	r3, #0
20027966:	461a      	mov	r2, r3
20027968:	f80d 2003 	strb.w	r2, [sp, r3]
2002796c:	3301      	adds	r3, #1
2002796e:	2bd8      	cmp	r3, #216	@ 0xd8
20027970:	d1fa      	bne.n	20027968 <mbedtls_sha512+0x88>
20027972:	b037      	add	sp, #220	@ 0xdc
20027974:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
20027978:	ed9f 4b15 	vldr	d4, [pc, #84]	@ 200279d0 <mbedtls_sha512+0xf0>
2002797c:	f20f 0b90 	addw	fp, pc, #144	@ 0x90
20027980:	e9db ab00 	ldrd	sl, fp, [fp]
20027984:	f20f 0990 	addw	r9, pc, #144	@ 0x90
20027988:	e9d9 8900 	ldrd	r8, r9, [r9]
2002798c:	a124      	add	r1, pc, #144	@ (adr r1, 20027a20 <mbedtls_sha512+0x140>)
2002798e:	e9d1 0100 	ldrd	r0, r1, [r1]
20027992:	a325      	add	r3, pc, #148	@ (adr r3, 20027a28 <mbedtls_sha512+0x148>)
20027994:	e9d3 2300 	ldrd	r2, r3, [r3]
20027998:	ed9f 5b0f 	vldr	d5, [pc, #60]	@ 200279d8 <mbedtls_sha512+0xf8>
2002799c:	ed9f 6b10 	vldr	d6, [pc, #64]	@ 200279e0 <mbedtls_sha512+0x100>
200279a0:	ed9f 7b11 	vldr	d7, [pc, #68]	@ 200279e8 <mbedtls_sha512+0x108>
200279a4:	e7be      	b.n	20027924 <mbedtls_sha512+0x44>
200279a6:	bf00      	nop
200279a8:	c1059ed8 	.word	0xc1059ed8
200279ac:	cbbb9d5d 	.word	0xcbbb9d5d
200279b0:	367cd507 	.word	0x367cd507
200279b4:	629a292a 	.word	0x629a292a
200279b8:	3070dd17 	.word	0x3070dd17
200279bc:	9159015a 	.word	0x9159015a
200279c0:	f70e5939 	.word	0xf70e5939
200279c4:	152fecd8 	.word	0x152fecd8
	...
200279d0:	f3bcc908 	.word	0xf3bcc908
200279d4:	6a09e667 	.word	0x6a09e667
200279d8:	84caa73b 	.word	0x84caa73b
200279dc:	bb67ae85 	.word	0xbb67ae85
200279e0:	fe94f82b 	.word	0xfe94f82b
200279e4:	3c6ef372 	.word	0x3c6ef372
200279e8:	5f1d36f1 	.word	0x5f1d36f1
200279ec:	a54ff53a 	.word	0xa54ff53a
200279f0:	ffc00b31 	.word	0xffc00b31
200279f4:	67332667 	.word	0x67332667
200279f8:	68581511 	.word	0x68581511
200279fc:	8eb44a87 	.word	0x8eb44a87
20027a00:	64f98fa7 	.word	0x64f98fa7
20027a04:	db0c2e0d 	.word	0xdb0c2e0d
20027a08:	befa4fa4 	.word	0xbefa4fa4
20027a0c:	47b5481d 	.word	0x47b5481d
20027a10:	ade682d1 	.word	0xade682d1
20027a14:	510e527f 	.word	0x510e527f
20027a18:	2b3e6c1f 	.word	0x2b3e6c1f
20027a1c:	9b05688c 	.word	0x9b05688c
20027a20:	fb41bd6b 	.word	0xfb41bd6b
20027a24:	1f83d9ab 	.word	0x1f83d9ab
20027a28:	137e2179 	.word	0x137e2179
20027a2c:	5be0cd19 	.word	0x5be0cd19

20027a30 <mbedtls_asn1_get_len>:
20027a30:	b570      	push	{r4, r5, r6, lr}
20027a32:	6803      	ldr	r3, [r0, #0]
20027a34:	1acd      	subs	r5, r1, r3
20027a36:	2d00      	cmp	r5, #0
20027a38:	dc02      	bgt.n	20027a40 <mbedtls_asn1_get_len+0x10>
20027a3a:	f06f 005f 	mvn.w	r0, #95	@ 0x5f
20027a3e:	bd70      	pop	{r4, r5, r6, pc}
20027a40:	f993 6000 	ldrsb.w	r6, [r3]
20027a44:	781c      	ldrb	r4, [r3, #0]
20027a46:	2e00      	cmp	r6, #0
20027a48:	db0a      	blt.n	20027a60 <mbedtls_asn1_get_len+0x30>
20027a4a:	1c5c      	adds	r4, r3, #1
20027a4c:	6004      	str	r4, [r0, #0]
20027a4e:	781b      	ldrb	r3, [r3, #0]
20027a50:	6013      	str	r3, [r2, #0]
20027a52:	6803      	ldr	r3, [r0, #0]
20027a54:	1ac9      	subs	r1, r1, r3
20027a56:	6813      	ldr	r3, [r2, #0]
20027a58:	428b      	cmp	r3, r1
20027a5a:	d8ee      	bhi.n	20027a3a <mbedtls_asn1_get_len+0xa>
20027a5c:	2000      	movs	r0, #0
20027a5e:	e7ee      	b.n	20027a3e <mbedtls_asn1_get_len+0xe>
20027a60:	f004 047f 	and.w	r4, r4, #127	@ 0x7f
20027a64:	3c01      	subs	r4, #1
20027a66:	2c03      	cmp	r4, #3
20027a68:	d82b      	bhi.n	20027ac2 <mbedtls_asn1_get_len+0x92>
20027a6a:	e8df f004 	tbb	[pc, r4]
20027a6e:	0a02      	.short	0x0a02
20027a70:	2114      	.short	0x2114
20027a72:	2d01      	cmp	r5, #1
20027a74:	d0e1      	beq.n	20027a3a <mbedtls_asn1_get_len+0xa>
20027a76:	785b      	ldrb	r3, [r3, #1]
20027a78:	6013      	str	r3, [r2, #0]
20027a7a:	6803      	ldr	r3, [r0, #0]
20027a7c:	3302      	adds	r3, #2
20027a7e:	6003      	str	r3, [r0, #0]
20027a80:	e7e7      	b.n	20027a52 <mbedtls_asn1_get_len+0x22>
20027a82:	2d02      	cmp	r5, #2
20027a84:	ddd9      	ble.n	20027a3a <mbedtls_asn1_get_len+0xa>
20027a86:	f8b3 3001 	ldrh.w	r3, [r3, #1]
20027a8a:	ba5b      	rev16	r3, r3
20027a8c:	b29b      	uxth	r3, r3
20027a8e:	6013      	str	r3, [r2, #0]
20027a90:	6803      	ldr	r3, [r0, #0]
20027a92:	3303      	adds	r3, #3
20027a94:	e7f3      	b.n	20027a7e <mbedtls_asn1_get_len+0x4e>
20027a96:	2d03      	cmp	r5, #3
20027a98:	ddcf      	ble.n	20027a3a <mbedtls_asn1_get_len+0xa>
20027a9a:	789c      	ldrb	r4, [r3, #2]
20027a9c:	785d      	ldrb	r5, [r3, #1]
20027a9e:	0224      	lsls	r4, r4, #8
20027aa0:	78db      	ldrb	r3, [r3, #3]
20027aa2:	ea44 4405 	orr.w	r4, r4, r5, lsl #16
20027aa6:	4323      	orrs	r3, r4
20027aa8:	6013      	str	r3, [r2, #0]
20027aaa:	6803      	ldr	r3, [r0, #0]
20027aac:	3304      	adds	r3, #4
20027aae:	e7e6      	b.n	20027a7e <mbedtls_asn1_get_len+0x4e>
20027ab0:	2d04      	cmp	r5, #4
20027ab2:	ddc2      	ble.n	20027a3a <mbedtls_asn1_get_len+0xa>
20027ab4:	f8d3 3001 	ldr.w	r3, [r3, #1]
20027ab8:	ba1b      	rev	r3, r3
20027aba:	6013      	str	r3, [r2, #0]
20027abc:	6803      	ldr	r3, [r0, #0]
20027abe:	3305      	adds	r3, #5
20027ac0:	e7dd      	b.n	20027a7e <mbedtls_asn1_get_len+0x4e>
20027ac2:	f06f 0063 	mvn.w	r0, #99	@ 0x63
20027ac6:	e7ba      	b.n	20027a3e <mbedtls_asn1_get_len+0xe>

20027ac8 <mbedtls_asn1_get_tag>:
20027ac8:	b470      	push	{r4, r5, r6}
20027aca:	6804      	ldr	r4, [r0, #0]
20027acc:	1b0e      	subs	r6, r1, r4
20027ace:	2e00      	cmp	r6, #0
20027ad0:	dd07      	ble.n	20027ae2 <mbedtls_asn1_get_tag+0x1a>
20027ad2:	7826      	ldrb	r6, [r4, #0]
20027ad4:	429e      	cmp	r6, r3
20027ad6:	d108      	bne.n	20027aea <mbedtls_asn1_get_tag+0x22>
20027ad8:	3401      	adds	r4, #1
20027ada:	6004      	str	r4, [r0, #0]
20027adc:	bc70      	pop	{r4, r5, r6}
20027ade:	f7ff bfa7 	b.w	20027a30 <mbedtls_asn1_get_len>
20027ae2:	f06f 005f 	mvn.w	r0, #95	@ 0x5f
20027ae6:	bc70      	pop	{r4, r5, r6}
20027ae8:	4770      	bx	lr
20027aea:	f06f 0061 	mvn.w	r0, #97	@ 0x61
20027aee:	e7fa      	b.n	20027ae6 <mbedtls_asn1_get_tag+0x1e>

20027af0 <mbedtls_asn1_get_mpi>:
20027af0:	b573      	push	{r0, r1, r4, r5, r6, lr}
20027af2:	2302      	movs	r3, #2
20027af4:	4615      	mov	r5, r2
20027af6:	aa01      	add	r2, sp, #4
20027af8:	4604      	mov	r4, r0
20027afa:	f7ff ffe5 	bl	20027ac8 <mbedtls_asn1_get_tag>
20027afe:	b940      	cbnz	r0, 20027b12 <mbedtls_asn1_get_mpi+0x22>
20027b00:	9e01      	ldr	r6, [sp, #4]
20027b02:	4628      	mov	r0, r5
20027b04:	4632      	mov	r2, r6
20027b06:	6821      	ldr	r1, [r4, #0]
20027b08:	f000 fad4 	bl	200280b4 <mbedtls_mpi_read_binary>
20027b0c:	6823      	ldr	r3, [r4, #0]
20027b0e:	4433      	add	r3, r6
20027b10:	6023      	str	r3, [r4, #0]
20027b12:	b002      	add	sp, #8
20027b14:	bd70      	pop	{r4, r5, r6, pc}

20027b16 <mbedtls_asn1_get_bitstring_null>:
20027b16:	b538      	push	{r3, r4, r5, lr}
20027b18:	2303      	movs	r3, #3
20027b1a:	4604      	mov	r4, r0
20027b1c:	4615      	mov	r5, r2
20027b1e:	f7ff ffd3 	bl	20027ac8 <mbedtls_asn1_get_tag>
20027b22:	b958      	cbnz	r0, 20027b3c <mbedtls_asn1_get_bitstring_null+0x26>
20027b24:	6813      	ldr	r3, [r2, #0]
20027b26:	1e5a      	subs	r2, r3, #1
20027b28:	2b01      	cmp	r3, #1
20027b2a:	602a      	str	r2, [r5, #0]
20027b2c:	d904      	bls.n	20027b38 <mbedtls_asn1_get_bitstring_null+0x22>
20027b2e:	6823      	ldr	r3, [r4, #0]
20027b30:	1c5a      	adds	r2, r3, #1
20027b32:	6022      	str	r2, [r4, #0]
20027b34:	781b      	ldrb	r3, [r3, #0]
20027b36:	b10b      	cbz	r3, 20027b3c <mbedtls_asn1_get_bitstring_null+0x26>
20027b38:	f06f 0067 	mvn.w	r0, #103	@ 0x67
20027b3c:	bd38      	pop	{r3, r4, r5, pc}

20027b3e <mbedtls_asn1_get_alg>:
20027b3e:	e92d 41f3 	stmdb	sp!, {r0, r1, r4, r5, r6, r7, r8, lr}
20027b42:	4690      	mov	r8, r2
20027b44:	461e      	mov	r6, r3
20027b46:	aa01      	add	r2, sp, #4
20027b48:	2330      	movs	r3, #48	@ 0x30
20027b4a:	4605      	mov	r5, r0
20027b4c:	460f      	mov	r7, r1
20027b4e:	f7ff ffbb 	bl	20027ac8 <mbedtls_asn1_get_tag>
20027b52:	4604      	mov	r4, r0
20027b54:	bb10      	cbnz	r0, 20027b9c <mbedtls_asn1_get_alg+0x5e>
20027b56:	682b      	ldr	r3, [r5, #0]
20027b58:	1aff      	subs	r7, r7, r3
20027b5a:	2f00      	cmp	r7, #0
20027b5c:	dd38      	ble.n	20027bd0 <mbedtls_asn1_get_alg+0x92>
20027b5e:	4642      	mov	r2, r8
20027b60:	781b      	ldrb	r3, [r3, #0]
20027b62:	4628      	mov	r0, r5
20027b64:	f842 3b04 	str.w	r3, [r2], #4
20027b68:	682f      	ldr	r7, [r5, #0]
20027b6a:	9b01      	ldr	r3, [sp, #4]
20027b6c:	441f      	add	r7, r3
20027b6e:	4639      	mov	r1, r7
20027b70:	2306      	movs	r3, #6
20027b72:	f7ff ffa9 	bl	20027ac8 <mbedtls_asn1_get_tag>
20027b76:	4604      	mov	r4, r0
20027b78:	b980      	cbnz	r0, 20027b9c <mbedtls_asn1_get_alg+0x5e>
20027b7a:	682b      	ldr	r3, [r5, #0]
20027b7c:	f8d8 2004 	ldr.w	r2, [r8, #4]
20027b80:	f8c8 3008 	str.w	r3, [r8, #8]
20027b84:	1899      	adds	r1, r3, r2
20027b86:	42b9      	cmp	r1, r7
20027b88:	6029      	str	r1, [r5, #0]
20027b8a:	d10b      	bne.n	20027ba4 <mbedtls_asn1_get_alg+0x66>
20027b8c:	4601      	mov	r1, r0
20027b8e:	f106 030c 	add.w	r3, r6, #12
20027b92:	4632      	mov	r2, r6
20027b94:	3601      	adds	r6, #1
20027b96:	42b3      	cmp	r3, r6
20027b98:	7011      	strb	r1, [r2, #0]
20027b9a:	d1fa      	bne.n	20027b92 <mbedtls_asn1_get_alg+0x54>
20027b9c:	4620      	mov	r0, r4
20027b9e:	b002      	add	sp, #8
20027ba0:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}
20027ba4:	5c9b      	ldrb	r3, [r3, r2]
20027ba6:	4632      	mov	r2, r6
20027ba8:	f842 3b04 	str.w	r3, [r2], #4
20027bac:	682b      	ldr	r3, [r5, #0]
20027bae:	4639      	mov	r1, r7
20027bb0:	3301      	adds	r3, #1
20027bb2:	4628      	mov	r0, r5
20027bb4:	602b      	str	r3, [r5, #0]
20027bb6:	f7ff ff3b 	bl	20027a30 <mbedtls_asn1_get_len>
20027bba:	b960      	cbnz	r0, 20027bd6 <mbedtls_asn1_get_alg+0x98>
20027bbc:	682b      	ldr	r3, [r5, #0]
20027bbe:	6872      	ldr	r2, [r6, #4]
20027bc0:	60b3      	str	r3, [r6, #8]
20027bc2:	4413      	add	r3, r2
20027bc4:	42bb      	cmp	r3, r7
20027bc6:	bf18      	it	ne
20027bc8:	f06f 0465 	mvnne.w	r4, #101	@ 0x65
20027bcc:	602b      	str	r3, [r5, #0]
20027bce:	e7e5      	b.n	20027b9c <mbedtls_asn1_get_alg+0x5e>
20027bd0:	f06f 045f 	mvn.w	r4, #95	@ 0x5f
20027bd4:	e7e2      	b.n	20027b9c <mbedtls_asn1_get_alg+0x5e>
20027bd6:	4604      	mov	r4, r0
20027bd8:	e7e0      	b.n	20027b9c <mbedtls_asn1_get_alg+0x5e>

20027bda <mpi_sub_hlp>:
20027bda:	2300      	movs	r3, #0
20027bdc:	b5f0      	push	{r4, r5, r6, r7, lr}
20027bde:	461c      	mov	r4, r3
20027be0:	1f16      	subs	r6, r2, #4
20027be2:	4284      	cmp	r4, r0
20027be4:	d103      	bne.n	20027bee <mpi_sub_hlp+0x14>
20027be6:	eb02 0284 	add.w	r2, r2, r4, lsl #2
20027bea:	b9b3      	cbnz	r3, 20027c1a <mpi_sub_hlp+0x40>
20027bec:	bdf0      	pop	{r4, r5, r6, r7, pc}
20027bee:	f856 cf04 	ldr.w	ip, [r6, #4]!
20027bf2:	ebac 0503 	sub.w	r5, ip, r3
20027bf6:	6035      	str	r5, [r6, #0]
20027bf8:	f851 7024 	ldr.w	r7, [r1, r4, lsl #2]
20027bfc:	3401      	adds	r4, #1
20027bfe:	42bd      	cmp	r5, r7
20027c00:	bf2c      	ite	cs
20027c02:	f04f 0e00 	movcs.w	lr, #0
20027c06:	f04f 0e01 	movcc.w	lr, #1
20027c0a:	1bed      	subs	r5, r5, r7
20027c0c:	459c      	cmp	ip, r3
20027c0e:	bf2c      	ite	cs
20027c10:	4673      	movcs	r3, lr
20027c12:	f10e 0301 	addcc.w	r3, lr, #1
20027c16:	6035      	str	r5, [r6, #0]
20027c18:	e7e3      	b.n	20027be2 <mpi_sub_hlp+0x8>
20027c1a:	6811      	ldr	r1, [r2, #0]
20027c1c:	1ac8      	subs	r0, r1, r3
20027c1e:	4299      	cmp	r1, r3
20027c20:	bf2c      	ite	cs
20027c22:	2300      	movcs	r3, #0
20027c24:	2301      	movcc	r3, #1
20027c26:	f842 0b04 	str.w	r0, [r2], #4
20027c2a:	e7de      	b.n	20027bea <mpi_sub_hlp+0x10>

20027c2c <mpi_mul_hlp>:
20027c2c:	e92d 41f0 	stmdb	sp!, {r4, r5, r6, r7, r8, lr}
20027c30:	4694      	mov	ip, r2
20027c32:	460e      	mov	r6, r1
20027c34:	4686      	mov	lr, r0
20027c36:	2500      	movs	r5, #0
20027c38:	f102 0440 	add.w	r4, r2, #64	@ 0x40
20027c3c:	f1be 0f0f 	cmp.w	lr, #15
20027c40:	f854 7c40 	ldr.w	r7, [r4, #-64]
20027c44:	f106 0640 	add.w	r6, r6, #64	@ 0x40
20027c48:	f104 0440 	add.w	r4, r4, #64	@ 0x40
20027c4c:	d87c      	bhi.n	20027d48 <mpi_mul_hlp+0x11c>
20027c4e:	f06f 080f 	mvn.w	r8, #15
20027c52:	0902      	lsrs	r2, r0, #4
20027c54:	fb08 0002 	mla	r0, r8, r2, r0
20027c58:	2807      	cmp	r0, #7
20027c5a:	ea4f 1e82 	mov.w	lr, r2, lsl #6
20027c5e:	eb0c 1482 	add.w	r4, ip, r2, lsl #6
20027c62:	eb01 1682 	add.w	r6, r1, r2, lsl #6
20027c66:	d95b      	bls.n	20027d20 <mpi_mul_hlp+0xf4>
20027c68:	f851 100e 	ldr.w	r1, [r1, lr]
20027c6c:	3808      	subs	r0, #8
20027c6e:	fba1 1203 	umull	r1, r2, r1, r3
20027c72:	1869      	adds	r1, r5, r1
20027c74:	f142 0200 	adc.w	r2, r2, #0
20027c78:	187f      	adds	r7, r7, r1
20027c7a:	f84c 700e 	str.w	r7, [ip, lr]
20027c7e:	6871      	ldr	r1, [r6, #4]
20027c80:	f142 0200 	adc.w	r2, r2, #0
20027c84:	fba1 5103 	umull	r5, r1, r1, r3
20027c88:	1952      	adds	r2, r2, r5
20027c8a:	6865      	ldr	r5, [r4, #4]
20027c8c:	f141 0100 	adc.w	r1, r1, #0
20027c90:	1952      	adds	r2, r2, r5
20027c92:	6062      	str	r2, [r4, #4]
20027c94:	68b2      	ldr	r2, [r6, #8]
20027c96:	f141 0100 	adc.w	r1, r1, #0
20027c9a:	fba2 5203 	umull	r5, r2, r2, r3
20027c9e:	1949      	adds	r1, r1, r5
20027ca0:	68a5      	ldr	r5, [r4, #8]
20027ca2:	f142 0200 	adc.w	r2, r2, #0
20027ca6:	1949      	adds	r1, r1, r5
20027ca8:	60a1      	str	r1, [r4, #8]
20027caa:	68f1      	ldr	r1, [r6, #12]
20027cac:	f142 0200 	adc.w	r2, r2, #0
20027cb0:	fba1 5103 	umull	r5, r1, r1, r3
20027cb4:	1952      	adds	r2, r2, r5
20027cb6:	68e5      	ldr	r5, [r4, #12]
20027cb8:	f141 0100 	adc.w	r1, r1, #0
20027cbc:	1952      	adds	r2, r2, r5
20027cbe:	60e2      	str	r2, [r4, #12]
20027cc0:	6932      	ldr	r2, [r6, #16]
20027cc2:	f141 0100 	adc.w	r1, r1, #0
20027cc6:	fba2 5203 	umull	r5, r2, r2, r3
20027cca:	1949      	adds	r1, r1, r5
20027ccc:	6925      	ldr	r5, [r4, #16]
20027cce:	f142 0200 	adc.w	r2, r2, #0
20027cd2:	1949      	adds	r1, r1, r5
20027cd4:	6121      	str	r1, [r4, #16]
20027cd6:	6971      	ldr	r1, [r6, #20]
20027cd8:	f142 0200 	adc.w	r2, r2, #0
20027cdc:	fba1 5103 	umull	r5, r1, r1, r3
20027ce0:	1952      	adds	r2, r2, r5
20027ce2:	6965      	ldr	r5, [r4, #20]
20027ce4:	f141 0100 	adc.w	r1, r1, #0
20027ce8:	1952      	adds	r2, r2, r5
20027cea:	6162      	str	r2, [r4, #20]
20027cec:	69b2      	ldr	r2, [r6, #24]
20027cee:	f141 0100 	adc.w	r1, r1, #0
20027cf2:	fba2 5203 	umull	r5, r2, r2, r3
20027cf6:	1949      	adds	r1, r1, r5
20027cf8:	69a5      	ldr	r5, [r4, #24]
20027cfa:	f142 0200 	adc.w	r2, r2, #0
20027cfe:	1949      	adds	r1, r1, r5
20027d00:	61a1      	str	r1, [r4, #24]
20027d02:	69f1      	ldr	r1, [r6, #28]
20027d04:	f142 0200 	adc.w	r2, r2, #0
20027d08:	fba1 1503 	umull	r1, r5, r1, r3
20027d0c:	1852      	adds	r2, r2, r1
20027d0e:	69e1      	ldr	r1, [r4, #28]
20027d10:	f145 0500 	adc.w	r5, r5, #0
20027d14:	1852      	adds	r2, r2, r1
20027d16:	61e2      	str	r2, [r4, #28]
20027d18:	f145 0500 	adc.w	r5, r5, #0
20027d1c:	3420      	adds	r4, #32
20027d1e:	3620      	adds	r6, #32
20027d20:	4627      	mov	r7, r4
20027d22:	ea4f 0c80 	mov.w	ip, r0, lsl #2
20027d26:	eb06 0080 	add.w	r0, r6, r0, lsl #2
20027d2a:	42b0      	cmp	r0, r6
20027d2c:	f857 1b04 	ldr.w	r1, [r7], #4
20027d30:	f040 80eb 	bne.w	20027f0a <mpi_mul_hlp+0x2de>
20027d34:	4464      	add	r4, ip
20027d36:	6823      	ldr	r3, [r4, #0]
20027d38:	195b      	adds	r3, r3, r5
20027d3a:	f844 3b04 	str.w	r3, [r4], #4
20027d3e:	f04f 0501 	mov.w	r5, #1
20027d42:	d2f8      	bcs.n	20027d36 <mpi_mul_hlp+0x10a>
20027d44:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}
20027d48:	f856 2c40 	ldr.w	r2, [r6, #-64]
20027d4c:	f1ae 0e10 	sub.w	lr, lr, #16
20027d50:	fba2 2803 	umull	r2, r8, r2, r3
20027d54:	18aa      	adds	r2, r5, r2
20027d56:	f148 0500 	adc.w	r5, r8, #0
20027d5a:	18ba      	adds	r2, r7, r2
20027d5c:	f844 2c80 	str.w	r2, [r4, #-128]
20027d60:	f856 2c3c 	ldr.w	r2, [r6, #-60]
20027d64:	f145 0500 	adc.w	r5, r5, #0
20027d68:	fba2 7203 	umull	r7, r2, r2, r3
20027d6c:	19ef      	adds	r7, r5, r7
20027d6e:	f854 5c7c 	ldr.w	r5, [r4, #-124]
20027d72:	f142 0200 	adc.w	r2, r2, #0
20027d76:	19ed      	adds	r5, r5, r7
20027d78:	f844 5c7c 	str.w	r5, [r4, #-124]
20027d7c:	f856 5c38 	ldr.w	r5, [r6, #-56]
20027d80:	f142 0200 	adc.w	r2, r2, #0
20027d84:	fba5 7503 	umull	r7, r5, r5, r3
20027d88:	19d7      	adds	r7, r2, r7
20027d8a:	f854 2c78 	ldr.w	r2, [r4, #-120]
20027d8e:	f145 0500 	adc.w	r5, r5, #0
20027d92:	19d2      	adds	r2, r2, r7
20027d94:	f844 2c78 	str.w	r2, [r4, #-120]
20027d98:	f856 2c34 	ldr.w	r2, [r6, #-52]
20027d9c:	f145 0500 	adc.w	r5, r5, #0
20027da0:	fba2 7203 	umull	r7, r2, r2, r3
20027da4:	19ef      	adds	r7, r5, r7
20027da6:	f854 5c74 	ldr.w	r5, [r4, #-116]
20027daa:	f142 0200 	adc.w	r2, r2, #0
20027dae:	19ed      	adds	r5, r5, r7
20027db0:	f844 5c74 	str.w	r5, [r4, #-116]
20027db4:	f856 5c30 	ldr.w	r5, [r6, #-48]
20027db8:	f142 0200 	adc.w	r2, r2, #0
20027dbc:	fba5 7503 	umull	r7, r5, r5, r3
20027dc0:	19d7      	adds	r7, r2, r7
20027dc2:	f854 2c70 	ldr.w	r2, [r4, #-112]
20027dc6:	f145 0500 	adc.w	r5, r5, #0
20027dca:	19d2      	adds	r2, r2, r7
20027dcc:	f844 2c70 	str.w	r2, [r4, #-112]
20027dd0:	f856 2c2c 	ldr.w	r2, [r6, #-44]
20027dd4:	f145 0500 	adc.w	r5, r5, #0
20027dd8:	fba2 7203 	umull	r7, r2, r2, r3
20027ddc:	19ef      	adds	r7, r5, r7
20027dde:	f854 5c6c 	ldr.w	r5, [r4, #-108]
20027de2:	f142 0200 	adc.w	r2, r2, #0
20027de6:	19ed      	adds	r5, r5, r7
20027de8:	f844 5c6c 	str.w	r5, [r4, #-108]
20027dec:	f856 5c28 	ldr.w	r5, [r6, #-40]
20027df0:	f142 0200 	adc.w	r2, r2, #0
20027df4:	fba5 7503 	umull	r7, r5, r5, r3
20027df8:	19d7      	adds	r7, r2, r7
20027dfa:	f854 2c68 	ldr.w	r2, [r4, #-104]
20027dfe:	f145 0500 	adc.w	r5, r5, #0
20027e02:	19d2      	adds	r2, r2, r7
20027e04:	f844 2c68 	str.w	r2, [r4, #-104]
20027e08:	f856 2c24 	ldr.w	r2, [r6, #-36]
20027e0c:	f145 0500 	adc.w	r5, r5, #0
20027e10:	fba2 7203 	umull	r7, r2, r2, r3
20027e14:	19ef      	adds	r7, r5, r7
20027e16:	f854 5c64 	ldr.w	r5, [r4, #-100]
20027e1a:	f142 0200 	adc.w	r2, r2, #0
20027e1e:	19ed      	adds	r5, r5, r7
20027e20:	f844 5c64 	str.w	r5, [r4, #-100]
20027e24:	f856 5c20 	ldr.w	r5, [r6, #-32]
20027e28:	f142 0200 	adc.w	r2, r2, #0
20027e2c:	fba5 7503 	umull	r7, r5, r5, r3
20027e30:	19d7      	adds	r7, r2, r7
20027e32:	f854 2c60 	ldr.w	r2, [r4, #-96]
20027e36:	f145 0500 	adc.w	r5, r5, #0
20027e3a:	19d2      	adds	r2, r2, r7
20027e3c:	f844 2c60 	str.w	r2, [r4, #-96]
20027e40:	f856 2c1c 	ldr.w	r2, [r6, #-28]
20027e44:	f145 0500 	adc.w	r5, r5, #0
20027e48:	fba2 7203 	umull	r7, r2, r2, r3
20027e4c:	19ef      	adds	r7, r5, r7
20027e4e:	f854 5c5c 	ldr.w	r5, [r4, #-92]
20027e52:	f142 0200 	adc.w	r2, r2, #0
20027e56:	19ed      	adds	r5, r5, r7
20027e58:	f844 5c5c 	str.w	r5, [r4, #-92]
20027e5c:	f856 5c18 	ldr.w	r5, [r6, #-24]
20027e60:	f142 0200 	adc.w	r2, r2, #0
20027e64:	fba5 7503 	umull	r7, r5, r5, r3
20027e68:	19d7      	adds	r7, r2, r7
20027e6a:	f854 2c58 	ldr.w	r2, [r4, #-88]
20027e6e:	f145 0500 	adc.w	r5, r5, #0
20027e72:	19d2      	adds	r2, r2, r7
20027e74:	f844 2c58 	str.w	r2, [r4, #-88]
20027e78:	f856 2c14 	ldr.w	r2, [r6, #-20]
20027e7c:	f145 0500 	adc.w	r5, r5, #0
20027e80:	fba2 7203 	umull	r7, r2, r2, r3
20027e84:	19ef      	adds	r7, r5, r7
20027e86:	f854 5c54 	ldr.w	r5, [r4, #-84]
20027e8a:	f142 0200 	adc.w	r2, r2, #0
20027e8e:	19ed      	adds	r5, r5, r7
20027e90:	f844 5c54 	str.w	r5, [r4, #-84]
20027e94:	f856 5c10 	ldr.w	r5, [r6, #-16]
20027e98:	f142 0200 	adc.w	r2, r2, #0
20027e9c:	fba5 7503 	umull	r7, r5, r5, r3
20027ea0:	19d7      	adds	r7, r2, r7
20027ea2:	f854 2c50 	ldr.w	r2, [r4, #-80]
20027ea6:	f145 0500 	adc.w	r5, r5, #0
20027eaa:	19d2      	adds	r2, r2, r7
20027eac:	f844 2c50 	str.w	r2, [r4, #-80]
20027eb0:	f856 2c0c 	ldr.w	r2, [r6, #-12]
20027eb4:	f145 0500 	adc.w	r5, r5, #0
20027eb8:	fba2 7203 	umull	r7, r2, r2, r3
20027ebc:	19ef      	adds	r7, r5, r7
20027ebe:	f854 5c4c 	ldr.w	r5, [r4, #-76]
20027ec2:	f142 0200 	adc.w	r2, r2, #0
20027ec6:	19ed      	adds	r5, r5, r7
20027ec8:	f844 5c4c 	str.w	r5, [r4, #-76]
20027ecc:	f856 5c08 	ldr.w	r5, [r6, #-8]
20027ed0:	f142 0200 	adc.w	r2, r2, #0
20027ed4:	fba5 5703 	umull	r5, r7, r5, r3
20027ed8:	1955      	adds	r5, r2, r5
20027eda:	f854 2c48 	ldr.w	r2, [r4, #-72]
20027ede:	f147 0700 	adc.w	r7, r7, #0
20027ee2:	1952      	adds	r2, r2, r5
20027ee4:	f844 2c48 	str.w	r2, [r4, #-72]
20027ee8:	f856 2c04 	ldr.w	r2, [r6, #-4]
20027eec:	f147 0700 	adc.w	r7, r7, #0
20027ef0:	fba2 2503 	umull	r2, r5, r2, r3
20027ef4:	18bf      	adds	r7, r7, r2
20027ef6:	f854 2c44 	ldr.w	r2, [r4, #-68]
20027efa:	f145 0500 	adc.w	r5, r5, #0
20027efe:	19d2      	adds	r2, r2, r7
20027f00:	f145 0500 	adc.w	r5, r5, #0
20027f04:	f844 2c44 	str.w	r2, [r4, #-68]
20027f08:	e698      	b.n	20027c3c <mpi_mul_hlp+0x10>
20027f0a:	f856 2b04 	ldr.w	r2, [r6], #4
20027f0e:	fba2 2e03 	umull	r2, lr, r2, r3
20027f12:	18aa      	adds	r2, r5, r2
20027f14:	f14e 0500 	adc.w	r5, lr, #0
20027f18:	1889      	adds	r1, r1, r2
20027f1a:	f145 0500 	adc.w	r5, r5, #0
20027f1e:	f847 1c04 	str.w	r1, [r7, #-4]
20027f22:	e702      	b.n	20027d2a <mpi_mul_hlp+0xfe>

20027f24 <mbedtls_mpi_init>:
20027f24:	b120      	cbz	r0, 20027f30 <mbedtls_mpi_init+0xc>
20027f26:	2300      	movs	r3, #0
20027f28:	2201      	movs	r2, #1
20027f2a:	e9c0 2300 	strd	r2, r3, [r0]
20027f2e:	6083      	str	r3, [r0, #8]
20027f30:	4770      	bx	lr

20027f32 <mbedtls_mpi_free>:
20027f32:	b510      	push	{r4, lr}
20027f34:	4604      	mov	r4, r0
20027f36:	b168      	cbz	r0, 20027f54 <mbedtls_mpi_free+0x22>
20027f38:	6883      	ldr	r3, [r0, #8]
20027f3a:	b133      	cbz	r3, 20027f4a <mbedtls_mpi_free+0x18>
20027f3c:	2100      	movs	r1, #0
20027f3e:	6842      	ldr	r2, [r0, #4]
20027f40:	3a01      	subs	r2, #1
20027f42:	d208      	bcs.n	20027f56 <mbedtls_mpi_free+0x24>
20027f44:	68a0      	ldr	r0, [r4, #8]
20027f46:	f002 fcbf 	bl	2002a8c8 <free>
20027f4a:	2300      	movs	r3, #0
20027f4c:	2201      	movs	r2, #1
20027f4e:	e9c4 2300 	strd	r2, r3, [r4]
20027f52:	60a3      	str	r3, [r4, #8]
20027f54:	bd10      	pop	{r4, pc}
20027f56:	f843 1b04 	str.w	r1, [r3], #4
20027f5a:	e7f1      	b.n	20027f40 <mbedtls_mpi_free+0xe>

20027f5c <mbedtls_mpi_grow>:
20027f5c:	f242 7310 	movw	r3, #10000	@ 0x2710
20027f60:	4299      	cmp	r1, r3
20027f62:	e92d 41f0 	stmdb	sp!, {r4, r5, r6, r7, r8, lr}
20027f66:	4605      	mov	r5, r0
20027f68:	460f      	mov	r7, r1
20027f6a:	d903      	bls.n	20027f74 <mbedtls_mpi_grow+0x18>
20027f6c:	f06f 000f 	mvn.w	r0, #15
20027f70:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}
20027f74:	6846      	ldr	r6, [r0, #4]
20027f76:	428e      	cmp	r6, r1
20027f78:	d301      	bcc.n	20027f7e <mbedtls_mpi_grow+0x22>
20027f7a:	2000      	movs	r0, #0
20027f7c:	e7f8      	b.n	20027f70 <mbedtls_mpi_grow+0x14>
20027f7e:	2104      	movs	r1, #4
20027f80:	4638      	mov	r0, r7
20027f82:	f002 fc85 	bl	2002a890 <calloc>
20027f86:	4680      	mov	r8, r0
20027f88:	2800      	cmp	r0, #0
20027f8a:	d0ef      	beq.n	20027f6c <mbedtls_mpi_grow+0x10>
20027f8c:	68ac      	ldr	r4, [r5, #8]
20027f8e:	b15c      	cbz	r4, 20027fa8 <mbedtls_mpi_grow+0x4c>
20027f90:	00b6      	lsls	r6, r6, #2
20027f92:	4632      	mov	r2, r6
20027f94:	4621      	mov	r1, r4
20027f96:	f002 fd77 	bl	2002aa88 <memcpy>
20027f9a:	2300      	movs	r3, #0
20027f9c:	4426      	add	r6, r4
20027f9e:	42b4      	cmp	r4, r6
20027fa0:	d105      	bne.n	20027fae <mbedtls_mpi_grow+0x52>
20027fa2:	68a8      	ldr	r0, [r5, #8]
20027fa4:	f002 fc90 	bl	2002a8c8 <free>
20027fa8:	e9c5 7801 	strd	r7, r8, [r5, #4]
20027fac:	e7e5      	b.n	20027f7a <mbedtls_mpi_grow+0x1e>
20027fae:	f844 3b04 	str.w	r3, [r4], #4
20027fb2:	e7f4      	b.n	20027f9e <mbedtls_mpi_grow+0x42>

20027fb4 <mbedtls_mpi_copy>:
20027fb4:	4288      	cmp	r0, r1
20027fb6:	b570      	push	{r4, r5, r6, lr}
20027fb8:	4605      	mov	r5, r0
20027fba:	460e      	mov	r6, r1
20027fbc:	d003      	beq.n	20027fc6 <mbedtls_mpi_copy+0x12>
20027fbe:	688b      	ldr	r3, [r1, #8]
20027fc0:	b91b      	cbnz	r3, 20027fca <mbedtls_mpi_copy+0x16>
20027fc2:	f7ff ffb6 	bl	20027f32 <mbedtls_mpi_free>
20027fc6:	2000      	movs	r0, #0
20027fc8:	bd70      	pop	{r4, r5, r6, pc}
20027fca:	684a      	ldr	r2, [r1, #4]
20027fcc:	3a01      	subs	r2, #1
20027fce:	b11a      	cbz	r2, 20027fd8 <mbedtls_mpi_copy+0x24>
20027fd0:	f853 1022 	ldr.w	r1, [r3, r2, lsl #2]
20027fd4:	2900      	cmp	r1, #0
20027fd6:	d0f9      	beq.n	20027fcc <mbedtls_mpi_copy+0x18>
20027fd8:	6833      	ldr	r3, [r6, #0]
20027fda:	1c54      	adds	r4, r2, #1
20027fdc:	4621      	mov	r1, r4
20027fde:	4628      	mov	r0, r5
20027fe0:	602b      	str	r3, [r5, #0]
20027fe2:	f7ff ffbb 	bl	20027f5c <mbedtls_mpi_grow>
20027fe6:	4601      	mov	r1, r0
20027fe8:	b950      	cbnz	r0, 20028000 <mbedtls_mpi_copy+0x4c>
20027fea:	686a      	ldr	r2, [r5, #4]
20027fec:	68a8      	ldr	r0, [r5, #8]
20027fee:	0092      	lsls	r2, r2, #2
20027ff0:	f002 fd30 	bl	2002aa54 <memset>
20027ff4:	68b1      	ldr	r1, [r6, #8]
20027ff6:	68a8      	ldr	r0, [r5, #8]
20027ff8:	00a2      	lsls	r2, r4, #2
20027ffa:	f002 fd45 	bl	2002aa88 <memcpy>
20027ffe:	e7e2      	b.n	20027fc6 <mbedtls_mpi_copy+0x12>
20028000:	f06f 000f 	mvn.w	r0, #15
20028004:	e7e0      	b.n	20027fc8 <mbedtls_mpi_copy+0x14>

20028006 <mbedtls_mpi_lset>:
20028006:	b570      	push	{r4, r5, r6, lr}
20028008:	460e      	mov	r6, r1
2002800a:	2101      	movs	r1, #1
2002800c:	4604      	mov	r4, r0
2002800e:	f7ff ffa5 	bl	20027f5c <mbedtls_mpi_grow>
20028012:	4605      	mov	r5, r0
20028014:	b988      	cbnz	r0, 2002803a <mbedtls_mpi_lset+0x34>
20028016:	6862      	ldr	r2, [r4, #4]
20028018:	4601      	mov	r1, r0
2002801a:	0092      	lsls	r2, r2, #2
2002801c:	68a0      	ldr	r0, [r4, #8]
2002801e:	f002 fd19 	bl	2002aa54 <memset>
20028022:	68a3      	ldr	r3, [r4, #8]
20028024:	ea86 72e6 	eor.w	r2, r6, r6, asr #31
20028028:	2e00      	cmp	r6, #0
2002802a:	eba2 72e6 	sub.w	r2, r2, r6, asr #31
2002802e:	601a      	str	r2, [r3, #0]
20028030:	bfac      	ite	ge
20028032:	2301      	movge	r3, #1
20028034:	f04f 33ff 	movlt.w	r3, #4294967295
20028038:	6023      	str	r3, [r4, #0]
2002803a:	4628      	mov	r0, r5
2002803c:	bd70      	pop	{r4, r5, r6, pc}

2002803e <mbedtls_mpi_lsb>:
2002803e:	2300      	movs	r3, #0
20028040:	4619      	mov	r1, r3
20028042:	b570      	push	{r4, r5, r6, lr}
20028044:	6844      	ldr	r4, [r0, #4]
20028046:	428c      	cmp	r4, r1
20028048:	d101      	bne.n	2002804e <mbedtls_mpi_lsb+0x10>
2002804a:	2000      	movs	r0, #0
2002804c:	e008      	b.n	20028060 <mbedtls_mpi_lsb+0x22>
2002804e:	6882      	ldr	r2, [r0, #8]
20028050:	f852 5021 	ldr.w	r5, [r2, r1, lsl #2]
20028054:	2200      	movs	r2, #0
20028056:	fa25 f602 	lsr.w	r6, r5, r2
2002805a:	07f6      	lsls	r6, r6, #31
2002805c:	d501      	bpl.n	20028062 <mbedtls_mpi_lsb+0x24>
2002805e:	1898      	adds	r0, r3, r2
20028060:	bd70      	pop	{r4, r5, r6, pc}
20028062:	3201      	adds	r2, #1
20028064:	2a20      	cmp	r2, #32
20028066:	d1f6      	bne.n	20028056 <mbedtls_mpi_lsb+0x18>
20028068:	3320      	adds	r3, #32
2002806a:	3101      	adds	r1, #1
2002806c:	e7eb      	b.n	20028046 <mbedtls_mpi_lsb+0x8>

2002806e <mbedtls_mpi_bitlen>:
2002806e:	4602      	mov	r2, r0
20028070:	6840      	ldr	r0, [r0, #4]
20028072:	b188      	cbz	r0, 20028098 <mbedtls_mpi_bitlen+0x2a>
20028074:	6891      	ldr	r1, [r2, #8]
20028076:	1e43      	subs	r3, r0, #1
20028078:	b97b      	cbnz	r3, 2002809a <mbedtls_mpi_bitlen+0x2c>
2002807a:	461a      	mov	r2, r3
2002807c:	5889      	ldr	r1, [r1, r2]
2002807e:	2000      	movs	r0, #0
20028080:	f04f 4200 	mov.w	r2, #2147483648	@ 0x80000000
20028084:	4211      	tst	r1, r2
20028086:	d104      	bne.n	20028092 <mbedtls_mpi_bitlen+0x24>
20028088:	3001      	adds	r0, #1
2002808a:	2820      	cmp	r0, #32
2002808c:	ea4f 0252 	mov.w	r2, r2, lsr #1
20028090:	d1f8      	bne.n	20028084 <mbedtls_mpi_bitlen+0x16>
20028092:	3301      	adds	r3, #1
20028094:	ebc0 1043 	rsb	r0, r0, r3, lsl #5
20028098:	4770      	bx	lr
2002809a:	f851 0023 	ldr.w	r0, [r1, r3, lsl #2]
2002809e:	009a      	lsls	r2, r3, #2
200280a0:	2800      	cmp	r0, #0
200280a2:	d1eb      	bne.n	2002807c <mbedtls_mpi_bitlen+0xe>
200280a4:	3b01      	subs	r3, #1
200280a6:	e7e7      	b.n	20028078 <mbedtls_mpi_bitlen+0xa>

200280a8 <mbedtls_mpi_size>:
200280a8:	b508      	push	{r3, lr}
200280aa:	f7ff ffe0 	bl	2002806e <mbedtls_mpi_bitlen>
200280ae:	3007      	adds	r0, #7
200280b0:	08c0      	lsrs	r0, r0, #3
200280b2:	bd08      	pop	{r3, pc}

200280b4 <mbedtls_mpi_read_binary>:
200280b4:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
200280b6:	4607      	mov	r7, r0
200280b8:	460c      	mov	r4, r1
200280ba:	4616      	mov	r6, r2
200280bc:	2500      	movs	r5, #0
200280be:	42b5      	cmp	r5, r6
200280c0:	d001      	beq.n	200280c6 <mbedtls_mpi_read_binary+0x12>
200280c2:	5d63      	ldrb	r3, [r4, r5]
200280c4:	b173      	cbz	r3, 200280e4 <mbedtls_mpi_read_binary+0x30>
200280c6:	1b71      	subs	r1, r6, r5
200280c8:	f011 0303 	ands.w	r3, r1, #3
200280cc:	bf18      	it	ne
200280ce:	2301      	movne	r3, #1
200280d0:	4638      	mov	r0, r7
200280d2:	eb03 0191 	add.w	r1, r3, r1, lsr #2
200280d6:	f7ff ff41 	bl	20027f5c <mbedtls_mpi_grow>
200280da:	4601      	mov	r1, r0
200280dc:	b120      	cbz	r0, 200280e8 <mbedtls_mpi_read_binary+0x34>
200280de:	f06f 000f 	mvn.w	r0, #15
200280e2:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
200280e4:	3501      	adds	r5, #1
200280e6:	e7ea      	b.n	200280be <mbedtls_mpi_read_binary+0xa>
200280e8:	4638      	mov	r0, r7
200280ea:	f7ff ff8c 	bl	20028006 <mbedtls_mpi_lset>
200280ee:	2800      	cmp	r0, #0
200280f0:	d1f5      	bne.n	200280de <mbedtls_mpi_read_binary+0x2a>
200280f2:	4603      	mov	r3, r0
200280f4:	4434      	add	r4, r6
200280f6:	1af2      	subs	r2, r6, r3
200280f8:	4295      	cmp	r5, r2
200280fa:	d2f2      	bcs.n	200280e2 <mbedtls_mpi_read_binary+0x2e>
200280fc:	f8d7 e008 	ldr.w	lr, [r7, #8]
20028100:	f814 1d01 	ldrb.w	r1, [r4, #-1]!
20028104:	00da      	lsls	r2, r3, #3
20028106:	f023 0c03 	bic.w	ip, r3, #3
2002810a:	f002 0218 	and.w	r2, r2, #24
2002810e:	4091      	lsls	r1, r2
20028110:	f85e 200c 	ldr.w	r2, [lr, ip]
20028114:	3301      	adds	r3, #1
20028116:	430a      	orrs	r2, r1
20028118:	f84e 200c 	str.w	r2, [lr, ip]
2002811c:	e7eb      	b.n	200280f6 <mbedtls_mpi_read_binary+0x42>

2002811e <mbedtls_mpi_write_binary>:
2002811e:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
20028120:	4615      	mov	r5, r2
20028122:	4607      	mov	r7, r0
20028124:	460c      	mov	r4, r1
20028126:	f7ff ffbf 	bl	200280a8 <mbedtls_mpi_size>
2002812a:	42a8      	cmp	r0, r5
2002812c:	4606      	mov	r6, r0
2002812e:	d816      	bhi.n	2002815e <mbedtls_mpi_write_binary+0x40>
20028130:	4620      	mov	r0, r4
20028132:	462a      	mov	r2, r5
20028134:	2100      	movs	r1, #0
20028136:	f002 fc8d 	bl	2002aa54 <memset>
2002813a:	2300      	movs	r3, #0
2002813c:	442c      	add	r4, r5
2002813e:	42b3      	cmp	r3, r6
20028140:	d101      	bne.n	20028146 <mbedtls_mpi_write_binary+0x28>
20028142:	2000      	movs	r0, #0
20028144:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
20028146:	68b8      	ldr	r0, [r7, #8]
20028148:	f023 0203 	bic.w	r2, r3, #3
2002814c:	5882      	ldr	r2, [r0, r2]
2002814e:	00d9      	lsls	r1, r3, #3
20028150:	f001 0118 	and.w	r1, r1, #24
20028154:	40ca      	lsrs	r2, r1
20028156:	f804 2d01 	strb.w	r2, [r4, #-1]!
2002815a:	3301      	adds	r3, #1
2002815c:	e7ef      	b.n	2002813e <mbedtls_mpi_write_binary+0x20>
2002815e:	f06f 0007 	mvn.w	r0, #7
20028162:	e7ef      	b.n	20028144 <mbedtls_mpi_write_binary+0x26>

20028164 <mbedtls_mpi_shift_l>:
20028164:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
20028166:	4605      	mov	r5, r0
20028168:	460e      	mov	r6, r1
2002816a:	094c      	lsrs	r4, r1, #5
2002816c:	f001 071f 	and.w	r7, r1, #31
20028170:	f7ff ff7d 	bl	2002806e <mbedtls_mpi_bitlen>
20028174:	686b      	ldr	r3, [r5, #4]
20028176:	4430      	add	r0, r6
20028178:	ebb0 1f43 	cmp.w	r0, r3, lsl #5
2002817c:	d805      	bhi.n	2002818a <mbedtls_mpi_shift_l+0x26>
2002817e:	2e1f      	cmp	r6, #31
20028180:	d811      	bhi.n	200281a6 <mbedtls_mpi_shift_l+0x42>
20028182:	2f00      	cmp	r7, #0
20028184:	d143      	bne.n	2002820e <mbedtls_mpi_shift_l+0xaa>
20028186:	2000      	movs	r0, #0
20028188:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
2002818a:	f010 011f 	ands.w	r1, r0, #31
2002818e:	bf18      	it	ne
20028190:	2101      	movne	r1, #1
20028192:	eb01 1150 	add.w	r1, r1, r0, lsr #5
20028196:	4628      	mov	r0, r5
20028198:	f7ff fee0 	bl	20027f5c <mbedtls_mpi_grow>
2002819c:	2800      	cmp	r0, #0
2002819e:	d0ee      	beq.n	2002817e <mbedtls_mpi_shift_l+0x1a>
200281a0:	f06f 000f 	mvn.w	r0, #15
200281a4:	e7f0      	b.n	20028188 <mbedtls_mpi_shift_l+0x24>
200281a6:	f06f 0003 	mvn.w	r0, #3
200281aa:	686a      	ldr	r2, [r5, #4]
200281ac:	4360      	muls	r0, r4
200281ae:	4611      	mov	r1, r2
200281b0:	0093      	lsls	r3, r2, #2
200281b2:	42a1      	cmp	r1, r4
200281b4:	f1a3 0304 	sub.w	r3, r3, #4
200281b8:	d80c      	bhi.n	200281d4 <mbedtls_mpi_shift_l+0x70>
200281ba:	1aa3      	subs	r3, r4, r2
200281bc:	4294      	cmp	r4, r2
200281be:	bf88      	it	hi
200281c0:	2300      	movhi	r3, #0
200281c2:	4413      	add	r3, r2
200281c4:	2200      	movs	r2, #0
200281c6:	009b      	lsls	r3, r3, #2
200281c8:	3b04      	subs	r3, #4
200281ca:	1d19      	adds	r1, r3, #4
200281cc:	d0d9      	beq.n	20028182 <mbedtls_mpi_shift_l+0x1e>
200281ce:	68a9      	ldr	r1, [r5, #8]
200281d0:	50ca      	str	r2, [r1, r3]
200281d2:	e7f9      	b.n	200281c8 <mbedtls_mpi_shift_l+0x64>
200281d4:	68ae      	ldr	r6, [r5, #8]
200281d6:	3901      	subs	r1, #1
200281d8:	eb06 0c03 	add.w	ip, r6, r3
200281dc:	f85c c000 	ldr.w	ip, [ip, r0]
200281e0:	f846 c003 	str.w	ip, [r6, r3]
200281e4:	e7e5      	b.n	200281b2 <mbedtls_mpi_shift_l+0x4e>
200281e6:	68ab      	ldr	r3, [r5, #8]
200281e8:	f853 1024 	ldr.w	r1, [r3, r4, lsl #2]
200281ec:	fa01 f007 	lsl.w	r0, r1, r7
200281f0:	f843 0024 	str.w	r0, [r3, r4, lsl #2]
200281f4:	68a8      	ldr	r0, [r5, #8]
200281f6:	f850 3024 	ldr.w	r3, [r0, r4, lsl #2]
200281fa:	4313      	orrs	r3, r2
200281fc:	f840 3024 	str.w	r3, [r0, r4, lsl #2]
20028200:	fa21 f206 	lsr.w	r2, r1, r6
20028204:	3401      	adds	r4, #1
20028206:	686b      	ldr	r3, [r5, #4]
20028208:	42a3      	cmp	r3, r4
2002820a:	d8ec      	bhi.n	200281e6 <mbedtls_mpi_shift_l+0x82>
2002820c:	e7bb      	b.n	20028186 <mbedtls_mpi_shift_l+0x22>
2002820e:	2200      	movs	r2, #0
20028210:	f1c7 0620 	rsb	r6, r7, #32
20028214:	e7f7      	b.n	20028206 <mbedtls_mpi_shift_l+0xa2>

20028216 <mbedtls_mpi_shift_r>:
20028216:	b4f0      	push	{r4, r5, r6, r7}
20028218:	6843      	ldr	r3, [r0, #4]
2002821a:	094c      	lsrs	r4, r1, #5
2002821c:	42a3      	cmp	r3, r4
2002821e:	f001 021f 	and.w	r2, r1, #31
20028222:	d301      	bcc.n	20028228 <mbedtls_mpi_shift_r+0x12>
20028224:	d104      	bne.n	20028230 <mbedtls_mpi_shift_r+0x1a>
20028226:	b392      	cbz	r2, 2002828e <mbedtls_mpi_shift_r+0x78>
20028228:	bcf0      	pop	{r4, r5, r6, r7}
2002822a:	2100      	movs	r1, #0
2002822c:	f7ff beeb 	b.w	20028006 <mbedtls_mpi_lset>
20028230:	291f      	cmp	r1, #31
20028232:	d82e      	bhi.n	20028292 <mbedtls_mpi_shift_r+0x7c>
20028234:	b9aa      	cbnz	r2, 20028262 <mbedtls_mpi_shift_r+0x4c>
20028236:	bcf0      	pop	{r4, r5, r6, r7}
20028238:	2000      	movs	r0, #0
2002823a:	4770      	bx	lr
2002823c:	6885      	ldr	r5, [r0, #8]
2002823e:	586e      	ldr	r6, [r5, r1]
20028240:	3104      	adds	r1, #4
20028242:	f845 6023 	str.w	r6, [r5, r3, lsl #2]
20028246:	3301      	adds	r3, #1
20028248:	6845      	ldr	r5, [r0, #4]
2002824a:	1b2d      	subs	r5, r5, r4
2002824c:	429d      	cmp	r5, r3
2002824e:	d8f5      	bhi.n	2002823c <mbedtls_mpi_shift_r+0x26>
20028250:	2400      	movs	r4, #0
20028252:	6841      	ldr	r1, [r0, #4]
20028254:	4299      	cmp	r1, r3
20028256:	d9ed      	bls.n	20028234 <mbedtls_mpi_shift_r+0x1e>
20028258:	6881      	ldr	r1, [r0, #8]
2002825a:	f841 4023 	str.w	r4, [r1, r3, lsl #2]
2002825e:	3301      	adds	r3, #1
20028260:	e7f7      	b.n	20028252 <mbedtls_mpi_shift_r+0x3c>
20028262:	2400      	movs	r4, #0
20028264:	6843      	ldr	r3, [r0, #4]
20028266:	f1c2 0720 	rsb	r7, r2, #32
2002826a:	3b01      	subs	r3, #1
2002826c:	d3e3      	bcc.n	20028236 <mbedtls_mpi_shift_r+0x20>
2002826e:	6881      	ldr	r1, [r0, #8]
20028270:	f851 5023 	ldr.w	r5, [r1, r3, lsl #2]
20028274:	fa25 f602 	lsr.w	r6, r5, r2
20028278:	f841 6023 	str.w	r6, [r1, r3, lsl #2]
2002827c:	6886      	ldr	r6, [r0, #8]
2002827e:	f856 1023 	ldr.w	r1, [r6, r3, lsl #2]
20028282:	4321      	orrs	r1, r4
20028284:	f846 1023 	str.w	r1, [r6, r3, lsl #2]
20028288:	fa05 f407 	lsl.w	r4, r5, r7
2002828c:	e7ed      	b.n	2002826a <mbedtls_mpi_shift_r+0x54>
2002828e:	291f      	cmp	r1, #31
20028290:	d9d1      	bls.n	20028236 <mbedtls_mpi_shift_r+0x20>
20028292:	2300      	movs	r3, #0
20028294:	00a1      	lsls	r1, r4, #2
20028296:	e7d7      	b.n	20028248 <mbedtls_mpi_shift_r+0x32>

20028298 <mbedtls_mpi_cmp_abs>:
20028298:	b530      	push	{r4, r5, lr}
2002829a:	6842      	ldr	r2, [r0, #4]
2002829c:	b922      	cbnz	r2, 200282a8 <mbedtls_mpi_cmp_abs+0x10>
2002829e:	684b      	ldr	r3, [r1, #4]
200282a0:	b95b      	cbnz	r3, 200282ba <mbedtls_mpi_cmp_abs+0x22>
200282a2:	b19a      	cbz	r2, 200282cc <mbedtls_mpi_cmp_abs+0x34>
200282a4:	2001      	movs	r0, #1
200282a6:	e015      	b.n	200282d4 <mbedtls_mpi_cmp_abs+0x3c>
200282a8:	6883      	ldr	r3, [r0, #8]
200282aa:	eb03 0382 	add.w	r3, r3, r2, lsl #2
200282ae:	f853 3c04 	ldr.w	r3, [r3, #-4]
200282b2:	2b00      	cmp	r3, #0
200282b4:	d1f3      	bne.n	2002829e <mbedtls_mpi_cmp_abs+0x6>
200282b6:	3a01      	subs	r2, #1
200282b8:	e7f0      	b.n	2002829c <mbedtls_mpi_cmp_abs+0x4>
200282ba:	688c      	ldr	r4, [r1, #8]
200282bc:	eb04 0583 	add.w	r5, r4, r3, lsl #2
200282c0:	f855 5c04 	ldr.w	r5, [r5, #-4]
200282c4:	b90d      	cbnz	r5, 200282ca <mbedtls_mpi_cmp_abs+0x32>
200282c6:	3b01      	subs	r3, #1
200282c8:	e7ea      	b.n	200282a0 <mbedtls_mpi_cmp_abs+0x8>
200282ca:	b922      	cbnz	r2, 200282d6 <mbedtls_mpi_cmp_abs+0x3e>
200282cc:	1e18      	subs	r0, r3, #0
200282ce:	bf18      	it	ne
200282d0:	2001      	movne	r0, #1
200282d2:	4240      	negs	r0, r0
200282d4:	bd30      	pop	{r4, r5, pc}
200282d6:	4293      	cmp	r3, r2
200282d8:	d3e4      	bcc.n	200282a4 <mbedtls_mpi_cmp_abs+0xc>
200282da:	d80e      	bhi.n	200282fa <mbedtls_mpi_cmp_abs+0x62>
200282dc:	3a01      	subs	r2, #1
200282de:	6883      	ldr	r3, [r0, #8]
200282e0:	f853 1022 	ldr.w	r1, [r3, r2, lsl #2]
200282e4:	f854 3022 	ldr.w	r3, [r4, r2, lsl #2]
200282e8:	4299      	cmp	r1, r3
200282ea:	d8db      	bhi.n	200282a4 <mbedtls_mpi_cmp_abs+0xc>
200282ec:	f102 32ff 	add.w	r2, r2, #4294967295
200282f0:	d303      	bcc.n	200282fa <mbedtls_mpi_cmp_abs+0x62>
200282f2:	1c53      	adds	r3, r2, #1
200282f4:	d1f3      	bne.n	200282de <mbedtls_mpi_cmp_abs+0x46>
200282f6:	2000      	movs	r0, #0
200282f8:	e7ec      	b.n	200282d4 <mbedtls_mpi_cmp_abs+0x3c>
200282fa:	f04f 30ff 	mov.w	r0, #4294967295
200282fe:	e7e9      	b.n	200282d4 <mbedtls_mpi_cmp_abs+0x3c>

20028300 <mpi_montmul>:
20028300:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
20028304:	4615      	mov	r5, r2
20028306:	b087      	sub	sp, #28
20028308:	9305      	str	r3, [sp, #20]
2002830a:	9b10      	ldr	r3, [sp, #64]	@ 0x40
2002830c:	4606      	mov	r6, r0
2002830e:	685a      	ldr	r2, [r3, #4]
20028310:	686b      	ldr	r3, [r5, #4]
20028312:	4689      	mov	r9, r1
20028314:	3301      	adds	r3, #1
20028316:	429a      	cmp	r2, r3
20028318:	d359      	bcc.n	200283ce <mpi_montmul+0xce>
2002831a:	9b10      	ldr	r3, [sp, #64]	@ 0x40
2002831c:	6898      	ldr	r0, [r3, #8]
2002831e:	2800      	cmp	r0, #0
20028320:	d055      	beq.n	200283ce <mpi_montmul+0xce>
20028322:	0092      	lsls	r2, r2, #2
20028324:	2100      	movs	r1, #0
20028326:	f002 fb95 	bl	2002aa54 <memset>
2002832a:	9b10      	ldr	r3, [sp, #64]	@ 0x40
2002832c:	f8d5 8004 	ldr.w	r8, [r5, #4]
20028330:	f8d3 a008 	ldr.w	sl, [r3, #8]
20028334:	f8d9 3004 	ldr.w	r3, [r9, #4]
20028338:	46d3      	mov	fp, sl
2002833a:	4543      	cmp	r3, r8
2002833c:	bf28      	it	cs
2002833e:	4643      	movcs	r3, r8
20028340:	2400      	movs	r4, #0
20028342:	9304      	str	r3, [sp, #16]
20028344:	f108 0301 	add.w	r3, r8, #1
20028348:	009a      	lsls	r2, r3, #2
2002834a:	eb0a 0383 	add.w	r3, sl, r3, lsl #2
2002834e:	9202      	str	r2, [sp, #8]
20028350:	9303      	str	r3, [sp, #12]
20028352:	4544      	cmp	r4, r8
20028354:	68b0      	ldr	r0, [r6, #8]
20028356:	d118      	bne.n	2002838a <mpi_montmul+0x8a>
20028358:	9b02      	ldr	r3, [sp, #8]
2002835a:	1f19      	subs	r1, r3, #4
2002835c:	461a      	mov	r2, r3
2002835e:	4451      	add	r1, sl
20028360:	f002 fb92 	bl	2002aa88 <memcpy>
20028364:	4629      	mov	r1, r5
20028366:	4630      	mov	r0, r6
20028368:	f7ff ff96 	bl	20028298 <mbedtls_mpi_cmp_abs>
2002836c:	3001      	adds	r0, #1
2002836e:	68b1      	ldr	r1, [r6, #8]
20028370:	bf0c      	ite	eq
20028372:	9b10      	ldreq	r3, [sp, #64]	@ 0x40
20028374:	460a      	movne	r2, r1
20028376:	4620      	mov	r0, r4
20028378:	bf14      	ite	ne
2002837a:	68a9      	ldrne	r1, [r5, #8]
2002837c:	689a      	ldreq	r2, [r3, #8]
2002837e:	f7ff fc2c 	bl	20027bda <mpi_sub_hlp>
20028382:	2000      	movs	r0, #0
20028384:	b007      	add	sp, #28
20028386:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
2002838a:	f850 3024 	ldr.w	r3, [r0, r4, lsl #2]
2002838e:	f8d9 1008 	ldr.w	r1, [r9, #8]
20028392:	9301      	str	r3, [sp, #4]
20028394:	9a01      	ldr	r2, [sp, #4]
20028396:	680b      	ldr	r3, [r1, #0]
20028398:	f8db 7000 	ldr.w	r7, [fp]
2002839c:	9804      	ldr	r0, [sp, #16]
2002839e:	fb03 7702 	mla	r7, r3, r2, r7
200283a2:	9b05      	ldr	r3, [sp, #20]
200283a4:	3401      	adds	r4, #1
200283a6:	435f      	muls	r7, r3
200283a8:	4613      	mov	r3, r2
200283aa:	465a      	mov	r2, fp
200283ac:	f7ff fc3e 	bl	20027c2c <mpi_mul_hlp>
200283b0:	465a      	mov	r2, fp
200283b2:	463b      	mov	r3, r7
200283b4:	4640      	mov	r0, r8
200283b6:	68a9      	ldr	r1, [r5, #8]
200283b8:	f7ff fc38 	bl	20027c2c <mpi_mul_hlp>
200283bc:	2200      	movs	r2, #0
200283be:	9b01      	ldr	r3, [sp, #4]
200283c0:	f84b 3b04 	str.w	r3, [fp], #4
200283c4:	9b03      	ldr	r3, [sp, #12]
200283c6:	f843 2f04 	str.w	r2, [r3, #4]!
200283ca:	9303      	str	r3, [sp, #12]
200283cc:	e7c1      	b.n	20028352 <mpi_montmul+0x52>
200283ce:	f06f 0003 	mvn.w	r0, #3
200283d2:	e7d7      	b.n	20028384 <mpi_montmul+0x84>

200283d4 <mbedtls_mpi_cmp_mpi>:
200283d4:	4602      	mov	r2, r0
200283d6:	b530      	push	{r4, r5, lr}
200283d8:	6843      	ldr	r3, [r0, #4]
200283da:	b923      	cbnz	r3, 200283e6 <mbedtls_mpi_cmp_mpi+0x12>
200283dc:	6848      	ldr	r0, [r1, #4]
200283de:	b958      	cbnz	r0, 200283f8 <mbedtls_mpi_cmp_mpi+0x24>
200283e0:	2b00      	cmp	r3, #0
200283e2:	d136      	bne.n	20028452 <mbedtls_mpi_cmp_mpi+0x7e>
200283e4:	e02f      	b.n	20028446 <mbedtls_mpi_cmp_mpi+0x72>
200283e6:	6890      	ldr	r0, [r2, #8]
200283e8:	eb00 0083 	add.w	r0, r0, r3, lsl #2
200283ec:	f850 0c04 	ldr.w	r0, [r0, #-4]
200283f0:	2800      	cmp	r0, #0
200283f2:	d1f3      	bne.n	200283dc <mbedtls_mpi_cmp_mpi+0x8>
200283f4:	3b01      	subs	r3, #1
200283f6:	e7f0      	b.n	200283da <mbedtls_mpi_cmp_mpi+0x6>
200283f8:	688c      	ldr	r4, [r1, #8]
200283fa:	eb04 0580 	add.w	r5, r4, r0, lsl #2
200283fe:	f855 5c04 	ldr.w	r5, [r5, #-4]
20028402:	bb15      	cbnz	r5, 2002844a <mbedtls_mpi_cmp_mpi+0x76>
20028404:	3801      	subs	r0, #1
20028406:	e7ea      	b.n	200283de <mbedtls_mpi_cmp_mpi+0xa>
20028408:	680d      	ldr	r5, [r1, #0]
2002840a:	d202      	bcs.n	20028412 <mbedtls_mpi_cmp_mpi+0x3e>
2002840c:	6808      	ldr	r0, [r1, #0]
2002840e:	4240      	negs	r0, r0
20028410:	e020      	b.n	20028454 <mbedtls_mpi_cmp_mpi+0x80>
20028412:	6810      	ldr	r0, [r2, #0]
20028414:	2800      	cmp	r0, #0
20028416:	dd03      	ble.n	20028420 <mbedtls_mpi_cmp_mpi+0x4c>
20028418:	2d00      	cmp	r5, #0
2002841a:	da07      	bge.n	2002842c <mbedtls_mpi_cmp_mpi+0x58>
2002841c:	2001      	movs	r0, #1
2002841e:	e019      	b.n	20028454 <mbedtls_mpi_cmp_mpi+0x80>
20028420:	2d00      	cmp	r5, #0
20028422:	dd03      	ble.n	2002842c <mbedtls_mpi_cmp_mpi+0x58>
20028424:	b110      	cbz	r0, 2002842c <mbedtls_mpi_cmp_mpi+0x58>
20028426:	f04f 30ff 	mov.w	r0, #4294967295
2002842a:	e013      	b.n	20028454 <mbedtls_mpi_cmp_mpi+0x80>
2002842c:	3b01      	subs	r3, #1
2002842e:	6891      	ldr	r1, [r2, #8]
20028430:	f851 5023 	ldr.w	r5, [r1, r3, lsl #2]
20028434:	f854 1023 	ldr.w	r1, [r4, r3, lsl #2]
20028438:	428d      	cmp	r5, r1
2002843a:	d80b      	bhi.n	20028454 <mbedtls_mpi_cmp_mpi+0x80>
2002843c:	f103 33ff 	add.w	r3, r3, #4294967295
20028440:	d3e5      	bcc.n	2002840e <mbedtls_mpi_cmp_mpi+0x3a>
20028442:	1c59      	adds	r1, r3, #1
20028444:	d1f3      	bne.n	2002842e <mbedtls_mpi_cmp_mpi+0x5a>
20028446:	2000      	movs	r0, #0
20028448:	e004      	b.n	20028454 <mbedtls_mpi_cmp_mpi+0x80>
2002844a:	2b00      	cmp	r3, #0
2002844c:	d0de      	beq.n	2002840c <mbedtls_mpi_cmp_mpi+0x38>
2002844e:	4283      	cmp	r3, r0
20028450:	d9da      	bls.n	20028408 <mbedtls_mpi_cmp_mpi+0x34>
20028452:	6810      	ldr	r0, [r2, #0]
20028454:	bd30      	pop	{r4, r5, pc}

20028456 <mbedtls_mpi_cmp_int>:
20028456:	b51f      	push	{r0, r1, r2, r3, r4, lr}
20028458:	ea81 73e1 	eor.w	r3, r1, r1, asr #31
2002845c:	eba3 73e1 	sub.w	r3, r3, r1, asr #31
20028460:	2900      	cmp	r1, #0
20028462:	9300      	str	r3, [sp, #0]
20028464:	bfac      	ite	ge
20028466:	2301      	movge	r3, #1
20028468:	f04f 33ff 	movlt.w	r3, #4294967295
2002846c:	9301      	str	r3, [sp, #4]
2002846e:	2301      	movs	r3, #1
20028470:	a901      	add	r1, sp, #4
20028472:	9302      	str	r3, [sp, #8]
20028474:	f8cd d00c 	str.w	sp, [sp, #12]
20028478:	f7ff ffac 	bl	200283d4 <mbedtls_mpi_cmp_mpi>
2002847c:	b005      	add	sp, #20
2002847e:	f85d fb04 	ldr.w	pc, [sp], #4

20028482 <mbedtls_mpi_add_abs>:
20028482:	4290      	cmp	r0, r2
20028484:	e92d 41f0 	stmdb	sp!, {r4, r5, r6, r7, r8, lr}
20028488:	4606      	mov	r6, r0
2002848a:	460c      	mov	r4, r1
2002848c:	4615      	mov	r5, r2
2002848e:	d002      	beq.n	20028496 <mbedtls_mpi_add_abs+0x14>
20028490:	4288      	cmp	r0, r1
20028492:	d12c      	bne.n	200284ee <mbedtls_mpi_add_abs+0x6c>
20028494:	462c      	mov	r4, r5
20028496:	2301      	movs	r3, #1
20028498:	6033      	str	r3, [r6, #0]
2002849a:	6865      	ldr	r5, [r4, #4]
2002849c:	bb85      	cbnz	r5, 20028500 <mbedtls_mpi_add_abs+0x7e>
2002849e:	4629      	mov	r1, r5
200284a0:	4630      	mov	r0, r6
200284a2:	f7ff fd5b 	bl	20027f5c <mbedtls_mpi_grow>
200284a6:	4607      	mov	r7, r0
200284a8:	bb28      	cbnz	r0, 200284f6 <mbedtls_mpi_add_abs+0x74>
200284aa:	68b3      	ldr	r3, [r6, #8]
200284ac:	68a1      	ldr	r1, [r4, #8]
200284ae:	469c      	mov	ip, r3
200284b0:	4604      	mov	r4, r0
200284b2:	42a8      	cmp	r0, r5
200284b4:	d12d      	bne.n	20028512 <mbedtls_mpi_add_abs+0x90>
200284b6:	eb03 0385 	add.w	r3, r3, r5, lsl #2
200284ba:	b1f4      	cbz	r4, 200284fa <mbedtls_mpi_add_abs+0x78>
200284bc:	6872      	ldr	r2, [r6, #4]
200284be:	f105 0801 	add.w	r8, r5, #1
200284c2:	42aa      	cmp	r2, r5
200284c4:	d807      	bhi.n	200284d6 <mbedtls_mpi_add_abs+0x54>
200284c6:	4641      	mov	r1, r8
200284c8:	4630      	mov	r0, r6
200284ca:	f7ff fd47 	bl	20027f5c <mbedtls_mpi_grow>
200284ce:	b990      	cbnz	r0, 200284f6 <mbedtls_mpi_add_abs+0x74>
200284d0:	68b3      	ldr	r3, [r6, #8]
200284d2:	eb03 0385 	add.w	r3, r3, r5, lsl #2
200284d6:	681a      	ldr	r2, [r3, #0]
200284d8:	4645      	mov	r5, r8
200284da:	1912      	adds	r2, r2, r4
200284dc:	bf2c      	ite	cs
200284de:	2401      	movcs	r4, #1
200284e0:	2400      	movcc	r4, #0
200284e2:	3c00      	subs	r4, #0
200284e4:	bf18      	it	ne
200284e6:	2401      	movne	r4, #1
200284e8:	f843 2b04 	str.w	r2, [r3], #4
200284ec:	e7e5      	b.n	200284ba <mbedtls_mpi_add_abs+0x38>
200284ee:	f7ff fd61 	bl	20027fb4 <mbedtls_mpi_copy>
200284f2:	2800      	cmp	r0, #0
200284f4:	d0ce      	beq.n	20028494 <mbedtls_mpi_add_abs+0x12>
200284f6:	f06f 070f 	mvn.w	r7, #15
200284fa:	4638      	mov	r0, r7
200284fc:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}
20028500:	68a3      	ldr	r3, [r4, #8]
20028502:	eb03 0385 	add.w	r3, r3, r5, lsl #2
20028506:	f853 3c04 	ldr.w	r3, [r3, #-4]
2002850a:	2b00      	cmp	r3, #0
2002850c:	d1c7      	bne.n	2002849e <mbedtls_mpi_add_abs+0x1c>
2002850e:	3d01      	subs	r5, #1
20028510:	e7c4      	b.n	2002849c <mbedtls_mpi_add_abs+0x1a>
20028512:	f8dc 2000 	ldr.w	r2, [ip]
20028516:	1912      	adds	r2, r2, r4
20028518:	bf2c      	ite	cs
2002851a:	f04f 0e01 	movcs.w	lr, #1
2002851e:	f04f 0e00 	movcc.w	lr, #0
20028522:	f851 4020 	ldr.w	r4, [r1, r0, lsl #2]
20028526:	3001      	adds	r0, #1
20028528:	1912      	adds	r2, r2, r4
2002852a:	f84c 2b04 	str.w	r2, [ip], #4
2002852e:	f14e 0400 	adc.w	r4, lr, #0
20028532:	e7be      	b.n	200284b2 <mbedtls_mpi_add_abs+0x30>

20028534 <mbedtls_mpi_sub_abs>:
20028534:	b57f      	push	{r0, r1, r2, r3, r4, r5, r6, lr}
20028536:	460e      	mov	r6, r1
20028538:	4605      	mov	r5, r0
2002853a:	4611      	mov	r1, r2
2002853c:	4630      	mov	r0, r6
2002853e:	4614      	mov	r4, r2
20028540:	f7ff feaa 	bl	20028298 <mbedtls_mpi_cmp_abs>
20028544:	3001      	adds	r0, #1
20028546:	d02f      	beq.n	200285a8 <mbedtls_mpi_sub_abs+0x74>
20028548:	2300      	movs	r3, #0
2002854a:	2201      	movs	r2, #1
2002854c:	42ac      	cmp	r4, r5
2002854e:	e9cd 2301 	strd	r2, r3, [sp, #4]
20028552:	9303      	str	r3, [sp, #12]
20028554:	d10d      	bne.n	20028572 <mbedtls_mpi_sub_abs+0x3e>
20028556:	4621      	mov	r1, r4
20028558:	a801      	add	r0, sp, #4
2002855a:	f7ff fd2b 	bl	20027fb4 <mbedtls_mpi_copy>
2002855e:	b138      	cbz	r0, 20028570 <mbedtls_mpi_sub_abs+0x3c>
20028560:	f06f 040f 	mvn.w	r4, #15
20028564:	a801      	add	r0, sp, #4
20028566:	f7ff fce4 	bl	20027f32 <mbedtls_mpi_free>
2002856a:	4620      	mov	r0, r4
2002856c:	b004      	add	sp, #16
2002856e:	bd70      	pop	{r4, r5, r6, pc}
20028570:	ac01      	add	r4, sp, #4
20028572:	42ae      	cmp	r6, r5
20028574:	d109      	bne.n	2002858a <mbedtls_mpi_sub_abs+0x56>
20028576:	2301      	movs	r3, #1
20028578:	602b      	str	r3, [r5, #0]
2002857a:	e9d4 0101 	ldrd	r0, r1, [r4, #4]
2002857e:	b958      	cbnz	r0, 20028598 <mbedtls_mpi_sub_abs+0x64>
20028580:	68aa      	ldr	r2, [r5, #8]
20028582:	f7ff fb2a 	bl	20027bda <mpi_sub_hlp>
20028586:	2400      	movs	r4, #0
20028588:	e7ec      	b.n	20028564 <mbedtls_mpi_sub_abs+0x30>
2002858a:	4631      	mov	r1, r6
2002858c:	4628      	mov	r0, r5
2002858e:	f7ff fd11 	bl	20027fb4 <mbedtls_mpi_copy>
20028592:	2800      	cmp	r0, #0
20028594:	d0ef      	beq.n	20028576 <mbedtls_mpi_sub_abs+0x42>
20028596:	e7e3      	b.n	20028560 <mbedtls_mpi_sub_abs+0x2c>
20028598:	eb01 0380 	add.w	r3, r1, r0, lsl #2
2002859c:	f853 3c04 	ldr.w	r3, [r3, #-4]
200285a0:	2b00      	cmp	r3, #0
200285a2:	d1ed      	bne.n	20028580 <mbedtls_mpi_sub_abs+0x4c>
200285a4:	3801      	subs	r0, #1
200285a6:	e7ea      	b.n	2002857e <mbedtls_mpi_sub_abs+0x4a>
200285a8:	f06f 0409 	mvn.w	r4, #9
200285ac:	e7dd      	b.n	2002856a <mbedtls_mpi_sub_abs+0x36>

200285ae <mbedtls_mpi_add_mpi>:
200285ae:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
200285b0:	680d      	ldr	r5, [r1, #0]
200285b2:	6813      	ldr	r3, [r2, #0]
200285b4:	4604      	mov	r4, r0
200285b6:	436b      	muls	r3, r5
200285b8:	460f      	mov	r7, r1
200285ba:	4616      	mov	r6, r2
200285bc:	d516      	bpl.n	200285ec <mbedtls_mpi_add_mpi+0x3e>
200285be:	4611      	mov	r1, r2
200285c0:	4638      	mov	r0, r7
200285c2:	f7ff fe69 	bl	20028298 <mbedtls_mpi_cmp_abs>
200285c6:	3001      	adds	r0, #1
200285c8:	d007      	beq.n	200285da <mbedtls_mpi_add_mpi+0x2c>
200285ca:	4632      	mov	r2, r6
200285cc:	4639      	mov	r1, r7
200285ce:	4620      	mov	r0, r4
200285d0:	f7ff ffb0 	bl	20028534 <mbedtls_mpi_sub_abs>
200285d4:	b900      	cbnz	r0, 200285d8 <mbedtls_mpi_add_mpi+0x2a>
200285d6:	6025      	str	r5, [r4, #0]
200285d8:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
200285da:	463a      	mov	r2, r7
200285dc:	4631      	mov	r1, r6
200285de:	4620      	mov	r0, r4
200285e0:	f7ff ffa8 	bl	20028534 <mbedtls_mpi_sub_abs>
200285e4:	2800      	cmp	r0, #0
200285e6:	d1f7      	bne.n	200285d8 <mbedtls_mpi_add_mpi+0x2a>
200285e8:	426d      	negs	r5, r5
200285ea:	e7f4      	b.n	200285d6 <mbedtls_mpi_add_mpi+0x28>
200285ec:	f7ff ff49 	bl	20028482 <mbedtls_mpi_add_abs>
200285f0:	2800      	cmp	r0, #0
200285f2:	d0f0      	beq.n	200285d6 <mbedtls_mpi_add_mpi+0x28>
200285f4:	f06f 000f 	mvn.w	r0, #15
200285f8:	e7ee      	b.n	200285d8 <mbedtls_mpi_add_mpi+0x2a>

200285fa <mbedtls_mpi_sub_mpi>:
200285fa:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
200285fc:	680d      	ldr	r5, [r1, #0]
200285fe:	6813      	ldr	r3, [r2, #0]
20028600:	4604      	mov	r4, r0
20028602:	436b      	muls	r3, r5
20028604:	2b00      	cmp	r3, #0
20028606:	460f      	mov	r7, r1
20028608:	4616      	mov	r6, r2
2002860a:	dd16      	ble.n	2002863a <mbedtls_mpi_sub_mpi+0x40>
2002860c:	4611      	mov	r1, r2
2002860e:	4638      	mov	r0, r7
20028610:	f7ff fe42 	bl	20028298 <mbedtls_mpi_cmp_abs>
20028614:	3001      	adds	r0, #1
20028616:	d007      	beq.n	20028628 <mbedtls_mpi_sub_mpi+0x2e>
20028618:	4632      	mov	r2, r6
2002861a:	4639      	mov	r1, r7
2002861c:	4620      	mov	r0, r4
2002861e:	f7ff ff89 	bl	20028534 <mbedtls_mpi_sub_abs>
20028622:	b900      	cbnz	r0, 20028626 <mbedtls_mpi_sub_mpi+0x2c>
20028624:	6025      	str	r5, [r4, #0]
20028626:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
20028628:	463a      	mov	r2, r7
2002862a:	4631      	mov	r1, r6
2002862c:	4620      	mov	r0, r4
2002862e:	f7ff ff81 	bl	20028534 <mbedtls_mpi_sub_abs>
20028632:	2800      	cmp	r0, #0
20028634:	d1f7      	bne.n	20028626 <mbedtls_mpi_sub_mpi+0x2c>
20028636:	426d      	negs	r5, r5
20028638:	e7f4      	b.n	20028624 <mbedtls_mpi_sub_mpi+0x2a>
2002863a:	f7ff ff22 	bl	20028482 <mbedtls_mpi_add_abs>
2002863e:	2800      	cmp	r0, #0
20028640:	d0f0      	beq.n	20028624 <mbedtls_mpi_sub_mpi+0x2a>
20028642:	f06f 000f 	mvn.w	r0, #15
20028646:	e7ee      	b.n	20028626 <mbedtls_mpi_sub_mpi+0x2c>

20028648 <mbedtls_mpi_sub_int>:
20028648:	b51f      	push	{r0, r1, r2, r3, r4, lr}
2002864a:	ea82 73e2 	eor.w	r3, r2, r2, asr #31
2002864e:	eba3 73e2 	sub.w	r3, r3, r2, asr #31
20028652:	2a00      	cmp	r2, #0
20028654:	9300      	str	r3, [sp, #0]
20028656:	bfac      	ite	ge
20028658:	2301      	movge	r3, #1
2002865a:	f04f 33ff 	movlt.w	r3, #4294967295
2002865e:	9301      	str	r3, [sp, #4]
20028660:	2301      	movs	r3, #1
20028662:	aa01      	add	r2, sp, #4
20028664:	9302      	str	r3, [sp, #8]
20028666:	f8cd d00c 	str.w	sp, [sp, #12]
2002866a:	f7ff ffc6 	bl	200285fa <mbedtls_mpi_sub_mpi>
2002866e:	b005      	add	sp, #20
20028670:	f85d fb04 	ldr.w	pc, [sp], #4

20028674 <mbedtls_mpi_mul_mpi>:
20028674:	e92d 43f0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, lr}
20028678:	2300      	movs	r3, #0
2002867a:	4615      	mov	r5, r2
2002867c:	2201      	movs	r2, #1
2002867e:	b087      	sub	sp, #28
20028680:	4288      	cmp	r0, r1
20028682:	4607      	mov	r7, r0
20028684:	460e      	mov	r6, r1
20028686:	e9cd 2300 	strd	r2, r3, [sp]
2002868a:	e9cd 3202 	strd	r3, r2, [sp, #8]
2002868e:	e9cd 3304 	strd	r3, r3, [sp, #16]
20028692:	d110      	bne.n	200286b6 <mbedtls_mpi_mul_mpi+0x42>
20028694:	4668      	mov	r0, sp
20028696:	f7ff fc8d 	bl	20027fb4 <mbedtls_mpi_copy>
2002869a:	b158      	cbz	r0, 200286b4 <mbedtls_mpi_mul_mpi+0x40>
2002869c:	f06f 090f 	mvn.w	r9, #15
200286a0:	a803      	add	r0, sp, #12
200286a2:	f7ff fc46 	bl	20027f32 <mbedtls_mpi_free>
200286a6:	4668      	mov	r0, sp
200286a8:	f7ff fc43 	bl	20027f32 <mbedtls_mpi_free>
200286ac:	4648      	mov	r0, r9
200286ae:	b007      	add	sp, #28
200286b0:	e8bd 83f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, pc}
200286b4:	466e      	mov	r6, sp
200286b6:	42af      	cmp	r7, r5
200286b8:	d106      	bne.n	200286c8 <mbedtls_mpi_mul_mpi+0x54>
200286ba:	4639      	mov	r1, r7
200286bc:	a803      	add	r0, sp, #12
200286be:	f7ff fc79 	bl	20027fb4 <mbedtls_mpi_copy>
200286c2:	2800      	cmp	r0, #0
200286c4:	d1ea      	bne.n	2002869c <mbedtls_mpi_mul_mpi+0x28>
200286c6:	ad03      	add	r5, sp, #12
200286c8:	f8d6 8004 	ldr.w	r8, [r6, #4]
200286cc:	f1b8 0f00 	cmp.w	r8, #0
200286d0:	d116      	bne.n	20028700 <mbedtls_mpi_mul_mpi+0x8c>
200286d2:	686c      	ldr	r4, [r5, #4]
200286d4:	b9f4      	cbnz	r4, 20028714 <mbedtls_mpi_mul_mpi+0xa0>
200286d6:	eb08 0104 	add.w	r1, r8, r4
200286da:	4638      	mov	r0, r7
200286dc:	f7ff fc3e 	bl	20027f5c <mbedtls_mpi_grow>
200286e0:	4601      	mov	r1, r0
200286e2:	2800      	cmp	r0, #0
200286e4:	d1da      	bne.n	2002869c <mbedtls_mpi_mul_mpi+0x28>
200286e6:	4638      	mov	r0, r7
200286e8:	f7ff fc8d 	bl	20028006 <mbedtls_mpi_lset>
200286ec:	4681      	mov	r9, r0
200286ee:	2800      	cmp	r0, #0
200286f0:	d1d4      	bne.n	2002869c <mbedtls_mpi_mul_mpi+0x28>
200286f2:	3c01      	subs	r4, #1
200286f4:	d217      	bcs.n	20028726 <mbedtls_mpi_mul_mpi+0xb2>
200286f6:	6833      	ldr	r3, [r6, #0]
200286f8:	682a      	ldr	r2, [r5, #0]
200286fa:	4353      	muls	r3, r2
200286fc:	603b      	str	r3, [r7, #0]
200286fe:	e7cf      	b.n	200286a0 <mbedtls_mpi_mul_mpi+0x2c>
20028700:	68b3      	ldr	r3, [r6, #8]
20028702:	eb03 0388 	add.w	r3, r3, r8, lsl #2
20028706:	f853 3c04 	ldr.w	r3, [r3, #-4]
2002870a:	2b00      	cmp	r3, #0
2002870c:	d1e1      	bne.n	200286d2 <mbedtls_mpi_mul_mpi+0x5e>
2002870e:	f108 38ff 	add.w	r8, r8, #4294967295
20028712:	e7db      	b.n	200286cc <mbedtls_mpi_mul_mpi+0x58>
20028714:	68ab      	ldr	r3, [r5, #8]
20028716:	eb03 0384 	add.w	r3, r3, r4, lsl #2
2002871a:	f853 3c04 	ldr.w	r3, [r3, #-4]
2002871e:	2b00      	cmp	r3, #0
20028720:	d1d9      	bne.n	200286d6 <mbedtls_mpi_mul_mpi+0x62>
20028722:	3c01      	subs	r4, #1
20028724:	e7d6      	b.n	200286d4 <mbedtls_mpi_mul_mpi+0x60>
20028726:	68ab      	ldr	r3, [r5, #8]
20028728:	68ba      	ldr	r2, [r7, #8]
2002872a:	4640      	mov	r0, r8
2002872c:	f853 3024 	ldr.w	r3, [r3, r4, lsl #2]
20028730:	68b1      	ldr	r1, [r6, #8]
20028732:	eb02 0284 	add.w	r2, r2, r4, lsl #2
20028736:	f7ff fa79 	bl	20027c2c <mpi_mul_hlp>
2002873a:	e7da      	b.n	200286f2 <mbedtls_mpi_mul_mpi+0x7e>

2002873c <mbedtls_mpi_mul_int>:
2002873c:	b51f      	push	{r0, r1, r2, r3, r4, lr}
2002873e:	2301      	movs	r3, #1
20028740:	9200      	str	r2, [sp, #0]
20028742:	aa01      	add	r2, sp, #4
20028744:	e9cd 3301 	strd	r3, r3, [sp, #4]
20028748:	f8cd d00c 	str.w	sp, [sp, #12]
2002874c:	f7ff ff92 	bl	20028674 <mbedtls_mpi_mul_mpi>
20028750:	b005      	add	sp, #20
20028752:	f85d fb04 	ldr.w	pc, [sp], #4

20028756 <mbedtls_mpi_div_mpi>:
20028756:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
2002875a:	b09f      	sub	sp, #124	@ 0x7c
2002875c:	e9cd 1203 	strd	r1, r2, [sp, #12]
20028760:	9005      	str	r0, [sp, #20]
20028762:	2100      	movs	r1, #0
20028764:	4618      	mov	r0, r3
20028766:	9309      	str	r3, [sp, #36]	@ 0x24
20028768:	f7ff fe75 	bl	20028456 <mbedtls_mpi_cmp_int>
2002876c:	2800      	cmp	r0, #0
2002876e:	f000 81f3 	beq.w	20028b58 <mbedtls_mpi_div_mpi+0x402>
20028772:	2501      	movs	r5, #1
20028774:	2400      	movs	r4, #0
20028776:	9909      	ldr	r1, [sp, #36]	@ 0x24
20028778:	9804      	ldr	r0, [sp, #16]
2002877a:	e9cd 5418 	strd	r5, r4, [sp, #96]	@ 0x60
2002877e:	e9cd 541b 	strd	r5, r4, [sp, #108]	@ 0x6c
20028782:	950f      	str	r5, [sp, #60]	@ 0x3c
20028784:	9512      	str	r5, [sp, #72]	@ 0x48
20028786:	9515      	str	r5, [sp, #84]	@ 0x54
20028788:	9416      	str	r4, [sp, #88]	@ 0x58
2002878a:	f7ff fd85 	bl	20028298 <mbedtls_mpi_cmp_abs>
2002878e:	3001      	adds	r0, #1
20028790:	d11f      	bne.n	200287d2 <mbedtls_mpi_div_mpi+0x7c>
20028792:	9b05      	ldr	r3, [sp, #20]
20028794:	b933      	cbnz	r3, 200287a4 <mbedtls_mpi_div_mpi+0x4e>
20028796:	9b03      	ldr	r3, [sp, #12]
20028798:	b9a3      	cbnz	r3, 200287c4 <mbedtls_mpi_div_mpi+0x6e>
2002879a:	2100      	movs	r1, #0
2002879c:	4608      	mov	r0, r1
2002879e:	b01f      	add	sp, #124	@ 0x7c
200287a0:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
200287a4:	4621      	mov	r1, r4
200287a6:	9805      	ldr	r0, [sp, #20]
200287a8:	f7ff fc2d 	bl	20028006 <mbedtls_mpi_lset>
200287ac:	2800      	cmp	r0, #0
200287ae:	d0f2      	beq.n	20028796 <mbedtls_mpi_div_mpi+0x40>
200287b0:	2400      	movs	r4, #0
200287b2:	4625      	mov	r5, r4
200287b4:	46a1      	mov	r9, r4
200287b6:	46a0      	mov	r8, r4
200287b8:	4626      	mov	r6, r4
200287ba:	4627      	mov	r7, r4
200287bc:	9402      	str	r4, [sp, #8]
200287be:	f06f 010f 	mvn.w	r1, #15
200287c2:	e0ef      	b.n	200289a4 <mbedtls_mpi_div_mpi+0x24e>
200287c4:	e9dd 0103 	ldrd	r0, r1, [sp, #12]
200287c8:	f7ff fbf4 	bl	20027fb4 <mbedtls_mpi_copy>
200287cc:	2800      	cmp	r0, #0
200287ce:	d1ef      	bne.n	200287b0 <mbedtls_mpi_div_mpi+0x5a>
200287d0:	e7e3      	b.n	2002879a <mbedtls_mpi_div_mpi+0x44>
200287d2:	9904      	ldr	r1, [sp, #16]
200287d4:	a80f      	add	r0, sp, #60	@ 0x3c
200287d6:	e9cd 4410 	strd	r4, r4, [sp, #64]	@ 0x40
200287da:	f7ff fbeb 	bl	20027fb4 <mbedtls_mpi_copy>
200287de:	e9dd 7610 	ldrd	r7, r6, [sp, #64]	@ 0x40
200287e2:	4682      	mov	sl, r0
200287e4:	2800      	cmp	r0, #0
200287e6:	f040 81a9 	bne.w	20028b3c <mbedtls_mpi_div_mpi+0x3e6>
200287ea:	e9cd 0013 	strd	r0, r0, [sp, #76]	@ 0x4c
200287ee:	9909      	ldr	r1, [sp, #36]	@ 0x24
200287f0:	a812      	add	r0, sp, #72	@ 0x48
200287f2:	f7ff fbdf 	bl	20027fb4 <mbedtls_mpi_copy>
200287f6:	e9dd 8913 	ldrd	r8, r9, [sp, #76]	@ 0x4c
200287fa:	4604      	mov	r4, r0
200287fc:	2800      	cmp	r0, #0
200287fe:	f040 81a2 	bne.w	20028b46 <mbedtls_mpi_div_mpi+0x3f0>
20028802:	9b04      	ldr	r3, [sp, #16]
20028804:	9017      	str	r0, [sp, #92]	@ 0x5c
20028806:	6859      	ldr	r1, [r3, #4]
20028808:	a815      	add	r0, sp, #84	@ 0x54
2002880a:	3102      	adds	r1, #2
2002880c:	9512      	str	r5, [sp, #72]	@ 0x48
2002880e:	950f      	str	r5, [sp, #60]	@ 0x3c
20028810:	f7ff fba4 	bl	20027f5c <mbedtls_mpi_grow>
20028814:	4605      	mov	r5, r0
20028816:	b118      	cbz	r0, 20028820 <mbedtls_mpi_div_mpi+0xca>
20028818:	9b17      	ldr	r3, [sp, #92]	@ 0x5c
2002881a:	9302      	str	r3, [sp, #8]
2002881c:	4625      	mov	r5, r4
2002881e:	e7ce      	b.n	200287be <mbedtls_mpi_div_mpi+0x68>
20028820:	4601      	mov	r1, r0
20028822:	a815      	add	r0, sp, #84	@ 0x54
20028824:	f7ff fbef 	bl	20028006 <mbedtls_mpi_lset>
20028828:	9b17      	ldr	r3, [sp, #92]	@ 0x5c
2002882a:	4604      	mov	r4, r0
2002882c:	9302      	str	r3, [sp, #8]
2002882e:	2800      	cmp	r0, #0
20028830:	f040 818e 	bne.w	20028b50 <mbedtls_mpi_div_mpi+0x3fa>
20028834:	901a      	str	r0, [sp, #104]	@ 0x68
20028836:	2102      	movs	r1, #2
20028838:	a818      	add	r0, sp, #96	@ 0x60
2002883a:	f7ff fb8f 	bl	20027f5c <mbedtls_mpi_grow>
2002883e:	9d1a      	ldr	r5, [sp, #104]	@ 0x68
20028840:	2800      	cmp	r0, #0
20028842:	d1bc      	bne.n	200287be <mbedtls_mpi_div_mpi+0x68>
20028844:	901d      	str	r0, [sp, #116]	@ 0x74
20028846:	2103      	movs	r1, #3
20028848:	a81b      	add	r0, sp, #108	@ 0x6c
2002884a:	f7ff fb87 	bl	20027f5c <mbedtls_mpi_grow>
2002884e:	9c1d      	ldr	r4, [sp, #116]	@ 0x74
20028850:	4683      	mov	fp, r0
20028852:	2800      	cmp	r0, #0
20028854:	d1b3      	bne.n	200287be <mbedtls_mpi_div_mpi+0x68>
20028856:	a812      	add	r0, sp, #72	@ 0x48
20028858:	f7ff fc09 	bl	2002806e <mbedtls_mpi_bitlen>
2002885c:	f000 001f 	and.w	r0, r0, #31
20028860:	281f      	cmp	r0, #31
20028862:	f000 808a 	beq.w	2002897a <mbedtls_mpi_div_mpi+0x224>
20028866:	f1c0 031f 	rsb	r3, r0, #31
2002886a:	4619      	mov	r1, r3
2002886c:	a80f      	add	r0, sp, #60	@ 0x3c
2002886e:	9306      	str	r3, [sp, #24]
20028870:	f7ff fc78 	bl	20028164 <mbedtls_mpi_shift_l>
20028874:	e9dd 7610 	ldrd	r7, r6, [sp, #64]	@ 0x40
20028878:	2800      	cmp	r0, #0
2002887a:	d1a0      	bne.n	200287be <mbedtls_mpi_div_mpi+0x68>
2002887c:	9906      	ldr	r1, [sp, #24]
2002887e:	a812      	add	r0, sp, #72	@ 0x48
20028880:	f7ff fc70 	bl	20028164 <mbedtls_mpi_shift_l>
20028884:	e9dd 8913 	ldrd	r8, r9, [sp, #76]	@ 0x4c
20028888:	2800      	cmp	r0, #0
2002888a:	d198      	bne.n	200287be <mbedtls_mpi_div_mpi+0x68>
2002888c:	46ba      	mov	sl, r7
2002888e:	f8cd 8020 	str.w	r8, [sp, #32]
20028892:	eba7 0b08 	sub.w	fp, r7, r8
20028896:	ea4f 134b 	mov.w	r3, fp, lsl #5
2002889a:	4619      	mov	r1, r3
2002889c:	a812      	add	r0, sp, #72	@ 0x48
2002889e:	e9cd 8913 	strd	r8, r9, [sp, #76]	@ 0x4c
200288a2:	9301      	str	r3, [sp, #4]
200288a4:	f7ff fc5e 	bl	20028164 <mbedtls_mpi_shift_l>
200288a8:	e9dd 8913 	ldrd	r8, r9, [sp, #76]	@ 0x4c
200288ac:	2800      	cmp	r0, #0
200288ae:	d186      	bne.n	200287be <mbedtls_mpi_div_mpi+0x68>
200288b0:	ea4f 038b 	mov.w	r3, fp, lsl #2
200288b4:	930b      	str	r3, [sp, #44]	@ 0x2c
200288b6:	9b02      	ldr	r3, [sp, #8]
200288b8:	eb03 0b8b 	add.w	fp, r3, fp, lsl #2
200288bc:	a912      	add	r1, sp, #72	@ 0x48
200288be:	a80f      	add	r0, sp, #60	@ 0x3c
200288c0:	e9cd 7610 	strd	r7, r6, [sp, #64]	@ 0x40
200288c4:	e9cd 8913 	strd	r8, r9, [sp, #76]	@ 0x4c
200288c8:	f7ff fd84 	bl	200283d4 <mbedtls_mpi_cmp_mpi>
200288cc:	2800      	cmp	r0, #0
200288ce:	da5a      	bge.n	20028986 <mbedtls_mpi_div_mpi+0x230>
200288d0:	9901      	ldr	r1, [sp, #4]
200288d2:	a812      	add	r0, sp, #72	@ 0x48
200288d4:	f7ff fc9f 	bl	20028216 <mbedtls_mpi_shift_r>
200288d8:	e9dd 8913 	ldrd	r8, r9, [sp, #76]	@ 0x4c
200288dc:	2800      	cmp	r0, #0
200288de:	f47f af6e 	bne.w	200287be <mbedtls_mpi_div_mpi+0x68>
200288e2:	f10a 33ff 	add.w	r3, sl, #4294967295
200288e6:	9301      	str	r3, [sp, #4]
200288e8:	9b08      	ldr	r3, [sp, #32]
200288ea:	9a02      	ldr	r2, [sp, #8]
200288ec:	3b01      	subs	r3, #1
200288ee:	9307      	str	r3, [sp, #28]
200288f0:	eb09 0383 	add.w	r3, r9, r3, lsl #2
200288f4:	930a      	str	r3, [sp, #40]	@ 0x28
200288f6:	9b08      	ldr	r3, [sp, #32]
200288f8:	f103 4380 	add.w	r3, r3, #1073741824	@ 0x40000000
200288fc:	3b02      	subs	r3, #2
200288fe:	eb09 0383 	add.w	r3, r9, r3, lsl #2
20028902:	930c      	str	r3, [sp, #48]	@ 0x30
20028904:	9b0b      	ldr	r3, [sp, #44]	@ 0x2c
20028906:	4413      	add	r3, r2
20028908:	469a      	mov	sl, r3
2002890a:	9b01      	ldr	r3, [sp, #4]
2002890c:	9a07      	ldr	r2, [sp, #28]
2002890e:	4293      	cmp	r3, r2
20028910:	d862      	bhi.n	200289d8 <mbedtls_mpi_div_mpi+0x282>
20028912:	9b05      	ldr	r3, [sp, #20]
20028914:	b16b      	cbz	r3, 20028932 <mbedtls_mpi_div_mpi+0x1dc>
20028916:	4618      	mov	r0, r3
20028918:	a915      	add	r1, sp, #84	@ 0x54
2002891a:	f7ff fb4b 	bl	20027fb4 <mbedtls_mpi_copy>
2002891e:	2800      	cmp	r0, #0
20028920:	f47f af4d 	bne.w	200287be <mbedtls_mpi_div_mpi+0x68>
20028924:	9b04      	ldr	r3, [sp, #16]
20028926:	9a09      	ldr	r2, [sp, #36]	@ 0x24
20028928:	681b      	ldr	r3, [r3, #0]
2002892a:	6812      	ldr	r2, [r2, #0]
2002892c:	4353      	muls	r3, r2
2002892e:	9a05      	ldr	r2, [sp, #20]
20028930:	6013      	str	r3, [r2, #0]
20028932:	9b03      	ldr	r3, [sp, #12]
20028934:	2b00      	cmp	r3, #0
20028936:	f000 810d 	beq.w	20028b54 <mbedtls_mpi_div_mpi+0x3fe>
2002893a:	9906      	ldr	r1, [sp, #24]
2002893c:	a80f      	add	r0, sp, #60	@ 0x3c
2002893e:	e9cd 7610 	strd	r7, r6, [sp, #64]	@ 0x40
20028942:	f7ff fc68 	bl	20028216 <mbedtls_mpi_shift_r>
20028946:	e9dd 7610 	ldrd	r7, r6, [sp, #64]	@ 0x40
2002894a:	2800      	cmp	r0, #0
2002894c:	f47f af37 	bne.w	200287be <mbedtls_mpi_div_mpi+0x68>
20028950:	9b04      	ldr	r3, [sp, #16]
20028952:	a90f      	add	r1, sp, #60	@ 0x3c
20028954:	681b      	ldr	r3, [r3, #0]
20028956:	9803      	ldr	r0, [sp, #12]
20028958:	930f      	str	r3, [sp, #60]	@ 0x3c
2002895a:	f7ff fb2b 	bl	20027fb4 <mbedtls_mpi_copy>
2002895e:	4601      	mov	r1, r0
20028960:	2800      	cmp	r0, #0
20028962:	f47f af2c 	bne.w	200287be <mbedtls_mpi_div_mpi+0x68>
20028966:	9001      	str	r0, [sp, #4]
20028968:	9803      	ldr	r0, [sp, #12]
2002896a:	f7ff fd74 	bl	20028456 <mbedtls_mpi_cmp_int>
2002896e:	9901      	ldr	r1, [sp, #4]
20028970:	b9c0      	cbnz	r0, 200289a4 <mbedtls_mpi_div_mpi+0x24e>
20028972:	2301      	movs	r3, #1
20028974:	9a03      	ldr	r2, [sp, #12]
20028976:	6013      	str	r3, [r2, #0]
20028978:	e014      	b.n	200289a4 <mbedtls_mpi_div_mpi+0x24e>
2002897a:	46ba      	mov	sl, r7
2002897c:	f8cd 8020 	str.w	r8, [sp, #32]
20028980:	f8cd b018 	str.w	fp, [sp, #24]
20028984:	e785      	b.n	20028892 <mbedtls_mpi_div_mpi+0x13c>
20028986:	f8db 2000 	ldr.w	r2, [fp]
2002898a:	a90f      	add	r1, sp, #60	@ 0x3c
2002898c:	3201      	adds	r2, #1
2002898e:	4608      	mov	r0, r1
20028990:	f8cb 2000 	str.w	r2, [fp]
20028994:	aa12      	add	r2, sp, #72	@ 0x48
20028996:	f7ff fe30 	bl	200285fa <mbedtls_mpi_sub_mpi>
2002899a:	e9dd 7610 	ldrd	r7, r6, [sp, #64]	@ 0x40
2002899e:	4601      	mov	r1, r0
200289a0:	2800      	cmp	r0, #0
200289a2:	d08b      	beq.n	200288bc <mbedtls_mpi_div_mpi+0x166>
200289a4:	a80f      	add	r0, sp, #60	@ 0x3c
200289a6:	9101      	str	r1, [sp, #4]
200289a8:	e9cd 7610 	strd	r7, r6, [sp, #64]	@ 0x40
200289ac:	f7ff fac1 	bl	20027f32 <mbedtls_mpi_free>
200289b0:	a812      	add	r0, sp, #72	@ 0x48
200289b2:	e9cd 8913 	strd	r8, r9, [sp, #76]	@ 0x4c
200289b6:	f7ff fabc 	bl	20027f32 <mbedtls_mpi_free>
200289ba:	9b02      	ldr	r3, [sp, #8]
200289bc:	a815      	add	r0, sp, #84	@ 0x54
200289be:	9317      	str	r3, [sp, #92]	@ 0x5c
200289c0:	f7ff fab7 	bl	20027f32 <mbedtls_mpi_free>
200289c4:	a818      	add	r0, sp, #96	@ 0x60
200289c6:	951a      	str	r5, [sp, #104]	@ 0x68
200289c8:	f7ff fab3 	bl	20027f32 <mbedtls_mpi_free>
200289cc:	a81b      	add	r0, sp, #108	@ 0x6c
200289ce:	941d      	str	r4, [sp, #116]	@ 0x74
200289d0:	f7ff faaf 	bl	20027f32 <mbedtls_mpi_free>
200289d4:	9901      	ldr	r1, [sp, #4]
200289d6:	e6e1      	b.n	2002879c <mbedtls_mpi_div_mpi+0x46>
200289d8:	9b01      	ldr	r3, [sp, #4]
200289da:	ea4f 0b83 	mov.w	fp, r3, lsl #2
200289de:	eb06 0383 	add.w	r3, r6, r3, lsl #2
200289e2:	930b      	str	r3, [sp, #44]	@ 0x2c
200289e4:	9b01      	ldr	r3, [sp, #4]
200289e6:	f1ab 0004 	sub.w	r0, fp, #4
200289ea:	f856 1023 	ldr.w	r1, [r6, r3, lsl #2]
200289ee:	9b0a      	ldr	r3, [sp, #40]	@ 0x28
200289f0:	681a      	ldr	r2, [r3, #0]
200289f2:	1833      	adds	r3, r6, r0
200289f4:	4291      	cmp	r1, r2
200289f6:	930d      	str	r3, [sp, #52]	@ 0x34
200289f8:	d255      	bcs.n	20028aa6 <mbedtls_mpi_div_mpi+0x350>
200289fa:	2300      	movs	r3, #0
200289fc:	5830      	ldr	r0, [r6, r0]
200289fe:	f001 fd87 	bl	2002a510 <__aeabi_uldivmod>
20028a02:	2900      	cmp	r1, #0
20028a04:	bf14      	ite	ne
20028a06:	f04f 33ff 	movne.w	r3, #4294967295
20028a0a:	4603      	moveq	r3, r0
20028a0c:	3301      	adds	r3, #1
20028a0e:	f1ab 0b08 	sub.w	fp, fp, #8
20028a12:	f84a 3c04 	str.w	r3, [sl, #-4]
20028a16:	44b3      	add	fp, r6
20028a18:	f85a 3c04 	ldr.w	r3, [sl, #-4]
20028a1c:	2100      	movs	r1, #0
20028a1e:	3b01      	subs	r3, #1
20028a20:	f84a 3c04 	str.w	r3, [sl, #-4]
20028a24:	a818      	add	r0, sp, #96	@ 0x60
20028a26:	951a      	str	r5, [sp, #104]	@ 0x68
20028a28:	f7ff faed 	bl	20028006 <mbedtls_mpi_lset>
20028a2c:	9d1a      	ldr	r5, [sp, #104]	@ 0x68
20028a2e:	2800      	cmp	r0, #0
20028a30:	f47f aec5 	bne.w	200287be <mbedtls_mpi_div_mpi+0x68>
20028a34:	9b07      	ldr	r3, [sp, #28]
20028a36:	2b00      	cmp	r3, #0
20028a38:	d038      	beq.n	20028aac <mbedtls_mpi_div_mpi+0x356>
20028a3a:	9b0c      	ldr	r3, [sp, #48]	@ 0x30
20028a3c:	681b      	ldr	r3, [r3, #0]
20028a3e:	602b      	str	r3, [r5, #0]
20028a40:	9b0a      	ldr	r3, [sp, #40]	@ 0x28
20028a42:	a918      	add	r1, sp, #96	@ 0x60
20028a44:	681b      	ldr	r3, [r3, #0]
20028a46:	4608      	mov	r0, r1
20028a48:	606b      	str	r3, [r5, #4]
20028a4a:	f85a 2c04 	ldr.w	r2, [sl, #-4]
20028a4e:	f7ff fe75 	bl	2002873c <mbedtls_mpi_mul_int>
20028a52:	9d1a      	ldr	r5, [sp, #104]	@ 0x68
20028a54:	4601      	mov	r1, r0
20028a56:	2800      	cmp	r0, #0
20028a58:	f47f aeb1 	bne.w	200287be <mbedtls_mpi_div_mpi+0x68>
20028a5c:	a81b      	add	r0, sp, #108	@ 0x6c
20028a5e:	941d      	str	r4, [sp, #116]	@ 0x74
20028a60:	f7ff fad1 	bl	20028006 <mbedtls_mpi_lset>
20028a64:	9c1d      	ldr	r4, [sp, #116]	@ 0x74
20028a66:	2800      	cmp	r0, #0
20028a68:	f47f aea9 	bne.w	200287be <mbedtls_mpi_div_mpi+0x68>
20028a6c:	9b01      	ldr	r3, [sp, #4]
20028a6e:	a91b      	add	r1, sp, #108	@ 0x6c
20028a70:	2b01      	cmp	r3, #1
20028a72:	bf18      	it	ne
20028a74:	f8db 0000 	ldrne.w	r0, [fp]
20028a78:	9b0d      	ldr	r3, [sp, #52]	@ 0x34
20028a7a:	6020      	str	r0, [r4, #0]
20028a7c:	681b      	ldr	r3, [r3, #0]
20028a7e:	a818      	add	r0, sp, #96	@ 0x60
20028a80:	6063      	str	r3, [r4, #4]
20028a82:	9b0b      	ldr	r3, [sp, #44]	@ 0x2c
20028a84:	681b      	ldr	r3, [r3, #0]
20028a86:	60a3      	str	r3, [r4, #8]
20028a88:	f7ff fca4 	bl	200283d4 <mbedtls_mpi_cmp_mpi>
20028a8c:	2800      	cmp	r0, #0
20028a8e:	dcc3      	bgt.n	20028a18 <mbedtls_mpi_div_mpi+0x2c2>
20028a90:	f85a 2c04 	ldr.w	r2, [sl, #-4]
20028a94:	a912      	add	r1, sp, #72	@ 0x48
20028a96:	a818      	add	r0, sp, #96	@ 0x60
20028a98:	e9cd 8913 	strd	r8, r9, [sp, #76]	@ 0x4c
20028a9c:	f7ff fe4e 	bl	2002873c <mbedtls_mpi_mul_int>
20028aa0:	b130      	cbz	r0, 20028ab0 <mbedtls_mpi_div_mpi+0x35a>
20028aa2:	9d1a      	ldr	r5, [sp, #104]	@ 0x68
20028aa4:	e68b      	b.n	200287be <mbedtls_mpi_div_mpi+0x68>
20028aa6:	f04f 33ff 	mov.w	r3, #4294967295
20028aaa:	e7af      	b.n	20028a0c <mbedtls_mpi_div_mpi+0x2b6>
20028aac:	9b07      	ldr	r3, [sp, #28]
20028aae:	e7c6      	b.n	20028a3e <mbedtls_mpi_div_mpi+0x2e8>
20028ab0:	f06f 0b1f 	mvn.w	fp, #31
20028ab4:	9b08      	ldr	r3, [sp, #32]
20028ab6:	a818      	add	r0, sp, #96	@ 0x60
20028ab8:	fb0b fb03 	mul.w	fp, fp, r3
20028abc:	9b01      	ldr	r3, [sp, #4]
20028abe:	eb0b 1b43 	add.w	fp, fp, r3, lsl #5
20028ac2:	4659      	mov	r1, fp
20028ac4:	f7ff fb4e 	bl	20028164 <mbedtls_mpi_shift_l>
20028ac8:	9d1a      	ldr	r5, [sp, #104]	@ 0x68
20028aca:	2800      	cmp	r0, #0
20028acc:	f47f ae77 	bne.w	200287be <mbedtls_mpi_div_mpi+0x68>
20028ad0:	a90f      	add	r1, sp, #60	@ 0x3c
20028ad2:	4608      	mov	r0, r1
20028ad4:	aa18      	add	r2, sp, #96	@ 0x60
20028ad6:	e9cd 7610 	strd	r7, r6, [sp, #64]	@ 0x40
20028ada:	f7ff fd8e 	bl	200285fa <mbedtls_mpi_sub_mpi>
20028ade:	e9dd 7610 	ldrd	r7, r6, [sp, #64]	@ 0x40
20028ae2:	4601      	mov	r1, r0
20028ae4:	2800      	cmp	r0, #0
20028ae6:	f47f af5d 	bne.w	200289a4 <mbedtls_mpi_div_mpi+0x24e>
20028aea:	a80f      	add	r0, sp, #60	@ 0x3c
20028aec:	f7ff fcb3 	bl	20028456 <mbedtls_mpi_cmp_int>
20028af0:	2800      	cmp	r0, #0
20028af2:	da1d      	bge.n	20028b30 <mbedtls_mpi_div_mpi+0x3da>
20028af4:	a912      	add	r1, sp, #72	@ 0x48
20028af6:	a818      	add	r0, sp, #96	@ 0x60
20028af8:	f7ff fa5c 	bl	20027fb4 <mbedtls_mpi_copy>
20028afc:	2800      	cmp	r0, #0
20028afe:	d1d0      	bne.n	20028aa2 <mbedtls_mpi_div_mpi+0x34c>
20028b00:	4659      	mov	r1, fp
20028b02:	a818      	add	r0, sp, #96	@ 0x60
20028b04:	f7ff fb2e 	bl	20028164 <mbedtls_mpi_shift_l>
20028b08:	9d1a      	ldr	r5, [sp, #104]	@ 0x68
20028b0a:	2800      	cmp	r0, #0
20028b0c:	f47f ae57 	bne.w	200287be <mbedtls_mpi_div_mpi+0x68>
20028b10:	a90f      	add	r1, sp, #60	@ 0x3c
20028b12:	4608      	mov	r0, r1
20028b14:	aa18      	add	r2, sp, #96	@ 0x60
20028b16:	f7ff fd4a 	bl	200285ae <mbedtls_mpi_add_mpi>
20028b1a:	e9dd 7610 	ldrd	r7, r6, [sp, #64]	@ 0x40
20028b1e:	4601      	mov	r1, r0
20028b20:	2800      	cmp	r0, #0
20028b22:	f47f af3f 	bne.w	200289a4 <mbedtls_mpi_div_mpi+0x24e>
20028b26:	f85a 3c04 	ldr.w	r3, [sl, #-4]
20028b2a:	3b01      	subs	r3, #1
20028b2c:	f84a 3c04 	str.w	r3, [sl, #-4]
20028b30:	9b01      	ldr	r3, [sp, #4]
20028b32:	f1aa 0a04 	sub.w	sl, sl, #4
20028b36:	3b01      	subs	r3, #1
20028b38:	9301      	str	r3, [sp, #4]
20028b3a:	e6e6      	b.n	2002890a <mbedtls_mpi_div_mpi+0x1b4>
20028b3c:	4625      	mov	r5, r4
20028b3e:	46a1      	mov	r9, r4
20028b40:	46a0      	mov	r8, r4
20028b42:	9402      	str	r4, [sp, #8]
20028b44:	e63b      	b.n	200287be <mbedtls_mpi_div_mpi+0x68>
20028b46:	4654      	mov	r4, sl
20028b48:	4655      	mov	r5, sl
20028b4a:	f8cd a008 	str.w	sl, [sp, #8]
20028b4e:	e636      	b.n	200287be <mbedtls_mpi_div_mpi+0x68>
20028b50:	462c      	mov	r4, r5
20028b52:	e663      	b.n	2002881c <mbedtls_mpi_div_mpi+0xc6>
20028b54:	9903      	ldr	r1, [sp, #12]
20028b56:	e725      	b.n	200289a4 <mbedtls_mpi_div_mpi+0x24e>
20028b58:	f06f 010b 	mvn.w	r1, #11
20028b5c:	e61e      	b.n	2002879c <mbedtls_mpi_div_mpi+0x46>

20028b5e <mbedtls_mpi_mod_mpi>:
20028b5e:	b570      	push	{r4, r5, r6, lr}
20028b60:	4604      	mov	r4, r0
20028b62:	460d      	mov	r5, r1
20028b64:	4610      	mov	r0, r2
20028b66:	2100      	movs	r1, #0
20028b68:	4616      	mov	r6, r2
20028b6a:	f7ff fc74 	bl	20028456 <mbedtls_mpi_cmp_int>
20028b6e:	2800      	cmp	r0, #0
20028b70:	db24      	blt.n	20028bbc <mbedtls_mpi_mod_mpi+0x5e>
20028b72:	462a      	mov	r2, r5
20028b74:	4633      	mov	r3, r6
20028b76:	4621      	mov	r1, r4
20028b78:	2000      	movs	r0, #0
20028b7a:	f7ff fdec 	bl	20028756 <mbedtls_mpi_div_mpi>
20028b7e:	4605      	mov	r5, r0
20028b80:	b138      	cbz	r0, 20028b92 <mbedtls_mpi_mod_mpi+0x34>
20028b82:	4628      	mov	r0, r5
20028b84:	bd70      	pop	{r4, r5, r6, pc}
20028b86:	4632      	mov	r2, r6
20028b88:	4621      	mov	r1, r4
20028b8a:	4620      	mov	r0, r4
20028b8c:	f7ff fd0f 	bl	200285ae <mbedtls_mpi_add_mpi>
20028b90:	b990      	cbnz	r0, 20028bb8 <mbedtls_mpi_mod_mpi+0x5a>
20028b92:	2100      	movs	r1, #0
20028b94:	4620      	mov	r0, r4
20028b96:	f7ff fc5e 	bl	20028456 <mbedtls_mpi_cmp_int>
20028b9a:	2800      	cmp	r0, #0
20028b9c:	dbf3      	blt.n	20028b86 <mbedtls_mpi_mod_mpi+0x28>
20028b9e:	4631      	mov	r1, r6
20028ba0:	4620      	mov	r0, r4
20028ba2:	f7ff fc17 	bl	200283d4 <mbedtls_mpi_cmp_mpi>
20028ba6:	2800      	cmp	r0, #0
20028ba8:	dbeb      	blt.n	20028b82 <mbedtls_mpi_mod_mpi+0x24>
20028baa:	4632      	mov	r2, r6
20028bac:	4621      	mov	r1, r4
20028bae:	4620      	mov	r0, r4
20028bb0:	f7ff fd23 	bl	200285fa <mbedtls_mpi_sub_mpi>
20028bb4:	2800      	cmp	r0, #0
20028bb6:	d0f2      	beq.n	20028b9e <mbedtls_mpi_mod_mpi+0x40>
20028bb8:	4605      	mov	r5, r0
20028bba:	e7e2      	b.n	20028b82 <mbedtls_mpi_mod_mpi+0x24>
20028bbc:	f06f 0509 	mvn.w	r5, #9
20028bc0:	e7df      	b.n	20028b82 <mbedtls_mpi_mod_mpi+0x24>

20028bc2 <mbedtls_mpi_exp_mod>:
20028bc2:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
20028bc6:	4605      	mov	r5, r0
20028bc8:	f2ad 6d54 	subw	sp, sp, #1620	@ 0x654
20028bcc:	4688      	mov	r8, r1
20028bce:	4618      	mov	r0, r3
20028bd0:	2100      	movs	r1, #0
20028bd2:	461c      	mov	r4, r3
20028bd4:	9203      	str	r2, [sp, #12]
20028bd6:	f7ff fc3e 	bl	20028456 <mbedtls_mpi_cmp_int>
20028bda:	2800      	cmp	r0, #0
20028bdc:	f2c0 8202 	blt.w	20028fe4 <mbedtls_mpi_exp_mod+0x422>
20028be0:	68a3      	ldr	r3, [r4, #8]
20028be2:	681f      	ldr	r7, [r3, #0]
20028be4:	f017 0301 	ands.w	r3, r7, #1
20028be8:	9305      	str	r3, [sp, #20]
20028bea:	f000 81fb 	beq.w	20028fe4 <mbedtls_mpi_exp_mod+0x422>
20028bee:	2100      	movs	r1, #0
20028bf0:	9803      	ldr	r0, [sp, #12]
20028bf2:	f7ff fc30 	bl	20028456 <mbedtls_mpi_cmp_int>
20028bf6:	2800      	cmp	r0, #0
20028bf8:	f2c0 81f4 	blt.w	20028fe4 <mbedtls_mpi_exp_mod+0x422>
20028bfc:	2100      	movs	r1, #0
20028bfe:	2301      	movs	r3, #1
20028c00:	f44f 62c0 	mov.w	r2, #1536	@ 0x600
20028c04:	a814      	add	r0, sp, #80	@ 0x50
20028c06:	e9cd 3108 	strd	r3, r1, [sp, #32]
20028c0a:	e9cd 130a 	strd	r1, r3, [sp, #40]	@ 0x28
20028c0e:	e9cd 110c 	strd	r1, r1, [sp, #48]	@ 0x30
20028c12:	e9cd 310e 	strd	r3, r1, [sp, #56]	@ 0x38
20028c16:	9110      	str	r1, [sp, #64]	@ 0x40
20028c18:	f001 ff1c 	bl	2002aa54 <memset>
20028c1c:	9803      	ldr	r0, [sp, #12]
20028c1e:	f7ff fa26 	bl	2002806e <mbedtls_mpi_bitlen>
20028c22:	f5b0 7f28 	cmp.w	r0, #672	@ 0x2a0
20028c26:	d233      	bcs.n	20028c90 <mbedtls_mpi_exp_mod+0xce>
20028c28:	28ef      	cmp	r0, #239	@ 0xef
20028c2a:	d833      	bhi.n	20028c94 <mbedtls_mpi_exp_mod+0xd2>
20028c2c:	284f      	cmp	r0, #79	@ 0x4f
20028c2e:	d833      	bhi.n	20028c98 <mbedtls_mpi_exp_mod+0xd6>
20028c30:	9b05      	ldr	r3, [sp, #20]
20028c32:	2818      	cmp	r0, #24
20028c34:	bf34      	ite	cc
20028c36:	461e      	movcc	r6, r3
20028c38:	2603      	movcs	r6, #3
20028c3a:	6863      	ldr	r3, [r4, #4]
20028c3c:	4628      	mov	r0, r5
20028c3e:	f103 0901 	add.w	r9, r3, #1
20028c42:	4649      	mov	r1, r9
20028c44:	f7ff f98a 	bl	20027f5c <mbedtls_mpi_grow>
20028c48:	b340      	cbz	r0, 20028c9c <mbedtls_mpi_exp_mod+0xda>
20028c4a:	f06f 090f 	mvn.w	r9, #15
20028c4e:	2301      	movs	r3, #1
20028c50:	1e74      	subs	r4, r6, #1
20028c52:	fa03 f506 	lsl.w	r5, r3, r6
20028c56:	260c      	movs	r6, #12
20028c58:	fa03 f404 	lsl.w	r4, r3, r4
20028c5c:	af14      	add	r7, sp, #80	@ 0x50
20028c5e:	42a5      	cmp	r5, r4
20028c60:	f200 81ba 	bhi.w	20028fd8 <mbedtls_mpi_exp_mod+0x416>
20028c64:	a817      	add	r0, sp, #92	@ 0x5c
20028c66:	f7ff f964 	bl	20027f32 <mbedtls_mpi_free>
20028c6a:	a80b      	add	r0, sp, #44	@ 0x2c
20028c6c:	f7ff f961 	bl	20027f32 <mbedtls_mpi_free>
20028c70:	a80e      	add	r0, sp, #56	@ 0x38
20028c72:	f7ff f95e 	bl	20027f32 <mbedtls_mpi_free>
20028c76:	f8dd 3678 	ldr.w	r3, [sp, #1656]	@ 0x678
20028c7a:	b10b      	cbz	r3, 20028c80 <mbedtls_mpi_exp_mod+0xbe>
20028c7c:	689b      	ldr	r3, [r3, #8]
20028c7e:	b913      	cbnz	r3, 20028c86 <mbedtls_mpi_exp_mod+0xc4>
20028c80:	a808      	add	r0, sp, #32
20028c82:	f7ff f956 	bl	20027f32 <mbedtls_mpi_free>
20028c86:	4648      	mov	r0, r9
20028c88:	f20d 6d54 	addw	sp, sp, #1620	@ 0x654
20028c8c:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
20028c90:	2606      	movs	r6, #6
20028c92:	e7d2      	b.n	20028c3a <mbedtls_mpi_exp_mod+0x78>
20028c94:	2605      	movs	r6, #5
20028c96:	e7d0      	b.n	20028c3a <mbedtls_mpi_exp_mod+0x78>
20028c98:	2604      	movs	r6, #4
20028c9a:	e7ce      	b.n	20028c3a <mbedtls_mpi_exp_mod+0x78>
20028c9c:	4649      	mov	r1, r9
20028c9e:	a817      	add	r0, sp, #92	@ 0x5c
20028ca0:	f7ff f95c 	bl	20027f5c <mbedtls_mpi_grow>
20028ca4:	2800      	cmp	r0, #0
20028ca6:	d1d0      	bne.n	20028c4a <mbedtls_mpi_exp_mod+0x88>
20028ca8:	ea4f 0149 	mov.w	r1, r9, lsl #1
20028cac:	a80b      	add	r0, sp, #44	@ 0x2c
20028cae:	f7ff f955 	bl	20027f5c <mbedtls_mpi_grow>
20028cb2:	2800      	cmp	r0, #0
20028cb4:	d1c9      	bne.n	20028c4a <mbedtls_mpi_exp_mod+0x88>
20028cb6:	f8d8 3000 	ldr.w	r3, [r8]
20028cba:	9304      	str	r3, [sp, #16]
20028cbc:	3301      	adds	r3, #1
20028cbe:	d109      	bne.n	20028cd4 <mbedtls_mpi_exp_mod+0x112>
20028cc0:	4641      	mov	r1, r8
20028cc2:	a80e      	add	r0, sp, #56	@ 0x38
20028cc4:	f7ff f976 	bl	20027fb4 <mbedtls_mpi_copy>
20028cc8:	2800      	cmp	r0, #0
20028cca:	d1be      	bne.n	20028c4a <mbedtls_mpi_exp_mod+0x88>
20028ccc:	2301      	movs	r3, #1
20028cce:	f10d 0838 	add.w	r8, sp, #56	@ 0x38
20028cd2:	930e      	str	r3, [sp, #56]	@ 0x38
20028cd4:	f8dd 3678 	ldr.w	r3, [sp, #1656]	@ 0x678
20028cd8:	b11b      	cbz	r3, 20028ce2 <mbedtls_mpi_exp_mod+0x120>
20028cda:	689b      	ldr	r3, [r3, #8]
20028cdc:	2b00      	cmp	r3, #0
20028cde:	f040 80ab 	bne.w	20028e38 <mbedtls_mpi_exp_mod+0x276>
20028ce2:	2101      	movs	r1, #1
20028ce4:	a808      	add	r0, sp, #32
20028ce6:	f7ff f98e 	bl	20028006 <mbedtls_mpi_lset>
20028cea:	2800      	cmp	r0, #0
20028cec:	d1ad      	bne.n	20028c4a <mbedtls_mpi_exp_mod+0x88>
20028cee:	6861      	ldr	r1, [r4, #4]
20028cf0:	a808      	add	r0, sp, #32
20028cf2:	0189      	lsls	r1, r1, #6
20028cf4:	f7ff fa36 	bl	20028164 <mbedtls_mpi_shift_l>
20028cf8:	2800      	cmp	r0, #0
20028cfa:	d1a6      	bne.n	20028c4a <mbedtls_mpi_exp_mod+0x88>
20028cfc:	a908      	add	r1, sp, #32
20028cfe:	4622      	mov	r2, r4
20028d00:	4608      	mov	r0, r1
20028d02:	f7ff ff2c 	bl	20028b5e <mbedtls_mpi_mod_mpi>
20028d06:	4681      	mov	r9, r0
20028d08:	2800      	cmp	r0, #0
20028d0a:	d1a0      	bne.n	20028c4e <mbedtls_mpi_exp_mod+0x8c>
20028d0c:	f8dd 3678 	ldr.w	r3, [sp, #1656]	@ 0x678
20028d10:	b13b      	cbz	r3, 20028d22 <mbedtls_mpi_exp_mod+0x160>
20028d12:	f8dd 2678 	ldr.w	r2, [sp, #1656]	@ 0x678
20028d16:	ab08      	add	r3, sp, #32
20028d18:	cb03      	ldmia	r3!, {r0, r1}
20028d1a:	6010      	str	r0, [r2, #0]
20028d1c:	6818      	ldr	r0, [r3, #0]
20028d1e:	6051      	str	r1, [r2, #4]
20028d20:	6090      	str	r0, [r2, #8]
20028d22:	4621      	mov	r1, r4
20028d24:	4640      	mov	r0, r8
20028d26:	f7ff fb55 	bl	200283d4 <mbedtls_mpi_cmp_mpi>
20028d2a:	2800      	cmp	r0, #0
20028d2c:	f2c0 808d 	blt.w	20028e4a <mbedtls_mpi_exp_mod+0x288>
20028d30:	4622      	mov	r2, r4
20028d32:	4641      	mov	r1, r8
20028d34:	a817      	add	r0, sp, #92	@ 0x5c
20028d36:	f7ff ff12 	bl	20028b5e <mbedtls_mpi_mod_mpi>
20028d3a:	4681      	mov	r9, r0
20028d3c:	2800      	cmp	r0, #0
20028d3e:	d186      	bne.n	20028c4e <mbedtls_mpi_exp_mod+0x8c>
20028d40:	1cba      	adds	r2, r7, #2
20028d42:	0052      	lsls	r2, r2, #1
20028d44:	f002 0208 	and.w	r2, r2, #8
20028d48:	443a      	add	r2, r7
20028d4a:	fb02 f307 	mul.w	r3, r2, r7
20028d4e:	f1c3 0302 	rsb	r3, r3, #2
20028d52:	4353      	muls	r3, r2
20028d54:	fb03 f207 	mul.w	r2, r3, r7
20028d58:	f1c2 0202 	rsb	r2, r2, #2
20028d5c:	4353      	muls	r3, r2
20028d5e:	435f      	muls	r7, r3
20028d60:	3f02      	subs	r7, #2
20028d62:	437b      	muls	r3, r7
20028d64:	f10d 0b2c 	add.w	fp, sp, #44	@ 0x2c
20028d68:	4622      	mov	r2, r4
20028d6a:	f8cd b000 	str.w	fp, [sp]
20028d6e:	a908      	add	r1, sp, #32
20028d70:	a817      	add	r0, sp, #92	@ 0x5c
20028d72:	9302      	str	r3, [sp, #8]
20028d74:	f7ff fac4 	bl	20028300 <mpi_montmul>
20028d78:	2800      	cmp	r0, #0
20028d7a:	f040 80e4 	bne.w	20028f46 <mbedtls_mpi_exp_mod+0x384>
20028d7e:	4628      	mov	r0, r5
20028d80:	a908      	add	r1, sp, #32
20028d82:	f7ff f917 	bl	20027fb4 <mbedtls_mpi_copy>
20028d86:	2800      	cmp	r0, #0
20028d88:	f47f af5f 	bne.w	20028c4a <mbedtls_mpi_exp_mod+0x88>
20028d8c:	2301      	movs	r3, #1
20028d8e:	aa07      	add	r2, sp, #28
20028d90:	e9cd 3311 	strd	r3, r3, [sp, #68]	@ 0x44
20028d94:	9307      	str	r3, [sp, #28]
20028d96:	9213      	str	r2, [sp, #76]	@ 0x4c
20028d98:	4628      	mov	r0, r5
20028d9a:	4622      	mov	r2, r4
20028d9c:	9b02      	ldr	r3, [sp, #8]
20028d9e:	f8cd b000 	str.w	fp, [sp]
20028da2:	a911      	add	r1, sp, #68	@ 0x44
20028da4:	f7ff faac 	bl	20028300 <mpi_montmul>
20028da8:	2800      	cmp	r0, #0
20028daa:	f040 80cc 	bne.w	20028f46 <mbedtls_mpi_exp_mod+0x384>
20028dae:	2e01      	cmp	r6, #1
20028db0:	d153      	bne.n	20028e5a <mbedtls_mpi_exp_mod+0x298>
20028db2:	f04f 0900 	mov.w	r9, #0
20028db6:	464f      	mov	r7, r9
20028db8:	46ca      	mov	sl, r9
20028dba:	46c8      	mov	r8, r9
20028dbc:	9b03      	ldr	r3, [sp, #12]
20028dbe:	f8d3 b004 	ldr.w	fp, [r3, #4]
20028dc2:	f1ba 0f00 	cmp.w	sl, #0
20028dc6:	f040 80a1 	bne.w	20028f0c <mbedtls_mpi_exp_mod+0x34a>
20028dca:	f1bb 0f00 	cmp.w	fp, #0
20028dce:	f040 8099 	bne.w	20028f04 <mbedtls_mpi_exp_mod+0x342>
20028dd2:	f04f 0a01 	mov.w	sl, #1
20028dd6:	f10d 092c 	add.w	r9, sp, #44	@ 0x2c
20028dda:	fa0a fa06 	lsl.w	sl, sl, r6
20028dde:	45bb      	cmp	fp, r7
20028de0:	f040 80dd 	bne.w	20028f9e <mbedtls_mpi_exp_mod+0x3dc>
20028de4:	2301      	movs	r3, #1
20028de6:	aa07      	add	r2, sp, #28
20028de8:	e9cd 3311 	strd	r3, r3, [sp, #68]	@ 0x44
20028dec:	9307      	str	r3, [sp, #28]
20028dee:	9213      	str	r2, [sp, #76]	@ 0x4c
20028df0:	f8cd 9000 	str.w	r9, [sp]
20028df4:	4622      	mov	r2, r4
20028df6:	4628      	mov	r0, r5
20028df8:	9b02      	ldr	r3, [sp, #8]
20028dfa:	a911      	add	r1, sp, #68	@ 0x44
20028dfc:	f7ff fa80 	bl	20028300 <mpi_montmul>
20028e00:	4681      	mov	r9, r0
20028e02:	2800      	cmp	r0, #0
20028e04:	f040 809f 	bne.w	20028f46 <mbedtls_mpi_exp_mod+0x384>
20028e08:	9b04      	ldr	r3, [sp, #16]
20028e0a:	3301      	adds	r3, #1
20028e0c:	f47f af1f 	bne.w	20028c4e <mbedtls_mpi_exp_mod+0x8c>
20028e10:	9b03      	ldr	r3, [sp, #12]
20028e12:	685b      	ldr	r3, [r3, #4]
20028e14:	2b00      	cmp	r3, #0
20028e16:	f43f af1a 	beq.w	20028c4e <mbedtls_mpi_exp_mod+0x8c>
20028e1a:	9b03      	ldr	r3, [sp, #12]
20028e1c:	689b      	ldr	r3, [r3, #8]
20028e1e:	681b      	ldr	r3, [r3, #0]
20028e20:	07db      	lsls	r3, r3, #31
20028e22:	f57f af14 	bpl.w	20028c4e <mbedtls_mpi_exp_mod+0x8c>
20028e26:	9b04      	ldr	r3, [sp, #16]
20028e28:	462a      	mov	r2, r5
20028e2a:	4621      	mov	r1, r4
20028e2c:	4628      	mov	r0, r5
20028e2e:	602b      	str	r3, [r5, #0]
20028e30:	f7ff fbbd 	bl	200285ae <mbedtls_mpi_add_mpi>
20028e34:	4681      	mov	r9, r0
20028e36:	e70a      	b.n	20028c4e <mbedtls_mpi_exp_mod+0x8c>
20028e38:	f8dd 2678 	ldr.w	r2, [sp, #1656]	@ 0x678
20028e3c:	ab08      	add	r3, sp, #32
20028e3e:	6810      	ldr	r0, [r2, #0]
20028e40:	6851      	ldr	r1, [r2, #4]
20028e42:	c303      	stmia	r3!, {r0, r1}
20028e44:	6890      	ldr	r0, [r2, #8]
20028e46:	6018      	str	r0, [r3, #0]
20028e48:	e76b      	b.n	20028d22 <mbedtls_mpi_exp_mod+0x160>
20028e4a:	4641      	mov	r1, r8
20028e4c:	a817      	add	r0, sp, #92	@ 0x5c
20028e4e:	f7ff f8b1 	bl	20027fb4 <mbedtls_mpi_copy>
20028e52:	2800      	cmp	r0, #0
20028e54:	f43f af74 	beq.w	20028d40 <mbedtls_mpi_exp_mod+0x17e>
20028e58:	e6f7      	b.n	20028c4a <mbedtls_mpi_exp_mod+0x88>
20028e5a:	f04f 0a0c 	mov.w	sl, #12
20028e5e:	1e77      	subs	r7, r6, #1
20028e60:	6861      	ldr	r1, [r4, #4]
20028e62:	fa0a fa07 	lsl.w	sl, sl, r7
20028e66:	f10d 0950 	add.w	r9, sp, #80	@ 0x50
20028e6a:	44d1      	add	r9, sl
20028e6c:	4648      	mov	r0, r9
20028e6e:	3101      	adds	r1, #1
20028e70:	f7ff f874 	bl	20027f5c <mbedtls_mpi_grow>
20028e74:	2800      	cmp	r0, #0
20028e76:	f47f aee8 	bne.w	20028c4a <mbedtls_mpi_exp_mod+0x88>
20028e7a:	4648      	mov	r0, r9
20028e7c:	a917      	add	r1, sp, #92	@ 0x5c
20028e7e:	f7ff f899 	bl	20027fb4 <mbedtls_mpi_copy>
20028e82:	2800      	cmp	r0, #0
20028e84:	f47f aee1 	bne.w	20028c4a <mbedtls_mpi_exp_mod+0x88>
20028e88:	4680      	mov	r8, r0
20028e8a:	4622      	mov	r2, r4
20028e8c:	4649      	mov	r1, r9
20028e8e:	4648      	mov	r0, r9
20028e90:	9b02      	ldr	r3, [sp, #8]
20028e92:	f8cd b000 	str.w	fp, [sp]
20028e96:	f7ff fa33 	bl	20028300 <mpi_montmul>
20028e9a:	2800      	cmp	r0, #0
20028e9c:	d153      	bne.n	20028f46 <mbedtls_mpi_exp_mod+0x384>
20028e9e:	f108 0801 	add.w	r8, r8, #1
20028ea2:	45b8      	cmp	r8, r7
20028ea4:	d3f1      	bcc.n	20028e8a <mbedtls_mpi_exp_mod+0x2c8>
20028ea6:	f04f 0801 	mov.w	r8, #1
20028eaa:	f10d 0b50 	add.w	fp, sp, #80	@ 0x50
20028eae:	fa08 f707 	lsl.w	r7, r8, r7
20028eb2:	4447      	add	r7, r8
20028eb4:	44d3      	add	fp, sl
20028eb6:	fa08 f806 	lsl.w	r8, r8, r6
20028eba:	f10d 0a2c 	add.w	sl, sp, #44	@ 0x2c
20028ebe:	45b8      	cmp	r8, r7
20028ec0:	f67f af77 	bls.w	20028db2 <mbedtls_mpi_exp_mod+0x1f0>
20028ec4:	6861      	ldr	r1, [r4, #4]
20028ec6:	f10b 090c 	add.w	r9, fp, #12
20028eca:	4648      	mov	r0, r9
20028ecc:	3101      	adds	r1, #1
20028ece:	f7ff f845 	bl	20027f5c <mbedtls_mpi_grow>
20028ed2:	2800      	cmp	r0, #0
20028ed4:	f47f aeb9 	bne.w	20028c4a <mbedtls_mpi_exp_mod+0x88>
20028ed8:	4659      	mov	r1, fp
20028eda:	4648      	mov	r0, r9
20028edc:	f7ff f86a 	bl	20027fb4 <mbedtls_mpi_copy>
20028ee0:	2800      	cmp	r0, #0
20028ee2:	f47f aeb2 	bne.w	20028c4a <mbedtls_mpi_exp_mod+0x88>
20028ee6:	4622      	mov	r2, r4
20028ee8:	4648      	mov	r0, r9
20028eea:	9b02      	ldr	r3, [sp, #8]
20028eec:	f8cd a000 	str.w	sl, [sp]
20028ef0:	a917      	add	r1, sp, #92	@ 0x5c
20028ef2:	f7ff fa05 	bl	20028300 <mpi_montmul>
20028ef6:	bb30      	cbnz	r0, 20028f46 <mbedtls_mpi_exp_mod+0x384>
20028ef8:	46cb      	mov	fp, r9
20028efa:	3701      	adds	r7, #1
20028efc:	e7df      	b.n	20028ebe <mbedtls_mpi_exp_mod+0x2fc>
20028efe:	f04f 0902 	mov.w	r9, #2
20028f02:	e75e      	b.n	20028dc2 <mbedtls_mpi_exp_mod+0x200>
20028f04:	f04f 0a20 	mov.w	sl, #32
20028f08:	f10b 3bff 	add.w	fp, fp, #4294967295
20028f0c:	9b03      	ldr	r3, [sp, #12]
20028f0e:	f10a 3aff 	add.w	sl, sl, #4294967295
20028f12:	689b      	ldr	r3, [r3, #8]
20028f14:	f853 302b 	ldr.w	r3, [r3, fp, lsl #2]
20028f18:	fa23 f30a 	lsr.w	r3, r3, sl
20028f1c:	f013 0301 	ands.w	r3, r3, #1
20028f20:	d114      	bne.n	20028f4c <mbedtls_mpi_exp_mod+0x38a>
20028f22:	f1b9 0f00 	cmp.w	r9, #0
20028f26:	f43f af4c 	beq.w	20028dc2 <mbedtls_mpi_exp_mod+0x200>
20028f2a:	f1b9 0f01 	cmp.w	r9, #1
20028f2e:	d10d      	bne.n	20028f4c <mbedtls_mpi_exp_mod+0x38a>
20028f30:	ab0b      	add	r3, sp, #44	@ 0x2c
20028f32:	9300      	str	r3, [sp, #0]
20028f34:	4622      	mov	r2, r4
20028f36:	4629      	mov	r1, r5
20028f38:	4628      	mov	r0, r5
20028f3a:	9b02      	ldr	r3, [sp, #8]
20028f3c:	f7ff f9e0 	bl	20028300 <mpi_montmul>
20028f40:	2800      	cmp	r0, #0
20028f42:	f43f af3e 	beq.w	20028dc2 <mbedtls_mpi_exp_mod+0x200>
20028f46:	f06f 0903 	mvn.w	r9, #3
20028f4a:	e680      	b.n	20028c4e <mbedtls_mpi_exp_mod+0x8c>
20028f4c:	3701      	adds	r7, #1
20028f4e:	1bf2      	subs	r2, r6, r7
20028f50:	4093      	lsls	r3, r2
20028f52:	42be      	cmp	r6, r7
20028f54:	ea48 0803 	orr.w	r8, r8, r3
20028f58:	d1d1      	bne.n	20028efe <mbedtls_mpi_exp_mod+0x33c>
20028f5a:	f04f 0900 	mov.w	r9, #0
20028f5e:	ab0b      	add	r3, sp, #44	@ 0x2c
20028f60:	9300      	str	r3, [sp, #0]
20028f62:	4622      	mov	r2, r4
20028f64:	4629      	mov	r1, r5
20028f66:	4628      	mov	r0, r5
20028f68:	9b02      	ldr	r3, [sp, #8]
20028f6a:	f7ff f9c9 	bl	20028300 <mpi_montmul>
20028f6e:	2800      	cmp	r0, #0
20028f70:	d1e9      	bne.n	20028f46 <mbedtls_mpi_exp_mod+0x384>
20028f72:	f109 0901 	add.w	r9, r9, #1
20028f76:	454f      	cmp	r7, r9
20028f78:	d8f1      	bhi.n	20028f5e <mbedtls_mpi_exp_mod+0x39c>
20028f7a:	200c      	movs	r0, #12
20028f7c:	ab0b      	add	r3, sp, #44	@ 0x2c
20028f7e:	a914      	add	r1, sp, #80	@ 0x50
20028f80:	fb00 1108 	mla	r1, r0, r8, r1
20028f84:	9300      	str	r3, [sp, #0]
20028f86:	4622      	mov	r2, r4
20028f88:	4628      	mov	r0, r5
20028f8a:	9b02      	ldr	r3, [sp, #8]
20028f8c:	f7ff f9b8 	bl	20028300 <mpi_montmul>
20028f90:	4607      	mov	r7, r0
20028f92:	2800      	cmp	r0, #0
20028f94:	d1d7      	bne.n	20028f46 <mbedtls_mpi_exp_mod+0x384>
20028f96:	4680      	mov	r8, r0
20028f98:	f8dd 9014 	ldr.w	r9, [sp, #20]
20028f9c:	e711      	b.n	20028dc2 <mbedtls_mpi_exp_mod+0x200>
20028f9e:	4622      	mov	r2, r4
20028fa0:	4629      	mov	r1, r5
20028fa2:	4628      	mov	r0, r5
20028fa4:	9b02      	ldr	r3, [sp, #8]
20028fa6:	f8cd 9000 	str.w	r9, [sp]
20028faa:	f7ff f9a9 	bl	20028300 <mpi_montmul>
20028fae:	2800      	cmp	r0, #0
20028fb0:	d1c9      	bne.n	20028f46 <mbedtls_mpi_exp_mod+0x384>
20028fb2:	ea4f 0848 	mov.w	r8, r8, lsl #1
20028fb6:	ea18 0f0a 	tst.w	r8, sl
20028fba:	d102      	bne.n	20028fc2 <mbedtls_mpi_exp_mod+0x400>
20028fbc:	f10b 0b01 	add.w	fp, fp, #1
20028fc0:	e70d      	b.n	20028dde <mbedtls_mpi_exp_mod+0x21c>
20028fc2:	4622      	mov	r2, r4
20028fc4:	4628      	mov	r0, r5
20028fc6:	9b02      	ldr	r3, [sp, #8]
20028fc8:	f8cd 9000 	str.w	r9, [sp]
20028fcc:	a917      	add	r1, sp, #92	@ 0x5c
20028fce:	f7ff f997 	bl	20028300 <mpi_montmul>
20028fd2:	2800      	cmp	r0, #0
20028fd4:	d0f2      	beq.n	20028fbc <mbedtls_mpi_exp_mod+0x3fa>
20028fd6:	e7b6      	b.n	20028f46 <mbedtls_mpi_exp_mod+0x384>
20028fd8:	fb06 7004 	mla	r0, r6, r4, r7
20028fdc:	f7fe ffa9 	bl	20027f32 <mbedtls_mpi_free>
20028fe0:	3401      	adds	r4, #1
20028fe2:	e63c      	b.n	20028c5e <mbedtls_mpi_exp_mod+0x9c>
20028fe4:	f06f 0903 	mvn.w	r9, #3
20028fe8:	e64d      	b.n	20028c86 <mbedtls_mpi_exp_mod+0xc4>

20028fea <mbedtls_mpi_gcd>:
20028fea:	b570      	push	{r4, r5, r6, lr}
20028fec:	2300      	movs	r3, #0
20028fee:	2401      	movs	r4, #1
20028ff0:	b086      	sub	sp, #24
20028ff2:	4606      	mov	r6, r0
20028ff4:	4668      	mov	r0, sp
20028ff6:	4615      	mov	r5, r2
20028ff8:	e9cd 4300 	strd	r4, r3, [sp]
20028ffc:	e9cd 3402 	strd	r3, r4, [sp, #8]
20029000:	e9cd 3304 	strd	r3, r3, [sp, #16]
20029004:	f7fe ffd6 	bl	20027fb4 <mbedtls_mpi_copy>
20029008:	b150      	cbz	r0, 20029020 <mbedtls_mpi_gcd+0x36>
2002900a:	f06f 040f 	mvn.w	r4, #15
2002900e:	4668      	mov	r0, sp
20029010:	f7fe ff8f 	bl	20027f32 <mbedtls_mpi_free>
20029014:	a803      	add	r0, sp, #12
20029016:	f7fe ff8c 	bl	20027f32 <mbedtls_mpi_free>
2002901a:	4620      	mov	r0, r4
2002901c:	b006      	add	sp, #24
2002901e:	bd70      	pop	{r4, r5, r6, pc}
20029020:	4629      	mov	r1, r5
20029022:	a803      	add	r0, sp, #12
20029024:	f7fe ffc6 	bl	20027fb4 <mbedtls_mpi_copy>
20029028:	2800      	cmp	r0, #0
2002902a:	d1ee      	bne.n	2002900a <mbedtls_mpi_gcd+0x20>
2002902c:	4668      	mov	r0, sp
2002902e:	f7ff f806 	bl	2002803e <mbedtls_mpi_lsb>
20029032:	4605      	mov	r5, r0
20029034:	a803      	add	r0, sp, #12
20029036:	f7ff f802 	bl	2002803e <mbedtls_mpi_lsb>
2002903a:	4285      	cmp	r5, r0
2002903c:	bf28      	it	cs
2002903e:	4605      	movcs	r5, r0
20029040:	4668      	mov	r0, sp
20029042:	4629      	mov	r1, r5
20029044:	f7ff f8e7 	bl	20028216 <mbedtls_mpi_shift_r>
20029048:	2800      	cmp	r0, #0
2002904a:	d1de      	bne.n	2002900a <mbedtls_mpi_gcd+0x20>
2002904c:	4629      	mov	r1, r5
2002904e:	a803      	add	r0, sp, #12
20029050:	f7ff f8e1 	bl	20028216 <mbedtls_mpi_shift_r>
20029054:	2800      	cmp	r0, #0
20029056:	d1d8      	bne.n	2002900a <mbedtls_mpi_gcd+0x20>
20029058:	9403      	str	r4, [sp, #12]
2002905a:	9400      	str	r4, [sp, #0]
2002905c:	2100      	movs	r1, #0
2002905e:	4668      	mov	r0, sp
20029060:	f7ff f9f9 	bl	20028456 <mbedtls_mpi_cmp_int>
20029064:	b968      	cbnz	r0, 20029082 <mbedtls_mpi_gcd+0x98>
20029066:	4629      	mov	r1, r5
20029068:	a803      	add	r0, sp, #12
2002906a:	f7ff f87b 	bl	20028164 <mbedtls_mpi_shift_l>
2002906e:	2800      	cmp	r0, #0
20029070:	d1cb      	bne.n	2002900a <mbedtls_mpi_gcd+0x20>
20029072:	4630      	mov	r0, r6
20029074:	a903      	add	r1, sp, #12
20029076:	f7fe ff9d 	bl	20027fb4 <mbedtls_mpi_copy>
2002907a:	4604      	mov	r4, r0
2002907c:	2800      	cmp	r0, #0
2002907e:	d0c6      	beq.n	2002900e <mbedtls_mpi_gcd+0x24>
20029080:	e7c3      	b.n	2002900a <mbedtls_mpi_gcd+0x20>
20029082:	4668      	mov	r0, sp
20029084:	f7fe ffdb 	bl	2002803e <mbedtls_mpi_lsb>
20029088:	4601      	mov	r1, r0
2002908a:	4668      	mov	r0, sp
2002908c:	f7ff f8c3 	bl	20028216 <mbedtls_mpi_shift_r>
20029090:	2800      	cmp	r0, #0
20029092:	d1ba      	bne.n	2002900a <mbedtls_mpi_gcd+0x20>
20029094:	a803      	add	r0, sp, #12
20029096:	f7fe ffd2 	bl	2002803e <mbedtls_mpi_lsb>
2002909a:	4601      	mov	r1, r0
2002909c:	a803      	add	r0, sp, #12
2002909e:	f7ff f8ba 	bl	20028216 <mbedtls_mpi_shift_r>
200290a2:	2800      	cmp	r0, #0
200290a4:	d1b1      	bne.n	2002900a <mbedtls_mpi_gcd+0x20>
200290a6:	4668      	mov	r0, sp
200290a8:	a903      	add	r1, sp, #12
200290aa:	f7ff f993 	bl	200283d4 <mbedtls_mpi_cmp_mpi>
200290ae:	2800      	cmp	r0, #0
200290b0:	db0e      	blt.n	200290d0 <mbedtls_mpi_gcd+0xe6>
200290b2:	4669      	mov	r1, sp
200290b4:	4668      	mov	r0, sp
200290b6:	aa03      	add	r2, sp, #12
200290b8:	f7ff fa3c 	bl	20028534 <mbedtls_mpi_sub_abs>
200290bc:	4604      	mov	r4, r0
200290be:	2800      	cmp	r0, #0
200290c0:	d1a5      	bne.n	2002900e <mbedtls_mpi_gcd+0x24>
200290c2:	2101      	movs	r1, #1
200290c4:	4668      	mov	r0, sp
200290c6:	f7ff f8a6 	bl	20028216 <mbedtls_mpi_shift_r>
200290ca:	2800      	cmp	r0, #0
200290cc:	d0c6      	beq.n	2002905c <mbedtls_mpi_gcd+0x72>
200290ce:	e79c      	b.n	2002900a <mbedtls_mpi_gcd+0x20>
200290d0:	a903      	add	r1, sp, #12
200290d2:	466a      	mov	r2, sp
200290d4:	4608      	mov	r0, r1
200290d6:	f7ff fa2d 	bl	20028534 <mbedtls_mpi_sub_abs>
200290da:	4604      	mov	r4, r0
200290dc:	2800      	cmp	r0, #0
200290de:	d196      	bne.n	2002900e <mbedtls_mpi_gcd+0x24>
200290e0:	2101      	movs	r1, #1
200290e2:	a803      	add	r0, sp, #12
200290e4:	e7ef      	b.n	200290c6 <mbedtls_mpi_gcd+0xdc>

200290e6 <mbedtls_mpi_fill_random>:
200290e6:	b570      	push	{r4, r5, r6, lr}
200290e8:	f5b1 6f80 	cmp.w	r1, #1024	@ 0x400
200290ec:	4605      	mov	r5, r0
200290ee:	460c      	mov	r4, r1
200290f0:	4616      	mov	r6, r2
200290f2:	4618      	mov	r0, r3
200290f4:	f5ad 6d80 	sub.w	sp, sp, #1024	@ 0x400
200290f8:	d80f      	bhi.n	2002911a <mbedtls_mpi_fill_random+0x34>
200290fa:	460a      	mov	r2, r1
200290fc:	4669      	mov	r1, sp
200290fe:	47b0      	blx	r6
20029100:	b940      	cbnz	r0, 20029114 <mbedtls_mpi_fill_random+0x2e>
20029102:	4622      	mov	r2, r4
20029104:	4669      	mov	r1, sp
20029106:	4628      	mov	r0, r5
20029108:	f7fe ffd4 	bl	200280b4 <mbedtls_mpi_read_binary>
2002910c:	2800      	cmp	r0, #0
2002910e:	bf18      	it	ne
20029110:	f06f 000f 	mvnne.w	r0, #15
20029114:	f50d 6d80 	add.w	sp, sp, #1024	@ 0x400
20029118:	bd70      	pop	{r4, r5, r6, pc}
2002911a:	f06f 0003 	mvn.w	r0, #3
2002911e:	e7f9      	b.n	20029114 <mbedtls_mpi_fill_random+0x2e>

20029120 <mbedtls_mpi_inv_mod>:
20029120:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
20029124:	b09f      	sub	sp, #124	@ 0x7c
20029126:	9001      	str	r0, [sp, #4]
20029128:	460f      	mov	r7, r1
2002912a:	4610      	mov	r0, r2
2002912c:	2101      	movs	r1, #1
2002912e:	4692      	mov	sl, r2
20029130:	f7ff f991 	bl	20028456 <mbedtls_mpi_cmp_int>
20029134:	2800      	cmp	r0, #0
20029136:	f340 81b5 	ble.w	200294a4 <mbedtls_mpi_inv_mod+0x384>
2002913a:	2500      	movs	r5, #0
2002913c:	2601      	movs	r6, #1
2002913e:	4652      	mov	r2, sl
20029140:	4639      	mov	r1, r7
20029142:	a803      	add	r0, sp, #12
20029144:	e9cd 6506 	strd	r6, r5, [sp, #24]
20029148:	e9cd 5608 	strd	r5, r6, [sp, #32]
2002914c:	e9cd 650c 	strd	r6, r5, [sp, #48]	@ 0x30
20029150:	e9cd 650f 	strd	r6, r5, [sp, #60]	@ 0x3c
20029154:	e9cd 6503 	strd	r6, r5, [sp, #12]
20029158:	e9cd 6512 	strd	r6, r5, [sp, #72]	@ 0x48
2002915c:	e9cd 5614 	strd	r5, r6, [sp, #80]	@ 0x50
20029160:	e9cd 6518 	strd	r6, r5, [sp, #96]	@ 0x60
20029164:	e9cd 651b 	strd	r6, r5, [sp, #108]	@ 0x6c
20029168:	950a      	str	r5, [sp, #40]	@ 0x28
2002916a:	9505      	str	r5, [sp, #20]
2002916c:	9516      	str	r5, [sp, #88]	@ 0x58
2002916e:	f7ff ff3c 	bl	20028fea <mbedtls_mpi_gcd>
20029172:	4604      	mov	r4, r0
20029174:	2800      	cmp	r0, #0
20029176:	f040 8182 	bne.w	2002947e <mbedtls_mpi_inv_mod+0x35e>
2002917a:	4631      	mov	r1, r6
2002917c:	a803      	add	r0, sp, #12
2002917e:	f7ff f96a 	bl	20028456 <mbedtls_mpi_cmp_int>
20029182:	4605      	mov	r5, r0
20029184:	2800      	cmp	r0, #0
20029186:	f040 8171 	bne.w	2002946c <mbedtls_mpi_inv_mod+0x34c>
2002918a:	4652      	mov	r2, sl
2002918c:	4639      	mov	r1, r7
2002918e:	a806      	add	r0, sp, #24
20029190:	f7ff fce5 	bl	20028b5e <mbedtls_mpi_mod_mpi>
20029194:	4604      	mov	r4, r0
20029196:	2800      	cmp	r0, #0
20029198:	f040 8171 	bne.w	2002947e <mbedtls_mpi_inv_mod+0x35e>
2002919c:	900b      	str	r0, [sp, #44]	@ 0x2c
2002919e:	a906      	add	r1, sp, #24
200291a0:	a809      	add	r0, sp, #36	@ 0x24
200291a2:	f7fe ff07 	bl	20027fb4 <mbedtls_mpi_copy>
200291a6:	f8dd 902c 	ldr.w	r9, [sp, #44]	@ 0x2c
200291aa:	b920      	cbnz	r0, 200291b6 <mbedtls_mpi_inv_mod+0x96>
200291ac:	4651      	mov	r1, sl
200291ae:	a812      	add	r0, sp, #72	@ 0x48
200291b0:	f7fe ff00 	bl	20027fb4 <mbedtls_mpi_copy>
200291b4:	b130      	cbz	r0, 200291c4 <mbedtls_mpi_inv_mod+0xa4>
200291b6:	f04f 0b00 	mov.w	fp, #0
200291ba:	465d      	mov	r5, fp
200291bc:	46d8      	mov	r8, fp
200291be:	465e      	mov	r6, fp
200291c0:	465f      	mov	r7, fp
200291c2:	e0f5      	b.n	200293b0 <mbedtls_mpi_inv_mod+0x290>
200291c4:	9017      	str	r0, [sp, #92]	@ 0x5c
200291c6:	4651      	mov	r1, sl
200291c8:	a815      	add	r0, sp, #84	@ 0x54
200291ca:	f7fe fef3 	bl	20027fb4 <mbedtls_mpi_copy>
200291ce:	f8dd 805c 	ldr.w	r8, [sp, #92]	@ 0x5c
200291d2:	2800      	cmp	r0, #0
200291d4:	f040 8159 	bne.w	2002948a <mbedtls_mpi_inv_mod+0x36a>
200291d8:	4631      	mov	r1, r6
200291da:	900e      	str	r0, [sp, #56]	@ 0x38
200291dc:	a80c      	add	r0, sp, #48	@ 0x30
200291de:	f7fe ff12 	bl	20028006 <mbedtls_mpi_lset>
200291e2:	9f0e      	ldr	r7, [sp, #56]	@ 0x38
200291e4:	4601      	mov	r1, r0
200291e6:	2800      	cmp	r0, #0
200291e8:	f040 8152 	bne.w	20029490 <mbedtls_mpi_inv_mod+0x370>
200291ec:	9011      	str	r0, [sp, #68]	@ 0x44
200291ee:	a80f      	add	r0, sp, #60	@ 0x3c
200291f0:	f7fe ff09 	bl	20028006 <mbedtls_mpi_lset>
200291f4:	9e11      	ldr	r6, [sp, #68]	@ 0x44
200291f6:	4683      	mov	fp, r0
200291f8:	2800      	cmp	r0, #0
200291fa:	f040 814d 	bne.w	20029498 <mbedtls_mpi_inv_mod+0x378>
200291fe:	4601      	mov	r1, r0
20029200:	901a      	str	r0, [sp, #104]	@ 0x68
20029202:	a818      	add	r0, sp, #96	@ 0x60
20029204:	f7fe feff 	bl	20028006 <mbedtls_mpi_lset>
20029208:	9d1a      	ldr	r5, [sp, #104]	@ 0x68
2002920a:	2800      	cmp	r0, #0
2002920c:	f040 8147 	bne.w	2002949e <mbedtls_mpi_inv_mod+0x37e>
20029210:	2101      	movs	r1, #1
20029212:	a81b      	add	r0, sp, #108	@ 0x6c
20029214:	f8cd b074 	str.w	fp, [sp, #116]	@ 0x74
20029218:	f7fe fef5 	bl	20028006 <mbedtls_mpi_lset>
2002921c:	f8dd b074 	ldr.w	fp, [sp, #116]	@ 0x74
20029220:	2800      	cmp	r0, #0
20029222:	f040 80c5 	bne.w	200293b0 <mbedtls_mpi_inv_mod+0x290>
20029226:	f8d9 2000 	ldr.w	r2, [r9]
2002922a:	07d0      	lsls	r0, r2, #31
2002922c:	d554      	bpl.n	200292d8 <mbedtls_mpi_inv_mod+0x1b8>
2002922e:	f8d8 2000 	ldr.w	r2, [r8]
20029232:	07d3      	lsls	r3, r2, #31
20029234:	f140 8083 	bpl.w	2002933e <mbedtls_mpi_inv_mod+0x21e>
20029238:	a915      	add	r1, sp, #84	@ 0x54
2002923a:	a809      	add	r0, sp, #36	@ 0x24
2002923c:	f8cd 902c 	str.w	r9, [sp, #44]	@ 0x2c
20029240:	f8cd 805c 	str.w	r8, [sp, #92]	@ 0x5c
20029244:	f7ff f8c6 	bl	200283d4 <mbedtls_mpi_cmp_mpi>
20029248:	2800      	cmp	r0, #0
2002924a:	f2c0 80b4 	blt.w	200293b6 <mbedtls_mpi_inv_mod+0x296>
2002924e:	a909      	add	r1, sp, #36	@ 0x24
20029250:	4608      	mov	r0, r1
20029252:	aa15      	add	r2, sp, #84	@ 0x54
20029254:	f7ff f9d1 	bl	200285fa <mbedtls_mpi_sub_mpi>
20029258:	f8dd 902c 	ldr.w	r9, [sp, #44]	@ 0x2c
2002925c:	4604      	mov	r4, r0
2002925e:	2800      	cmp	r0, #0
20029260:	f040 80d1 	bne.w	20029406 <mbedtls_mpi_inv_mod+0x2e6>
20029264:	a90c      	add	r1, sp, #48	@ 0x30
20029266:	4608      	mov	r0, r1
20029268:	aa18      	add	r2, sp, #96	@ 0x60
2002926a:	970e      	str	r7, [sp, #56]	@ 0x38
2002926c:	951a      	str	r5, [sp, #104]	@ 0x68
2002926e:	f7ff f9c4 	bl	200285fa <mbedtls_mpi_sub_mpi>
20029272:	9f0e      	ldr	r7, [sp, #56]	@ 0x38
20029274:	4604      	mov	r4, r0
20029276:	2800      	cmp	r0, #0
20029278:	f040 80c5 	bne.w	20029406 <mbedtls_mpi_inv_mod+0x2e6>
2002927c:	a90f      	add	r1, sp, #60	@ 0x3c
2002927e:	4608      	mov	r0, r1
20029280:	aa1b      	add	r2, sp, #108	@ 0x6c
20029282:	9611      	str	r6, [sp, #68]	@ 0x44
20029284:	f8cd b074 	str.w	fp, [sp, #116]	@ 0x74
20029288:	f7ff f9b7 	bl	200285fa <mbedtls_mpi_sub_mpi>
2002928c:	9e11      	ldr	r6, [sp, #68]	@ 0x44
2002928e:	4604      	mov	r4, r0
20029290:	2800      	cmp	r0, #0
20029292:	f040 80b8 	bne.w	20029406 <mbedtls_mpi_inv_mod+0x2e6>
20029296:	2100      	movs	r1, #0
20029298:	a809      	add	r0, sp, #36	@ 0x24
2002929a:	f8cd 902c 	str.w	r9, [sp, #44]	@ 0x2c
2002929e:	f7ff f8da 	bl	20028456 <mbedtls_mpi_cmp_int>
200292a2:	2800      	cmp	r0, #0
200292a4:	d1bf      	bne.n	20029226 <mbedtls_mpi_inv_mod+0x106>
200292a6:	2100      	movs	r1, #0
200292a8:	a818      	add	r0, sp, #96	@ 0x60
200292aa:	951a      	str	r5, [sp, #104]	@ 0x68
200292ac:	f7ff f8d3 	bl	20028456 <mbedtls_mpi_cmp_int>
200292b0:	2800      	cmp	r0, #0
200292b2:	f2c0 809e 	blt.w	200293f2 <mbedtls_mpi_inv_mod+0x2d2>
200292b6:	4651      	mov	r1, sl
200292b8:	a818      	add	r0, sp, #96	@ 0x60
200292ba:	951a      	str	r5, [sp, #104]	@ 0x68
200292bc:	f7ff f88a 	bl	200283d4 <mbedtls_mpi_cmp_mpi>
200292c0:	2800      	cmp	r0, #0
200292c2:	f280 80c8 	bge.w	20029456 <mbedtls_mpi_inv_mod+0x336>
200292c6:	9801      	ldr	r0, [sp, #4]
200292c8:	a918      	add	r1, sp, #96	@ 0x60
200292ca:	f7fe fe73 	bl	20027fb4 <mbedtls_mpi_copy>
200292ce:	1e04      	subs	r4, r0, #0
200292d0:	bf18      	it	ne
200292d2:	f06f 040f 	mvnne.w	r4, #15
200292d6:	e096      	b.n	20029406 <mbedtls_mpi_inv_mod+0x2e6>
200292d8:	2101      	movs	r1, #1
200292da:	a809      	add	r0, sp, #36	@ 0x24
200292dc:	f8cd 902c 	str.w	r9, [sp, #44]	@ 0x2c
200292e0:	f7fe ff99 	bl	20028216 <mbedtls_mpi_shift_r>
200292e4:	f8dd 902c 	ldr.w	r9, [sp, #44]	@ 0x2c
200292e8:	2800      	cmp	r0, #0
200292ea:	d161      	bne.n	200293b0 <mbedtls_mpi_inv_mod+0x290>
200292ec:	683a      	ldr	r2, [r7, #0]
200292ee:	07d3      	lsls	r3, r2, #31
200292f0:	d402      	bmi.n	200292f8 <mbedtls_mpi_inv_mod+0x1d8>
200292f2:	6832      	ldr	r2, [r6, #0]
200292f4:	07d4      	lsls	r4, r2, #31
200292f6:	d513      	bpl.n	20029320 <mbedtls_mpi_inv_mod+0x200>
200292f8:	a90c      	add	r1, sp, #48	@ 0x30
200292fa:	4608      	mov	r0, r1
200292fc:	aa12      	add	r2, sp, #72	@ 0x48
200292fe:	970e      	str	r7, [sp, #56]	@ 0x38
20029300:	f7ff f955 	bl	200285ae <mbedtls_mpi_add_mpi>
20029304:	9f0e      	ldr	r7, [sp, #56]	@ 0x38
20029306:	4604      	mov	r4, r0
20029308:	2800      	cmp	r0, #0
2002930a:	d17c      	bne.n	20029406 <mbedtls_mpi_inv_mod+0x2e6>
2002930c:	a90f      	add	r1, sp, #60	@ 0x3c
2002930e:	4608      	mov	r0, r1
20029310:	aa06      	add	r2, sp, #24
20029312:	9611      	str	r6, [sp, #68]	@ 0x44
20029314:	f7ff f971 	bl	200285fa <mbedtls_mpi_sub_mpi>
20029318:	9e11      	ldr	r6, [sp, #68]	@ 0x44
2002931a:	4604      	mov	r4, r0
2002931c:	2800      	cmp	r0, #0
2002931e:	d172      	bne.n	20029406 <mbedtls_mpi_inv_mod+0x2e6>
20029320:	2101      	movs	r1, #1
20029322:	a80c      	add	r0, sp, #48	@ 0x30
20029324:	970e      	str	r7, [sp, #56]	@ 0x38
20029326:	f7fe ff76 	bl	20028216 <mbedtls_mpi_shift_r>
2002932a:	9f0e      	ldr	r7, [sp, #56]	@ 0x38
2002932c:	2800      	cmp	r0, #0
2002932e:	d13f      	bne.n	200293b0 <mbedtls_mpi_inv_mod+0x290>
20029330:	2101      	movs	r1, #1
20029332:	a80f      	add	r0, sp, #60	@ 0x3c
20029334:	9611      	str	r6, [sp, #68]	@ 0x44
20029336:	f7fe ff6e 	bl	20028216 <mbedtls_mpi_shift_r>
2002933a:	9e11      	ldr	r6, [sp, #68]	@ 0x44
2002933c:	e770      	b.n	20029220 <mbedtls_mpi_inv_mod+0x100>
2002933e:	2101      	movs	r1, #1
20029340:	a815      	add	r0, sp, #84	@ 0x54
20029342:	f8cd 805c 	str.w	r8, [sp, #92]	@ 0x5c
20029346:	f7fe ff66 	bl	20028216 <mbedtls_mpi_shift_r>
2002934a:	f8dd 805c 	ldr.w	r8, [sp, #92]	@ 0x5c
2002934e:	2800      	cmp	r0, #0
20029350:	d12e      	bne.n	200293b0 <mbedtls_mpi_inv_mod+0x290>
20029352:	682a      	ldr	r2, [r5, #0]
20029354:	07d1      	lsls	r1, r2, #31
20029356:	d403      	bmi.n	20029360 <mbedtls_mpi_inv_mod+0x240>
20029358:	f8db 2000 	ldr.w	r2, [fp]
2002935c:	07d2      	lsls	r2, r2, #31
2002935e:	d515      	bpl.n	2002938c <mbedtls_mpi_inv_mod+0x26c>
20029360:	a918      	add	r1, sp, #96	@ 0x60
20029362:	4608      	mov	r0, r1
20029364:	aa12      	add	r2, sp, #72	@ 0x48
20029366:	951a      	str	r5, [sp, #104]	@ 0x68
20029368:	f7ff f921 	bl	200285ae <mbedtls_mpi_add_mpi>
2002936c:	9d1a      	ldr	r5, [sp, #104]	@ 0x68
2002936e:	4604      	mov	r4, r0
20029370:	2800      	cmp	r0, #0
20029372:	d148      	bne.n	20029406 <mbedtls_mpi_inv_mod+0x2e6>
20029374:	a91b      	add	r1, sp, #108	@ 0x6c
20029376:	4608      	mov	r0, r1
20029378:	aa06      	add	r2, sp, #24
2002937a:	f8cd b074 	str.w	fp, [sp, #116]	@ 0x74
2002937e:	f7ff f93c 	bl	200285fa <mbedtls_mpi_sub_mpi>
20029382:	f8dd b074 	ldr.w	fp, [sp, #116]	@ 0x74
20029386:	4604      	mov	r4, r0
20029388:	2800      	cmp	r0, #0
2002938a:	d13c      	bne.n	20029406 <mbedtls_mpi_inv_mod+0x2e6>
2002938c:	2101      	movs	r1, #1
2002938e:	a818      	add	r0, sp, #96	@ 0x60
20029390:	951a      	str	r5, [sp, #104]	@ 0x68
20029392:	f7fe ff40 	bl	20028216 <mbedtls_mpi_shift_r>
20029396:	9d1a      	ldr	r5, [sp, #104]	@ 0x68
20029398:	b950      	cbnz	r0, 200293b0 <mbedtls_mpi_inv_mod+0x290>
2002939a:	2101      	movs	r1, #1
2002939c:	a81b      	add	r0, sp, #108	@ 0x6c
2002939e:	f8cd b074 	str.w	fp, [sp, #116]	@ 0x74
200293a2:	f7fe ff38 	bl	20028216 <mbedtls_mpi_shift_r>
200293a6:	f8dd b074 	ldr.w	fp, [sp, #116]	@ 0x74
200293aa:	2800      	cmp	r0, #0
200293ac:	f43f af3f 	beq.w	2002922e <mbedtls_mpi_inv_mod+0x10e>
200293b0:	f06f 040f 	mvn.w	r4, #15
200293b4:	e027      	b.n	20029406 <mbedtls_mpi_inv_mod+0x2e6>
200293b6:	a915      	add	r1, sp, #84	@ 0x54
200293b8:	4608      	mov	r0, r1
200293ba:	aa09      	add	r2, sp, #36	@ 0x24
200293bc:	f7ff f91d 	bl	200285fa <mbedtls_mpi_sub_mpi>
200293c0:	f8dd 805c 	ldr.w	r8, [sp, #92]	@ 0x5c
200293c4:	4604      	mov	r4, r0
200293c6:	b9f0      	cbnz	r0, 20029406 <mbedtls_mpi_inv_mod+0x2e6>
200293c8:	a918      	add	r1, sp, #96	@ 0x60
200293ca:	4608      	mov	r0, r1
200293cc:	aa0c      	add	r2, sp, #48	@ 0x30
200293ce:	951a      	str	r5, [sp, #104]	@ 0x68
200293d0:	970e      	str	r7, [sp, #56]	@ 0x38
200293d2:	f7ff f912 	bl	200285fa <mbedtls_mpi_sub_mpi>
200293d6:	9d1a      	ldr	r5, [sp, #104]	@ 0x68
200293d8:	4604      	mov	r4, r0
200293da:	b9a0      	cbnz	r0, 20029406 <mbedtls_mpi_inv_mod+0x2e6>
200293dc:	a91b      	add	r1, sp, #108	@ 0x6c
200293de:	4608      	mov	r0, r1
200293e0:	aa0f      	add	r2, sp, #60	@ 0x3c
200293e2:	f8cd b074 	str.w	fp, [sp, #116]	@ 0x74
200293e6:	9611      	str	r6, [sp, #68]	@ 0x44
200293e8:	f7ff f907 	bl	200285fa <mbedtls_mpi_sub_mpi>
200293ec:	f8dd b074 	ldr.w	fp, [sp, #116]	@ 0x74
200293f0:	e74d      	b.n	2002928e <mbedtls_mpi_inv_mod+0x16e>
200293f2:	a918      	add	r1, sp, #96	@ 0x60
200293f4:	4652      	mov	r2, sl
200293f6:	4608      	mov	r0, r1
200293f8:	f7ff f8d9 	bl	200285ae <mbedtls_mpi_add_mpi>
200293fc:	9d1a      	ldr	r5, [sp, #104]	@ 0x68
200293fe:	4604      	mov	r4, r0
20029400:	2800      	cmp	r0, #0
20029402:	f43f af50 	beq.w	200292a6 <mbedtls_mpi_inv_mod+0x186>
20029406:	a806      	add	r0, sp, #24
20029408:	f7fe fd93 	bl	20027f32 <mbedtls_mpi_free>
2002940c:	a809      	add	r0, sp, #36	@ 0x24
2002940e:	f8cd 902c 	str.w	r9, [sp, #44]	@ 0x2c
20029412:	f7fe fd8e 	bl	20027f32 <mbedtls_mpi_free>
20029416:	a80c      	add	r0, sp, #48	@ 0x30
20029418:	970e      	str	r7, [sp, #56]	@ 0x38
2002941a:	f7fe fd8a 	bl	20027f32 <mbedtls_mpi_free>
2002941e:	a80f      	add	r0, sp, #60	@ 0x3c
20029420:	9611      	str	r6, [sp, #68]	@ 0x44
20029422:	f7fe fd86 	bl	20027f32 <mbedtls_mpi_free>
20029426:	a803      	add	r0, sp, #12
20029428:	f7fe fd83 	bl	20027f32 <mbedtls_mpi_free>
2002942c:	a812      	add	r0, sp, #72	@ 0x48
2002942e:	f7fe fd80 	bl	20027f32 <mbedtls_mpi_free>
20029432:	a815      	add	r0, sp, #84	@ 0x54
20029434:	f8cd 805c 	str.w	r8, [sp, #92]	@ 0x5c
20029438:	f7fe fd7b 	bl	20027f32 <mbedtls_mpi_free>
2002943c:	a818      	add	r0, sp, #96	@ 0x60
2002943e:	951a      	str	r5, [sp, #104]	@ 0x68
20029440:	f7fe fd77 	bl	20027f32 <mbedtls_mpi_free>
20029444:	a81b      	add	r0, sp, #108	@ 0x6c
20029446:	f8cd b074 	str.w	fp, [sp, #116]	@ 0x74
2002944a:	f7fe fd72 	bl	20027f32 <mbedtls_mpi_free>
2002944e:	4620      	mov	r0, r4
20029450:	b01f      	add	sp, #124	@ 0x7c
20029452:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
20029456:	a918      	add	r1, sp, #96	@ 0x60
20029458:	4652      	mov	r2, sl
2002945a:	4608      	mov	r0, r1
2002945c:	f7ff f8cd 	bl	200285fa <mbedtls_mpi_sub_mpi>
20029460:	9d1a      	ldr	r5, [sp, #104]	@ 0x68
20029462:	4604      	mov	r4, r0
20029464:	2800      	cmp	r0, #0
20029466:	f43f af26 	beq.w	200292b6 <mbedtls_mpi_inv_mod+0x196>
2002946a:	e7cc      	b.n	20029406 <mbedtls_mpi_inv_mod+0x2e6>
2002946c:	46a3      	mov	fp, r4
2002946e:	4625      	mov	r5, r4
20029470:	46a0      	mov	r8, r4
20029472:	4626      	mov	r6, r4
20029474:	4627      	mov	r7, r4
20029476:	46a1      	mov	r9, r4
20029478:	f06f 040d 	mvn.w	r4, #13
2002947c:	e7c3      	b.n	20029406 <mbedtls_mpi_inv_mod+0x2e6>
2002947e:	46ab      	mov	fp, r5
20029480:	46a8      	mov	r8, r5
20029482:	462e      	mov	r6, r5
20029484:	462f      	mov	r7, r5
20029486:	46a9      	mov	r9, r5
20029488:	e7bd      	b.n	20029406 <mbedtls_mpi_inv_mod+0x2e6>
2002948a:	46a3      	mov	fp, r4
2002948c:	4625      	mov	r5, r4
2002948e:	e696      	b.n	200291be <mbedtls_mpi_inv_mod+0x9e>
20029490:	46a3      	mov	fp, r4
20029492:	4625      	mov	r5, r4
20029494:	4626      	mov	r6, r4
20029496:	e78b      	b.n	200293b0 <mbedtls_mpi_inv_mod+0x290>
20029498:	46a3      	mov	fp, r4
2002949a:	4625      	mov	r5, r4
2002949c:	e788      	b.n	200293b0 <mbedtls_mpi_inv_mod+0x290>
2002949e:	f04f 0b00 	mov.w	fp, #0
200294a2:	e785      	b.n	200293b0 <mbedtls_mpi_inv_mod+0x290>
200294a4:	f06f 0403 	mvn.w	r4, #3
200294a8:	e7d1      	b.n	2002944e <mbedtls_mpi_inv_mod+0x32e>
	...

200294ac <mbedtls_oid_get_pk_alg>:
200294ac:	b570      	push	{r4, r5, r6, lr}
200294ae:	460e      	mov	r6, r1
200294b0:	4605      	mov	r5, r0
200294b2:	b110      	cbz	r0, 200294ba <mbedtls_oid_get_pk_alg+0xe>
200294b4:	4c09      	ldr	r4, [pc, #36]	@ (200294dc <mbedtls_oid_get_pk_alg+0x30>)
200294b6:	6820      	ldr	r0, [r4, #0]
200294b8:	b910      	cbnz	r0, 200294c0 <mbedtls_oid_get_pk_alg+0x14>
200294ba:	f06f 002d 	mvn.w	r0, #45	@ 0x2d
200294be:	bd70      	pop	{r4, r5, r6, pc}
200294c0:	686b      	ldr	r3, [r5, #4]
200294c2:	6862      	ldr	r2, [r4, #4]
200294c4:	429a      	cmp	r2, r3
200294c6:	d103      	bne.n	200294d0 <mbedtls_oid_get_pk_alg+0x24>
200294c8:	68a9      	ldr	r1, [r5, #8]
200294ca:	f001 fab3 	bl	2002aa34 <memcmp>
200294ce:	b108      	cbz	r0, 200294d4 <mbedtls_oid_get_pk_alg+0x28>
200294d0:	3414      	adds	r4, #20
200294d2:	e7f0      	b.n	200294b6 <mbedtls_oid_get_pk_alg+0xa>
200294d4:	7c23      	ldrb	r3, [r4, #16]
200294d6:	7033      	strb	r3, [r6, #0]
200294d8:	e7f1      	b.n	200294be <mbedtls_oid_get_pk_alg+0x12>
200294da:	bf00      	nop
200294dc:	2002c424 	.word	0x2002c424

200294e0 <mbedtls_oid_get_md_alg>:
200294e0:	b570      	push	{r4, r5, r6, lr}
200294e2:	460e      	mov	r6, r1
200294e4:	4605      	mov	r5, r0
200294e6:	b110      	cbz	r0, 200294ee <mbedtls_oid_get_md_alg+0xe>
200294e8:	4c09      	ldr	r4, [pc, #36]	@ (20029510 <mbedtls_oid_get_md_alg+0x30>)
200294ea:	6820      	ldr	r0, [r4, #0]
200294ec:	b910      	cbnz	r0, 200294f4 <mbedtls_oid_get_md_alg+0x14>
200294ee:	f06f 002d 	mvn.w	r0, #45	@ 0x2d
200294f2:	bd70      	pop	{r4, r5, r6, pc}
200294f4:	686b      	ldr	r3, [r5, #4]
200294f6:	6862      	ldr	r2, [r4, #4]
200294f8:	429a      	cmp	r2, r3
200294fa:	d103      	bne.n	20029504 <mbedtls_oid_get_md_alg+0x24>
200294fc:	68a9      	ldr	r1, [r5, #8]
200294fe:	f001 fa99 	bl	2002aa34 <memcmp>
20029502:	b108      	cbz	r0, 20029508 <mbedtls_oid_get_md_alg+0x28>
20029504:	3414      	adds	r4, #20
20029506:	e7f0      	b.n	200294ea <mbedtls_oid_get_md_alg+0xa>
20029508:	7c23      	ldrb	r3, [r4, #16]
2002950a:	7033      	strb	r3, [r6, #0]
2002950c:	e7f1      	b.n	200294f2 <mbedtls_oid_get_md_alg+0x12>
2002950e:	bf00      	nop
20029510:	2002c3c0 	.word	0x2002c3c0

20029514 <mbedtls_oid_get_oid_by_md>:
20029514:	b530      	push	{r4, r5, lr}
20029516:	4b08      	ldr	r3, [pc, #32]	@ (20029538 <mbedtls_oid_get_oid_by_md+0x24>)
20029518:	681c      	ldr	r4, [r3, #0]
2002951a:	b914      	cbnz	r4, 20029522 <mbedtls_oid_get_oid_by_md+0xe>
2002951c:	f06f 002d 	mvn.w	r0, #45	@ 0x2d
20029520:	e006      	b.n	20029530 <mbedtls_oid_get_oid_by_md+0x1c>
20029522:	7c1d      	ldrb	r5, [r3, #16]
20029524:	4285      	cmp	r5, r0
20029526:	d104      	bne.n	20029532 <mbedtls_oid_get_oid_by_md+0x1e>
20029528:	2000      	movs	r0, #0
2002952a:	600c      	str	r4, [r1, #0]
2002952c:	685b      	ldr	r3, [r3, #4]
2002952e:	6013      	str	r3, [r2, #0]
20029530:	bd30      	pop	{r4, r5, pc}
20029532:	3314      	adds	r3, #20
20029534:	e7f0      	b.n	20029518 <mbedtls_oid_get_oid_by_md+0x4>
20029536:	bf00      	nop
20029538:	2002c3c0 	.word	0x2002c3c0

2002953c <mbedtls_pk_init>:
2002953c:	b110      	cbz	r0, 20029544 <mbedtls_pk_init+0x8>
2002953e:	2300      	movs	r3, #0
20029540:	e9c0 3300 	strd	r3, r3, [r0]
20029544:	4770      	bx	lr

20029546 <mbedtls_pk_free>:
20029546:	b510      	push	{r4, lr}
20029548:	4604      	mov	r4, r0
2002954a:	b160      	cbz	r0, 20029566 <mbedtls_pk_free+0x20>
2002954c:	6803      	ldr	r3, [r0, #0]
2002954e:	b153      	cbz	r3, 20029566 <mbedtls_pk_free+0x20>
20029550:	6a9b      	ldr	r3, [r3, #40]	@ 0x28
20029552:	6840      	ldr	r0, [r0, #4]
20029554:	4798      	blx	r3
20029556:	2100      	movs	r1, #0
20029558:	f104 0308 	add.w	r3, r4, #8
2002955c:	4622      	mov	r2, r4
2002955e:	3401      	adds	r4, #1
20029560:	429c      	cmp	r4, r3
20029562:	7011      	strb	r1, [r2, #0]
20029564:	d1fa      	bne.n	2002955c <mbedtls_pk_free+0x16>
20029566:	bd10      	pop	{r4, pc}

20029568 <mbedtls_pk_info_from_type>:
20029568:	2801      	cmp	r0, #1
2002956a:	4802      	ldr	r0, [pc, #8]	@ (20029574 <mbedtls_pk_info_from_type+0xc>)
2002956c:	bf18      	it	ne
2002956e:	2000      	movne	r0, #0
20029570:	4770      	bx	lr
20029572:	bf00      	nop
20029574:	2002c474 	.word	0x2002c474

20029578 <mbedtls_pk_setup>:
20029578:	b570      	push	{r4, r5, r6, lr}
2002957a:	460e      	mov	r6, r1
2002957c:	4605      	mov	r5, r0
2002957e:	b148      	cbz	r0, 20029594 <mbedtls_pk_setup+0x1c>
20029580:	b141      	cbz	r1, 20029594 <mbedtls_pk_setup+0x1c>
20029582:	6804      	ldr	r4, [r0, #0]
20029584:	b934      	cbnz	r4, 20029594 <mbedtls_pk_setup+0x1c>
20029586:	6a4b      	ldr	r3, [r1, #36]	@ 0x24
20029588:	4798      	blx	r3
2002958a:	6068      	str	r0, [r5, #4]
2002958c:	b120      	cbz	r0, 20029598 <mbedtls_pk_setup+0x20>
2002958e:	4620      	mov	r0, r4
20029590:	602e      	str	r6, [r5, #0]
20029592:	bd70      	pop	{r4, r5, r6, pc}
20029594:	4801      	ldr	r0, [pc, #4]	@ (2002959c <mbedtls_pk_setup+0x24>)
20029596:	e7fc      	b.n	20029592 <mbedtls_pk_setup+0x1a>
20029598:	4801      	ldr	r0, [pc, #4]	@ (200295a0 <mbedtls_pk_setup+0x28>)
2002959a:	e7fa      	b.n	20029592 <mbedtls_pk_setup+0x1a>
2002959c:	ffffc180 	.word	0xffffc180
200295a0:	ffffc080 	.word	0xffffc080

200295a4 <mbedtls_pk_verify>:
200295a4:	e92d 47f0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, lr}
200295a8:	460d      	mov	r5, r1
200295aa:	e9dd 8908 	ldrd	r8, r9, [sp, #32]
200295ae:	4616      	mov	r6, r2
200295b0:	4604      	mov	r4, r0
200295b2:	b910      	cbnz	r0, 200295ba <mbedtls_pk_verify+0x16>
200295b4:	480e      	ldr	r0, [pc, #56]	@ (200295f0 <mbedtls_pk_verify+0x4c>)
200295b6:	e8bd 87f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, pc}
200295ba:	6802      	ldr	r2, [r0, #0]
200295bc:	2a00      	cmp	r2, #0
200295be:	d0f9      	beq.n	200295b4 <mbedtls_pk_verify+0x10>
200295c0:	b93b      	cbnz	r3, 200295d2 <mbedtls_pk_verify+0x2e>
200295c2:	4608      	mov	r0, r1
200295c4:	f7fc fd40 	bl	20026048 <mbedtls_md_info_from_type>
200295c8:	2800      	cmp	r0, #0
200295ca:	d0f3      	beq.n	200295b4 <mbedtls_pk_verify+0x10>
200295cc:	f7fc fd48 	bl	20026060 <mbedtls_md_get_size>
200295d0:	4603      	mov	r3, r0
200295d2:	6822      	ldr	r2, [r4, #0]
200295d4:	6917      	ldr	r7, [r2, #16]
200295d6:	b147      	cbz	r7, 200295ea <mbedtls_pk_verify+0x46>
200295d8:	e9cd 8908 	strd	r8, r9, [sp, #32]
200295dc:	4632      	mov	r2, r6
200295de:	4629      	mov	r1, r5
200295e0:	46bc      	mov	ip, r7
200295e2:	6860      	ldr	r0, [r4, #4]
200295e4:	e8bd 47f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, lr}
200295e8:	4760      	bx	ip
200295ea:	4802      	ldr	r0, [pc, #8]	@ (200295f4 <mbedtls_pk_verify+0x50>)
200295ec:	e7e3      	b.n	200295b6 <mbedtls_pk_verify+0x12>
200295ee:	bf00      	nop
200295f0:	ffffc180 	.word	0xffffc180
200295f4:	ffffc100 	.word	0xffffc100

200295f8 <pk_get_pk_alg>:
200295f8:	b530      	push	{r4, r5, lr}
200295fa:	4615      	mov	r5, r2
200295fc:	2200      	movs	r2, #0
200295fe:	b085      	sub	sp, #20
20029600:	e9c3 2200 	strd	r2, r2, [r3]
20029604:	609a      	str	r2, [r3, #8]
20029606:	aa01      	add	r2, sp, #4
20029608:	461c      	mov	r4, r3
2002960a:	f7fe fa98 	bl	20027b3e <mbedtls_asn1_get_alg>
2002960e:	b118      	cbz	r0, 20029618 <pk_get_pk_alg+0x20>
20029610:	f5a0 506a 	sub.w	r0, r0, #14976	@ 0x3a80
20029614:	b005      	add	sp, #20
20029616:	bd30      	pop	{r4, r5, pc}
20029618:	4629      	mov	r1, r5
2002961a:	a801      	add	r0, sp, #4
2002961c:	f7ff ff46 	bl	200294ac <mbedtls_oid_get_pk_alg>
20029620:	b960      	cbnz	r0, 2002963c <pk_get_pk_alg+0x44>
20029622:	782b      	ldrb	r3, [r5, #0]
20029624:	2b01      	cmp	r3, #1
20029626:	d1f5      	bne.n	20029614 <pk_get_pk_alg+0x1c>
20029628:	6823      	ldr	r3, [r4, #0]
2002962a:	2b05      	cmp	r3, #5
2002962c:	d000      	beq.n	20029630 <pk_get_pk_alg+0x38>
2002962e:	b93b      	cbnz	r3, 20029640 <pk_get_pk_alg+0x48>
20029630:	6862      	ldr	r2, [r4, #4]
20029632:	4b04      	ldr	r3, [pc, #16]	@ (20029644 <pk_get_pk_alg+0x4c>)
20029634:	2a00      	cmp	r2, #0
20029636:	bf18      	it	ne
20029638:	4618      	movne	r0, r3
2002963a:	e7eb      	b.n	20029614 <pk_get_pk_alg+0x1c>
2002963c:	4802      	ldr	r0, [pc, #8]	@ (20029648 <pk_get_pk_alg+0x50>)
2002963e:	e7e9      	b.n	20029614 <pk_get_pk_alg+0x1c>
20029640:	4800      	ldr	r0, [pc, #0]	@ (20029644 <pk_get_pk_alg+0x4c>)
20029642:	e7e7      	b.n	20029614 <pk_get_pk_alg+0x1c>
20029644:	ffffc580 	.word	0xffffc580
20029648:	ffffc380 	.word	0xffffc380

2002964c <mbedtls_pk_parse_subpubkey>:
2002964c:	2300      	movs	r3, #0
2002964e:	e92d 45f0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, lr}
20029652:	b087      	sub	sp, #28
20029654:	4690      	mov	r8, r2
20029656:	f88d 3003 	strb.w	r3, [sp, #3]
2002965a:	aa01      	add	r2, sp, #4
2002965c:	2330      	movs	r3, #48	@ 0x30
2002965e:	4606      	mov	r6, r0
20029660:	f7fe fa32 	bl	20027ac8 <mbedtls_asn1_get_tag>
20029664:	b128      	cbz	r0, 20029672 <mbedtls_pk_parse_subpubkey+0x26>
20029666:	f5a0 5474 	sub.w	r4, r0, #15616	@ 0x3d00
2002966a:	4620      	mov	r0, r4
2002966c:	b007      	add	sp, #28
2002966e:	e8bd 85f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, pc}
20029672:	9b01      	ldr	r3, [sp, #4]
20029674:	6837      	ldr	r7, [r6, #0]
20029676:	4630      	mov	r0, r6
20029678:	441f      	add	r7, r3
2002967a:	4639      	mov	r1, r7
2002967c:	ab03      	add	r3, sp, #12
2002967e:	f10d 0203 	add.w	r2, sp, #3
20029682:	f7ff ffb9 	bl	200295f8 <pk_get_pk_alg>
20029686:	4604      	mov	r4, r0
20029688:	2800      	cmp	r0, #0
2002968a:	d1ee      	bne.n	2002966a <mbedtls_pk_parse_subpubkey+0x1e>
2002968c:	4639      	mov	r1, r7
2002968e:	4630      	mov	r0, r6
20029690:	aa01      	add	r2, sp, #4
20029692:	f7fe fa40 	bl	20027b16 <mbedtls_asn1_get_bitstring_null>
20029696:	b110      	cbz	r0, 2002969e <mbedtls_pk_parse_subpubkey+0x52>
20029698:	f5a0 546c 	sub.w	r4, r0, #15104	@ 0x3b00
2002969c:	e7e5      	b.n	2002966a <mbedtls_pk_parse_subpubkey+0x1e>
2002969e:	6833      	ldr	r3, [r6, #0]
200296a0:	9a01      	ldr	r2, [sp, #4]
200296a2:	4413      	add	r3, r2
200296a4:	429f      	cmp	r7, r3
200296a6:	d14b      	bne.n	20029740 <mbedtls_pk_parse_subpubkey+0xf4>
200296a8:	f89d 0003 	ldrb.w	r0, [sp, #3]
200296ac:	f7ff ff5c 	bl	20029568 <mbedtls_pk_info_from_type>
200296b0:	4601      	mov	r1, r0
200296b2:	2800      	cmp	r0, #0
200296b4:	d046      	beq.n	20029744 <mbedtls_pk_parse_subpubkey+0xf8>
200296b6:	4640      	mov	r0, r8
200296b8:	f7ff ff5e 	bl	20029578 <mbedtls_pk_setup>
200296bc:	4604      	mov	r4, r0
200296be:	2800      	cmp	r0, #0
200296c0:	d1d3      	bne.n	2002966a <mbedtls_pk_parse_subpubkey+0x1e>
200296c2:	f89d 3003 	ldrb.w	r3, [sp, #3]
200296c6:	2b01      	cmp	r3, #1
200296c8:	d138      	bne.n	2002973c <mbedtls_pk_parse_subpubkey+0xf0>
200296ca:	2330      	movs	r3, #48	@ 0x30
200296cc:	4639      	mov	r1, r7
200296ce:	4630      	mov	r0, r6
200296d0:	aa02      	add	r2, sp, #8
200296d2:	f8d8 5004 	ldr.w	r5, [r8, #4]
200296d6:	f7fe f9f7 	bl	20027ac8 <mbedtls_asn1_get_tag>
200296da:	b138      	cbz	r0, 200296ec <mbedtls_pk_parse_subpubkey+0xa0>
200296dc:	f5a0 556c 	sub.w	r5, r0, #15104	@ 0x3b00
200296e0:	bb3d      	cbnz	r5, 20029732 <mbedtls_pk_parse_subpubkey+0xe6>
200296e2:	6833      	ldr	r3, [r6, #0]
200296e4:	42bb      	cmp	r3, r7
200296e6:	d0c0      	beq.n	2002966a <mbedtls_pk_parse_subpubkey+0x1e>
200296e8:	4d17      	ldr	r5, [pc, #92]	@ (20029748 <mbedtls_pk_parse_subpubkey+0xfc>)
200296ea:	e022      	b.n	20029732 <mbedtls_pk_parse_subpubkey+0xe6>
200296ec:	6833      	ldr	r3, [r6, #0]
200296ee:	9a02      	ldr	r2, [sp, #8]
200296f0:	4413      	add	r3, r2
200296f2:	429f      	cmp	r7, r3
200296f4:	d1f8      	bne.n	200296e8 <mbedtls_pk_parse_subpubkey+0x9c>
200296f6:	f105 0a08 	add.w	sl, r5, #8
200296fa:	4652      	mov	r2, sl
200296fc:	4639      	mov	r1, r7
200296fe:	4630      	mov	r0, r6
20029700:	f7fe f9f6 	bl	20027af0 <mbedtls_asn1_get_mpi>
20029704:	2800      	cmp	r0, #0
20029706:	d1e9      	bne.n	200296dc <mbedtls_pk_parse_subpubkey+0x90>
20029708:	4639      	mov	r1, r7
2002970a:	4630      	mov	r0, r6
2002970c:	f105 0214 	add.w	r2, r5, #20
20029710:	f7fe f9ee 	bl	20027af0 <mbedtls_asn1_get_mpi>
20029714:	2800      	cmp	r0, #0
20029716:	d1e1      	bne.n	200296dc <mbedtls_pk_parse_subpubkey+0x90>
20029718:	6833      	ldr	r3, [r6, #0]
2002971a:	429f      	cmp	r7, r3
2002971c:	d1e4      	bne.n	200296e8 <mbedtls_pk_parse_subpubkey+0x9c>
2002971e:	4628      	mov	r0, r5
20029720:	f000 f8c2 	bl	200298a8 <mbedtls_rsa_check_pubkey>
20029724:	b920      	cbnz	r0, 20029730 <mbedtls_pk_parse_subpubkey+0xe4>
20029726:	4650      	mov	r0, sl
20029728:	f7fe fcbe 	bl	200280a8 <mbedtls_mpi_size>
2002972c:	6068      	str	r0, [r5, #4]
2002972e:	e7d8      	b.n	200296e2 <mbedtls_pk_parse_subpubkey+0x96>
20029730:	4d06      	ldr	r5, [pc, #24]	@ (2002974c <mbedtls_pk_parse_subpubkey+0x100>)
20029732:	4640      	mov	r0, r8
20029734:	f7ff ff07 	bl	20029546 <mbedtls_pk_free>
20029738:	462c      	mov	r4, r5
2002973a:	e796      	b.n	2002966a <mbedtls_pk_parse_subpubkey+0x1e>
2002973c:	4d04      	ldr	r5, [pc, #16]	@ (20029750 <mbedtls_pk_parse_subpubkey+0x104>)
2002973e:	e7f8      	b.n	20029732 <mbedtls_pk_parse_subpubkey+0xe6>
20029740:	4c01      	ldr	r4, [pc, #4]	@ (20029748 <mbedtls_pk_parse_subpubkey+0xfc>)
20029742:	e792      	b.n	2002966a <mbedtls_pk_parse_subpubkey+0x1e>
20029744:	4c02      	ldr	r4, [pc, #8]	@ (20029750 <mbedtls_pk_parse_subpubkey+0x104>)
20029746:	e790      	b.n	2002966a <mbedtls_pk_parse_subpubkey+0x1e>
20029748:	ffffc49a 	.word	0xffffc49a
2002974c:	ffffc500 	.word	0xffffc500
20029750:	ffffc380 	.word	0xffffc380

20029754 <mbedtls_pk_parse_public_key>:
20029754:	4613      	mov	r3, r2
20029756:	b507      	push	{r0, r1, r2, lr}
20029758:	4602      	mov	r2, r0
2002975a:	9101      	str	r1, [sp, #4]
2002975c:	a801      	add	r0, sp, #4
2002975e:	4419      	add	r1, r3
20029760:	f7ff ff74 	bl	2002964c <mbedtls_pk_parse_subpubkey>
20029764:	b003      	add	sp, #12
20029766:	f85d fb04 	ldr.w	pc, [sp], #4

2002976a <rsa_can_do>:
2002976a:	2801      	cmp	r0, #1
2002976c:	d002      	beq.n	20029774 <rsa_can_do+0xa>
2002976e:	1f83      	subs	r3, r0, #6
20029770:	4258      	negs	r0, r3
20029772:	4158      	adcs	r0, r3
20029774:	4770      	bx	lr

20029776 <rsa_get_bitlen>:
20029776:	6840      	ldr	r0, [r0, #4]
20029778:	00c0      	lsls	r0, r0, #3
2002977a:	4770      	bx	lr

2002977c <rsa_debug>:
2002977c:	2301      	movs	r3, #1
2002977e:	4a06      	ldr	r2, [pc, #24]	@ (20029798 <rsa_debug+0x1c>)
20029780:	700b      	strb	r3, [r1, #0]
20029782:	730b      	strb	r3, [r1, #12]
20029784:	4b05      	ldr	r3, [pc, #20]	@ (2002979c <rsa_debug+0x20>)
20029786:	604a      	str	r2, [r1, #4]
20029788:	f100 0208 	add.w	r2, r0, #8
2002978c:	3014      	adds	r0, #20
2002978e:	608a      	str	r2, [r1, #8]
20029790:	610b      	str	r3, [r1, #16]
20029792:	6148      	str	r0, [r1, #20]
20029794:	4770      	bx	lr
20029796:	bf00      	nop
20029798:	2002b250 	.word	0x2002b250
2002979c:	2002b256 	.word	0x2002b256

200297a0 <rsa_free_wrap>:
200297a0:	b510      	push	{r4, lr}
200297a2:	4604      	mov	r4, r0
200297a4:	f000 fe7c 	bl	2002a4a0 <mbedtls_rsa_free>
200297a8:	4620      	mov	r0, r4
200297aa:	e8bd 4010 	ldmia.w	sp!, {r4, lr}
200297ae:	f001 b88b 	b.w	2002a8c8 <free>

200297b2 <rsa_alloc_wrap>:
200297b2:	b510      	push	{r4, lr}
200297b4:	21ac      	movs	r1, #172	@ 0xac
200297b6:	2001      	movs	r0, #1
200297b8:	f001 f86a 	bl	2002a890 <calloc>
200297bc:	4604      	mov	r4, r0
200297be:	b118      	cbz	r0, 200297c8 <rsa_alloc_wrap+0x16>
200297c0:	2200      	movs	r2, #0
200297c2:	4611      	mov	r1, r2
200297c4:	f000 f862 	bl	2002988c <mbedtls_rsa_init>
200297c8:	4620      	mov	r0, r4
200297ca:	bd10      	pop	{r4, pc}

200297cc <rsa_check_pair_wrap>:
200297cc:	f000 b99c 	b.w	20029b08 <mbedtls_rsa_check_pub_priv>

200297d0 <rsa_encrypt_wrap>:
200297d0:	b4f0      	push	{r4, r5, r6, r7}
200297d2:	9f04      	ldr	r7, [sp, #16]
200297d4:	6846      	ldr	r6, [r0, #4]
200297d6:	460d      	mov	r5, r1
200297d8:	603e      	str	r6, [r7, #0]
200297da:	9f05      	ldr	r7, [sp, #20]
200297dc:	4614      	mov	r4, r2
200297de:	e9dd 1206 	ldrd	r1, r2, [sp, #24]
200297e2:	42be      	cmp	r6, r7
200297e4:	d806      	bhi.n	200297f4 <rsa_encrypt_wrap+0x24>
200297e6:	e9cd 5305 	strd	r5, r3, [sp, #20]
200297ea:	9404      	str	r4, [sp, #16]
200297ec:	2300      	movs	r3, #0
200297ee:	bcf0      	pop	{r4, r5, r6, r7}
200297f0:	f000 bbe2 	b.w	20029fb8 <mbedtls_rsa_pkcs1_encrypt>
200297f4:	4801      	ldr	r0, [pc, #4]	@ (200297fc <rsa_encrypt_wrap+0x2c>)
200297f6:	bcf0      	pop	{r4, r5, r6, r7}
200297f8:	4770      	bx	lr
200297fa:	bf00      	nop
200297fc:	ffffbc00 	.word	0xffffbc00

20029800 <rsa_decrypt_wrap>:
20029800:	b4f0      	push	{r4, r5, r6, r7}
20029802:	4616      	mov	r6, r2
20029804:	6847      	ldr	r7, [r0, #4]
20029806:	460c      	mov	r4, r1
20029808:	e9dd 5105 	ldrd	r5, r1, [sp, #20]
2002980c:	42b7      	cmp	r7, r6
2002980e:	9a07      	ldr	r2, [sp, #28]
20029810:	d106      	bne.n	20029820 <rsa_decrypt_wrap+0x20>
20029812:	e9cd 3506 	strd	r3, r5, [sp, #24]
20029816:	9405      	str	r4, [sp, #20]
20029818:	2301      	movs	r3, #1
2002981a:	bcf0      	pop	{r4, r5, r6, r7}
2002981c:	f000 bc6e 	b.w	2002a0fc <mbedtls_rsa_pkcs1_decrypt>
20029820:	4801      	ldr	r0, [pc, #4]	@ (20029828 <rsa_decrypt_wrap+0x28>)
20029822:	bcf0      	pop	{r4, r5, r6, r7}
20029824:	4770      	bx	lr
20029826:	bf00      	nop
20029828:	ffffbf80 	.word	0xffffbf80

2002982c <rsa_sign_wrap>:
2002982c:	b4f0      	push	{r4, r5, r6, r7}
2002982e:	460c      	mov	r4, r1
20029830:	4615      	mov	r5, r2
20029832:	e9dd 1206 	ldrd	r1, r2, [sp, #24]
20029836:	6847      	ldr	r7, [r0, #4]
20029838:	9e05      	ldr	r6, [sp, #20]
2002983a:	6037      	str	r7, [r6, #0]
2002983c:	9e04      	ldr	r6, [sp, #16]
2002983e:	e9cd 4304 	strd	r4, r3, [sp, #16]
20029842:	e9cd 5606 	strd	r5, r6, [sp, #24]
20029846:	bcf0      	pop	{r4, r5, r6, r7}
20029848:	2301      	movs	r3, #1
2002984a:	f000 bd31 	b.w	2002a2b0 <mbedtls_rsa_pkcs1_sign>
	...

20029850 <rsa_verify_wrap>:
20029850:	b57f      	push	{r0, r1, r2, r3, r4, r5, r6, lr}
20029852:	9d09      	ldr	r5, [sp, #36]	@ 0x24
20029854:	6846      	ldr	r6, [r0, #4]
20029856:	4604      	mov	r4, r0
20029858:	42ae      	cmp	r6, r5
2002985a:	d811      	bhi.n	20029880 <rsa_verify_wrap+0x30>
2002985c:	e9cd 1300 	strd	r1, r3, [sp]
20029860:	2300      	movs	r3, #0
20029862:	9e08      	ldr	r6, [sp, #32]
20029864:	4619      	mov	r1, r3
20029866:	e9cd 2602 	strd	r2, r6, [sp, #8]
2002986a:	461a      	mov	r2, r3
2002986c:	f000 fe08 	bl	2002a480 <mbedtls_rsa_pkcs1_verify>
20029870:	b920      	cbnz	r0, 2002987c <rsa_verify_wrap+0x2c>
20029872:	6862      	ldr	r2, [r4, #4]
20029874:	4b03      	ldr	r3, [pc, #12]	@ (20029884 <rsa_verify_wrap+0x34>)
20029876:	42aa      	cmp	r2, r5
20029878:	bf38      	it	cc
2002987a:	4618      	movcc	r0, r3
2002987c:	b004      	add	sp, #16
2002987e:	bd70      	pop	{r4, r5, r6, pc}
20029880:	4801      	ldr	r0, [pc, #4]	@ (20029888 <rsa_verify_wrap+0x38>)
20029882:	e7fb      	b.n	2002987c <rsa_verify_wrap+0x2c>
20029884:	ffffc700 	.word	0xffffc700
20029888:	ffffbc80 	.word	0xffffbc80

2002988c <mbedtls_rsa_init>:
2002988c:	b570      	push	{r4, r5, r6, lr}
2002988e:	4604      	mov	r4, r0
20029890:	460e      	mov	r6, r1
20029892:	4615      	mov	r5, r2
20029894:	2100      	movs	r1, #0
20029896:	22ac      	movs	r2, #172	@ 0xac
20029898:	f001 f8dc 	bl	2002aa54 <memset>
2002989c:	e9c4 6529 	strd	r6, r5, [r4, #164]	@ 0xa4
200298a0:	bd70      	pop	{r4, r5, r6, pc}

200298a2 <mbedtls_rsa_set_padding>:
200298a2:	e9c0 1229 	strd	r1, r2, [r0, #164]	@ 0xa4
200298a6:	4770      	bx	lr

200298a8 <mbedtls_rsa_check_pubkey>:
200298a8:	b538      	push	{r3, r4, r5, lr}
200298aa:	6902      	ldr	r2, [r0, #16]
200298ac:	4604      	mov	r4, r0
200298ae:	b10a      	cbz	r2, 200298b4 <mbedtls_rsa_check_pubkey+0xc>
200298b0:	69c3      	ldr	r3, [r0, #28]
200298b2:	b90b      	cbnz	r3, 200298b8 <mbedtls_rsa_check_pubkey+0x10>
200298b4:	4811      	ldr	r0, [pc, #68]	@ (200298fc <mbedtls_rsa_check_pubkey+0x54>)
200298b6:	bd38      	pop	{r3, r4, r5, pc}
200298b8:	6812      	ldr	r2, [r2, #0]
200298ba:	07d2      	lsls	r2, r2, #31
200298bc:	d5fa      	bpl.n	200298b4 <mbedtls_rsa_check_pubkey+0xc>
200298be:	681b      	ldr	r3, [r3, #0]
200298c0:	07db      	lsls	r3, r3, #31
200298c2:	d5f7      	bpl.n	200298b4 <mbedtls_rsa_check_pubkey+0xc>
200298c4:	f100 0508 	add.w	r5, r0, #8
200298c8:	4628      	mov	r0, r5
200298ca:	f7fe fbd0 	bl	2002806e <mbedtls_mpi_bitlen>
200298ce:	287f      	cmp	r0, #127	@ 0x7f
200298d0:	d9f0      	bls.n	200298b4 <mbedtls_rsa_check_pubkey+0xc>
200298d2:	4628      	mov	r0, r5
200298d4:	f7fe fbcb 	bl	2002806e <mbedtls_mpi_bitlen>
200298d8:	f5b0 5f00 	cmp.w	r0, #8192	@ 0x2000
200298dc:	d8ea      	bhi.n	200298b4 <mbedtls_rsa_check_pubkey+0xc>
200298de:	3414      	adds	r4, #20
200298e0:	4620      	mov	r0, r4
200298e2:	f7fe fbc4 	bl	2002806e <mbedtls_mpi_bitlen>
200298e6:	2801      	cmp	r0, #1
200298e8:	d9e4      	bls.n	200298b4 <mbedtls_rsa_check_pubkey+0xc>
200298ea:	4629      	mov	r1, r5
200298ec:	4620      	mov	r0, r4
200298ee:	f7fe fd71 	bl	200283d4 <mbedtls_mpi_cmp_mpi>
200298f2:	2800      	cmp	r0, #0
200298f4:	dade      	bge.n	200298b4 <mbedtls_rsa_check_pubkey+0xc>
200298f6:	2000      	movs	r0, #0
200298f8:	e7dd      	b.n	200298b6 <mbedtls_rsa_check_pubkey+0xe>
200298fa:	bf00      	nop
200298fc:	ffffbe00 	.word	0xffffbe00

20029900 <mbedtls_rsa_check_privkey>:
20029900:	e92d 43f0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, lr}
20029904:	b0a9      	sub	sp, #164	@ 0xa4
20029906:	4605      	mov	r5, r0
20029908:	f7ff ffce 	bl	200298a8 <mbedtls_rsa_check_pubkey>
2002990c:	b120      	cbz	r0, 20029918 <mbedtls_rsa_check_privkey+0x18>
2002990e:	4c7d      	ldr	r4, [pc, #500]	@ (20029b04 <mbedtls_rsa_check_privkey+0x204>)
20029910:	4620      	mov	r0, r4
20029912:	b029      	add	sp, #164	@ 0xa4
20029914:	e8bd 83f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, pc}
20029918:	6b6b      	ldr	r3, [r5, #52]	@ 0x34
2002991a:	2b00      	cmp	r3, #0
2002991c:	d0f7      	beq.n	2002990e <mbedtls_rsa_check_privkey+0xe>
2002991e:	6c2b      	ldr	r3, [r5, #64]	@ 0x40
20029920:	2b00      	cmp	r3, #0
20029922:	d0f4      	beq.n	2002990e <mbedtls_rsa_check_privkey+0xe>
20029924:	6aab      	ldr	r3, [r5, #40]	@ 0x28
20029926:	2b00      	cmp	r3, #0
20029928:	d0f1      	beq.n	2002990e <mbedtls_rsa_check_privkey+0xe>
2002992a:	a801      	add	r0, sp, #4
2002992c:	f7fe fafa 	bl	20027f24 <mbedtls_mpi_init>
20029930:	a804      	add	r0, sp, #16
20029932:	f7fe faf7 	bl	20027f24 <mbedtls_mpi_init>
20029936:	a807      	add	r0, sp, #28
20029938:	f7fe faf4 	bl	20027f24 <mbedtls_mpi_init>
2002993c:	a80a      	add	r0, sp, #40	@ 0x28
2002993e:	f7fe faf1 	bl	20027f24 <mbedtls_mpi_init>
20029942:	a80d      	add	r0, sp, #52	@ 0x34
20029944:	f7fe faee 	bl	20027f24 <mbedtls_mpi_init>
20029948:	a810      	add	r0, sp, #64	@ 0x40
2002994a:	f7fe faeb 	bl	20027f24 <mbedtls_mpi_init>
2002994e:	a813      	add	r0, sp, #76	@ 0x4c
20029950:	f7fe fae8 	bl	20027f24 <mbedtls_mpi_init>
20029954:	a816      	add	r0, sp, #88	@ 0x58
20029956:	f7fe fae5 	bl	20027f24 <mbedtls_mpi_init>
2002995a:	a819      	add	r0, sp, #100	@ 0x64
2002995c:	f7fe fae2 	bl	20027f24 <mbedtls_mpi_init>
20029960:	a81c      	add	r0, sp, #112	@ 0x70
20029962:	f7fe fadf 	bl	20027f24 <mbedtls_mpi_init>
20029966:	a81f      	add	r0, sp, #124	@ 0x7c
20029968:	f7fe fadc 	bl	20027f24 <mbedtls_mpi_init>
2002996c:	a822      	add	r0, sp, #136	@ 0x88
2002996e:	f7fe fad9 	bl	20027f24 <mbedtls_mpi_init>
20029972:	f105 072c 	add.w	r7, r5, #44	@ 0x2c
20029976:	a825      	add	r0, sp, #148	@ 0x94
20029978:	f105 0638 	add.w	r6, r5, #56	@ 0x38
2002997c:	f7fe fad2 	bl	20027f24 <mbedtls_mpi_init>
20029980:	4632      	mov	r2, r6
20029982:	4639      	mov	r1, r7
20029984:	a801      	add	r0, sp, #4
20029986:	f7fe fe75 	bl	20028674 <mbedtls_mpi_mul_mpi>
2002998a:	4604      	mov	r4, r0
2002998c:	2800      	cmp	r0, #0
2002998e:	d15e      	bne.n	20029a4e <mbedtls_rsa_check_privkey+0x14e>
20029990:	f105 0820 	add.w	r8, r5, #32
20029994:	f105 0914 	add.w	r9, r5, #20
20029998:	464a      	mov	r2, r9
2002999a:	4641      	mov	r1, r8
2002999c:	a804      	add	r0, sp, #16
2002999e:	f7fe fe69 	bl	20028674 <mbedtls_mpi_mul_mpi>
200299a2:	4604      	mov	r4, r0
200299a4:	2800      	cmp	r0, #0
200299a6:	d152      	bne.n	20029a4e <mbedtls_rsa_check_privkey+0x14e>
200299a8:	2201      	movs	r2, #1
200299aa:	4639      	mov	r1, r7
200299ac:	a807      	add	r0, sp, #28
200299ae:	f7fe fe4b 	bl	20028648 <mbedtls_mpi_sub_int>
200299b2:	4604      	mov	r4, r0
200299b4:	2800      	cmp	r0, #0
200299b6:	d14a      	bne.n	20029a4e <mbedtls_rsa_check_privkey+0x14e>
200299b8:	2201      	movs	r2, #1
200299ba:	4631      	mov	r1, r6
200299bc:	a80a      	add	r0, sp, #40	@ 0x28
200299be:	f7fe fe43 	bl	20028648 <mbedtls_mpi_sub_int>
200299c2:	4604      	mov	r4, r0
200299c4:	2800      	cmp	r0, #0
200299c6:	d142      	bne.n	20029a4e <mbedtls_rsa_check_privkey+0x14e>
200299c8:	aa0a      	add	r2, sp, #40	@ 0x28
200299ca:	a907      	add	r1, sp, #28
200299cc:	a80d      	add	r0, sp, #52	@ 0x34
200299ce:	f7fe fe51 	bl	20028674 <mbedtls_mpi_mul_mpi>
200299d2:	4604      	mov	r4, r0
200299d4:	2800      	cmp	r0, #0
200299d6:	d13a      	bne.n	20029a4e <mbedtls_rsa_check_privkey+0x14e>
200299d8:	4649      	mov	r1, r9
200299da:	aa0d      	add	r2, sp, #52	@ 0x34
200299dc:	a813      	add	r0, sp, #76	@ 0x4c
200299de:	f7ff fb04 	bl	20028fea <mbedtls_mpi_gcd>
200299e2:	4604      	mov	r4, r0
200299e4:	2800      	cmp	r0, #0
200299e6:	d132      	bne.n	20029a4e <mbedtls_rsa_check_privkey+0x14e>
200299e8:	aa0a      	add	r2, sp, #40	@ 0x28
200299ea:	a907      	add	r1, sp, #28
200299ec:	a816      	add	r0, sp, #88	@ 0x58
200299ee:	f7ff fafc 	bl	20028fea <mbedtls_mpi_gcd>
200299f2:	4604      	mov	r4, r0
200299f4:	bb58      	cbnz	r0, 20029a4e <mbedtls_rsa_check_privkey+0x14e>
200299f6:	ab16      	add	r3, sp, #88	@ 0x58
200299f8:	aa0d      	add	r2, sp, #52	@ 0x34
200299fa:	a91c      	add	r1, sp, #112	@ 0x70
200299fc:	a819      	add	r0, sp, #100	@ 0x64
200299fe:	f7fe feaa 	bl	20028756 <mbedtls_mpi_div_mpi>
20029a02:	4604      	mov	r4, r0
20029a04:	bb18      	cbnz	r0, 20029a4e <mbedtls_rsa_check_privkey+0x14e>
20029a06:	aa19      	add	r2, sp, #100	@ 0x64
20029a08:	a904      	add	r1, sp, #16
20029a0a:	a810      	add	r0, sp, #64	@ 0x40
20029a0c:	f7ff f8a7 	bl	20028b5e <mbedtls_mpi_mod_mpi>
20029a10:	4604      	mov	r4, r0
20029a12:	b9e0      	cbnz	r0, 20029a4e <mbedtls_rsa_check_privkey+0x14e>
20029a14:	4641      	mov	r1, r8
20029a16:	aa07      	add	r2, sp, #28
20029a18:	a81f      	add	r0, sp, #124	@ 0x7c
20029a1a:	f7ff f8a0 	bl	20028b5e <mbedtls_mpi_mod_mpi>
20029a1e:	4604      	mov	r4, r0
20029a20:	b9a8      	cbnz	r0, 20029a4e <mbedtls_rsa_check_privkey+0x14e>
20029a22:	4641      	mov	r1, r8
20029a24:	aa0a      	add	r2, sp, #40	@ 0x28
20029a26:	a822      	add	r0, sp, #136	@ 0x88
20029a28:	f7ff f899 	bl	20028b5e <mbedtls_mpi_mod_mpi>
20029a2c:	4604      	mov	r4, r0
20029a2e:	b970      	cbnz	r0, 20029a4e <mbedtls_rsa_check_privkey+0x14e>
20029a30:	463a      	mov	r2, r7
20029a32:	4631      	mov	r1, r6
20029a34:	a825      	add	r0, sp, #148	@ 0x94
20029a36:	f7ff fb73 	bl	20029120 <mbedtls_mpi_inv_mod>
20029a3a:	4604      	mov	r4, r0
20029a3c:	b938      	cbnz	r0, 20029a4e <mbedtls_rsa_check_privkey+0x14e>
20029a3e:	f105 0108 	add.w	r1, r5, #8
20029a42:	a801      	add	r0, sp, #4
20029a44:	f7fe fcc6 	bl	200283d4 <mbedtls_mpi_cmp_mpi>
20029a48:	2800      	cmp	r0, #0
20029a4a:	d031      	beq.n	20029ab0 <mbedtls_rsa_check_privkey+0x1b0>
20029a4c:	4c2d      	ldr	r4, [pc, #180]	@ (20029b04 <mbedtls_rsa_check_privkey+0x204>)
20029a4e:	a801      	add	r0, sp, #4
20029a50:	f7fe fa6f 	bl	20027f32 <mbedtls_mpi_free>
20029a54:	a804      	add	r0, sp, #16
20029a56:	f7fe fa6c 	bl	20027f32 <mbedtls_mpi_free>
20029a5a:	a807      	add	r0, sp, #28
20029a5c:	f7fe fa69 	bl	20027f32 <mbedtls_mpi_free>
20029a60:	a80a      	add	r0, sp, #40	@ 0x28
20029a62:	f7fe fa66 	bl	20027f32 <mbedtls_mpi_free>
20029a66:	a80d      	add	r0, sp, #52	@ 0x34
20029a68:	f7fe fa63 	bl	20027f32 <mbedtls_mpi_free>
20029a6c:	a810      	add	r0, sp, #64	@ 0x40
20029a6e:	f7fe fa60 	bl	20027f32 <mbedtls_mpi_free>
20029a72:	a813      	add	r0, sp, #76	@ 0x4c
20029a74:	f7fe fa5d 	bl	20027f32 <mbedtls_mpi_free>
20029a78:	a816      	add	r0, sp, #88	@ 0x58
20029a7a:	f7fe fa5a 	bl	20027f32 <mbedtls_mpi_free>
20029a7e:	a819      	add	r0, sp, #100	@ 0x64
20029a80:	f7fe fa57 	bl	20027f32 <mbedtls_mpi_free>
20029a84:	a81c      	add	r0, sp, #112	@ 0x70
20029a86:	f7fe fa54 	bl	20027f32 <mbedtls_mpi_free>
20029a8a:	a81f      	add	r0, sp, #124	@ 0x7c
20029a8c:	f7fe fa51 	bl	20027f32 <mbedtls_mpi_free>
20029a90:	a822      	add	r0, sp, #136	@ 0x88
20029a92:	f7fe fa4e 	bl	20027f32 <mbedtls_mpi_free>
20029a96:	a825      	add	r0, sp, #148	@ 0x94
20029a98:	f7fe fa4b 	bl	20027f32 <mbedtls_mpi_free>
20029a9c:	f514 4f84 	cmn.w	r4, #16896	@ 0x4200
20029aa0:	f43f af35 	beq.w	2002990e <mbedtls_rsa_check_privkey+0xe>
20029aa4:	2c00      	cmp	r4, #0
20029aa6:	f43f af33 	beq.w	20029910 <mbedtls_rsa_check_privkey+0x10>
20029aaa:	f5a4 4484 	sub.w	r4, r4, #16896	@ 0x4200
20029aae:	e72f      	b.n	20029910 <mbedtls_rsa_check_privkey+0x10>
20029ab0:	f105 0144 	add.w	r1, r5, #68	@ 0x44
20029ab4:	a81f      	add	r0, sp, #124	@ 0x7c
20029ab6:	f7fe fc8d 	bl	200283d4 <mbedtls_mpi_cmp_mpi>
20029aba:	2800      	cmp	r0, #0
20029abc:	d1c6      	bne.n	20029a4c <mbedtls_rsa_check_privkey+0x14c>
20029abe:	f105 0150 	add.w	r1, r5, #80	@ 0x50
20029ac2:	a822      	add	r0, sp, #136	@ 0x88
20029ac4:	f7fe fc86 	bl	200283d4 <mbedtls_mpi_cmp_mpi>
20029ac8:	2800      	cmp	r0, #0
20029aca:	d1bf      	bne.n	20029a4c <mbedtls_rsa_check_privkey+0x14c>
20029acc:	f105 015c 	add.w	r1, r5, #92	@ 0x5c
20029ad0:	a825      	add	r0, sp, #148	@ 0x94
20029ad2:	f7fe fc7f 	bl	200283d4 <mbedtls_mpi_cmp_mpi>
20029ad6:	2800      	cmp	r0, #0
20029ad8:	d1b8      	bne.n	20029a4c <mbedtls_rsa_check_privkey+0x14c>
20029ada:	2100      	movs	r1, #0
20029adc:	a81c      	add	r0, sp, #112	@ 0x70
20029ade:	f7fe fcba 	bl	20028456 <mbedtls_mpi_cmp_int>
20029ae2:	2800      	cmp	r0, #0
20029ae4:	d1b2      	bne.n	20029a4c <mbedtls_rsa_check_privkey+0x14c>
20029ae6:	2101      	movs	r1, #1
20029ae8:	a810      	add	r0, sp, #64	@ 0x40
20029aea:	f7fe fcb4 	bl	20028456 <mbedtls_mpi_cmp_int>
20029aee:	2800      	cmp	r0, #0
20029af0:	d1ac      	bne.n	20029a4c <mbedtls_rsa_check_privkey+0x14c>
20029af2:	2101      	movs	r1, #1
20029af4:	a813      	add	r0, sp, #76	@ 0x4c
20029af6:	f7fe fcae 	bl	20028456 <mbedtls_mpi_cmp_int>
20029afa:	4604      	mov	r4, r0
20029afc:	2800      	cmp	r0, #0
20029afe:	d1a5      	bne.n	20029a4c <mbedtls_rsa_check_privkey+0x14c>
20029b00:	e7a5      	b.n	20029a4e <mbedtls_rsa_check_privkey+0x14e>
20029b02:	bf00      	nop
20029b04:	ffffbe00 	.word	0xffffbe00

20029b08 <mbedtls_rsa_check_pub_priv>:
20029b08:	b538      	push	{r3, r4, r5, lr}
20029b0a:	4605      	mov	r5, r0
20029b0c:	460c      	mov	r4, r1
20029b0e:	f7ff fecb 	bl	200298a8 <mbedtls_rsa_check_pubkey>
20029b12:	b918      	cbnz	r0, 20029b1c <mbedtls_rsa_check_pub_priv+0x14>
20029b14:	4620      	mov	r0, r4
20029b16:	f7ff fef3 	bl	20029900 <mbedtls_rsa_check_privkey>
20029b1a:	b108      	cbz	r0, 20029b20 <mbedtls_rsa_check_pub_priv+0x18>
20029b1c:	4809      	ldr	r0, [pc, #36]	@ (20029b44 <mbedtls_rsa_check_pub_priv+0x3c>)
20029b1e:	bd38      	pop	{r3, r4, r5, pc}
20029b20:	f104 0108 	add.w	r1, r4, #8
20029b24:	f105 0008 	add.w	r0, r5, #8
20029b28:	f7fe fc54 	bl	200283d4 <mbedtls_mpi_cmp_mpi>
20029b2c:	2800      	cmp	r0, #0
20029b2e:	d1f5      	bne.n	20029b1c <mbedtls_rsa_check_pub_priv+0x14>
20029b30:	f104 0114 	add.w	r1, r4, #20
20029b34:	f105 0014 	add.w	r0, r5, #20
20029b38:	f7fe fc4c 	bl	200283d4 <mbedtls_mpi_cmp_mpi>
20029b3c:	2800      	cmp	r0, #0
20029b3e:	d0ee      	beq.n	20029b1e <mbedtls_rsa_check_pub_priv+0x16>
20029b40:	e7ec      	b.n	20029b1c <mbedtls_rsa_check_pub_priv+0x14>
20029b42:	bf00      	nop
20029b44:	ffffbe00 	.word	0xffffbe00

20029b48 <mbedtls_rsa_public>:
20029b48:	b5f0      	push	{r4, r5, r6, r7, lr}
20029b4a:	460c      	mov	r4, r1
20029b4c:	4605      	mov	r5, r0
20029b4e:	b087      	sub	sp, #28
20029b50:	a803      	add	r0, sp, #12
20029b52:	4616      	mov	r6, r2
20029b54:	f7fe f9e6 	bl	20027f24 <mbedtls_mpi_init>
20029b58:	4621      	mov	r1, r4
20029b5a:	686a      	ldr	r2, [r5, #4]
20029b5c:	a803      	add	r0, sp, #12
20029b5e:	f7fe faa9 	bl	200280b4 <mbedtls_mpi_read_binary>
20029b62:	4604      	mov	r4, r0
20029b64:	b9d0      	cbnz	r0, 20029b9c <mbedtls_rsa_public+0x54>
20029b66:	f105 0408 	add.w	r4, r5, #8
20029b6a:	4621      	mov	r1, r4
20029b6c:	a803      	add	r0, sp, #12
20029b6e:	f7fe fc31 	bl	200283d4 <mbedtls_mpi_cmp_mpi>
20029b72:	2800      	cmp	r0, #0
20029b74:	da1b      	bge.n	20029bae <mbedtls_rsa_public+0x66>
20029b76:	f105 0368 	add.w	r3, r5, #104	@ 0x68
20029b7a:	a903      	add	r1, sp, #12
20029b7c:	686f      	ldr	r7, [r5, #4]
20029b7e:	4608      	mov	r0, r1
20029b80:	9300      	str	r3, [sp, #0]
20029b82:	f105 0214 	add.w	r2, r5, #20
20029b86:	4623      	mov	r3, r4
20029b88:	f7ff f81b 	bl	20028bc2 <mbedtls_mpi_exp_mod>
20029b8c:	4604      	mov	r4, r0
20029b8e:	b928      	cbnz	r0, 20029b9c <mbedtls_rsa_public+0x54>
20029b90:	463a      	mov	r2, r7
20029b92:	4631      	mov	r1, r6
20029b94:	a803      	add	r0, sp, #12
20029b96:	f7fe fac2 	bl	2002811e <mbedtls_mpi_write_binary>
20029b9a:	4604      	mov	r4, r0
20029b9c:	a803      	add	r0, sp, #12
20029b9e:	f7fe f9c8 	bl	20027f32 <mbedtls_mpi_free>
20029ba2:	b10c      	cbz	r4, 20029ba8 <mbedtls_rsa_public+0x60>
20029ba4:	f5a4 4485 	sub.w	r4, r4, #17024	@ 0x4280
20029ba8:	4620      	mov	r0, r4
20029baa:	b007      	add	sp, #28
20029bac:	bdf0      	pop	{r4, r5, r6, r7, pc}
20029bae:	f06f 0403 	mvn.w	r4, #3
20029bb2:	e7f3      	b.n	20029b9c <mbedtls_rsa_public+0x54>

20029bb4 <mbedtls_rsa_private>:
20029bb4:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
20029bb8:	461e      	mov	r6, r3
20029bba:	6b43      	ldr	r3, [r0, #52]	@ 0x34
20029bbc:	4604      	mov	r4, r0
20029bbe:	460d      	mov	r5, r1
20029bc0:	4617      	mov	r7, r2
20029bc2:	b09d      	sub	sp, #116	@ 0x74
20029bc4:	2b00      	cmp	r3, #0
20029bc6:	f000 8179 	beq.w	20029ebc <mbedtls_rsa_private+0x308>
20029bca:	6c03      	ldr	r3, [r0, #64]	@ 0x40
20029bcc:	2b00      	cmp	r3, #0
20029bce:	f000 8175 	beq.w	20029ebc <mbedtls_rsa_private+0x308>
20029bd2:	6a83      	ldr	r3, [r0, #40]	@ 0x28
20029bd4:	2b00      	cmp	r3, #0
20029bd6:	f000 8171 	beq.w	20029ebc <mbedtls_rsa_private+0x308>
20029bda:	a804      	add	r0, sp, #16
20029bdc:	f7fe f9a2 	bl	20027f24 <mbedtls_mpi_init>
20029be0:	a807      	add	r0, sp, #28
20029be2:	f7fe f99f 	bl	20027f24 <mbedtls_mpi_init>
20029be6:	a80a      	add	r0, sp, #40	@ 0x28
20029be8:	f7fe f99c 	bl	20027f24 <mbedtls_mpi_init>
20029bec:	a80d      	add	r0, sp, #52	@ 0x34
20029bee:	f7fe f999 	bl	20027f24 <mbedtls_mpi_init>
20029bf2:	a810      	add	r0, sp, #64	@ 0x40
20029bf4:	f7fe f996 	bl	20027f24 <mbedtls_mpi_init>
20029bf8:	a813      	add	r0, sp, #76	@ 0x4c
20029bfa:	f7fe f993 	bl	20027f24 <mbedtls_mpi_init>
20029bfe:	b12d      	cbz	r5, 20029c0c <mbedtls_rsa_private+0x58>
20029c00:	a816      	add	r0, sp, #88	@ 0x58
20029c02:	f7fe f98f 	bl	20027f24 <mbedtls_mpi_init>
20029c06:	a819      	add	r0, sp, #100	@ 0x64
20029c08:	f7fe f98c 	bl	20027f24 <mbedtls_mpi_init>
20029c0c:	4631      	mov	r1, r6
20029c0e:	6862      	ldr	r2, [r4, #4]
20029c10:	a804      	add	r0, sp, #16
20029c12:	f7fe fa4f 	bl	200280b4 <mbedtls_mpi_read_binary>
20029c16:	4603      	mov	r3, r0
20029c18:	2800      	cmp	r0, #0
20029c1a:	f040 80e0 	bne.w	20029dde <mbedtls_rsa_private+0x22a>
20029c1e:	f104 0608 	add.w	r6, r4, #8
20029c22:	4631      	mov	r1, r6
20029c24:	a804      	add	r0, sp, #16
20029c26:	f7fe fbd5 	bl	200283d4 <mbedtls_mpi_cmp_mpi>
20029c2a:	2800      	cmp	r0, #0
20029c2c:	f280 8143 	bge.w	20029eb6 <mbedtls_rsa_private+0x302>
20029c30:	f104 0a44 	add.w	sl, r4, #68	@ 0x44
20029c34:	f104 0950 	add.w	r9, r4, #80	@ 0x50
20029c38:	2d00      	cmp	r5, #0
20029c3a:	f000 8089 	beq.w	20029d50 <mbedtls_rsa_private+0x19c>
20029c3e:	f8d4 30a0 	ldr.w	r3, [r4, #160]	@ 0xa0
20029c42:	2b00      	cmp	r3, #0
20029c44:	f000 80f4 	beq.w	20029e30 <mbedtls_rsa_private+0x27c>
20029c48:	f104 088c 	add.w	r8, r4, #140	@ 0x8c
20029c4c:	4642      	mov	r2, r8
20029c4e:	4641      	mov	r1, r8
20029c50:	4640      	mov	r0, r8
20029c52:	f7fe fd0f 	bl	20028674 <mbedtls_mpi_mul_mpi>
20029c56:	4603      	mov	r3, r0
20029c58:	2800      	cmp	r0, #0
20029c5a:	f040 80c0 	bne.w	20029dde <mbedtls_rsa_private+0x22a>
20029c5e:	4632      	mov	r2, r6
20029c60:	4641      	mov	r1, r8
20029c62:	4640      	mov	r0, r8
20029c64:	f7fe ff7b 	bl	20028b5e <mbedtls_mpi_mod_mpi>
20029c68:	4603      	mov	r3, r0
20029c6a:	2800      	cmp	r0, #0
20029c6c:	f040 80b7 	bne.w	20029dde <mbedtls_rsa_private+0x22a>
20029c70:	f104 0898 	add.w	r8, r4, #152	@ 0x98
20029c74:	4642      	mov	r2, r8
20029c76:	4641      	mov	r1, r8
20029c78:	4640      	mov	r0, r8
20029c7a:	f7fe fcfb 	bl	20028674 <mbedtls_mpi_mul_mpi>
20029c7e:	4603      	mov	r3, r0
20029c80:	2800      	cmp	r0, #0
20029c82:	f040 80ac 	bne.w	20029dde <mbedtls_rsa_private+0x22a>
20029c86:	4632      	mov	r2, r6
20029c88:	4641      	mov	r1, r8
20029c8a:	4640      	mov	r0, r8
20029c8c:	f7fe ff67 	bl	20028b5e <mbedtls_mpi_mod_mpi>
20029c90:	4603      	mov	r3, r0
20029c92:	2800      	cmp	r0, #0
20029c94:	f040 80a3 	bne.w	20029dde <mbedtls_rsa_private+0x22a>
20029c98:	a904      	add	r1, sp, #16
20029c9a:	4608      	mov	r0, r1
20029c9c:	f104 028c 	add.w	r2, r4, #140	@ 0x8c
20029ca0:	f7fe fce8 	bl	20028674 <mbedtls_mpi_mul_mpi>
20029ca4:	4603      	mov	r3, r0
20029ca6:	2800      	cmp	r0, #0
20029ca8:	f040 8099 	bne.w	20029dde <mbedtls_rsa_private+0x22a>
20029cac:	a904      	add	r1, sp, #16
20029cae:	4632      	mov	r2, r6
20029cb0:	4608      	mov	r0, r1
20029cb2:	f7fe ff54 	bl	20028b5e <mbedtls_mpi_mod_mpi>
20029cb6:	4603      	mov	r3, r0
20029cb8:	2800      	cmp	r0, #0
20029cba:	f040 8090 	bne.w	20029dde <mbedtls_rsa_private+0x22a>
20029cbe:	2201      	movs	r2, #1
20029cc0:	f104 012c 	add.w	r1, r4, #44	@ 0x2c
20029cc4:	a80d      	add	r0, sp, #52	@ 0x34
20029cc6:	f7fe fcbf 	bl	20028648 <mbedtls_mpi_sub_int>
20029cca:	4603      	mov	r3, r0
20029ccc:	2800      	cmp	r0, #0
20029cce:	f040 8086 	bne.w	20029dde <mbedtls_rsa_private+0x22a>
20029cd2:	2201      	movs	r2, #1
20029cd4:	f104 0138 	add.w	r1, r4, #56	@ 0x38
20029cd8:	a810      	add	r0, sp, #64	@ 0x40
20029cda:	f7fe fcb5 	bl	20028648 <mbedtls_mpi_sub_int>
20029cde:	4603      	mov	r3, r0
20029ce0:	2800      	cmp	r0, #0
20029ce2:	d17c      	bne.n	20029dde <mbedtls_rsa_private+0x22a>
20029ce4:	463b      	mov	r3, r7
20029ce6:	462a      	mov	r2, r5
20029ce8:	211c      	movs	r1, #28
20029cea:	a813      	add	r0, sp, #76	@ 0x4c
20029cec:	f7ff f9fb 	bl	200290e6 <mbedtls_mpi_fill_random>
20029cf0:	4603      	mov	r3, r0
20029cf2:	2800      	cmp	r0, #0
20029cf4:	d173      	bne.n	20029dde <mbedtls_rsa_private+0x22a>
20029cf6:	aa13      	add	r2, sp, #76	@ 0x4c
20029cf8:	a90d      	add	r1, sp, #52	@ 0x34
20029cfa:	a816      	add	r0, sp, #88	@ 0x58
20029cfc:	f7fe fcba 	bl	20028674 <mbedtls_mpi_mul_mpi>
20029d00:	4603      	mov	r3, r0
20029d02:	2800      	cmp	r0, #0
20029d04:	d16b      	bne.n	20029dde <mbedtls_rsa_private+0x22a>
20029d06:	a916      	add	r1, sp, #88	@ 0x58
20029d08:	4652      	mov	r2, sl
20029d0a:	4608      	mov	r0, r1
20029d0c:	f7fe fc4f 	bl	200285ae <mbedtls_mpi_add_mpi>
20029d10:	4603      	mov	r3, r0
20029d12:	2800      	cmp	r0, #0
20029d14:	d163      	bne.n	20029dde <mbedtls_rsa_private+0x22a>
20029d16:	463b      	mov	r3, r7
20029d18:	462a      	mov	r2, r5
20029d1a:	211c      	movs	r1, #28
20029d1c:	a813      	add	r0, sp, #76	@ 0x4c
20029d1e:	f7ff f9e2 	bl	200290e6 <mbedtls_mpi_fill_random>
20029d22:	4603      	mov	r3, r0
20029d24:	2800      	cmp	r0, #0
20029d26:	d15a      	bne.n	20029dde <mbedtls_rsa_private+0x22a>
20029d28:	aa13      	add	r2, sp, #76	@ 0x4c
20029d2a:	a910      	add	r1, sp, #64	@ 0x40
20029d2c:	a819      	add	r0, sp, #100	@ 0x64
20029d2e:	f7fe fca1 	bl	20028674 <mbedtls_mpi_mul_mpi>
20029d32:	4603      	mov	r3, r0
20029d34:	2800      	cmp	r0, #0
20029d36:	d152      	bne.n	20029dde <mbedtls_rsa_private+0x22a>
20029d38:	a919      	add	r1, sp, #100	@ 0x64
20029d3a:	464a      	mov	r2, r9
20029d3c:	4608      	mov	r0, r1
20029d3e:	f7fe fc36 	bl	200285ae <mbedtls_mpi_add_mpi>
20029d42:	4603      	mov	r3, r0
20029d44:	2800      	cmp	r0, #0
20029d46:	d14a      	bne.n	20029dde <mbedtls_rsa_private+0x22a>
20029d48:	f10d 0964 	add.w	r9, sp, #100	@ 0x64
20029d4c:	f10d 0a58 	add.w	sl, sp, #88	@ 0x58
20029d50:	f104 0374 	add.w	r3, r4, #116	@ 0x74
20029d54:	f104 082c 	add.w	r8, r4, #44	@ 0x2c
20029d58:	9300      	str	r3, [sp, #0]
20029d5a:	4652      	mov	r2, sl
20029d5c:	4643      	mov	r3, r8
20029d5e:	a904      	add	r1, sp, #16
20029d60:	a807      	add	r0, sp, #28
20029d62:	f7fe ff2e 	bl	20028bc2 <mbedtls_mpi_exp_mod>
20029d66:	4603      	mov	r3, r0
20029d68:	2800      	cmp	r0, #0
20029d6a:	d138      	bne.n	20029dde <mbedtls_rsa_private+0x22a>
20029d6c:	f104 0380 	add.w	r3, r4, #128	@ 0x80
20029d70:	f104 0738 	add.w	r7, r4, #56	@ 0x38
20029d74:	9300      	str	r3, [sp, #0]
20029d76:	464a      	mov	r2, r9
20029d78:	463b      	mov	r3, r7
20029d7a:	a904      	add	r1, sp, #16
20029d7c:	a80a      	add	r0, sp, #40	@ 0x28
20029d7e:	f7fe ff20 	bl	20028bc2 <mbedtls_mpi_exp_mod>
20029d82:	4603      	mov	r3, r0
20029d84:	bb58      	cbnz	r0, 20029dde <mbedtls_rsa_private+0x22a>
20029d86:	aa0a      	add	r2, sp, #40	@ 0x28
20029d88:	a907      	add	r1, sp, #28
20029d8a:	a804      	add	r0, sp, #16
20029d8c:	f7fe fc35 	bl	200285fa <mbedtls_mpi_sub_mpi>
20029d90:	4603      	mov	r3, r0
20029d92:	bb20      	cbnz	r0, 20029dde <mbedtls_rsa_private+0x22a>
20029d94:	f104 025c 	add.w	r2, r4, #92	@ 0x5c
20029d98:	a904      	add	r1, sp, #16
20029d9a:	a807      	add	r0, sp, #28
20029d9c:	f7fe fc6a 	bl	20028674 <mbedtls_mpi_mul_mpi>
20029da0:	4603      	mov	r3, r0
20029da2:	b9e0      	cbnz	r0, 20029dde <mbedtls_rsa_private+0x22a>
20029da4:	4642      	mov	r2, r8
20029da6:	a907      	add	r1, sp, #28
20029da8:	a804      	add	r0, sp, #16
20029daa:	f7fe fed8 	bl	20028b5e <mbedtls_mpi_mod_mpi>
20029dae:	4603      	mov	r3, r0
20029db0:	b9a8      	cbnz	r0, 20029dde <mbedtls_rsa_private+0x22a>
20029db2:	463a      	mov	r2, r7
20029db4:	a904      	add	r1, sp, #16
20029db6:	a807      	add	r0, sp, #28
20029db8:	f7fe fc5c 	bl	20028674 <mbedtls_mpi_mul_mpi>
20029dbc:	4603      	mov	r3, r0
20029dbe:	b970      	cbnz	r0, 20029dde <mbedtls_rsa_private+0x22a>
20029dc0:	aa07      	add	r2, sp, #28
20029dc2:	a90a      	add	r1, sp, #40	@ 0x28
20029dc4:	a804      	add	r0, sp, #16
20029dc6:	f7fe fbf2 	bl	200285ae <mbedtls_mpi_add_mpi>
20029dca:	4603      	mov	r3, r0
20029dcc:	b938      	cbnz	r0, 20029dde <mbedtls_rsa_private+0x22a>
20029dce:	2d00      	cmp	r5, #0
20029dd0:	d15f      	bne.n	20029e92 <mbedtls_rsa_private+0x2de>
20029dd2:	6862      	ldr	r2, [r4, #4]
20029dd4:	9926      	ldr	r1, [sp, #152]	@ 0x98
20029dd6:	a804      	add	r0, sp, #16
20029dd8:	f7fe f9a1 	bl	2002811e <mbedtls_mpi_write_binary>
20029ddc:	4603      	mov	r3, r0
20029dde:	a804      	add	r0, sp, #16
20029de0:	9303      	str	r3, [sp, #12]
20029de2:	f7fe f8a6 	bl	20027f32 <mbedtls_mpi_free>
20029de6:	a807      	add	r0, sp, #28
20029de8:	f7fe f8a3 	bl	20027f32 <mbedtls_mpi_free>
20029dec:	a80a      	add	r0, sp, #40	@ 0x28
20029dee:	f7fe f8a0 	bl	20027f32 <mbedtls_mpi_free>
20029df2:	a80d      	add	r0, sp, #52	@ 0x34
20029df4:	f7fe f89d 	bl	20027f32 <mbedtls_mpi_free>
20029df8:	a810      	add	r0, sp, #64	@ 0x40
20029dfa:	f7fe f89a 	bl	20027f32 <mbedtls_mpi_free>
20029dfe:	a813      	add	r0, sp, #76	@ 0x4c
20029e00:	f7fe f897 	bl	20027f32 <mbedtls_mpi_free>
20029e04:	9b03      	ldr	r3, [sp, #12]
20029e06:	b135      	cbz	r5, 20029e16 <mbedtls_rsa_private+0x262>
20029e08:	a816      	add	r0, sp, #88	@ 0x58
20029e0a:	f7fe f892 	bl	20027f32 <mbedtls_mpi_free>
20029e0e:	a819      	add	r0, sp, #100	@ 0x64
20029e10:	f7fe f88f 	bl	20027f32 <mbedtls_mpi_free>
20029e14:	9b03      	ldr	r3, [sp, #12]
20029e16:	b10b      	cbz	r3, 20029e1c <mbedtls_rsa_private+0x268>
20029e18:	f5a3 4386 	sub.w	r3, r3, #17152	@ 0x4300
20029e1c:	4618      	mov	r0, r3
20029e1e:	b01d      	add	sp, #116	@ 0x74
20029e20:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
20029e24:	9b03      	ldr	r3, [sp, #12]
20029e26:	3b01      	subs	r3, #1
20029e28:	9303      	str	r3, [sp, #12]
20029e2a:	d107      	bne.n	20029e3c <mbedtls_rsa_private+0x288>
20029e2c:	4b24      	ldr	r3, [pc, #144]	@ (20029ec0 <mbedtls_rsa_private+0x30c>)
20029e2e:	e7d6      	b.n	20029dde <mbedtls_rsa_private+0x22a>
20029e30:	230b      	movs	r3, #11
20029e32:	f104 0b98 	add.w	fp, r4, #152	@ 0x98
20029e36:	9303      	str	r3, [sp, #12]
20029e38:	f104 088c 	add.w	r8, r4, #140	@ 0x8c
20029e3c:	6861      	ldr	r1, [r4, #4]
20029e3e:	463b      	mov	r3, r7
20029e40:	462a      	mov	r2, r5
20029e42:	4658      	mov	r0, fp
20029e44:	3901      	subs	r1, #1
20029e46:	f7ff f94e 	bl	200290e6 <mbedtls_mpi_fill_random>
20029e4a:	4603      	mov	r3, r0
20029e4c:	2800      	cmp	r0, #0
20029e4e:	d1c6      	bne.n	20029dde <mbedtls_rsa_private+0x22a>
20029e50:	4632      	mov	r2, r6
20029e52:	4659      	mov	r1, fp
20029e54:	4640      	mov	r0, r8
20029e56:	f7ff f8c8 	bl	20028fea <mbedtls_mpi_gcd>
20029e5a:	4603      	mov	r3, r0
20029e5c:	2800      	cmp	r0, #0
20029e5e:	d1be      	bne.n	20029dde <mbedtls_rsa_private+0x22a>
20029e60:	2101      	movs	r1, #1
20029e62:	4640      	mov	r0, r8
20029e64:	f7fe faf7 	bl	20028456 <mbedtls_mpi_cmp_int>
20029e68:	2800      	cmp	r0, #0
20029e6a:	d1db      	bne.n	20029e24 <mbedtls_rsa_private+0x270>
20029e6c:	4632      	mov	r2, r6
20029e6e:	4659      	mov	r1, fp
20029e70:	4640      	mov	r0, r8
20029e72:	f7ff f955 	bl	20029120 <mbedtls_mpi_inv_mod>
20029e76:	4603      	mov	r3, r0
20029e78:	2800      	cmp	r0, #0
20029e7a:	d1b0      	bne.n	20029dde <mbedtls_rsa_private+0x22a>
20029e7c:	f104 0368 	add.w	r3, r4, #104	@ 0x68
20029e80:	9300      	str	r3, [sp, #0]
20029e82:	4641      	mov	r1, r8
20029e84:	4633      	mov	r3, r6
20029e86:	4640      	mov	r0, r8
20029e88:	f104 0214 	add.w	r2, r4, #20
20029e8c:	f7fe fe99 	bl	20028bc2 <mbedtls_mpi_exp_mod>
20029e90:	e6fe      	b.n	20029c90 <mbedtls_rsa_private+0xdc>
20029e92:	a904      	add	r1, sp, #16
20029e94:	4608      	mov	r0, r1
20029e96:	f104 0298 	add.w	r2, r4, #152	@ 0x98
20029e9a:	f7fe fbeb 	bl	20028674 <mbedtls_mpi_mul_mpi>
20029e9e:	4603      	mov	r3, r0
20029ea0:	2800      	cmp	r0, #0
20029ea2:	d19c      	bne.n	20029dde <mbedtls_rsa_private+0x22a>
20029ea4:	a904      	add	r1, sp, #16
20029ea6:	4632      	mov	r2, r6
20029ea8:	4608      	mov	r0, r1
20029eaa:	f7fe fe58 	bl	20028b5e <mbedtls_mpi_mod_mpi>
20029eae:	4603      	mov	r3, r0
20029eb0:	2800      	cmp	r0, #0
20029eb2:	d08e      	beq.n	20029dd2 <mbedtls_rsa_private+0x21e>
20029eb4:	e793      	b.n	20029dde <mbedtls_rsa_private+0x22a>
20029eb6:	f06f 0303 	mvn.w	r3, #3
20029eba:	e790      	b.n	20029dde <mbedtls_rsa_private+0x22a>
20029ebc:	4b01      	ldr	r3, [pc, #4]	@ (20029ec4 <mbedtls_rsa_private+0x310>)
20029ebe:	e7ad      	b.n	20029e1c <mbedtls_rsa_private+0x268>
20029ec0:	ffffbb80 	.word	0xffffbb80
20029ec4:	ffffbf80 	.word	0xffffbf80

20029ec8 <mbedtls_rsa_rsaes_pkcs1_v15_encrypt>:
20029ec8:	e92d 4ff7 	stmdb	sp!, {r0, r1, r2, r4, r5, r6, r7, r8, r9, sl, fp, lr}
20029ecc:	4698      	mov	r8, r3
20029ece:	e9dd a30c 	ldrd	sl, r3, [sp, #48]	@ 0x30
20029ed2:	f1b8 0f01 	cmp.w	r8, #1
20029ed6:	4606      	mov	r6, r0
20029ed8:	460f      	mov	r7, r1
20029eda:	4691      	mov	r9, r2
20029edc:	9d0e      	ldr	r5, [sp, #56]	@ 0x38
20029ede:	d103      	bne.n	20029ee8 <mbedtls_rsa_rsaes_pkcs1_v15_encrypt+0x20>
20029ee0:	f8d0 20a4 	ldr.w	r2, [r0, #164]	@ 0xa4
20029ee4:	2a00      	cmp	r2, #0
20029ee6:	d162      	bne.n	20029fae <mbedtls_rsa_rsaes_pkcs1_v15_encrypt+0xe6>
20029ee8:	2f00      	cmp	r7, #0
20029eea:	d060      	beq.n	20029fae <mbedtls_rsa_rsaes_pkcs1_v15_encrypt+0xe6>
20029eec:	2b00      	cmp	r3, #0
20029eee:	d05e      	beq.n	20029fae <mbedtls_rsa_rsaes_pkcs1_v15_encrypt+0xe6>
20029ef0:	2d00      	cmp	r5, #0
20029ef2:	d05c      	beq.n	20029fae <mbedtls_rsa_rsaes_pkcs1_v15_encrypt+0xe6>
20029ef4:	f11a 0f0c 	cmn.w	sl, #12
20029ef8:	6874      	ldr	r4, [r6, #4]
20029efa:	d858      	bhi.n	20029fae <mbedtls_rsa_rsaes_pkcs1_v15_encrypt+0xe6>
20029efc:	f10a 020b 	add.w	r2, sl, #11
20029f00:	42a2      	cmp	r2, r4
20029f02:	d854      	bhi.n	20029fae <mbedtls_rsa_rsaes_pkcs1_v15_encrypt+0xe6>
20029f04:	4629      	mov	r1, r5
20029f06:	2200      	movs	r2, #0
20029f08:	eba4 040a 	sub.w	r4, r4, sl
20029f0c:	3c03      	subs	r4, #3
20029f0e:	f801 2b02 	strb.w	r2, [r1], #2
20029f12:	f1b8 0f00 	cmp.w	r8, #0
20029f16:	d131      	bne.n	20029f7c <mbedtls_rsa_rsaes_pkcs1_v15_encrypt+0xb4>
20029f18:	2202      	movs	r2, #2
20029f1a:	4414      	add	r4, r2
20029f1c:	706a      	strb	r2, [r5, #1]
20029f1e:	442c      	add	r4, r5
20029f20:	42a1      	cmp	r1, r4
20029f22:	d112      	bne.n	20029f4a <mbedtls_rsa_rsaes_pkcs1_v15_encrypt+0x82>
20029f24:	2200      	movs	r2, #0
20029f26:	4620      	mov	r0, r4
20029f28:	4619      	mov	r1, r3
20029f2a:	f800 2b01 	strb.w	r2, [r0], #1
20029f2e:	4652      	mov	r2, sl
20029f30:	f000 fdaa 	bl	2002aa88 <memcpy>
20029f34:	f1b8 0f00 	cmp.w	r8, #0
20029f38:	d12f      	bne.n	20029f9a <mbedtls_rsa_rsaes_pkcs1_v15_encrypt+0xd2>
20029f3a:	462a      	mov	r2, r5
20029f3c:	4629      	mov	r1, r5
20029f3e:	4630      	mov	r0, r6
20029f40:	b003      	add	sp, #12
20029f42:	e8bd 4ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
20029f46:	f7ff bdff 	b.w	20029b48 <mbedtls_rsa_public>
20029f4a:	f04f 0b64 	mov.w	fp, #100	@ 0x64
20029f4e:	2201      	movs	r2, #1
20029f50:	4648      	mov	r0, r9
20029f52:	9301      	str	r3, [sp, #4]
20029f54:	9100      	str	r1, [sp, #0]
20029f56:	47b8      	blx	r7
20029f58:	9900      	ldr	r1, [sp, #0]
20029f5a:	9b01      	ldr	r3, [sp, #4]
20029f5c:	780a      	ldrb	r2, [r1, #0]
20029f5e:	b94a      	cbnz	r2, 20029f74 <mbedtls_rsa_rsaes_pkcs1_v15_encrypt+0xac>
20029f60:	f1bb 0b01 	subs.w	fp, fp, #1
20029f64:	d001      	beq.n	20029f6a <mbedtls_rsa_rsaes_pkcs1_v15_encrypt+0xa2>
20029f66:	2800      	cmp	r0, #0
20029f68:	d0f1      	beq.n	20029f4e <mbedtls_rsa_rsaes_pkcs1_v15_encrypt+0x86>
20029f6a:	f5a0 4089 	sub.w	r0, r0, #17536	@ 0x4480
20029f6e:	b003      	add	sp, #12
20029f70:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
20029f74:	2800      	cmp	r0, #0
20029f76:	d1f8      	bne.n	20029f6a <mbedtls_rsa_rsaes_pkcs1_v15_encrypt+0xa2>
20029f78:	3101      	adds	r1, #1
20029f7a:	e7d1      	b.n	20029f20 <mbedtls_rsa_rsaes_pkcs1_v15_encrypt+0x58>
20029f7c:	2001      	movs	r0, #1
20029f7e:	462a      	mov	r2, r5
20029f80:	f04f 0cff 	mov.w	ip, #255	@ 0xff
20029f84:	f802 0f01 	strb.w	r0, [r2, #1]!
20029f88:	1820      	adds	r0, r4, r0
20029f8a:	4428      	add	r0, r5
20029f8c:	4282      	cmp	r2, r0
20029f8e:	d101      	bne.n	20029f94 <mbedtls_rsa_rsaes_pkcs1_v15_encrypt+0xcc>
20029f90:	440c      	add	r4, r1
20029f92:	e7c7      	b.n	20029f24 <mbedtls_rsa_rsaes_pkcs1_v15_encrypt+0x5c>
20029f94:	f802 cf01 	strb.w	ip, [r2, #1]!
20029f98:	e7f8      	b.n	20029f8c <mbedtls_rsa_rsaes_pkcs1_v15_encrypt+0xc4>
20029f9a:	462b      	mov	r3, r5
20029f9c:	464a      	mov	r2, r9
20029f9e:	4639      	mov	r1, r7
20029fa0:	4630      	mov	r0, r6
20029fa2:	950c      	str	r5, [sp, #48]	@ 0x30
20029fa4:	b003      	add	sp, #12
20029fa6:	e8bd 4ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
20029faa:	f7ff be03 	b.w	20029bb4 <mbedtls_rsa_private>
20029fae:	4801      	ldr	r0, [pc, #4]	@ (20029fb4 <mbedtls_rsa_rsaes_pkcs1_v15_encrypt+0xec>)
20029fb0:	e7dd      	b.n	20029f6e <mbedtls_rsa_rsaes_pkcs1_v15_encrypt+0xa6>
20029fb2:	bf00      	nop
20029fb4:	ffffbf80 	.word	0xffffbf80

20029fb8 <mbedtls_rsa_pkcs1_encrypt>:
20029fb8:	b410      	push	{r4}
20029fba:	f8d0 40a4 	ldr.w	r4, [r0, #164]	@ 0xa4
20029fbe:	b91c      	cbnz	r4, 20029fc8 <mbedtls_rsa_pkcs1_encrypt+0x10>
20029fc0:	f85d 4b04 	ldr.w	r4, [sp], #4
20029fc4:	f7ff bf80 	b.w	20029ec8 <mbedtls_rsa_rsaes_pkcs1_v15_encrypt>
20029fc8:	4801      	ldr	r0, [pc, #4]	@ (20029fd0 <mbedtls_rsa_pkcs1_encrypt+0x18>)
20029fca:	f85d 4b04 	ldr.w	r4, [sp], #4
20029fce:	4770      	bx	lr
20029fd0:	ffffbf00 	.word	0xffffbf00

20029fd4 <mbedtls_rsa_rsaes_pkcs1_v15_decrypt>:
20029fd4:	e92d 41f0 	stmdb	sp!, {r4, r5, r6, r7, r8, lr}
20029fd8:	4698      	mov	r8, r3
20029fda:	f5ad 6d81 	sub.w	sp, sp, #1032	@ 0x408
20029fde:	f1b8 0f01 	cmp.w	r8, #1
20029fe2:	f8dd 3424 	ldr.w	r3, [sp, #1060]	@ 0x424
20029fe6:	d103      	bne.n	20029ff0 <mbedtls_rsa_rsaes_pkcs1_v15_decrypt+0x1c>
20029fe8:	f8d0 40a4 	ldr.w	r4, [r0, #164]	@ 0xa4
20029fec:	2c00      	cmp	r4, #0
20029fee:	d17c      	bne.n	2002a0ea <mbedtls_rsa_rsaes_pkcs1_v15_decrypt+0x116>
20029ff0:	6845      	ldr	r5, [r0, #4]
20029ff2:	f1a5 0410 	sub.w	r4, r5, #16
20029ff6:	f5b4 7f7c 	cmp.w	r4, #1008	@ 0x3f0
20029ffa:	d876      	bhi.n	2002a0ea <mbedtls_rsa_rsaes_pkcs1_v15_decrypt+0x116>
20029ffc:	ae02      	add	r6, sp, #8
20029ffe:	f1b8 0f00 	cmp.w	r8, #0
2002a002:	d153      	bne.n	2002a0ac <mbedtls_rsa_rsaes_pkcs1_v15_decrypt+0xd8>
2002a004:	4632      	mov	r2, r6
2002a006:	4619      	mov	r1, r3
2002a008:	f7ff fd9e 	bl	20029b48 <mbedtls_rsa_public>
2002a00c:	4604      	mov	r4, r0
2002a00e:	2800      	cmp	r0, #0
2002a010:	d140      	bne.n	2002a094 <mbedtls_rsa_rsaes_pkcs1_v15_decrypt+0xc0>
2002a012:	f1b8 0f01 	cmp.w	r8, #1
2002a016:	7831      	ldrb	r1, [r6, #0]
2002a018:	7872      	ldrb	r2, [r6, #1]
2002a01a:	f1a5 0703 	sub.w	r7, r5, #3
2002a01e:	d149      	bne.n	2002a0b4 <mbedtls_rsa_rsaes_pkcs1_v15_decrypt+0xe0>
2002a020:	f082 0202 	eor.w	r2, r2, #2
2002a024:	ea41 0302 	orr.w	r3, r1, r2
2002a028:	4684      	mov	ip, r0
2002a02a:	4686      	mov	lr, r0
2002a02c:	4602      	mov	r2, r0
2002a02e:	f10d 0109 	add.w	r1, sp, #9
2002a032:	f811 0f01 	ldrb.w	r0, [r1, #1]!
2002a036:	f10e 0e01 	add.w	lr, lr, #1
2002a03a:	f1c0 0800 	rsb	r8, r0, #0
2002a03e:	ea40 0008 	orr.w	r0, r0, r8
2002a042:	f3c0 10c0 	ubfx	r0, r0, #7, #1
2002a046:	f080 0001 	eor.w	r0, r0, #1
2002a04a:	ea4c 0c00 	orr.w	ip, ip, r0
2002a04e:	f1cc 0000 	rsb	r0, ip, #0
2002a052:	ea4c 0000 	orr.w	r0, ip, r0
2002a056:	f3c0 10c0 	ubfx	r0, r0, #7, #1
2002a05a:	f080 0001 	eor.w	r0, r0, #1
2002a05e:	45be      	cmp	lr, r7
2002a060:	4402      	add	r2, r0
2002a062:	d3e6      	bcc.n	2002a032 <mbedtls_rsa_rsaes_pkcs1_v15_decrypt+0x5e>
2002a064:	f10d 000a 	add.w	r0, sp, #10
2002a068:	1881      	adds	r1, r0, r2
2002a06a:	5c80      	ldrb	r0, [r0, r2]
2002a06c:	3101      	adds	r1, #1
2002a06e:	4303      	orrs	r3, r0
2002a070:	2a07      	cmp	r2, #7
2002a072:	bf98      	it	ls
2002a074:	f043 0301 	orrls.w	r3, r3, #1
2002a078:	bb9b      	cbnz	r3, 2002a0e2 <mbedtls_rsa_rsaes_pkcs1_v15_decrypt+0x10e>
2002a07a:	1b8b      	subs	r3, r1, r6
2002a07c:	1aea      	subs	r2, r5, r3
2002a07e:	f8dd 342c 	ldr.w	r3, [sp, #1068]	@ 0x42c
2002a082:	429a      	cmp	r2, r3
2002a084:	d82f      	bhi.n	2002a0e6 <mbedtls_rsa_rsaes_pkcs1_v15_decrypt+0x112>
2002a086:	f8dd 3420 	ldr.w	r3, [sp, #1056]	@ 0x420
2002a08a:	f8dd 0428 	ldr.w	r0, [sp, #1064]	@ 0x428
2002a08e:	601a      	str	r2, [r3, #0]
2002a090:	f000 fcfa 	bl	2002aa88 <memcpy>
2002a094:	2300      	movs	r3, #0
2002a096:	461a      	mov	r2, r3
2002a098:	54f2      	strb	r2, [r6, r3]
2002a09a:	3301      	adds	r3, #1
2002a09c:	f5b3 6f80 	cmp.w	r3, #1024	@ 0x400
2002a0a0:	d1fa      	bne.n	2002a098 <mbedtls_rsa_rsaes_pkcs1_v15_decrypt+0xc4>
2002a0a2:	4620      	mov	r0, r4
2002a0a4:	f50d 6d81 	add.w	sp, sp, #1032	@ 0x408
2002a0a8:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}
2002a0ac:	9600      	str	r6, [sp, #0]
2002a0ae:	f7ff fd81 	bl	20029bb4 <mbedtls_rsa_private>
2002a0b2:	e7ab      	b.n	2002a00c <mbedtls_rsa_rsaes_pkcs1_v15_decrypt+0x38>
2002a0b4:	f082 0201 	eor.w	r2, r2, #1
2002a0b8:	ea41 0302 	orr.w	r3, r1, r2
2002a0bc:	4684      	mov	ip, r0
2002a0be:	4602      	mov	r2, r0
2002a0c0:	f10d 0109 	add.w	r1, sp, #9
2002a0c4:	f811 ef01 	ldrb.w	lr, [r1, #1]!
2002a0c8:	3001      	adds	r0, #1
2002a0ca:	f1be 0fff 	cmp.w	lr, #255	@ 0xff
2002a0ce:	bf18      	it	ne
2002a0d0:	f04c 0c01 	orrne.w	ip, ip, #1
2002a0d4:	42b8      	cmp	r0, r7
2002a0d6:	f08c 0e01 	eor.w	lr, ip, #1
2002a0da:	fa52 f28e 	uxtab	r2, r2, lr
2002a0de:	d3f1      	bcc.n	2002a0c4 <mbedtls_rsa_rsaes_pkcs1_v15_decrypt+0xf0>
2002a0e0:	e7c0      	b.n	2002a064 <mbedtls_rsa_rsaes_pkcs1_v15_decrypt+0x90>
2002a0e2:	4c03      	ldr	r4, [pc, #12]	@ (2002a0f0 <mbedtls_rsa_rsaes_pkcs1_v15_decrypt+0x11c>)
2002a0e4:	e7d6      	b.n	2002a094 <mbedtls_rsa_rsaes_pkcs1_v15_decrypt+0xc0>
2002a0e6:	4c03      	ldr	r4, [pc, #12]	@ (2002a0f4 <mbedtls_rsa_rsaes_pkcs1_v15_decrypt+0x120>)
2002a0e8:	e7d4      	b.n	2002a094 <mbedtls_rsa_rsaes_pkcs1_v15_decrypt+0xc0>
2002a0ea:	4c03      	ldr	r4, [pc, #12]	@ (2002a0f8 <mbedtls_rsa_rsaes_pkcs1_v15_decrypt+0x124>)
2002a0ec:	e7d9      	b.n	2002a0a2 <mbedtls_rsa_rsaes_pkcs1_v15_decrypt+0xce>
2002a0ee:	bf00      	nop
2002a0f0:	ffffbf00 	.word	0xffffbf00
2002a0f4:	ffffbc00 	.word	0xffffbc00
2002a0f8:	ffffbf80 	.word	0xffffbf80

2002a0fc <mbedtls_rsa_pkcs1_decrypt>:
2002a0fc:	b410      	push	{r4}
2002a0fe:	f8d0 40a4 	ldr.w	r4, [r0, #164]	@ 0xa4
2002a102:	b91c      	cbnz	r4, 2002a10c <mbedtls_rsa_pkcs1_decrypt+0x10>
2002a104:	f85d 4b04 	ldr.w	r4, [sp], #4
2002a108:	f7ff bf64 	b.w	20029fd4 <mbedtls_rsa_rsaes_pkcs1_v15_decrypt>
2002a10c:	4801      	ldr	r0, [pc, #4]	@ (2002a114 <mbedtls_rsa_pkcs1_decrypt+0x18>)
2002a10e:	f85d 4b04 	ldr.w	r4, [sp], #4
2002a112:	4770      	bx	lr
2002a114:	ffffbf00 	.word	0xffffbf00

2002a118 <mbedtls_rsa_rsassa_pkcs1_v15_sign>:
2002a118:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
2002a11c:	4692      	mov	sl, r2
2002a11e:	2200      	movs	r2, #0
2002a120:	b089      	sub	sp, #36	@ 0x24
2002a122:	2b01      	cmp	r3, #1
2002a124:	4604      	mov	r4, r0
2002a126:	461f      	mov	r7, r3
2002a128:	e9cd 2206 	strd	r2, r2, [sp, #24]
2002a12c:	f89d 8048 	ldrb.w	r8, [sp, #72]	@ 0x48
2002a130:	f8dd 904c 	ldr.w	r9, [sp, #76]	@ 0x4c
2002a134:	9e15      	ldr	r6, [sp, #84]	@ 0x54
2002a136:	9102      	str	r1, [sp, #8]
2002a138:	d107      	bne.n	2002a14a <mbedtls_rsa_rsassa_pkcs1_v15_sign+0x32>
2002a13a:	f8d0 20a4 	ldr.w	r2, [r0, #164]	@ 0xa4
2002a13e:	b122      	cbz	r2, 2002a14a <mbedtls_rsa_rsassa_pkcs1_v15_sign+0x32>
2002a140:	4d59      	ldr	r5, [pc, #356]	@ (2002a2a8 <mbedtls_rsa_rsassa_pkcs1_v15_sign+0x190>)
2002a142:	4628      	mov	r0, r5
2002a144:	b009      	add	sp, #36	@ 0x24
2002a146:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
2002a14a:	f8d4 b004 	ldr.w	fp, [r4, #4]
2002a14e:	f1ab 0503 	sub.w	r5, fp, #3
2002a152:	f1b8 0f00 	cmp.w	r8, #0
2002a156:	d014      	beq.n	2002a182 <mbedtls_rsa_rsassa_pkcs1_v15_sign+0x6a>
2002a158:	4640      	mov	r0, r8
2002a15a:	f7fb ff75 	bl	20026048 <mbedtls_md_info_from_type>
2002a15e:	4681      	mov	r9, r0
2002a160:	2800      	cmp	r0, #0
2002a162:	d0ed      	beq.n	2002a140 <mbedtls_rsa_rsassa_pkcs1_v15_sign+0x28>
2002a164:	4640      	mov	r0, r8
2002a166:	aa06      	add	r2, sp, #24
2002a168:	a907      	add	r1, sp, #28
2002a16a:	f7ff f9d3 	bl	20029514 <mbedtls_oid_get_oid_by_md>
2002a16e:	2800      	cmp	r0, #0
2002a170:	d1e6      	bne.n	2002a140 <mbedtls_rsa_rsassa_pkcs1_v15_sign+0x28>
2002a172:	9a06      	ldr	r2, [sp, #24]
2002a174:	4648      	mov	r0, r9
2002a176:	1aaa      	subs	r2, r5, r2
2002a178:	f1a2 050a 	sub.w	r5, r2, #10
2002a17c:	f7fb ff70 	bl	20026060 <mbedtls_md_get_size>
2002a180:	4681      	mov	r9, r0
2002a182:	eba5 0209 	sub.w	r2, r5, r9
2002a186:	2a07      	cmp	r2, #7
2002a188:	d9da      	bls.n	2002a140 <mbedtls_rsa_rsassa_pkcs1_v15_sign+0x28>
2002a18a:	4593      	cmp	fp, r2
2002a18c:	d3d8      	bcc.n	2002a140 <mbedtls_rsa_rsassa_pkcs1_v15_sign+0x28>
2002a18e:	46b3      	mov	fp, r6
2002a190:	2500      	movs	r5, #0
2002a192:	2101      	movs	r1, #1
2002a194:	f80b 5b02 	strb.w	r5, [fp], #2
2002a198:	4658      	mov	r0, fp
2002a19a:	7071      	strb	r1, [r6, #1]
2002a19c:	21ff      	movs	r1, #255	@ 0xff
2002a19e:	9203      	str	r2, [sp, #12]
2002a1a0:	f000 fc58 	bl	2002aa54 <memset>
2002a1a4:	9a03      	ldr	r2, [sp, #12]
2002a1a6:	eb0b 0002 	add.w	r0, fp, r2
2002a1aa:	f80b 5002 	strb.w	r5, [fp, r2]
2002a1ae:	f1b8 0f00 	cmp.w	r8, #0
2002a1b2:	d10c      	bne.n	2002a1ce <mbedtls_rsa_rsassa_pkcs1_v15_sign+0xb6>
2002a1b4:	464a      	mov	r2, r9
2002a1b6:	9914      	ldr	r1, [sp, #80]	@ 0x50
2002a1b8:	3001      	adds	r0, #1
2002a1ba:	f000 fc65 	bl	2002aa88 <memcpy>
2002a1be:	bb8f      	cbnz	r7, 2002a224 <mbedtls_rsa_rsassa_pkcs1_v15_sign+0x10c>
2002a1c0:	4632      	mov	r2, r6
2002a1c2:	4631      	mov	r1, r6
2002a1c4:	4620      	mov	r0, r4
2002a1c6:	f7ff fcbf 	bl	20029b48 <mbedtls_rsa_public>
2002a1ca:	4605      	mov	r5, r0
2002a1cc:	e7b9      	b.n	2002a142 <mbedtls_rsa_rsassa_pkcs1_v15_sign+0x2a>
2002a1ce:	2130      	movs	r1, #48	@ 0x30
2002a1d0:	7041      	strb	r1, [r0, #1]
2002a1d2:	9a06      	ldr	r2, [sp, #24]
2002a1d4:	70c1      	strb	r1, [r0, #3]
2002a1d6:	3208      	adds	r2, #8
2002a1d8:	fa52 f289 	uxtab	r2, r2, r9
2002a1dc:	7082      	strb	r2, [r0, #2]
2002a1de:	9a06      	ldr	r2, [sp, #24]
2002a1e0:	f100 0807 	add.w	r8, r0, #7
2002a1e4:	b2d1      	uxtb	r1, r2
2002a1e6:	f101 0c04 	add.w	ip, r1, #4
2002a1ea:	f880 c004 	strb.w	ip, [r0, #4]
2002a1ee:	f04f 0c06 	mov.w	ip, #6
2002a1f2:	7181      	strb	r1, [r0, #6]
2002a1f4:	f880 c005 	strb.w	ip, [r0, #5]
2002a1f8:	9907      	ldr	r1, [sp, #28]
2002a1fa:	4640      	mov	r0, r8
2002a1fc:	9203      	str	r2, [sp, #12]
2002a1fe:	f000 fc43 	bl	2002aa88 <memcpy>
2002a202:	2105      	movs	r1, #5
2002a204:	9a03      	ldr	r2, [sp, #12]
2002a206:	fa5f fb89 	uxtb.w	fp, r9
2002a20a:	eb08 0002 	add.w	r0, r8, r2
2002a20e:	f808 1002 	strb.w	r1, [r8, r2]
2002a212:	2204      	movs	r2, #4
2002a214:	7045      	strb	r5, [r0, #1]
2002a216:	7082      	strb	r2, [r0, #2]
2002a218:	f880 b003 	strb.w	fp, [r0, #3]
2002a21c:	464a      	mov	r2, r9
2002a21e:	9914      	ldr	r1, [sp, #80]	@ 0x50
2002a220:	3004      	adds	r0, #4
2002a222:	e7ca      	b.n	2002a1ba <mbedtls_rsa_rsassa_pkcs1_v15_sign+0xa2>
2002a224:	6865      	ldr	r5, [r4, #4]
2002a226:	2001      	movs	r0, #1
2002a228:	4629      	mov	r1, r5
2002a22a:	f000 fb31 	bl	2002a890 <calloc>
2002a22e:	4607      	mov	r7, r0
2002a230:	b140      	cbz	r0, 2002a244 <mbedtls_rsa_rsassa_pkcs1_v15_sign+0x12c>
2002a232:	4629      	mov	r1, r5
2002a234:	2001      	movs	r0, #1
2002a236:	f000 fb2b 	bl	2002a890 <calloc>
2002a23a:	4680      	mov	r8, r0
2002a23c:	b928      	cbnz	r0, 2002a24a <mbedtls_rsa_rsassa_pkcs1_v15_sign+0x132>
2002a23e:	4638      	mov	r0, r7
2002a240:	f000 fb42 	bl	2002a8c8 <free>
2002a244:	f06f 050f 	mvn.w	r5, #15
2002a248:	e77b      	b.n	2002a142 <mbedtls_rsa_rsassa_pkcs1_v15_sign+0x2a>
2002a24a:	4633      	mov	r3, r6
2002a24c:	4652      	mov	r2, sl
2002a24e:	4620      	mov	r0, r4
2002a250:	9902      	ldr	r1, [sp, #8]
2002a252:	9700      	str	r7, [sp, #0]
2002a254:	f7ff fcae 	bl	20029bb4 <mbedtls_rsa_private>
2002a258:	4605      	mov	r5, r0
2002a25a:	b9a0      	cbnz	r0, 2002a286 <mbedtls_rsa_rsassa_pkcs1_v15_sign+0x16e>
2002a25c:	4642      	mov	r2, r8
2002a25e:	4639      	mov	r1, r7
2002a260:	4620      	mov	r0, r4
2002a262:	f7ff fc71 	bl	20029b48 <mbedtls_rsa_public>
2002a266:	4605      	mov	r5, r0
2002a268:	b968      	cbnz	r0, 2002a286 <mbedtls_rsa_rsassa_pkcs1_v15_sign+0x16e>
2002a26a:	4601      	mov	r1, r0
2002a26c:	4603      	mov	r3, r0
2002a26e:	6862      	ldr	r2, [r4, #4]
2002a270:	429a      	cmp	r2, r3
2002a272:	d10f      	bne.n	2002a294 <mbedtls_rsa_rsassa_pkcs1_v15_sign+0x17c>
2002a274:	f88d 1017 	strb.w	r1, [sp, #23]
2002a278:	f89d 3017 	ldrb.w	r3, [sp, #23]
2002a27c:	b98b      	cbnz	r3, 2002a2a2 <mbedtls_rsa_rsassa_pkcs1_v15_sign+0x18a>
2002a27e:	4639      	mov	r1, r7
2002a280:	4630      	mov	r0, r6
2002a282:	f000 fc01 	bl	2002aa88 <memcpy>
2002a286:	4638      	mov	r0, r7
2002a288:	f000 fb1e 	bl	2002a8c8 <free>
2002a28c:	4640      	mov	r0, r8
2002a28e:	f000 fb1b 	bl	2002a8c8 <free>
2002a292:	e756      	b.n	2002a142 <mbedtls_rsa_rsassa_pkcs1_v15_sign+0x2a>
2002a294:	f818 0003 	ldrb.w	r0, [r8, r3]
2002a298:	5cf4      	ldrb	r4, [r6, r3]
2002a29a:	3301      	adds	r3, #1
2002a29c:	4060      	eors	r0, r4
2002a29e:	4301      	orrs	r1, r0
2002a2a0:	e7e6      	b.n	2002a270 <mbedtls_rsa_rsassa_pkcs1_v15_sign+0x158>
2002a2a2:	4d02      	ldr	r5, [pc, #8]	@ (2002a2ac <mbedtls_rsa_rsassa_pkcs1_v15_sign+0x194>)
2002a2a4:	e7ef      	b.n	2002a286 <mbedtls_rsa_rsassa_pkcs1_v15_sign+0x16e>
2002a2a6:	bf00      	nop
2002a2a8:	ffffbf80 	.word	0xffffbf80
2002a2ac:	ffffbd00 	.word	0xffffbd00

2002a2b0 <mbedtls_rsa_pkcs1_sign>:
2002a2b0:	b430      	push	{r4, r5}
2002a2b2:	f8d0 50a4 	ldr.w	r5, [r0, #164]	@ 0xa4
2002a2b6:	f89d 4008 	ldrb.w	r4, [sp, #8]
2002a2ba:	b91d      	cbnz	r5, 2002a2c4 <mbedtls_rsa_pkcs1_sign+0x14>
2002a2bc:	9402      	str	r4, [sp, #8]
2002a2be:	bc30      	pop	{r4, r5}
2002a2c0:	f7ff bf2a 	b.w	2002a118 <mbedtls_rsa_rsassa_pkcs1_v15_sign>
2002a2c4:	4801      	ldr	r0, [pc, #4]	@ (2002a2cc <mbedtls_rsa_pkcs1_sign+0x1c>)
2002a2c6:	bc30      	pop	{r4, r5}
2002a2c8:	4770      	bx	lr
2002a2ca:	bf00      	nop
2002a2cc:	ffffbf00 	.word	0xffffbf00

2002a2d0 <mbedtls_rsa_rsassa_pkcs1_v15_verify>:
2002a2d0:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
2002a2d4:	461c      	mov	r4, r3
2002a2d6:	f2ad 4d2c 	subw	sp, sp, #1068	@ 0x42c
2002a2da:	f89d 3450 	ldrb.w	r3, [sp, #1104]	@ 0x450
2002a2de:	2c01      	cmp	r4, #1
2002a2e0:	9303      	str	r3, [sp, #12]
2002a2e2:	f8dd 8454 	ldr.w	r8, [sp, #1108]	@ 0x454
2002a2e6:	f8dd 345c 	ldr.w	r3, [sp, #1116]	@ 0x45c
2002a2ea:	d108      	bne.n	2002a2fe <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x2e>
2002a2ec:	f8d0 50a4 	ldr.w	r5, [r0, #164]	@ 0xa4
2002a2f0:	b12d      	cbz	r5, 2002a2fe <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x2e>
2002a2f2:	4d60      	ldr	r5, [pc, #384]	@ (2002a474 <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x1a4>)
2002a2f4:	4628      	mov	r0, r5
2002a2f6:	f20d 4d2c 	addw	sp, sp, #1068	@ 0x42c
2002a2fa:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
2002a2fe:	6846      	ldr	r6, [r0, #4]
2002a300:	f1a6 0510 	sub.w	r5, r6, #16
2002a304:	f5b5 7f7c 	cmp.w	r5, #1008	@ 0x3f0
2002a308:	d8f3      	bhi.n	2002a2f2 <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x22>
2002a30a:	af0a      	add	r7, sp, #40	@ 0x28
2002a30c:	b954      	cbnz	r4, 2002a324 <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x54>
2002a30e:	463a      	mov	r2, r7
2002a310:	4619      	mov	r1, r3
2002a312:	f7ff fc19 	bl	20029b48 <mbedtls_rsa_public>
2002a316:	4605      	mov	r5, r0
2002a318:	2800      	cmp	r0, #0
2002a31a:	d1eb      	bne.n	2002a2f4 <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x24>
2002a31c:	783b      	ldrb	r3, [r7, #0]
2002a31e:	b12b      	cbz	r3, 2002a32c <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x5c>
2002a320:	4d55      	ldr	r5, [pc, #340]	@ (2002a478 <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x1a8>)
2002a322:	e7e7      	b.n	2002a2f4 <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x24>
2002a324:	9700      	str	r7, [sp, #0]
2002a326:	f7ff fc45 	bl	20029bb4 <mbedtls_rsa_private>
2002a32a:	e7f4      	b.n	2002a316 <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x46>
2002a32c:	787b      	ldrb	r3, [r7, #1]
2002a32e:	ac06      	add	r4, sp, #24
2002a330:	f10d 002a 	add.w	r0, sp, #42	@ 0x2a
2002a334:	2b01      	cmp	r3, #1
2002a336:	6020      	str	r0, [r4, #0]
2002a338:	d1f2      	bne.n	2002a320 <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x50>
2002a33a:	1e73      	subs	r3, r6, #1
2002a33c:	443b      	add	r3, r7
2002a33e:	7802      	ldrb	r2, [r0, #0]
2002a340:	b992      	cbnz	r2, 2002a368 <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x98>
2002a342:	3001      	adds	r0, #1
2002a344:	1bc7      	subs	r7, r0, r7
2002a346:	2f0a      	cmp	r7, #10
2002a348:	6020      	str	r0, [r4, #0]
2002a34a:	dde9      	ble.n	2002a320 <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x50>
2002a34c:	1bf6      	subs	r6, r6, r7
2002a34e:	4546      	cmp	r6, r8
2002a350:	d112      	bne.n	2002a378 <mbedtls_rsa_rsassa_pkcs1_v15_verify+0xa8>
2002a352:	9b03      	ldr	r3, [sp, #12]
2002a354:	b983      	cbnz	r3, 2002a378 <mbedtls_rsa_rsassa_pkcs1_v15_verify+0xa8>
2002a356:	4642      	mov	r2, r8
2002a358:	f8dd 1458 	ldr.w	r1, [sp, #1112]	@ 0x458
2002a35c:	f000 fb6a 	bl	2002aa34 <memcmp>
2002a360:	2800      	cmp	r0, #0
2002a362:	d0c7      	beq.n	2002a2f4 <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x24>
2002a364:	4d45      	ldr	r5, [pc, #276]	@ (2002a47c <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x1ac>)
2002a366:	e7c5      	b.n	2002a2f4 <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x24>
2002a368:	4298      	cmp	r0, r3
2002a36a:	d2d9      	bcs.n	2002a320 <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x50>
2002a36c:	2aff      	cmp	r2, #255	@ 0xff
2002a36e:	f100 0001 	add.w	r0, r0, #1
2002a372:	d1d5      	bne.n	2002a320 <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x50>
2002a374:	6020      	str	r0, [r4, #0]
2002a376:	e7e2      	b.n	2002a33e <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x6e>
2002a378:	9803      	ldr	r0, [sp, #12]
2002a37a:	f7fb fe65 	bl	20026048 <mbedtls_md_info_from_type>
2002a37e:	2800      	cmp	r0, #0
2002a380:	d0b7      	beq.n	2002a2f2 <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x22>
2002a382:	f7fb fe6d 	bl	20026060 <mbedtls_md_get_size>
2002a386:	f8d4 a000 	ldr.w	sl, [r4]
2002a38a:	af05      	add	r7, sp, #20
2002a38c:	eb0a 0806 	add.w	r8, sl, r6
2002a390:	4681      	mov	r9, r0
2002a392:	2330      	movs	r3, #48	@ 0x30
2002a394:	463a      	mov	r2, r7
2002a396:	4641      	mov	r1, r8
2002a398:	4620      	mov	r0, r4
2002a39a:	f7fd fb95 	bl	20027ac8 <mbedtls_asn1_get_tag>
2002a39e:	2800      	cmp	r0, #0
2002a3a0:	d1e0      	bne.n	2002a364 <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x94>
2002a3a2:	f8d4 b000 	ldr.w	fp, [r4]
2002a3a6:	f10a 0a02 	add.w	sl, sl, #2
2002a3aa:	45d3      	cmp	fp, sl
2002a3ac:	d1da      	bne.n	2002a364 <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x94>
2002a3ae:	683b      	ldr	r3, [r7, #0]
2002a3b0:	3302      	adds	r3, #2
2002a3b2:	42b3      	cmp	r3, r6
2002a3b4:	d1d6      	bne.n	2002a364 <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x94>
2002a3b6:	2330      	movs	r3, #48	@ 0x30
2002a3b8:	463a      	mov	r2, r7
2002a3ba:	4641      	mov	r1, r8
2002a3bc:	4620      	mov	r0, r4
2002a3be:	f7fd fb83 	bl	20027ac8 <mbedtls_asn1_get_tag>
2002a3c2:	2800      	cmp	r0, #0
2002a3c4:	d1ce      	bne.n	2002a364 <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x94>
2002a3c6:	f8d4 a000 	ldr.w	sl, [r4]
2002a3ca:	f10b 0b02 	add.w	fp, fp, #2
2002a3ce:	45da      	cmp	sl, fp
2002a3d0:	d1c8      	bne.n	2002a364 <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x94>
2002a3d2:	683b      	ldr	r3, [r7, #0]
2002a3d4:	3306      	adds	r3, #6
2002a3d6:	444b      	add	r3, r9
2002a3d8:	42b3      	cmp	r3, r6
2002a3da:	d1c3      	bne.n	2002a364 <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x94>
2002a3dc:	2306      	movs	r3, #6
2002a3de:	4641      	mov	r1, r8
2002a3e0:	4620      	mov	r0, r4
2002a3e2:	aa08      	add	r2, sp, #32
2002a3e4:	ae07      	add	r6, sp, #28
2002a3e6:	f7fd fb6f 	bl	20027ac8 <mbedtls_asn1_get_tag>
2002a3ea:	2800      	cmp	r0, #0
2002a3ec:	d1ba      	bne.n	2002a364 <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x94>
2002a3ee:	6823      	ldr	r3, [r4, #0]
2002a3f0:	f10a 0a02 	add.w	sl, sl, #2
2002a3f4:	4553      	cmp	r3, sl
2002a3f6:	d1b5      	bne.n	2002a364 <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x94>
2002a3f8:	9a08      	ldr	r2, [sp, #32]
2002a3fa:	f10d 0a13 	add.w	sl, sp, #19
2002a3fe:	9309      	str	r3, [sp, #36]	@ 0x24
2002a400:	4651      	mov	r1, sl
2002a402:	4413      	add	r3, r2
2002a404:	4630      	mov	r0, r6
2002a406:	6023      	str	r3, [r4, #0]
2002a408:	f7ff f86a 	bl	200294e0 <mbedtls_oid_get_md_alg>
2002a40c:	2800      	cmp	r0, #0
2002a40e:	d1a9      	bne.n	2002a364 <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x94>
2002a410:	f89d 3013 	ldrb.w	r3, [sp, #19]
2002a414:	9a03      	ldr	r2, [sp, #12]
2002a416:	4293      	cmp	r3, r2
2002a418:	d1a4      	bne.n	2002a364 <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x94>
2002a41a:	2305      	movs	r3, #5
2002a41c:	463a      	mov	r2, r7
2002a41e:	4641      	mov	r1, r8
2002a420:	4620      	mov	r0, r4
2002a422:	f8d4 a000 	ldr.w	sl, [r4]
2002a426:	f7fd fb4f 	bl	20027ac8 <mbedtls_asn1_get_tag>
2002a42a:	2800      	cmp	r0, #0
2002a42c:	d19a      	bne.n	2002a364 <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x94>
2002a42e:	6826      	ldr	r6, [r4, #0]
2002a430:	f10a 0a02 	add.w	sl, sl, #2
2002a434:	4556      	cmp	r6, sl
2002a436:	d195      	bne.n	2002a364 <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x94>
2002a438:	2304      	movs	r3, #4
2002a43a:	463a      	mov	r2, r7
2002a43c:	4641      	mov	r1, r8
2002a43e:	4620      	mov	r0, r4
2002a440:	f7fd fb42 	bl	20027ac8 <mbedtls_asn1_get_tag>
2002a444:	2800      	cmp	r0, #0
2002a446:	d18d      	bne.n	2002a364 <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x94>
2002a448:	6824      	ldr	r4, [r4, #0]
2002a44a:	3602      	adds	r6, #2
2002a44c:	42b4      	cmp	r4, r6
2002a44e:	d189      	bne.n	2002a364 <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x94>
2002a450:	683b      	ldr	r3, [r7, #0]
2002a452:	454b      	cmp	r3, r9
2002a454:	d186      	bne.n	2002a364 <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x94>
2002a456:	464a      	mov	r2, r9
2002a458:	4620      	mov	r0, r4
2002a45a:	f8dd 1458 	ldr.w	r1, [sp, #1112]	@ 0x458
2002a45e:	f000 fae9 	bl	2002aa34 <memcmp>
2002a462:	2800      	cmp	r0, #0
2002a464:	f47f af7e 	bne.w	2002a364 <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x94>
2002a468:	444c      	add	r4, r9
2002a46a:	45a0      	cmp	r8, r4
2002a46c:	f43f af42 	beq.w	2002a2f4 <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x24>
2002a470:	e778      	b.n	2002a364 <mbedtls_rsa_rsassa_pkcs1_v15_verify+0x94>
2002a472:	bf00      	nop
2002a474:	ffffbf80 	.word	0xffffbf80
2002a478:	ffffbf00 	.word	0xffffbf00
2002a47c:	ffffbc80 	.word	0xffffbc80

2002a480 <mbedtls_rsa_pkcs1_verify>:
2002a480:	b430      	push	{r4, r5}
2002a482:	f8d0 50a4 	ldr.w	r5, [r0, #164]	@ 0xa4
2002a486:	f89d 4008 	ldrb.w	r4, [sp, #8]
2002a48a:	b91d      	cbnz	r5, 2002a494 <mbedtls_rsa_pkcs1_verify+0x14>
2002a48c:	9402      	str	r4, [sp, #8]
2002a48e:	bc30      	pop	{r4, r5}
2002a490:	f7ff bf1e 	b.w	2002a2d0 <mbedtls_rsa_rsassa_pkcs1_v15_verify>
2002a494:	4801      	ldr	r0, [pc, #4]	@ (2002a49c <mbedtls_rsa_pkcs1_verify+0x1c>)
2002a496:	bc30      	pop	{r4, r5}
2002a498:	4770      	bx	lr
2002a49a:	bf00      	nop
2002a49c:	ffffbf00 	.word	0xffffbf00

2002a4a0 <mbedtls_rsa_free>:
2002a4a0:	b510      	push	{r4, lr}
2002a4a2:	4604      	mov	r4, r0
2002a4a4:	308c      	adds	r0, #140	@ 0x8c
2002a4a6:	f7fd fd44 	bl	20027f32 <mbedtls_mpi_free>
2002a4aa:	f104 0098 	add.w	r0, r4, #152	@ 0x98
2002a4ae:	f7fd fd40 	bl	20027f32 <mbedtls_mpi_free>
2002a4b2:	f104 0080 	add.w	r0, r4, #128	@ 0x80
2002a4b6:	f7fd fd3c 	bl	20027f32 <mbedtls_mpi_free>
2002a4ba:	f104 0074 	add.w	r0, r4, #116	@ 0x74
2002a4be:	f7fd fd38 	bl	20027f32 <mbedtls_mpi_free>
2002a4c2:	f104 0068 	add.w	r0, r4, #104	@ 0x68
2002a4c6:	f7fd fd34 	bl	20027f32 <mbedtls_mpi_free>
2002a4ca:	f104 005c 	add.w	r0, r4, #92	@ 0x5c
2002a4ce:	f7fd fd30 	bl	20027f32 <mbedtls_mpi_free>
2002a4d2:	f104 0050 	add.w	r0, r4, #80	@ 0x50
2002a4d6:	f7fd fd2c 	bl	20027f32 <mbedtls_mpi_free>
2002a4da:	f104 0044 	add.w	r0, r4, #68	@ 0x44
2002a4de:	f7fd fd28 	bl	20027f32 <mbedtls_mpi_free>
2002a4e2:	f104 0038 	add.w	r0, r4, #56	@ 0x38
2002a4e6:	f7fd fd24 	bl	20027f32 <mbedtls_mpi_free>
2002a4ea:	f104 002c 	add.w	r0, r4, #44	@ 0x2c
2002a4ee:	f7fd fd20 	bl	20027f32 <mbedtls_mpi_free>
2002a4f2:	f104 0020 	add.w	r0, r4, #32
2002a4f6:	f7fd fd1c 	bl	20027f32 <mbedtls_mpi_free>
2002a4fa:	f104 0014 	add.w	r0, r4, #20
2002a4fe:	f7fd fd18 	bl	20027f32 <mbedtls_mpi_free>
2002a502:	f104 0008 	add.w	r0, r4, #8
2002a506:	e8bd 4010 	ldmia.w	sp!, {r4, lr}
2002a50a:	f7fd bd12 	b.w	20027f32 <mbedtls_mpi_free>
	...

2002a510 <__aeabi_uldivmod>:
2002a510:	b953      	cbnz	r3, 2002a528 <__aeabi_uldivmod+0x18>
2002a512:	b94a      	cbnz	r2, 2002a528 <__aeabi_uldivmod+0x18>
2002a514:	2900      	cmp	r1, #0
2002a516:	bf08      	it	eq
2002a518:	2800      	cmpeq	r0, #0
2002a51a:	bf1c      	itt	ne
2002a51c:	f04f 31ff 	movne.w	r1, #4294967295
2002a520:	f04f 30ff 	movne.w	r0, #4294967295
2002a524:	f000 b9b2 	b.w	2002a88c <__aeabi_idiv0>
2002a528:	f1ad 0c08 	sub.w	ip, sp, #8
2002a52c:	e96d ce04 	strd	ip, lr, [sp, #-16]!
2002a530:	f000 f806 	bl	2002a540 <__udivmoddi4>
2002a534:	f8dd e004 	ldr.w	lr, [sp, #4]
2002a538:	e9dd 2302 	ldrd	r2, r3, [sp, #8]
2002a53c:	b004      	add	sp, #16
2002a53e:	4770      	bx	lr

2002a540 <__udivmoddi4>:
2002a540:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
2002a544:	468c      	mov	ip, r1
2002a546:	9e09      	ldr	r6, [sp, #36]	@ 0x24
2002a548:	4604      	mov	r4, r0
2002a54a:	460f      	mov	r7, r1
2002a54c:	2b00      	cmp	r3, #0
2002a54e:	d148      	bne.n	2002a5e2 <__udivmoddi4+0xa2>
2002a550:	428a      	cmp	r2, r1
2002a552:	4615      	mov	r5, r2
2002a554:	d95e      	bls.n	2002a614 <__udivmoddi4+0xd4>
2002a556:	fab2 f382 	clz	r3, r2
2002a55a:	b13b      	cbz	r3, 2002a56c <__udivmoddi4+0x2c>
2002a55c:	f1c3 0220 	rsb	r2, r3, #32
2002a560:	409f      	lsls	r7, r3
2002a562:	409d      	lsls	r5, r3
2002a564:	409c      	lsls	r4, r3
2002a566:	fa20 f202 	lsr.w	r2, r0, r2
2002a56a:	4317      	orrs	r7, r2
2002a56c:	ea4f 4e15 	mov.w	lr, r5, lsr #16
2002a570:	fa1f fc85 	uxth.w	ip, r5
2002a574:	0c22      	lsrs	r2, r4, #16
2002a576:	fbb7 f1fe 	udiv	r1, r7, lr
2002a57a:	fb0e 7711 	mls	r7, lr, r1, r7
2002a57e:	fb01 f00c 	mul.w	r0, r1, ip
2002a582:	ea42 4207 	orr.w	r2, r2, r7, lsl #16
2002a586:	4290      	cmp	r0, r2
2002a588:	d907      	bls.n	2002a59a <__udivmoddi4+0x5a>
2002a58a:	18aa      	adds	r2, r5, r2
2002a58c:	f101 37ff 	add.w	r7, r1, #4294967295
2002a590:	d202      	bcs.n	2002a598 <__udivmoddi4+0x58>
2002a592:	4290      	cmp	r0, r2
2002a594:	f200 8158 	bhi.w	2002a848 <__udivmoddi4+0x308>
2002a598:	4639      	mov	r1, r7
2002a59a:	1a12      	subs	r2, r2, r0
2002a59c:	b2a4      	uxth	r4, r4
2002a59e:	fbb2 f0fe 	udiv	r0, r2, lr
2002a5a2:	fb0e 2210 	mls	r2, lr, r0, r2
2002a5a6:	fb00 fc0c 	mul.w	ip, r0, ip
2002a5aa:	ea44 4402 	orr.w	r4, r4, r2, lsl #16
2002a5ae:	45a4      	cmp	ip, r4
2002a5b0:	d90b      	bls.n	2002a5ca <__udivmoddi4+0x8a>
2002a5b2:	192c      	adds	r4, r5, r4
2002a5b4:	f100 32ff 	add.w	r2, r0, #4294967295
2002a5b8:	bf2c      	ite	cs
2002a5ba:	2701      	movcs	r7, #1
2002a5bc:	2700      	movcc	r7, #0
2002a5be:	45a4      	cmp	ip, r4
2002a5c0:	d902      	bls.n	2002a5c8 <__udivmoddi4+0x88>
2002a5c2:	2f00      	cmp	r7, #0
2002a5c4:	f000 8143 	beq.w	2002a84e <__udivmoddi4+0x30e>
2002a5c8:	4610      	mov	r0, r2
2002a5ca:	ea40 4001 	orr.w	r0, r0, r1, lsl #16
2002a5ce:	eba4 040c 	sub.w	r4, r4, ip
2002a5d2:	2100      	movs	r1, #0
2002a5d4:	b11e      	cbz	r6, 2002a5de <__udivmoddi4+0x9e>
2002a5d6:	40dc      	lsrs	r4, r3
2002a5d8:	2300      	movs	r3, #0
2002a5da:	e9c6 4300 	strd	r4, r3, [r6]
2002a5de:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
2002a5e2:	428b      	cmp	r3, r1
2002a5e4:	d906      	bls.n	2002a5f4 <__udivmoddi4+0xb4>
2002a5e6:	b10e      	cbz	r6, 2002a5ec <__udivmoddi4+0xac>
2002a5e8:	e9c6 0100 	strd	r0, r1, [r6]
2002a5ec:	2100      	movs	r1, #0
2002a5ee:	4608      	mov	r0, r1
2002a5f0:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
2002a5f4:	fab3 f183 	clz	r1, r3
2002a5f8:	2900      	cmp	r1, #0
2002a5fa:	d151      	bne.n	2002a6a0 <__udivmoddi4+0x160>
2002a5fc:	4563      	cmp	r3, ip
2002a5fe:	f0c0 8116 	bcc.w	2002a82e <__udivmoddi4+0x2ee>
2002a602:	4282      	cmp	r2, r0
2002a604:	f240 8113 	bls.w	2002a82e <__udivmoddi4+0x2ee>
2002a608:	4608      	mov	r0, r1
2002a60a:	2e00      	cmp	r6, #0
2002a60c:	d0e7      	beq.n	2002a5de <__udivmoddi4+0x9e>
2002a60e:	e9c6 4700 	strd	r4, r7, [r6]
2002a612:	e7e4      	b.n	2002a5de <__udivmoddi4+0x9e>
2002a614:	2a00      	cmp	r2, #0
2002a616:	f000 80af 	beq.w	2002a778 <__udivmoddi4+0x238>
2002a61a:	fab2 f382 	clz	r3, r2
2002a61e:	2b00      	cmp	r3, #0
2002a620:	f040 80c2 	bne.w	2002a7a8 <__udivmoddi4+0x268>
2002a624:	1a8a      	subs	r2, r1, r2
2002a626:	ea4f 4e15 	mov.w	lr, r5, lsr #16
2002a62a:	b2af      	uxth	r7, r5
2002a62c:	2101      	movs	r1, #1
2002a62e:	0c20      	lsrs	r0, r4, #16
2002a630:	fbb2 fcfe 	udiv	ip, r2, lr
2002a634:	fb0e 221c 	mls	r2, lr, ip, r2
2002a638:	ea40 4202 	orr.w	r2, r0, r2, lsl #16
2002a63c:	fb07 f00c 	mul.w	r0, r7, ip
2002a640:	4290      	cmp	r0, r2
2002a642:	d90e      	bls.n	2002a662 <__udivmoddi4+0x122>
2002a644:	18aa      	adds	r2, r5, r2
2002a646:	f10c 38ff 	add.w	r8, ip, #4294967295
2002a64a:	bf2c      	ite	cs
2002a64c:	f04f 0901 	movcs.w	r9, #1
2002a650:	f04f 0900 	movcc.w	r9, #0
2002a654:	4290      	cmp	r0, r2
2002a656:	d903      	bls.n	2002a660 <__udivmoddi4+0x120>
2002a658:	f1b9 0f00 	cmp.w	r9, #0
2002a65c:	f000 80f0 	beq.w	2002a840 <__udivmoddi4+0x300>
2002a660:	46c4      	mov	ip, r8
2002a662:	1a12      	subs	r2, r2, r0
2002a664:	b2a4      	uxth	r4, r4
2002a666:	fbb2 f0fe 	udiv	r0, r2, lr
2002a66a:	fb0e 2210 	mls	r2, lr, r0, r2
2002a66e:	fb00 f707 	mul.w	r7, r0, r7
2002a672:	ea44 4402 	orr.w	r4, r4, r2, lsl #16
2002a676:	42a7      	cmp	r7, r4
2002a678:	d90e      	bls.n	2002a698 <__udivmoddi4+0x158>
2002a67a:	192c      	adds	r4, r5, r4
2002a67c:	f100 32ff 	add.w	r2, r0, #4294967295
2002a680:	bf2c      	ite	cs
2002a682:	f04f 0e01 	movcs.w	lr, #1
2002a686:	f04f 0e00 	movcc.w	lr, #0
2002a68a:	42a7      	cmp	r7, r4
2002a68c:	d903      	bls.n	2002a696 <__udivmoddi4+0x156>
2002a68e:	f1be 0f00 	cmp.w	lr, #0
2002a692:	f000 80d2 	beq.w	2002a83a <__udivmoddi4+0x2fa>
2002a696:	4610      	mov	r0, r2
2002a698:	1be4      	subs	r4, r4, r7
2002a69a:	ea40 400c 	orr.w	r0, r0, ip, lsl #16
2002a69e:	e799      	b.n	2002a5d4 <__udivmoddi4+0x94>
2002a6a0:	f1c1 0520 	rsb	r5, r1, #32
2002a6a4:	408b      	lsls	r3, r1
2002a6a6:	fa0c f401 	lsl.w	r4, ip, r1
2002a6aa:	fa00 f901 	lsl.w	r9, r0, r1
2002a6ae:	fa22 f705 	lsr.w	r7, r2, r5
2002a6b2:	fa2c fc05 	lsr.w	ip, ip, r5
2002a6b6:	408a      	lsls	r2, r1
2002a6b8:	431f      	orrs	r7, r3
2002a6ba:	fa20 f305 	lsr.w	r3, r0, r5
2002a6be:	0c38      	lsrs	r0, r7, #16
2002a6c0:	4323      	orrs	r3, r4
2002a6c2:	fa1f fe87 	uxth.w	lr, r7
2002a6c6:	0c1c      	lsrs	r4, r3, #16
2002a6c8:	fbbc f8f0 	udiv	r8, ip, r0
2002a6cc:	fb00 cc18 	mls	ip, r0, r8, ip
2002a6d0:	ea44 440c 	orr.w	r4, r4, ip, lsl #16
2002a6d4:	fb08 fc0e 	mul.w	ip, r8, lr
2002a6d8:	45a4      	cmp	ip, r4
2002a6da:	d90e      	bls.n	2002a6fa <__udivmoddi4+0x1ba>
2002a6dc:	193c      	adds	r4, r7, r4
2002a6de:	f108 3aff 	add.w	sl, r8, #4294967295
2002a6e2:	bf2c      	ite	cs
2002a6e4:	f04f 0b01 	movcs.w	fp, #1
2002a6e8:	f04f 0b00 	movcc.w	fp, #0
2002a6ec:	45a4      	cmp	ip, r4
2002a6ee:	d903      	bls.n	2002a6f8 <__udivmoddi4+0x1b8>
2002a6f0:	f1bb 0f00 	cmp.w	fp, #0
2002a6f4:	f000 80b8 	beq.w	2002a868 <__udivmoddi4+0x328>
2002a6f8:	46d0      	mov	r8, sl
2002a6fa:	eba4 040c 	sub.w	r4, r4, ip
2002a6fe:	fa1f fc83 	uxth.w	ip, r3
2002a702:	fbb4 f3f0 	udiv	r3, r4, r0
2002a706:	fb00 4413 	mls	r4, r0, r3, r4
2002a70a:	fb03 fe0e 	mul.w	lr, r3, lr
2002a70e:	ea4c 4404 	orr.w	r4, ip, r4, lsl #16
2002a712:	45a6      	cmp	lr, r4
2002a714:	d90e      	bls.n	2002a734 <__udivmoddi4+0x1f4>
2002a716:	193c      	adds	r4, r7, r4
2002a718:	f103 30ff 	add.w	r0, r3, #4294967295
2002a71c:	bf2c      	ite	cs
2002a71e:	f04f 0c01 	movcs.w	ip, #1
2002a722:	f04f 0c00 	movcc.w	ip, #0
2002a726:	45a6      	cmp	lr, r4
2002a728:	d903      	bls.n	2002a732 <__udivmoddi4+0x1f2>
2002a72a:	f1bc 0f00 	cmp.w	ip, #0
2002a72e:	f000 809f 	beq.w	2002a870 <__udivmoddi4+0x330>
2002a732:	4603      	mov	r3, r0
2002a734:	ea43 4008 	orr.w	r0, r3, r8, lsl #16
2002a738:	eba4 040e 	sub.w	r4, r4, lr
2002a73c:	fba0 ec02 	umull	lr, ip, r0, r2
2002a740:	4564      	cmp	r4, ip
2002a742:	4673      	mov	r3, lr
2002a744:	46e0      	mov	r8, ip
2002a746:	d302      	bcc.n	2002a74e <__udivmoddi4+0x20e>
2002a748:	d107      	bne.n	2002a75a <__udivmoddi4+0x21a>
2002a74a:	45f1      	cmp	r9, lr
2002a74c:	d205      	bcs.n	2002a75a <__udivmoddi4+0x21a>
2002a74e:	ebbe 0302 	subs.w	r3, lr, r2
2002a752:	eb6c 0c07 	sbc.w	ip, ip, r7
2002a756:	3801      	subs	r0, #1
2002a758:	46e0      	mov	r8, ip
2002a75a:	b15e      	cbz	r6, 2002a774 <__udivmoddi4+0x234>
2002a75c:	ebb9 0203 	subs.w	r2, r9, r3
2002a760:	eb64 0408 	sbc.w	r4, r4, r8
2002a764:	fa04 f505 	lsl.w	r5, r4, r5
2002a768:	fa22 f301 	lsr.w	r3, r2, r1
2002a76c:	40cc      	lsrs	r4, r1
2002a76e:	431d      	orrs	r5, r3
2002a770:	e9c6 5400 	strd	r5, r4, [r6]
2002a774:	2100      	movs	r1, #0
2002a776:	e732      	b.n	2002a5de <__udivmoddi4+0x9e>
2002a778:	0842      	lsrs	r2, r0, #1
2002a77a:	462f      	mov	r7, r5
2002a77c:	084b      	lsrs	r3, r1, #1
2002a77e:	46ac      	mov	ip, r5
2002a780:	ea42 72c1 	orr.w	r2, r2, r1, lsl #31
2002a784:	46ae      	mov	lr, r5
2002a786:	07c4      	lsls	r4, r0, #31
2002a788:	0c11      	lsrs	r1, r2, #16
2002a78a:	b292      	uxth	r2, r2
2002a78c:	ea41 4103 	orr.w	r1, r1, r3, lsl #16
2002a790:	ea42 4201 	orr.w	r2, r2, r1, lsl #16
2002a794:	fbb1 f1f5 	udiv	r1, r1, r5
2002a798:	fbb3 f0f5 	udiv	r0, r3, r5
2002a79c:	231f      	movs	r3, #31
2002a79e:	eba2 020c 	sub.w	r2, r2, ip
2002a7a2:	ea41 4100 	orr.w	r1, r1, r0, lsl #16
2002a7a6:	e742      	b.n	2002a62e <__udivmoddi4+0xee>
2002a7a8:	409d      	lsls	r5, r3
2002a7aa:	f1c3 0220 	rsb	r2, r3, #32
2002a7ae:	4099      	lsls	r1, r3
2002a7b0:	409c      	lsls	r4, r3
2002a7b2:	fa2c fc02 	lsr.w	ip, ip, r2
2002a7b6:	ea4f 4e15 	mov.w	lr, r5, lsr #16
2002a7ba:	fa20 f202 	lsr.w	r2, r0, r2
2002a7be:	b2af      	uxth	r7, r5
2002a7c0:	fbbc f8fe 	udiv	r8, ip, lr
2002a7c4:	430a      	orrs	r2, r1
2002a7c6:	fb0e cc18 	mls	ip, lr, r8, ip
2002a7ca:	0c11      	lsrs	r1, r2, #16
2002a7cc:	ea41 410c 	orr.w	r1, r1, ip, lsl #16
2002a7d0:	fb08 fc07 	mul.w	ip, r8, r7
2002a7d4:	458c      	cmp	ip, r1
2002a7d6:	d950      	bls.n	2002a87a <__udivmoddi4+0x33a>
2002a7d8:	1869      	adds	r1, r5, r1
2002a7da:	f108 30ff 	add.w	r0, r8, #4294967295
2002a7de:	bf2c      	ite	cs
2002a7e0:	f04f 0901 	movcs.w	r9, #1
2002a7e4:	f04f 0900 	movcc.w	r9, #0
2002a7e8:	458c      	cmp	ip, r1
2002a7ea:	d902      	bls.n	2002a7f2 <__udivmoddi4+0x2b2>
2002a7ec:	f1b9 0f00 	cmp.w	r9, #0
2002a7f0:	d030      	beq.n	2002a854 <__udivmoddi4+0x314>
2002a7f2:	eba1 010c 	sub.w	r1, r1, ip
2002a7f6:	fbb1 f8fe 	udiv	r8, r1, lr
2002a7fa:	fb08 fc07 	mul.w	ip, r8, r7
2002a7fe:	fb0e 1118 	mls	r1, lr, r8, r1
2002a802:	b292      	uxth	r2, r2
2002a804:	ea42 4201 	orr.w	r2, r2, r1, lsl #16
2002a808:	4562      	cmp	r2, ip
2002a80a:	d234      	bcs.n	2002a876 <__udivmoddi4+0x336>
2002a80c:	18aa      	adds	r2, r5, r2
2002a80e:	f108 31ff 	add.w	r1, r8, #4294967295
2002a812:	bf2c      	ite	cs
2002a814:	f04f 0901 	movcs.w	r9, #1
2002a818:	f04f 0900 	movcc.w	r9, #0
2002a81c:	4562      	cmp	r2, ip
2002a81e:	d2be      	bcs.n	2002a79e <__udivmoddi4+0x25e>
2002a820:	f1b9 0f00 	cmp.w	r9, #0
2002a824:	d1bb      	bne.n	2002a79e <__udivmoddi4+0x25e>
2002a826:	f1a8 0102 	sub.w	r1, r8, #2
2002a82a:	442a      	add	r2, r5
2002a82c:	e7b7      	b.n	2002a79e <__udivmoddi4+0x25e>
2002a82e:	1a84      	subs	r4, r0, r2
2002a830:	eb6c 0203 	sbc.w	r2, ip, r3
2002a834:	2001      	movs	r0, #1
2002a836:	4617      	mov	r7, r2
2002a838:	e6e7      	b.n	2002a60a <__udivmoddi4+0xca>
2002a83a:	442c      	add	r4, r5
2002a83c:	3802      	subs	r0, #2
2002a83e:	e72b      	b.n	2002a698 <__udivmoddi4+0x158>
2002a840:	f1ac 0c02 	sub.w	ip, ip, #2
2002a844:	442a      	add	r2, r5
2002a846:	e70c      	b.n	2002a662 <__udivmoddi4+0x122>
2002a848:	3902      	subs	r1, #2
2002a84a:	442a      	add	r2, r5
2002a84c:	e6a5      	b.n	2002a59a <__udivmoddi4+0x5a>
2002a84e:	442c      	add	r4, r5
2002a850:	3802      	subs	r0, #2
2002a852:	e6ba      	b.n	2002a5ca <__udivmoddi4+0x8a>
2002a854:	eba5 0c0c 	sub.w	ip, r5, ip
2002a858:	f1a8 0002 	sub.w	r0, r8, #2
2002a85c:	4461      	add	r1, ip
2002a85e:	fbb1 f8fe 	udiv	r8, r1, lr
2002a862:	fb08 fc07 	mul.w	ip, r8, r7
2002a866:	e7ca      	b.n	2002a7fe <__udivmoddi4+0x2be>
2002a868:	f1a8 0802 	sub.w	r8, r8, #2
2002a86c:	443c      	add	r4, r7
2002a86e:	e744      	b.n	2002a6fa <__udivmoddi4+0x1ba>
2002a870:	3b02      	subs	r3, #2
2002a872:	443c      	add	r4, r7
2002a874:	e75e      	b.n	2002a734 <__udivmoddi4+0x1f4>
2002a876:	4641      	mov	r1, r8
2002a878:	e791      	b.n	2002a79e <__udivmoddi4+0x25e>
2002a87a:	eba1 010c 	sub.w	r1, r1, ip
2002a87e:	4640      	mov	r0, r8
2002a880:	fbb1 f8fe 	udiv	r8, r1, lr
2002a884:	fb08 fc07 	mul.w	ip, r8, r7
2002a888:	e7b9      	b.n	2002a7fe <__udivmoddi4+0x2be>
2002a88a:	bf00      	nop

2002a88c <__aeabi_idiv0>:
2002a88c:	4770      	bx	lr
2002a88e:	bf00      	nop

2002a890 <calloc>:
2002a890:	4b02      	ldr	r3, [pc, #8]	@ (2002a89c <calloc+0xc>)
2002a892:	460a      	mov	r2, r1
2002a894:	4601      	mov	r1, r0
2002a896:	6818      	ldr	r0, [r3, #0]
2002a898:	f000 b802 	b.w	2002a8a0 <_calloc_r>
2002a89c:	200449a0 	.word	0x200449a0

2002a8a0 <_calloc_r>:
2002a8a0:	b570      	push	{r4, r5, r6, lr}
2002a8a2:	fba1 5402 	umull	r5, r4, r1, r2
2002a8a6:	b934      	cbnz	r4, 2002a8b6 <_calloc_r+0x16>
2002a8a8:	4629      	mov	r1, r5
2002a8aa:	f000 f837 	bl	2002a91c <_malloc_r>
2002a8ae:	4606      	mov	r6, r0
2002a8b0:	b928      	cbnz	r0, 2002a8be <_calloc_r+0x1e>
2002a8b2:	4630      	mov	r0, r6
2002a8b4:	bd70      	pop	{r4, r5, r6, pc}
2002a8b6:	220c      	movs	r2, #12
2002a8b8:	2600      	movs	r6, #0
2002a8ba:	6002      	str	r2, [r0, #0]
2002a8bc:	e7f9      	b.n	2002a8b2 <_calloc_r+0x12>
2002a8be:	462a      	mov	r2, r5
2002a8c0:	4621      	mov	r1, r4
2002a8c2:	f000 f8c7 	bl	2002aa54 <memset>
2002a8c6:	e7f4      	b.n	2002a8b2 <_calloc_r+0x12>

2002a8c8 <free>:
2002a8c8:	4b02      	ldr	r3, [pc, #8]	@ (2002a8d4 <free+0xc>)
2002a8ca:	4601      	mov	r1, r0
2002a8cc:	6818      	ldr	r0, [r3, #0]
2002a8ce:	f000 b8e9 	b.w	2002aaa4 <_free_r>
2002a8d2:	bf00      	nop
2002a8d4:	200449a0 	.word	0x200449a0

2002a8d8 <sbrk_aligned>:
2002a8d8:	b570      	push	{r4, r5, r6, lr}
2002a8da:	4e0f      	ldr	r6, [pc, #60]	@ (2002a918 <sbrk_aligned+0x40>)
2002a8dc:	460c      	mov	r4, r1
2002a8de:	4605      	mov	r5, r0
2002a8e0:	6831      	ldr	r1, [r6, #0]
2002a8e2:	b911      	cbnz	r1, 2002a8ea <sbrk_aligned+0x12>
2002a8e4:	f000 f8be 	bl	2002aa64 <_sbrk_r>
2002a8e8:	6030      	str	r0, [r6, #0]
2002a8ea:	4621      	mov	r1, r4
2002a8ec:	4628      	mov	r0, r5
2002a8ee:	f000 f8b9 	bl	2002aa64 <_sbrk_r>
2002a8f2:	1c43      	adds	r3, r0, #1
2002a8f4:	d103      	bne.n	2002a8fe <sbrk_aligned+0x26>
2002a8f6:	f04f 34ff 	mov.w	r4, #4294967295
2002a8fa:	4620      	mov	r0, r4
2002a8fc:	bd70      	pop	{r4, r5, r6, pc}
2002a8fe:	1cc4      	adds	r4, r0, #3
2002a900:	f024 0403 	bic.w	r4, r4, #3
2002a904:	42a0      	cmp	r0, r4
2002a906:	d0f8      	beq.n	2002a8fa <sbrk_aligned+0x22>
2002a908:	1a21      	subs	r1, r4, r0
2002a90a:	4628      	mov	r0, r5
2002a90c:	f000 f8aa 	bl	2002aa64 <_sbrk_r>
2002a910:	3001      	adds	r0, #1
2002a912:	d1f2      	bne.n	2002a8fa <sbrk_aligned+0x22>
2002a914:	e7ef      	b.n	2002a8f6 <sbrk_aligned+0x1e>
2002a916:	bf00      	nop
2002a918:	2004d0c0 	.word	0x2004d0c0

2002a91c <_malloc_r>:
2002a91c:	e92d 43f8 	stmdb	sp!, {r3, r4, r5, r6, r7, r8, r9, lr}
2002a920:	1ccd      	adds	r5, r1, #3
2002a922:	4606      	mov	r6, r0
2002a924:	f025 0503 	bic.w	r5, r5, #3
2002a928:	3508      	adds	r5, #8
2002a92a:	2d0c      	cmp	r5, #12
2002a92c:	bf38      	it	cc
2002a92e:	250c      	movcc	r5, #12
2002a930:	2d00      	cmp	r5, #0
2002a932:	db01      	blt.n	2002a938 <_malloc_r+0x1c>
2002a934:	42a9      	cmp	r1, r5
2002a936:	d904      	bls.n	2002a942 <_malloc_r+0x26>
2002a938:	230c      	movs	r3, #12
2002a93a:	6033      	str	r3, [r6, #0]
2002a93c:	2000      	movs	r0, #0
2002a93e:	e8bd 83f8 	ldmia.w	sp!, {r3, r4, r5, r6, r7, r8, r9, pc}
2002a942:	f8df 80d4 	ldr.w	r8, [pc, #212]	@ 2002aa18 <_malloc_r+0xfc>
2002a946:	f000 f869 	bl	2002aa1c <__malloc_lock>
2002a94a:	f8d8 3000 	ldr.w	r3, [r8]
2002a94e:	461c      	mov	r4, r3
2002a950:	bb44      	cbnz	r4, 2002a9a4 <_malloc_r+0x88>
2002a952:	4629      	mov	r1, r5
2002a954:	4630      	mov	r0, r6
2002a956:	f7ff ffbf 	bl	2002a8d8 <sbrk_aligned>
2002a95a:	1c43      	adds	r3, r0, #1
2002a95c:	4604      	mov	r4, r0
2002a95e:	d158      	bne.n	2002aa12 <_malloc_r+0xf6>
2002a960:	f8d8 4000 	ldr.w	r4, [r8]
2002a964:	4627      	mov	r7, r4
2002a966:	2f00      	cmp	r7, #0
2002a968:	d143      	bne.n	2002a9f2 <_malloc_r+0xd6>
2002a96a:	2c00      	cmp	r4, #0
2002a96c:	d04b      	beq.n	2002aa06 <_malloc_r+0xea>
2002a96e:	6823      	ldr	r3, [r4, #0]
2002a970:	4639      	mov	r1, r7
2002a972:	4630      	mov	r0, r6
2002a974:	eb04 0903 	add.w	r9, r4, r3
2002a978:	f000 f874 	bl	2002aa64 <_sbrk_r>
2002a97c:	4581      	cmp	r9, r0
2002a97e:	d142      	bne.n	2002aa06 <_malloc_r+0xea>
2002a980:	6821      	ldr	r1, [r4, #0]
2002a982:	4630      	mov	r0, r6
2002a984:	1a6d      	subs	r5, r5, r1
2002a986:	4629      	mov	r1, r5
2002a988:	f7ff ffa6 	bl	2002a8d8 <sbrk_aligned>
2002a98c:	3001      	adds	r0, #1
2002a98e:	d03a      	beq.n	2002aa06 <_malloc_r+0xea>
2002a990:	6823      	ldr	r3, [r4, #0]
2002a992:	442b      	add	r3, r5
2002a994:	6023      	str	r3, [r4, #0]
2002a996:	f8d8 3000 	ldr.w	r3, [r8]
2002a99a:	685a      	ldr	r2, [r3, #4]
2002a99c:	bb62      	cbnz	r2, 2002a9f8 <_malloc_r+0xdc>
2002a99e:	f8c8 7000 	str.w	r7, [r8]
2002a9a2:	e00f      	b.n	2002a9c4 <_malloc_r+0xa8>
2002a9a4:	6822      	ldr	r2, [r4, #0]
2002a9a6:	1b52      	subs	r2, r2, r5
2002a9a8:	d420      	bmi.n	2002a9ec <_malloc_r+0xd0>
2002a9aa:	2a0b      	cmp	r2, #11
2002a9ac:	d917      	bls.n	2002a9de <_malloc_r+0xc2>
2002a9ae:	1961      	adds	r1, r4, r5
2002a9b0:	42a3      	cmp	r3, r4
2002a9b2:	6025      	str	r5, [r4, #0]
2002a9b4:	bf18      	it	ne
2002a9b6:	6059      	strne	r1, [r3, #4]
2002a9b8:	6863      	ldr	r3, [r4, #4]
2002a9ba:	bf08      	it	eq
2002a9bc:	f8c8 1000 	streq.w	r1, [r8]
2002a9c0:	5162      	str	r2, [r4, r5]
2002a9c2:	604b      	str	r3, [r1, #4]
2002a9c4:	4630      	mov	r0, r6
2002a9c6:	f000 f82f 	bl	2002aa28 <__malloc_unlock>
2002a9ca:	f104 000b 	add.w	r0, r4, #11
2002a9ce:	1d23      	adds	r3, r4, #4
2002a9d0:	f020 0007 	bic.w	r0, r0, #7
2002a9d4:	1ac2      	subs	r2, r0, r3
2002a9d6:	bf1c      	itt	ne
2002a9d8:	1a1b      	subne	r3, r3, r0
2002a9da:	50a3      	strne	r3, [r4, r2]
2002a9dc:	e7af      	b.n	2002a93e <_malloc_r+0x22>
2002a9de:	6862      	ldr	r2, [r4, #4]
2002a9e0:	42a3      	cmp	r3, r4
2002a9e2:	bf0c      	ite	eq
2002a9e4:	f8c8 2000 	streq.w	r2, [r8]
2002a9e8:	605a      	strne	r2, [r3, #4]
2002a9ea:	e7eb      	b.n	2002a9c4 <_malloc_r+0xa8>
2002a9ec:	4623      	mov	r3, r4
2002a9ee:	6864      	ldr	r4, [r4, #4]
2002a9f0:	e7ae      	b.n	2002a950 <_malloc_r+0x34>
2002a9f2:	463c      	mov	r4, r7
2002a9f4:	687f      	ldr	r7, [r7, #4]
2002a9f6:	e7b6      	b.n	2002a966 <_malloc_r+0x4a>
2002a9f8:	461a      	mov	r2, r3
2002a9fa:	685b      	ldr	r3, [r3, #4]
2002a9fc:	42a3      	cmp	r3, r4
2002a9fe:	d1fb      	bne.n	2002a9f8 <_malloc_r+0xdc>
2002aa00:	2300      	movs	r3, #0
2002aa02:	6053      	str	r3, [r2, #4]
2002aa04:	e7de      	b.n	2002a9c4 <_malloc_r+0xa8>
2002aa06:	230c      	movs	r3, #12
2002aa08:	4630      	mov	r0, r6
2002aa0a:	6033      	str	r3, [r6, #0]
2002aa0c:	f000 f80c 	bl	2002aa28 <__malloc_unlock>
2002aa10:	e794      	b.n	2002a93c <_malloc_r+0x20>
2002aa12:	6005      	str	r5, [r0, #0]
2002aa14:	e7d6      	b.n	2002a9c4 <_malloc_r+0xa8>
2002aa16:	bf00      	nop
2002aa18:	2004d0c4 	.word	0x2004d0c4

2002aa1c <__malloc_lock>:
2002aa1c:	4801      	ldr	r0, [pc, #4]	@ (2002aa24 <__malloc_lock+0x8>)
2002aa1e:	f000 b831 	b.w	2002aa84 <__retarget_lock_acquire_recursive>
2002aa22:	bf00      	nop
2002aa24:	2004d204 	.word	0x2004d204

2002aa28 <__malloc_unlock>:
2002aa28:	4801      	ldr	r0, [pc, #4]	@ (2002aa30 <__malloc_unlock+0x8>)
2002aa2a:	f000 b82c 	b.w	2002aa86 <__retarget_lock_release_recursive>
2002aa2e:	bf00      	nop
2002aa30:	2004d204 	.word	0x2004d204

2002aa34 <memcmp>:
2002aa34:	3901      	subs	r1, #1
2002aa36:	4402      	add	r2, r0
2002aa38:	b510      	push	{r4, lr}
2002aa3a:	4290      	cmp	r0, r2
2002aa3c:	d101      	bne.n	2002aa42 <memcmp+0xe>
2002aa3e:	2000      	movs	r0, #0
2002aa40:	e005      	b.n	2002aa4e <memcmp+0x1a>
2002aa42:	7803      	ldrb	r3, [r0, #0]
2002aa44:	f811 4f01 	ldrb.w	r4, [r1, #1]!
2002aa48:	42a3      	cmp	r3, r4
2002aa4a:	d001      	beq.n	2002aa50 <memcmp+0x1c>
2002aa4c:	1b18      	subs	r0, r3, r4
2002aa4e:	bd10      	pop	{r4, pc}
2002aa50:	3001      	adds	r0, #1
2002aa52:	e7f2      	b.n	2002aa3a <memcmp+0x6>

2002aa54 <memset>:
2002aa54:	4402      	add	r2, r0
2002aa56:	4603      	mov	r3, r0
2002aa58:	4293      	cmp	r3, r2
2002aa5a:	d100      	bne.n	2002aa5e <memset+0xa>
2002aa5c:	4770      	bx	lr
2002aa5e:	f803 1b01 	strb.w	r1, [r3], #1
2002aa62:	e7f9      	b.n	2002aa58 <memset+0x4>

2002aa64 <_sbrk_r>:
2002aa64:	b538      	push	{r3, r4, r5, lr}
2002aa66:	2300      	movs	r3, #0
2002aa68:	4d05      	ldr	r5, [pc, #20]	@ (2002aa80 <_sbrk_r+0x1c>)
2002aa6a:	4604      	mov	r4, r0
2002aa6c:	4608      	mov	r0, r1
2002aa6e:	602b      	str	r3, [r5, #0]
2002aa70:	f000 f862 	bl	2002ab38 <_sbrk>
2002aa74:	1c43      	adds	r3, r0, #1
2002aa76:	d102      	bne.n	2002aa7e <_sbrk_r+0x1a>
2002aa78:	682b      	ldr	r3, [r5, #0]
2002aa7a:	b103      	cbz	r3, 2002aa7e <_sbrk_r+0x1a>
2002aa7c:	6023      	str	r3, [r4, #0]
2002aa7e:	bd38      	pop	{r3, r4, r5, pc}
2002aa80:	2004d200 	.word	0x2004d200

2002aa84 <__retarget_lock_acquire_recursive>:
2002aa84:	4770      	bx	lr

2002aa86 <__retarget_lock_release_recursive>:
2002aa86:	4770      	bx	lr

2002aa88 <memcpy>:
2002aa88:	440a      	add	r2, r1
2002aa8a:	1e43      	subs	r3, r0, #1
2002aa8c:	4291      	cmp	r1, r2
2002aa8e:	d100      	bne.n	2002aa92 <memcpy+0xa>
2002aa90:	4770      	bx	lr
2002aa92:	b510      	push	{r4, lr}
2002aa94:	f811 4b01 	ldrb.w	r4, [r1], #1
2002aa98:	4291      	cmp	r1, r2
2002aa9a:	f803 4f01 	strb.w	r4, [r3, #1]!
2002aa9e:	d1f9      	bne.n	2002aa94 <memcpy+0xc>
2002aaa0:	bd10      	pop	{r4, pc}
	...

2002aaa4 <_free_r>:
2002aaa4:	b538      	push	{r3, r4, r5, lr}
2002aaa6:	4605      	mov	r5, r0
2002aaa8:	2900      	cmp	r1, #0
2002aaaa:	d041      	beq.n	2002ab30 <_free_r+0x8c>
2002aaac:	f851 3c04 	ldr.w	r3, [r1, #-4]
2002aab0:	1f0c      	subs	r4, r1, #4
2002aab2:	2b00      	cmp	r3, #0
2002aab4:	bfb8      	it	lt
2002aab6:	18e4      	addlt	r4, r4, r3
2002aab8:	f7ff ffb0 	bl	2002aa1c <__malloc_lock>
2002aabc:	4a1d      	ldr	r2, [pc, #116]	@ (2002ab34 <_free_r+0x90>)
2002aabe:	6813      	ldr	r3, [r2, #0]
2002aac0:	b933      	cbnz	r3, 2002aad0 <_free_r+0x2c>
2002aac2:	6063      	str	r3, [r4, #4]
2002aac4:	6014      	str	r4, [r2, #0]
2002aac6:	4628      	mov	r0, r5
2002aac8:	e8bd 4038 	ldmia.w	sp!, {r3, r4, r5, lr}
2002aacc:	f7ff bfac 	b.w	2002aa28 <__malloc_unlock>
2002aad0:	42a3      	cmp	r3, r4
2002aad2:	d908      	bls.n	2002aae6 <_free_r+0x42>
2002aad4:	6820      	ldr	r0, [r4, #0]
2002aad6:	1821      	adds	r1, r4, r0
2002aad8:	428b      	cmp	r3, r1
2002aada:	bf01      	itttt	eq
2002aadc:	6819      	ldreq	r1, [r3, #0]
2002aade:	685b      	ldreq	r3, [r3, #4]
2002aae0:	1809      	addeq	r1, r1, r0
2002aae2:	6021      	streq	r1, [r4, #0]
2002aae4:	e7ed      	b.n	2002aac2 <_free_r+0x1e>
2002aae6:	461a      	mov	r2, r3
2002aae8:	685b      	ldr	r3, [r3, #4]
2002aaea:	b10b      	cbz	r3, 2002aaf0 <_free_r+0x4c>
2002aaec:	42a3      	cmp	r3, r4
2002aaee:	d9fa      	bls.n	2002aae6 <_free_r+0x42>
2002aaf0:	6811      	ldr	r1, [r2, #0]
2002aaf2:	1850      	adds	r0, r2, r1
2002aaf4:	42a0      	cmp	r0, r4
2002aaf6:	d10b      	bne.n	2002ab10 <_free_r+0x6c>
2002aaf8:	6820      	ldr	r0, [r4, #0]
2002aafa:	4401      	add	r1, r0
2002aafc:	1850      	adds	r0, r2, r1
2002aafe:	6011      	str	r1, [r2, #0]
2002ab00:	4283      	cmp	r3, r0
2002ab02:	d1e0      	bne.n	2002aac6 <_free_r+0x22>
2002ab04:	6818      	ldr	r0, [r3, #0]
2002ab06:	685b      	ldr	r3, [r3, #4]
2002ab08:	4408      	add	r0, r1
2002ab0a:	6053      	str	r3, [r2, #4]
2002ab0c:	6010      	str	r0, [r2, #0]
2002ab0e:	e7da      	b.n	2002aac6 <_free_r+0x22>
2002ab10:	d902      	bls.n	2002ab18 <_free_r+0x74>
2002ab12:	230c      	movs	r3, #12
2002ab14:	602b      	str	r3, [r5, #0]
2002ab16:	e7d6      	b.n	2002aac6 <_free_r+0x22>
2002ab18:	6820      	ldr	r0, [r4, #0]
2002ab1a:	1821      	adds	r1, r4, r0
2002ab1c:	428b      	cmp	r3, r1
2002ab1e:	bf02      	ittt	eq
2002ab20:	6819      	ldreq	r1, [r3, #0]
2002ab22:	685b      	ldreq	r3, [r3, #4]
2002ab24:	1809      	addeq	r1, r1, r0
2002ab26:	6063      	str	r3, [r4, #4]
2002ab28:	bf08      	it	eq
2002ab2a:	6021      	streq	r1, [r4, #0]
2002ab2c:	6054      	str	r4, [r2, #4]
2002ab2e:	e7ca      	b.n	2002aac6 <_free_r+0x22>
2002ab30:	bd38      	pop	{r3, r4, r5, pc}
2002ab32:	bf00      	nop
2002ab34:	2004d0c4 	.word	0x2004d0c4

2002ab38 <_sbrk>:
2002ab38:	4a05      	ldr	r2, [pc, #20]	@ (2002ab50 <_sbrk+0x18>)
2002ab3a:	4603      	mov	r3, r0
2002ab3c:	6810      	ldr	r0, [r2, #0]
2002ab3e:	b110      	cbz	r0, 2002ab46 <_sbrk+0xe>
2002ab40:	4403      	add	r3, r0
2002ab42:	6013      	str	r3, [r2, #0]
2002ab44:	4770      	bx	lr
2002ab46:	4803      	ldr	r0, [pc, #12]	@ (2002ab54 <_sbrk+0x1c>)
2002ab48:	4403      	add	r3, r0
2002ab4a:	6013      	str	r3, [r2, #0]
2002ab4c:	4770      	bx	lr
2002ab4e:	bf00      	nop
2002ab50:	2004d208 	.word	0x2004d208
2002ab54:	20042000 	.word	0x20042000
2002ab58:	50041000 	.word	0x50041000
2002ab5c:	00000002 	.word	0x00000002
2002ab60:	10000000 	.word	0x10000000
2002ab64:	00000004 	.word	0x00000004
2002ab68:	00000000 	.word	0x00000000
2002ab6c:	50042000 	.word	0x50042000
2002ab70:	00000002 	.word	0x00000002
2002ab74:	12000000 	.word	0x12000000
2002ab78:	00000004 	.word	0x00000004
2002ab7c:	00000000 	.word	0x00000000
2002ab80:	62636573 	.word	0x62636573
2002ab84:	20746f6f 	.word	0x20746f6f
2002ab88:	6b676973 	.word	0x6b676973
2002ab8c:	70207965 	.word	0x70207965
2002ab90:	65206275 	.word	0x65206275
2002ab94:	00217272 	.word	0x00217272
2002ab98:	62636573 	.word	0x62636573
2002ab9c:	20746f6f 	.word	0x20746f6f
2002aba0:	20676d69 	.word	0x20676d69
2002aba4:	68736168 	.word	0x68736168
2002aba8:	67697320 	.word	0x67697320
2002abac:	72726520 	.word	0x72726520
2002abb0:	65730021 	.word	0x65730021
2002abb4:	6f6f6263 	.word	0x6f6f6263
2002abb8:	78652074 	.word	0x78652074
2002abbc:	20747063 	.word	0x20747063
2002abc0:	6c6c756e 	.word	0x6c6c756e
2002abc4:	41480021 	.word	0x41480021
2002abc8:	535f4853 	.word	0x535f4853
2002abcc:	49545445 	.word	0x49545445
2002abd0:	253d474e 	.word	0x253d474e
2002abd4:	0a583830 	.word	0x0a583830
2002abd8:	616f4c00 	.word	0x616f4c00
2002abdc:	56492064 	.word	0x56492064
2002abe0:	646e6120 	.word	0x646e6120
2002abe4:	6e656c20 	.word	0x6e656c20
2002abe8:	20687467 	.word	0x20687467
2002abec:	48534148 	.word	0x48534148
2002abf0:	5445535f 	.word	0x5445535f
2002abf4:	474e4954 	.word	0x474e4954
2002abf8:	3830253d 	.word	0x3830253d
2002abfc:	69202c58 	.word	0x69202c58
2002ac00:	656c2076 	.word	0x656c2076
2002ac04:	6874676e 	.word	0x6874676e
2002ac08:	0a64253d 	.word	0x0a64253d
2002ac0c:	73655200 	.word	0x73655200
2002ac10:	20746c75 	.word	0x20746c75
2002ac14:	3d6e656c 	.word	0x3d6e656c
2002ac18:	000a6425 	.word	0x000a6425
2002ac1c:	2070614d 	.word	0x2070614d
2002ac20:	6f727265 	.word	0x6f727265
2002ac24:	6c203a72 	.word	0x6c203a72
2002ac28:	6369676f 	.word	0x6369676f
2002ac2c:	2c642520 	.word	0x2c642520
2002ac30:	79687020 	.word	0x79687020
2002ac34:	0a642520 	.word	0x0a642520
2002ac38:	52524500 	.word	0x52524500
2002ac3c:	2032203a 	.word	0x2032203a
2002ac40:	69676f6c 	.word	0x69676f6c
2002ac44:	6c622063 	.word	0x6c622063
2002ac48:	736b636f 	.word	0x736b636f
2002ac4c:	70616d20 	.word	0x70616d20
2002ac50:	206f7420 	.word	0x206f7420
2002ac54:	656d6173 	.word	0x656d6173
2002ac58:	6b6c6220 	.word	0x6b6c6220
2002ac5c:	6f6c203a 	.word	0x6f6c203a
2002ac60:	30636967 	.word	0x30636967
2002ac64:	2c642520 	.word	0x2c642520
2002ac68:	79687020 	.word	0x79687020
2002ac6c:	64252030 	.word	0x64252030
2002ac70:	6f6c202c 	.word	0x6f6c202c
2002ac74:	31636967 	.word	0x31636967
2002ac78:	2c642520 	.word	0x2c642520
2002ac7c:	79687020 	.word	0x79687020
2002ac80:	64252031 	.word	0x64252031
2002ac84:	614d000a 	.word	0x614d000a
2002ac88:	72652070 	.word	0x72652070
2002ac8c:	30726f72 	.word	0x30726f72
2002ac90:	6f6c203a 	.word	0x6f6c203a
2002ac94:	20636967 	.word	0x20636967
2002ac98:	202c6425 	.word	0x202c6425
2002ac9c:	20796870 	.word	0x20796870
2002aca0:	000a6425 	.word	0x000a6425
2002aca4:	20746547 	.word	0x20746547
2002aca8:	2070616d 	.word	0x2070616d
2002acac:	636f6c62 	.word	0x636f6c62
2002acb0:	7265206b 	.word	0x7265206b
2002acb4:	20726f72 	.word	0x20726f72
2002acb8:	2d206425 	.word	0x2d206425
2002acbc:	25203e2d 	.word	0x25203e2d
2002acc0:	42000a64 	.word	0x42000a64
2002acc4:	76204d42 	.word	0x76204d42
2002acc8:	69737265 	.word	0x69737265
2002accc:	6e206e6f 	.word	0x6e206e6f
2002acd0:	6920746f 	.word	0x6920746f
2002acd4:	6572636e 	.word	0x6572636e
2002acd8:	64657361 	.word	0x64657361
2002acdc:	7270203a 	.word	0x7270203a
2002ace0:	25207665 	.word	0x25207665
2002ace4:	63202c64 	.word	0x63202c64
2002ace8:	20727275 	.word	0x20727275
2002acec:	000a6425 	.word	0x000a6425
2002acf0:	41544144 	.word	0x41544144
2002acf4:	746f6e20 	.word	0x746f6e20
2002acf8:	61657220 	.word	0x61657220
2002acfc:	616e6f73 	.word	0x616e6f73
2002ad00:	20656c62 	.word	0x20656c62
2002ad04:	42206e69 	.word	0x42206e69
2002ad08:	62204d42 	.word	0x62204d42
2002ad0c:	25206b6c 	.word	0x25206b6c
2002ad10:	61702064 	.word	0x61702064
2002ad14:	25206567 	.word	0x25206567
2002ad18:	30203a64 	.word	0x30203a64
2002ad1c:	0a782578 	.word	0x0a782578
2002ad20:	61655200 	.word	0x61655200
2002ad24:	62622064 	.word	0x62622064
2002ad28:	6c62206d 	.word	0x6c62206d
2002ad2c:	6425206b 	.word	0x6425206b
2002ad30:	67617020 	.word	0x67617020
2002ad34:	64252065 	.word	0x64252065
2002ad38:	69616620 	.word	0x69616620
2002ad3c:	49000a6c 	.word	0x49000a6c
2002ad40:	6c61766e 	.word	0x6c61766e
2002ad44:	42206469 	.word	0x42206469
2002ad48:	49204d42 	.word	0x49204d42
2002ad4c:	25205844 	.word	0x25205844
2002ad50:	56000a64 	.word	0x56000a64
2002ad54:	64252031 	.word	0x64252031
2002ad58:	206e6920 	.word	0x206e6920
2002ad5c:	636f6c62 	.word	0x636f6c62
2002ad60:	6425206b 	.word	0x6425206b
2002ad64:	3256202c 	.word	0x3256202c
2002ad68:	20642520 	.word	0x20642520
2002ad6c:	62206e69 	.word	0x62206e69
2002ad70:	6b636f6c 	.word	0x6b636f6c
2002ad74:	0a642520 	.word	0x0a642520
2002ad78:	6d615300 	.word	0x6d615300
2002ad7c:	69687465 	.word	0x69687465
2002ad80:	6d20676e 	.word	0x6d20676e
2002ad84:	20747375 	.word	0x20747375
2002ad88:	77206562 	.word	0x77206562
2002ad8c:	676e6f72 	.word	0x676e6f72
2002ad90:	6567202c 	.word	0x6567202c
2002ad94:	656e2074 	.word	0x656e2074
2002ad98:	65762077 	.word	0x65762077
2002ad9c:	6f697372 	.word	0x6f697372
2002ada0:	6425206e 	.word	0x6425206e
2002ada4:	206f6420 	.word	0x206f6420
2002ada8:	20746f6e 	.word	0x20746f6e
2002adac:	656d6173 	.word	0x656d6173
2002adb0:	206f7420 	.word	0x206f7420
2002adb4:	76657270 	.word	0x76657270
2002adb8:	65686320 	.word	0x65686320
2002adbc:	25206b63 	.word	0x25206b63
2002adc0:	43000a64 	.word	0x43000a64
2002adc4:	63204352 	.word	0x63204352
2002adc8:	6b636568 	.word	0x6b636568
2002adcc:	72726520 	.word	0x72726520
2002add0:	0a20726f 	.word	0x0a20726f
2002add4:	61655200 	.word	0x61655200
2002add8:	62622064 	.word	0x62622064
2002addc:	6c62206d 	.word	0x6c62206d
2002ade0:	6425206b 	.word	0x6425206b
2002ade4:	67617020 	.word	0x67617020
2002ade8:	64252065 	.word	0x64252065
2002adec:	74616420 	.word	0x74616420
2002adf0:	6f6e2061 	.word	0x6f6e2061
2002adf4:	72772074 	.word	0x72772074
2002adf8:	20657469 	.word	0x20657469
2002adfc:	20726f66 	.word	0x20726f66
2002ae00:	20646e32 	.word	0x20646e32
2002ae04:	656d6974 	.word	0x656d6974
2002ae08:	6552000a 	.word	0x6552000a
2002ae0c:	62206461 	.word	0x62206461
2002ae10:	62206d62 	.word	0x62206d62
2002ae14:	25206b6c 	.word	0x25206b6c
2002ae18:	61702064 	.word	0x61702064
2002ae1c:	25206567 	.word	0x25206567
2002ae20:	61662064 	.word	0x61662064
2002ae24:	66206c69 	.word	0x66206c69
2002ae28:	3220726f 	.word	0x3220726f
2002ae2c:	7420646e 	.word	0x7420646e
2002ae30:	3f656d69 	.word	0x3f656d69
2002ae34:	614c000a 	.word	0x614c000a
2002ae38:	74736574 	.word	0x74736574
2002ae3c:	72657620 	.word	0x72657620
2002ae40:	6e6f6973 	.word	0x6e6f6973
2002ae44:	0a642520 	.word	0x0a642520
2002ae48:	74654700 	.word	0x74654700
2002ae4c:	79687020 	.word	0x79687020
2002ae50:	6b6c6220 	.word	0x6b6c6220
2002ae54:	726f6620 	.word	0x726f6620
2002ae58:	20642520 	.word	0x20642520
2002ae5c:	6c696166 	.word	0x6c696166
2002ae60:	65687720 	.word	0x65687720
2002ae64:	6572206e 	.word	0x6572206e
2002ae68:	000a6461 	.word	0x000a6461
2002ae6c:	636f6c42 	.word	0x636f6c42
2002ae70:	6425206b 	.word	0x6425206b
2002ae74:	61726520 	.word	0x61726520
2002ae78:	66206573 	.word	0x66206573
2002ae7c:	2c6c6961 	.word	0x2c6c6961
2002ae80:	72616d20 	.word	0x72616d20
2002ae84:	7361206b 	.word	0x7361206b
2002ae88:	64616220 	.word	0x64616220
2002ae8c:	6c42000a 	.word	0x6c42000a
2002ae90:	206b636f 	.word	0x206b636f
2002ae94:	63206425 	.word	0x63206425
2002ae98:	6b636568 	.word	0x6b636568
2002ae9c:	20736120 	.word	0x20736120
2002aea0:	20646162 	.word	0x20646162
2002aea4:	636f6c62 	.word	0x636f6c62
2002aea8:	42000a6b 	.word	0x42000a6b
2002aeac:	6b636f6c 	.word	0x6b636f6c
2002aeb0:	20642520 	.word	0x20642520
2002aeb4:	62207369 	.word	0x62207369
2002aeb8:	69206461 	.word	0x69206461
2002aebc:	7375206e 	.word	0x7375206e
2002aec0:	62207265 	.word	0x62207265
2002aec4:	6b636f6c 	.word	0x6b636f6c
2002aec8:	6162000a 	.word	0x6162000a
2002aecc:	64252064 	.word	0x64252064
2002aed0:	6572202c 	.word	0x6572202c
2002aed4:	63616c70 	.word	0x63616c70
2002aed8:	64252065 	.word	0x64252065
2002aedc:	6f4e000a 	.word	0x6f4e000a
2002aee0:	63616220 	.word	0x63616220
2002aee4:	2070756b 	.word	0x2070756b
2002aee8:	636f6c62 	.word	0x636f6c62
2002aeec:	6e61206b 	.word	0x6e61206b
2002aef0:	6f6d2079 	.word	0x6f6d2079
2002aef4:	000a6572 	.word	0x000a6572
2002aef8:	74706d65 	.word	0x74706d65
2002aefc:	61742079 	.word	0x61742079
2002af00:	20656c62 	.word	0x20656c62
2002af04:	6e206425 	.word	0x6e206425
2002af08:	6520746f 	.word	0x6520746f
2002af0c:	67756f6e 	.word	0x67756f6e
2002af10:	6f662068 	.word	0x6f662068
2002af14:	6e692072 	.word	0x6e692072
2002af18:	61697469 	.word	0x61697469
2002af1c:	55000a6c 	.word	0x55000a6c
2002af20:	74616470 	.word	0x74616470
2002af24:	61742065 	.word	0x61742065
2002af28:	20656c62 	.word	0x20656c62
2002af2c:	66206f74 	.word	0x66206f74
2002af30:	6873616c 	.word	0x6873616c
2002af34:	6e6f6420 	.word	0x6e6f6420
2002af38:	49000a65 	.word	0x49000a65
2002af3c:	6974696e 	.word	0x6974696e
2002af40:	74206c61 	.word	0x74206c61
2002af44:	656c6261 	.word	0x656c6261
2002af48:	69616620 	.word	0x69616620
2002af4c:	42000a6c 	.word	0x42000a6c
2002af50:	69204d42 	.word	0x69204d42
2002af54:	6974696e 	.word	0x6974696e
2002af58:	7a696c61 	.word	0x7a696c61
2002af5c:	62206465 	.word	0x62206465
2002af60:	726f6665 	.word	0x726f6665
2002af64:	64202c65 	.word	0x64202c65
2002af68:	6f6e206f 	.word	0x6f6e206f
2002af6c:	6e692074 	.word	0x6e692074
2002af70:	61207469 	.word	0x61207469
2002af74:	6d20796e 	.word	0x6d20796e
2002af78:	0a65726f 	.word	0x0a65726f
2002af7c:	54454400 	.word	0x54454400
2002af80:	20642520 	.word	0x20642520
2002af84:	0a646162 	.word	0x0a646162
2002af88:	4b4c4200 	.word	0x4b4c4200
2002af8c:	20642520 	.word	0x20642520
2002af90:	64616572 	.word	0x64616572
2002af94:	69616620 	.word	0x69616620
2002af98:	6d202c6c 	.word	0x6d202c6c
2002af9c:	206b7261 	.word	0x206b7261
2002afa0:	62207361 	.word	0x62207361
2002afa4:	000a6461 	.word	0x000a6461
2002afa8:	20746564 	.word	0x20746564
2002afac:	206d6262 	.word	0x206d6262
2002afb0:	6c626174 	.word	0x6c626174
2002afb4:	69772065 	.word	0x69772065
2002afb8:	25206874 	.word	0x25206874
2002afbc:	25202c64 	.word	0x25202c64
2002afc0:	25202c64 	.word	0x25202c64
2002afc4:	64000a64 	.word	0x64000a64
2002afc8:	63657465 	.word	0x63657465
2002afcc:	65722074 	.word	0x65722074
2002afd0:	746c7573 	.word	0x746c7573
2002afd4:	0a642520 	.word	0x0a642520
2002afd8:	20317600 	.word	0x20317600
2002afdc:	69206425 	.word	0x69206425
2002afe0:	6c62206e 	.word	0x6c62206e
2002afe4:	6425206b 	.word	0x6425206b
2002afe8:	3276202c 	.word	0x3276202c
2002afec:	20642520 	.word	0x20642520
2002aff0:	62206e69 	.word	0x62206e69
2002aff4:	6b636f6c 	.word	0x6b636f6c
2002aff8:	0a642520 	.word	0x0a642520
2002affc:	65684300 	.word	0x65684300
2002b000:	62206b63 	.word	0x62206b63
2002b004:	74206d62 	.word	0x74206d62
2002b008:	656c6261 	.word	0x656c6261
2002b00c:	69616620 	.word	0x69616620
2002b010:	64000a6c 	.word	0x64000a6c
2002b014:	63657465 	.word	0x63657465
2002b018:	65722074 	.word	0x65722074
2002b01c:	746c7573 	.word	0x746c7573
2002b020:	20642520 	.word	0x20642520
2002b024:	20746f6e 	.word	0x20746f6e
2002b028:	73616572 	.word	0x73616572
2002b02c:	62616e6f 	.word	0x62616e6f
2002b030:	000a656c 	.word	0x000a656c
2002b034:	204d4242 	.word	0x204d4242
2002b038:	3a4d454d 	.word	0x3a4d454d
2002b03c:	78746320 	.word	0x78746320
2002b040:	2c702520 	.word	0x2c702520
2002b044:	70616d20 	.word	0x70616d20
2002b048:	70252031 	.word	0x70252031
2002b04c:	616d202c 	.word	0x616d202c
2002b050:	25203270 	.word	0x25203270
2002b054:	000a2070 	.word	0x000a2070
2002b058:	5f666973 	.word	0x5f666973
2002b05c:	5f6d6262 	.word	0x5f6d6262
2002b060:	74696e69 	.word	0x74696e69
2002b064:	6e6f6420 	.word	0x6e6f6420
2002b068:	53000a65 	.word	0x53000a65
2002b06c:	31354148 	.word	0x31354148
2002b070:	48530032 	.word	0x48530032
2002b074:	34383341 	.word	0x34383341
2002b078:	41485300 	.word	0x41485300
2002b07c:	00363532 	.word	0x00363532
2002b080:	32414853 	.word	0x32414853
2002b084:	60003432 	.word	0x60003432
2002b088:	65014886 	.word	0x65014886
2002b08c:	04020403 	.word	0x04020403
2002b090:	2d646900 	.word	0x2d646900
2002b094:	32616873 	.word	0x32616873
2002b098:	60003432 	.word	0x60003432
2002b09c:	65014886 	.word	0x65014886
2002b0a0:	01020403 	.word	0x01020403
2002b0a4:	2d646900 	.word	0x2d646900
2002b0a8:	32616873 	.word	0x32616873
2002b0ac:	60003635 	.word	0x60003635
2002b0b0:	65014886 	.word	0x65014886
2002b0b4:	02020403 	.word	0x02020403
2002b0b8:	2d646900 	.word	0x2d646900
2002b0bc:	33616873 	.word	0x33616873
2002b0c0:	60003438 	.word	0x60003438
2002b0c4:	65014886 	.word	0x65014886
2002b0c8:	03020403 	.word	0x03020403
2002b0cc:	2d646900 	.word	0x2d646900
2002b0d0:	35616873 	.word	0x35616873
2002b0d4:	2b003231 	.word	0x2b003231
2002b0d8:	0702030e 	.word	0x0702030e
2002b0dc:	73656400 	.word	0x73656400
2002b0e0:	00434243 	.word	0x00434243
2002b0e4:	2d534544 	.word	0x2d534544
2002b0e8:	00434243 	.word	0x00434243
2002b0ec:	8648862a 	.word	0x8648862a
2002b0f0:	07030df7 	.word	0x07030df7
2002b0f4:	73656400 	.word	0x73656400
2002b0f8:	6564652d 	.word	0x6564652d
2002b0fc:	62632d33 	.word	0x62632d33
2002b100:	45440063 	.word	0x45440063
2002b104:	44452d53 	.word	0x44452d53
2002b108:	432d3345 	.word	0x432d3345
2002b10c:	2a004342 	.word	0x2a004342
2002b110:	f7864886 	.word	0xf7864886
2002b114:	0101010d 	.word	0x0101010d
2002b118:	61737200 	.word	0x61737200
2002b11c:	72636e45 	.word	0x72636e45
2002b120:	69747079 	.word	0x69747079
2002b124:	52006e6f 	.word	0x52006e6f
2002b128:	2a004153 	.word	0x2a004153
2002b12c:	3dce4886 	.word	0x3dce4886
2002b130:	69000102 	.word	0x69000102
2002b134:	63652d64 	.word	0x63652d64
2002b138:	6c627550 	.word	0x6c627550
2002b13c:	654b6369 	.word	0x654b6369
2002b140:	65470079 	.word	0x65470079
2002b144:	6972656e 	.word	0x6972656e
2002b148:	43452063 	.word	0x43452063
2002b14c:	79656b20 	.word	0x79656b20
2002b150:	04812b00 	.word	0x04812b00
2002b154:	69000c01 	.word	0x69000c01
2002b158:	63652d64 	.word	0x63652d64
2002b15c:	45004844 	.word	0x45004844
2002b160:	656b2043 	.word	0x656b2043
2002b164:	6f662079 	.word	0x6f662079
2002b168:	43452072 	.word	0x43452072
2002b16c:	2a004844 	.word	0x2a004844
2002b170:	f7864886 	.word	0xf7864886
2002b174:	0e01010d 	.word	0x0e01010d
2002b178:	61687300 	.word	0x61687300
2002b17c:	57343232 	.word	0x57343232
2002b180:	52687469 	.word	0x52687469
2002b184:	6e454153 	.word	0x6e454153
2002b188:	70797263 	.word	0x70797263
2002b18c:	6e6f6974 	.word	0x6e6f6974
2002b190:	41535200 	.word	0x41535200
2002b194:	74697720 	.word	0x74697720
2002b198:	48532068 	.word	0x48532068
2002b19c:	32322d41 	.word	0x32322d41
2002b1a0:	862a0034 	.word	0x862a0034
2002b1a4:	0df78648 	.word	0x0df78648
2002b1a8:	000b0101 	.word	0x000b0101
2002b1ac:	32616873 	.word	0x32616873
2002b1b0:	69573635 	.word	0x69573635
2002b1b4:	53526874 	.word	0x53526874
2002b1b8:	636e4541 	.word	0x636e4541
2002b1bc:	74707972 	.word	0x74707972
2002b1c0:	006e6f69 	.word	0x006e6f69
2002b1c4:	20415352 	.word	0x20415352
2002b1c8:	68746977 	.word	0x68746977
2002b1cc:	41485320 	.word	0x41485320
2002b1d0:	3635322d 	.word	0x3635322d
2002b1d4:	48862a00 	.word	0x48862a00
2002b1d8:	010df786 	.word	0x010df786
2002b1dc:	73000c01 	.word	0x73000c01
2002b1e0:	38336168 	.word	0x38336168
2002b1e4:	74695734 	.word	0x74695734
2002b1e8:	41535268 	.word	0x41535268
2002b1ec:	72636e45 	.word	0x72636e45
2002b1f0:	69747079 	.word	0x69747079
2002b1f4:	52006e6f 	.word	0x52006e6f
2002b1f8:	77204153 	.word	0x77204153
2002b1fc:	20687469 	.word	0x20687469
2002b200:	2d414853 	.word	0x2d414853
2002b204:	00343833 	.word	0x00343833
2002b208:	8648862a 	.word	0x8648862a
2002b20c:	01010df7 	.word	0x01010df7
2002b210:	6873000d 	.word	0x6873000d
2002b214:	32313561 	.word	0x32313561
2002b218:	68746957 	.word	0x68746957
2002b21c:	45415352 	.word	0x45415352
2002b220:	7972636e 	.word	0x7972636e
2002b224:	6f697470 	.word	0x6f697470
2002b228:	5352006e 	.word	0x5352006e
2002b22c:	69772041 	.word	0x69772041
2002b230:	53206874 	.word	0x53206874
2002b234:	352d4148 	.word	0x352d4148
2002b238:	2a003231 	.word	0x2a003231
2002b23c:	f7864886 	.word	0xf7864886
2002b240:	0a01010d 	.word	0x0a01010d
2002b244:	41535200 	.word	0x41535200
2002b248:	2d415353 	.word	0x2d415353
2002b24c:	00535350 	.word	0x00535350
2002b250:	2e617372 	.word	0x2e617372
2002b254:	7372004e 	.word	0x7372004e
2002b258:	00452e61 	.word	0x00452e61

2002b25c <pin_pad_func_lcpu>:
	...
2002b27c:	032100b2 00000301 00000000 024b023b     ..!.........;.K.
2002b28c:	00000237 00000000 00000000 00000000     7...............
2002b29c:	032200b3 00000302 00000000 024b023c     ..".........<.K.
2002b2ac:	00000238 00000000 00000000 00000000     8...............
2002b2bc:	032300b4 00000303 00000000 024b023d     ..#.........=.K.
2002b2cc:	0000023a 00000000 00000000 00000000     :...............
2002b2dc:	032400b5 00000304 00000000 024b023e     ..$.........>.K.
2002b2ec:	00000239 00000000 00000000 00000000     9...............

2002b2fc <pin_pad_func_hcpu>:
	...
2002b31c:	000400f2 00000000 000b0000 00000000     ................
	...
2002b33c:	000900f3 00000000 00030000 00000000     ................
	...
2002b35c:	000a00f4 00000000 000a0000 00000000     ................
	...
2002b37c:	000b00f5 00000000 000b0000 00000000     ................
	...
2002b39c:	000c00f6 00000000 00030000 00000000     ................
	...
2002b3bc:	000300f7 000d0000 00000009 00000000     ................
	...
2002b3dc:	000200f8 000e0000 0000000b 00000000     ................
	...
2002b3fc:	000100f9 000f0000 0009000a 00000000     ................
	...
2002b41c:	000d00fa 00100000 000c0003 00000000     ................
	...
2002b43c:	000e00fb 00060000 00010001 00000000     ................
	...
2002b45c:	000f00fc 00010000 000c000c 00000000     ................
	...
2002b47c:	001000fd 00030000 00090000 00000000     ................
	...
2002b49c:	000500fe 00000006 00000000 00000000     ................
	...
2002b4bc:	01540052 00000000 026302b2 016a0000     R.T.......c...j.
	...
2002b4dc:	00000053 00000000 026402b3 00000000     S.........d.....
	...
2002b4fc:	01550054 01c60000 026502b4 016b019a     T.U.......e...k.
2002b50c:	023b0000 02270000 00000000 00000000     ..;...'.........
2002b51c:	014e0055 01c80000 026602b5 015f0199     U.N.......f..._.
2002b52c:	023c0000 02280000 00000000 00000000     ..<...(.........
2002b53c:	014f0056 01c70000 026702b6 015e0197     V.O.......g...^.
2002b54c:	023d0000 02290000 00000000 00000000     ..=...).........
2002b55c:	01500057 01c40000 026802b7 01680195     W.P.......h...h.
2002b56c:	023e0000 022a0000 00000000 00000000     ..>...*.........
2002b57c:	01510058 01c50000 026902b8 01690194     X.Q.......i...i.
2002b58c:	023f0000 022b0000 00000000 00000000     ..?...+.........
2002b59c:	01520059 01d40000 026a02b9 01600192     Y.R.......j...`.
2002b5ac:	02400000 022c0000 00000000 00000000     ..@...,.........
2002b5bc:	0153005a 01d50000 026b02ba 01610191     Z.S.......k...a.
2002b5cc:	02410000 0000023a 00000000 00000000     ..A.:...........
2002b5dc:	0000005b 00000000 026c02bb 00000000     [.........l.....
2002b5ec:	02420000 00000239 00000000 00000000     ..B.9...........
2002b5fc:	0000005c 00000000 026d02bc 00000000     \.........m.....
	...
2002b61c:	0000005d 00000000 026e02bd 00000000     ].........n.....
2002b62c:	01d30000 02210237 00000000 00000000     ....7.!.........
2002b63c:	001b005e 000001b7 026f02be 00000000     ^.........o.....
2002b64c:	00000000 02220238 00000000 00000000     ....8.".........
2002b65c:	0022005f 000001b8 027002bf 00000000     _.".......p.....
2002b66c:	00000000 02230000 00000000 00000000     ......#.........
2002b67c:	00230060 000001b2 027102c0 00000000     `.#.......q.....
2002b68c:	00000000 02240000 00000000 00000000     ......$.........
2002b69c:	00210061 000001b4 027202c1 00000000     a.!.......r.....
2002b6ac:	00000000 02250000 00000000 00000000     ......%.........
2002b6bc:	00190062 000001b5 027302c2 00000000     b.........s.....
2002b6cc:	00000000 02260000 00000000 00000000     ......&.........
2002b6dc:	00240063 000001b6 027402c3 00000000     c.$.......t.....
	...
2002b6fc:	00000064 0000021a 027502c4 00000000     d.........u.....
	...
2002b71c:	00000065 00000219 027602c5 00000000     e.........v.....
	...
2002b73c:	00000066 00000000 027702c6 00000000     f.........w.....
2002b74c:	024b0000 00000000 00000000 00000000     ..K.............
2002b75c:	00000067 00000000 027802c7 00000000     g.........x.....
	...
2002b77c:	00000068 01d40000 027902c8 00000000     h.........y.....
	...
2002b79c:	00000069 01d50000 027a02c9 00000000     i.........z.....
	...
2002b7bc:	0000006a 01c60149 027b02ca 03620361     j...I.....{.a.b.
2002b7cc:	03640363 03660365 00000000 00000000     c.d.e.f.........
2002b7dc:	0000006b 01c80148 027c02cb 03620361     k...H.....|.a.b.
2002b7ec:	03640363 03660365 00000000 00000000     c.d.e.f.........
2002b7fc:	0000006c 00000000 027d02cc 03620361     l.........}.a.b.
2002b80c:	03640363 03660365 00000000 00000000     c.d.e.f.........
2002b81c:	0000006d 00000000 027e02cd 03620361     m.........~.a.b.
2002b82c:	03640363 03660365 00000000 00000000     c.d.e.f.........
2002b83c:	0000006e 01c70146 027f02ce 00000000     n...F...........
	...
2002b85c:	0000006f 01c40147 028002cf 00000000     o...G...........
	...
2002b87c:	00000070 01c50000 028102d0 00000000     p...............
	...
2002b89c:	00000071 00000000 028202d1 00000000     q...............
2002b8ac:	02430000 00000000 00000000 00000000     ..C.............
2002b8bc:	00000072 00000000 028302d2 00000000     r...............
	...
2002b8dc:	00000073 00000000 028402d3 00000000     s...............
	...
2002b8fc:	00000074 00000000 028502d4 00000000     t...............
	...
2002b91c:	00000075 00000000 028602d5 00000000     u...............
	...
2002b93c:	00000076 00000000 028702d6 00000000     v...............
	...
2002b95c:	00000077 0000014d 028802d7 01620000     w...M.........b.
2002b96c:	02440000 00000000 00000000 00000000     ..D.............
2002b97c:	00000078 0000014c 028902d8 00000000     x...L...........
	...
2002b99c:	00000079 0000014a 028a02d9 01630190     y...J.........c.
2002b9ac:	02450000 022f0000 00000000 00000000     ..E.../.........
2002b9bc:	0000007a 0000014b 028b02da 0164018f     z...K.........d.
2002b9cc:	02460000 02300000 00000000 00000000     ..F...0.........
2002b9dc:	0000007b 00000000 028c02db 01650193     {.............e.
2002b9ec:	02470000 02310000 00000000 00000000     ..G...1.........
2002b9fc:	0000007c 00000000 028d02dc 01660196     |.............f.
2002ba0c:	02480000 02320000 00000000 00000000     ..H...2.........
2002ba1c:	0000007d 00000000 028e02dd 01670198     }.............g.
2002ba2c:	02490000 02330000 00000000 00000000     ..I...3.........
2002ba3c:	0000007e 00000000 028f02de 00000000     ~...............
2002ba4c:	024a0000 02340000 00000000 00000000     ..J...4.........

2002ba5c <HASH_SIZE>:
2002ba5c:	20202014 00000000 04030201 00000000     .   ............
2002ba6c:	01060204                                ....

2002ba70 <CSWTCH.40>:
2002ba70:	0000003f 00003f00 003f0000              ?....?....?.

2002ba7c <hpsys_dll2_limit>:
	...
2002ba84:	112a8800 112a8800                       ..*...*.

2002ba8c <hpsys_dvfs_config>:
2002ba8c:	000906fb 00100330 000a08fd 00110331     ....0.......1...
2002ba9c:	000d0b00 00130213 000f0d02 00130213     ................

2002baac <crc32tab>:
2002baac:	00000000 77073096 ee0e612c 990951ba     .....0.w,a...Q..
2002babc:	076dc419 706af48f e963a535 9e6495a3     ..m...jp5.c...d.
2002bacc:	0edb8832 79dcb8a4 e0d5e91e 97d2d988     2......y........
2002badc:	09b64c2b 7eb17cbd e7b82d07 90bf1d91     +L...|.~.-......
2002baec:	1db71064 6ab020f2 f3b97148 84be41de     d.... .jHq...A..
2002bafc:	1adad47d 6ddde4eb f4d4b551 83d385c7     }......mQ.......
2002bb0c:	136c9856 646ba8c0 fd62f97a 8a65c9ec     V.l...kdz.b...e.
2002bb1c:	14015c4f 63066cd9 fa0f3d63 8d080df5     O\...l.cc=......
2002bb2c:	3b6e20c8 4c69105e d56041e4 a2677172     . n;^.iL.A`.rqg.
2002bb3c:	3c03e4d1 4b04d447 d20d85fd a50ab56b     ...<G..K....k...
2002bb4c:	35b5a8fa 42b2986c dbbbc9d6 acbcf940     ...5l..B....@...
2002bb5c:	32d86ce3 45df5c75 dcd60dcf abd13d59     .l.2u\.E....Y=..
2002bb6c:	26d930ac 51de003a c8d75180 bfd06116     .0.&:..Q.Q...a..
2002bb7c:	21b4f4b5 56b3c423 cfba9599 b8bda50f     ...!#..V........
2002bb8c:	2802b89e 5f058808 c60cd9b2 b10be924     ...(..._....$...
2002bb9c:	2f6f7c87 58684c11 c1611dab b6662d3d     .|o/.LhX..a.=-f.
2002bbac:	76dc4190 01db7106 98d220bc efd5102a     .A.v.q... ..*...
2002bbbc:	71b18589 06b6b51f 9fbfe4a5 e8b8d433     ...q........3...
2002bbcc:	7807c9a2 0f00f934 9609a88e e10e9818     ...x4...........
2002bbdc:	7f6a0dbb 086d3d2d 91646c97 e6635c01     ..j.-=m..ld..\c.
2002bbec:	6b6b51f4 1c6c6162 856530d8 f262004e     .Qkkbal..0e.N.b.
2002bbfc:	6c0695ed 1b01a57b 8208f4c1 f50fc457     ...l{.......W...
2002bc0c:	65b0d9c6 12b7e950 8bbeb8ea fcb9887c     ...eP.......|...
2002bc1c:	62dd1ddf 15da2d49 8cd37cf3 fbd44c65     ...bI-...|..eL..
2002bc2c:	4db26158 3ab551ce a3bc0074 d4bb30e2     Xa.M.Q.:t....0..
2002bc3c:	4adfa541 3dd895d7 a4d1c46d d3d6f4fb     A..J...=m.......
2002bc4c:	4369e96a 346ed9fc ad678846 da60b8d0     j.iC..n4F.g...`.
2002bc5c:	44042d73 33031de5 aa0a4c5f dd0d7cc9     s-.D...3_L...|..
2002bc6c:	5005713c 270241aa be0b1010 c90c2086     <q.P.A.'..... ..
2002bc7c:	5768b525 206f85b3 b966d409 ce61e49f     %.hW..o ..f...a.
2002bc8c:	5edef90e 29d9c998 b0d09822 c7d7a8b4     ...^...)".......
2002bc9c:	59b33d17 2eb40d81 b7bd5c3b c0ba6cad     .=.Y....;\...l..
2002bcac:	edb88320 9abfb3b6 03b6e20c 74b1d29a      ..............t
2002bcbc:	ead54739 9dd277af 04db2615 73dc1683     9G...w...&.....s
2002bccc:	e3630b12 94643b84 0d6d6a3e 7a6a5aa8     ..c..;d.>jm..Zjz
2002bcdc:	e40ecf0b 9309ff9d 0a00ae27 7d079eb1     ........'......}
2002bcec:	f00f9344 8708a3d2 1e01f268 6906c2fe     D.......h......i
2002bcfc:	f762575d 806567cb 196c3671 6e6b06e7     ]Wb..ge.q6l...kn
2002bd0c:	fed41b76 89d32be0 10da7a5a 67dd4acc     v....+..Zz...J.g
2002bd1c:	f9b9df6f 8ebeeff9 17b7be43 60b08ed5     o.......C......`
2002bd2c:	d6d6a3e8 a1d1937e 38d8c2c4 4fdff252     ....~......8R..O
2002bd3c:	d1bb67f1 a6bc5767 3fb506dd 48b2364b     .g..gW.....?K6.H
2002bd4c:	d80d2bda af0a1b4c 36034af6 41047a60     .+..L....J.6`z.A
2002bd5c:	df60efc3 a867df55 316e8eef 4669be79     ..`.U.g...n1y.iF
2002bd6c:	cb61b38c bc66831a 256fd2a0 5268e236     ..a...f...o%6.hR
2002bd7c:	cc0c7795 bb0b4703 220216b9 5505262f     .w...G....."/&.U
2002bd8c:	c5ba3bbe b2bd0b28 2bb45a92 5cb36a04     .;..(....Z.+.j.\
2002bd9c:	c2d7ffa7 b5d0cf31 2cd99e8b 5bdeae1d     ....1......,...[
2002bdac:	9b64c2b0 ec63f226 756aa39c 026d930a     ..d.&.c...ju..m.
2002bdbc:	9c0906a9 eb0e363f 72076785 05005713     ....?6...g.r.W..
2002bdcc:	95bf4a82 e2b87a14 7bb12bae 0cb61b38     .J...z...+.{8...
2002bddc:	92d28e9b e5d5be0d 7cdcefb7 0bdbdf21     ...........|!...
2002bdec:	86d3d2d4 f1d4e242 68ddb3f8 1fda836e     ....B......hn...
2002bdfc:	81be16cd f6b9265b 6fb077e1 18b74777     ....[&...w.owG..
2002be0c:	88085ae6 ff0f6a70 66063bca 11010b5c     .Z..pj...;.f\...
2002be1c:	8f659eff f862ae69 616bffd3 166ccf45     ..e.i.b...kaE.l.
2002be2c:	a00ae278 d70dd2ee 4e048354 3903b3c2     x.......T..N...9
2002be3c:	a7672661 d06016f7 4969474d 3e6e77db     a&g...`.MGiI.wn>
2002be4c:	aed16a4a d9d65adc 40df0b66 37d83bf0     Jj...Z..f..@.;.7
2002be5c:	a9bcae53 debb9ec5 47b2cf7f 30b5ffe9     S..........G...0
2002be6c:	bdbdf21c cabac28a 53b39330 24b4a3a6     ........0..S...$
2002be7c:	bad03605 cdd70693 54de5729 23d967bf     .6......)W.T.g.#
2002be8c:	b3667a2e c4614ab8 5d681b02 2a6f2b94     .zf..Ja...h].+o*
2002be9c:	b40bbe37 c30c8ea1 5a05df1b 2d02ef8d     7..........Z...-

2002beac <CSWTCH.5>:
2002beac:	2002bf4c 2002bf1c 2002beec 2002bebc     L.. ... ... ... 

2002bebc <mbedtls_sha512_info>:
2002bebc:	00000008 2002b06b 00000040 00000080     ....k.. @.......
2002becc:	20026101 200260f7 200260f3 200260ed     .a. .`. .`. .`. 
2002bedc:	200260d1 200260bf 200260bb 200260b7     .`. .`. .`. .`. 

2002beec <mbedtls_sha384_info>:
2002beec:	00000007 2002b072 00000030 00000080     ....r.. 0.......
2002befc:	200260fb 200260f7 200260f3 200260e7     .`. .`. .`. .`. 
2002bf0c:	200260d1 200260bf 200260bb 200260b7     .`. .`. .`. .`. 

2002bf1c <mbedtls_sha256_info>:
2002bf1c:	00000006 2002b079 00000020 00000040     ....y..  ...@...
2002bf2c:	200260b1 200260a7 200260a3 2002609d     .`. .`. .`. .`. 
2002bf3c:	20026081 2002606f 2002606b 20026067     .`. o`. k`. g`. 

2002bf4c <mbedtls_sha224_info>:
2002bf4c:	00000005 2002b080 0000001c 00000040     ....... ....@...
2002bf5c:	200260ab 200260a7 200260a3 20026097     .`. .`. .`. .`. 
2002bf6c:	20026081 2002606f 2002606b 20026067     .`. o`. k`. g`. 

2002bf7c <sha256_padding>:
2002bf7c:	00000080 00000000 00000000 00000000     ................
	...

2002bfbc <K>:
2002bfbc:	428a2f98 71374491 b5c0fbcf e9b5dba5     ./.B.D7q........
2002bfcc:	3956c25b 59f111f1 923f82a4 ab1c5ed5     [.V9...Y..?..^..
2002bfdc:	d807aa98 12835b01 243185be 550c7dc3     .....[....1$.}.U
2002bfec:	72be5d74 80deb1fe 9bdc06a7 c19bf174     t].r........t...
2002bffc:	e49b69c1 efbe4786 0fc19dc6 240ca1cc     .i...G.........$
2002c00c:	2de92c6f 4a7484aa 5cb0a9dc 76f988da     o,.-..tJ...\...v
2002c01c:	983e5152 a831c66d b00327c8 bf597fc7     RQ>.m.1..'....Y.
2002c02c:	c6e00bf3 d5a79147 06ca6351 14292967     ....G...Qc..g)).
2002c03c:	27b70a85 2e1b2138 4d2c6dfc 53380d13     ...'8!...m,M..8S
2002c04c:	650a7354 766a0abb 81c2c92e 92722c85     Ts.e..jv.....,r.
2002c05c:	a2bfe8a1 a81a664b c24b8b70 c76c51a3     ....Kf..p.K..Ql.
2002c06c:	d192e819 d6990624 f40e3585 106aa070     ....$....5..p.j.
2002c07c:	19a4c116 1e376c08 2748774c 34b0bcb5     .....l7.LwH'...4
2002c08c:	391c0cb3 4ed8aa4a 5b9cca4f 682e6ff3     ...9J..NO..[.o.h
2002c09c:	748f82ee 78a5636f 84c87814 8cc70208     ...toc.x.x......
2002c0ac:	90befffa a4506ceb bef9a3f7 c67178f2     .....lP......xq.

2002c0bc <sha512_padding>:
2002c0bc:	00000080 00000000 00000000 00000000     ................
	...

2002c140 <K>:
2002c140:	d728ae22 428a2f98 23ef65cd 71374491     ".(../.B.e.#.D7q
2002c150:	ec4d3b2f b5c0fbcf 8189dbbc e9b5dba5     /;M.............
2002c160:	f348b538 3956c25b b605d019 59f111f1     8.H.[.V9.......Y
2002c170:	af194f9b 923f82a4 da6d8118 ab1c5ed5     .O....?...m..^..
2002c180:	a3030242 d807aa98 45706fbe 12835b01     B........opE.[..
2002c190:	4ee4b28c 243185be d5ffb4e2 550c7dc3     ...N..1$.....}.U
2002c1a0:	f27b896f 72be5d74 3b1696b1 80deb1fe     o.{.t].r...;....
2002c1b0:	25c71235 9bdc06a7 cf692694 c19bf174     5..%.....&i.t...
2002c1c0:	9ef14ad2 e49b69c1 384f25e3 efbe4786     .J...i...%O8.G..
2002c1d0:	8b8cd5b5 0fc19dc6 77ac9c65 240ca1cc     ........e..w...$
2002c1e0:	592b0275 2de92c6f 6ea6e483 4a7484aa     u.+Yo,.-...n..tJ
2002c1f0:	bd41fbd4 5cb0a9dc 831153b5 76f988da     ..A....\.S.....v
2002c200:	ee66dfab 983e5152 2db43210 a831c66d     ..f.RQ>..2.-m.1.
2002c210:	98fb213f b00327c8 beef0ee4 bf597fc7     ?!...'........Y.
2002c220:	3da88fc2 c6e00bf3 930aa725 d5a79147     ...=....%...G...
2002c230:	e003826f 06ca6351 0a0e6e70 14292967     o...Qc..pn..g)).
2002c240:	46d22ffc 27b70a85 5c26c926 2e1b2138     ./.F...'&.&\8!..
2002c250:	5ac42aed 4d2c6dfc 9d95b3df 53380d13     .*.Z.m,M......8S
2002c260:	8baf63de 650a7354 3c77b2a8 766a0abb     .c..Ts.e..w<..jv
2002c270:	47edaee6 81c2c92e 1482353b 92722c85     ...G....;5...,r.
2002c280:	4cf10364 a2bfe8a1 bc423001 a81a664b     d..L.....0B.Kf..
2002c290:	d0f89791 c24b8b70 0654be30 c76c51a3     ....p.K.0.T..Ql.
2002c2a0:	d6ef5218 d192e819 5565a910 d6990624     .R........eU$...
2002c2b0:	5771202a f40e3585 32bbd1b8 106aa070     * qW.5.....2p.j.
2002c2c0:	b8d2d0c8 19a4c116 5141ab53 1e376c08     ........S.AQ.l7.
2002c2d0:	df8eeb99 2748774c e19b48a8 34b0bcb5     ....LwH'.H.....4
2002c2e0:	c5c95a63 391c0cb3 e3418acb 4ed8aa4a     cZ.....9..A.J..N
2002c2f0:	7763e373 5b9cca4f d6b2b8a3 682e6ff3     s.cwO..[.....o.h
2002c300:	5defb2fc 748f82ee 43172f60 78a5636f     ...]...t`/.Coc.x
2002c310:	a1f0ab72 84c87814 1a6439ec 8cc70208     r....x...9d.....
2002c320:	23631e28 90befffa de82bde9 a4506ceb     (.c#.........lP.
2002c330:	b2c67915 bef9a3f7 e372532b c67178f2     .y......+Sr..xq.
2002c340:	ea26619c ca273ece 21c0c207 d186b8c7     .a&..>'....!....
2002c350:	cde0eb1e eada7dd6 ee6ed178 f57d4f7f     .....}..x.n..O}.
2002c360:	72176fba 06f067aa a2c898a6 0a637dc5     .o.r.g.......}c.
2002c370:	bef90dae 113f9804 131c471b 1b710b35     ......?..G..5.q.
2002c380:	23047d84 28db77f5 40c72493 32caab7b     .}.#.w.(.$.@{..2
2002c390:	15c9bebc 3c9ebe0a 9c100d4c 431d67c4     .......<L....g.C
2002c3a0:	cb3e42b6 4cc5d4be fc657e2a 597f299c     .B>....L*~e..).Y
2002c3b0:	3ad6faec 5fcb6fab 4a475817 6c44198c     ...:.o._.XGJ..Dl

2002c3c0 <oid_md_alg>:
2002c3c0:	2002b087 00000009 2002b091 2002b19a     ... ....... ... 
2002c3d0:	00000005 2002b09b 00000009 2002b0a5     ....... ....... 
2002c3e0:	2002b1cd 00000006 2002b0af 00000009     ... ....... ....
2002c3f0:	2002b0b9 2002b200 00000007 2002b0c3     ... ... ....... 
2002c400:	00000009 2002b0cd 2002b233 00000008     ....... 3.. ....
	...

2002c424 <oid_pk_alg>:
2002c424:	2002b10f 00000009 2002b119 2002b127     ... ....... '.. 
2002c434:	00000001 2002b12b 00000007 2002b133     ....+.. ....3.. 
2002c444:	2002b142 00000002 2002b151 00000005     B.. ....Q.. ....
2002c454:	2002b157 2002b15f 00000003 00000000     W.. _.. ........
	...

2002c474 <mbedtls_rsa_info>:
2002c474:	00000001 2002b127 20029777 2002976b     ....'.. w.. k.. 
2002c484:	20029851 2002982d 20029801 200297d1     Q.. -.. ... ... 
2002c494:	200297cd 200297b3 200297a1 2002977d     ... ... ... }.. 

2002c4a4 <_init>:
2002c4a4:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
2002c4a6:	bf00      	nop
2002c4a8:	bcf8      	pop	{r3, r4, r5, r6, r7}
2002c4aa:	bc08      	pop	{r3}
2002c4ac:	469e      	mov	lr, r3
2002c4ae:	4770      	bx	lr

2002c4b0 <_fini>:
2002c4b0:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
2002c4b2:	bf00      	nop
2002c4b4:	bcf8      	pop	{r3, r4, r5, r6, r7}
2002c4b6:	bc08      	pop	{r3}
2002c4b8:	469e      	mov	lr, r3
2002c4ba:	4770      	bx	lr

2002c4bc <__EH_FRAME_BEGIN__>:
2002c4bc:	0000 0000                                   ....

Disassembly of section .l1_ret_text_HAL_Set_backup:

2002c4c0 <HAL_Set_backup>:
2002c4c0:	4b01      	ldr	r3, [pc, #4]	@ (2002c4c8 <HAL_Set_backup+0x8>)
2002c4c2:	f843 1020 	str.w	r1, [r3, r0, lsl #2]
2002c4c6:	4770      	bx	lr
2002c4c8:	500cb030 	.word	0x500cb030

Disassembly of section .l1_ret_text_HAL_Get_backup:

2002c4cc <HAL_Get_backup>:
2002c4cc:	4b01      	ldr	r3, [pc, #4]	@ (2002c4d4 <HAL_Get_backup+0x8>)
2002c4ce:	f853 0020 	ldr.w	r0, [r3, r0, lsl #2]
2002c4d2:	4770      	bx	lr
2002c4d4:	500cb030 	.word	0x500cb030

Disassembly of section .l1_ret_text_HAL_PMU_ConfigPeriLdo:

2002c4d8 <HAL_PMU_ConfigPeriLdo>:
2002c4d8:	b538      	push	{r3, r4, r5, lr}
2002c4da:	b150      	cbz	r0, 2002c4f2 <HAL_PMU_ConfigPeriLdo+0x1a>
2002c4dc:	4c18      	ldr	r4, [pc, #96]	@ (2002c540 <HAL_PMU_ConfigPeriLdo+0x68>)
2002c4de:	6863      	ldr	r3, [r4, #4]
2002c4e0:	b2db      	uxtb	r3, r3
2002c4e2:	2b07      	cmp	r3, #7
2002c4e4:	d101      	bne.n	2002c4ea <HAL_PMU_ConfigPeriLdo+0x12>
2002c4e6:	2000      	movs	r0, #0
2002c4e8:	bd38      	pop	{r3, r4, r5, pc}
2002c4ea:	6863      	ldr	r3, [r4, #4]
2002c4ec:	b2db      	uxtb	r3, r3
2002c4ee:	2b0f      	cmp	r3, #15
2002c4f0:	d0f9      	beq.n	2002c4e6 <HAL_PMU_ConfigPeriLdo+0xe>
2002c4f2:	4c13      	ldr	r4, [pc, #76]	@ (2002c540 <HAL_PMU_ConfigPeriLdo+0x68>)
2002c4f4:	6863      	ldr	r3, [r4, #4]
2002c4f6:	b2db      	uxtb	r3, r3
2002c4f8:	2b07      	cmp	r3, #7
2002c4fa:	d0f4      	beq.n	2002c4e6 <HAL_PMU_ConfigPeriLdo+0xe>
2002c4fc:	6863      	ldr	r3, [r4, #4]
2002c4fe:	b2db      	uxtb	r3, r3
2002c500:	2b0f      	cmp	r3, #15
2002c502:	d0f0      	beq.n	2002c4e6 <HAL_PMU_ConfigPeriLdo+0xe>
2002c504:	2810      	cmp	r0, #16
2002c506:	d818      	bhi.n	2002c53a <HAL_PMU_ConfigPeriLdo+0x62>
2002c508:	4b0e      	ldr	r3, [pc, #56]	@ (2002c544 <HAL_PMU_ConfigPeriLdo+0x6c>)
2002c50a:	40c3      	lsrs	r3, r0
2002c50c:	07db      	lsls	r3, r3, #31
2002c50e:	d514      	bpl.n	2002c53a <HAL_PMU_ConfigPeriLdo+0x62>
2002c510:	2900      	cmp	r1, #0
2002c512:	f04f 0421 	mov.w	r4, #33	@ 0x21
2002c516:	bf0c      	ite	eq
2002c518:	2120      	moveq	r1, #32
2002c51a:	2101      	movne	r1, #1
2002c51c:	4d0a      	ldr	r5, [pc, #40]	@ (2002c548 <HAL_PMU_ConfigPeriLdo+0x70>)
2002c51e:	4084      	lsls	r4, r0
2002c520:	6deb      	ldr	r3, [r5, #92]	@ 0x5c
2002c522:	4081      	lsls	r1, r0
2002c524:	ea23 0304 	bic.w	r3, r3, r4
2002c528:	430b      	orrs	r3, r1
2002c52a:	65eb      	str	r3, [r5, #92]	@ 0x5c
2002c52c:	2a00      	cmp	r2, #0
2002c52e:	d0da      	beq.n	2002c4e6 <HAL_PMU_ConfigPeriLdo+0xe>
2002c530:	f241 3088 	movw	r0, #5000	@ 0x1388
2002c534:	f7f5 fe61 	bl	200221fa <HAL_Delay_us>
2002c538:	e7d5      	b.n	2002c4e6 <HAL_PMU_ConfigPeriLdo+0xe>
2002c53a:	2001      	movs	r0, #1
2002c53c:	e7d4      	b.n	2002c4e8 <HAL_PMU_ConfigPeriLdo+0x10>
2002c53e:	bf00      	nop
2002c540:	5000b000 	.word	0x5000b000
2002c544:	00010101 	.word	0x00010101
2002c548:	500ca000 	.word	0x500ca000

Disassembly of section .l1_ret_text_HAL_PMU_Reboot:

2002c54c <HAL_PMU_Reboot>:
2002c54c:	b538      	push	{r3, r4, r5, lr}
2002c54e:	f3ef 8310 	mrs	r3, PRIMASK
2002c552:	2501      	movs	r5, #1
2002c554:	f385 8810 	msr	PRIMASK, r5
2002c558:	2002      	movs	r0, #2
2002c55a:	f7f6 fb53 	bl	20022c04 <HAL_HPAON_WakeCore>
2002c55e:	4628      	mov	r0, r5
2002c560:	f7f8 ff60 	bl	20025424 <HAL_RCC_Reset_and_Halt_LCPU>
2002c564:	462a      	mov	r2, r5
2002c566:	2100      	movs	r1, #0
2002c568:	2008      	movs	r0, #8
2002c56a:	f7ff ffb5 	bl	2002c4d8 <HAL_PMU_ConfigPeriLdo>
2002c56e:	f44f 50fa 	mov.w	r0, #8000	@ 0x1f40
2002c572:	f7f5 fde3 	bl	2002213c <HAL_Delay_us_>
2002c576:	2000      	movs	r0, #0
2002c578:	f7f8 fd54 	bl	20025024 <HAL_RCC_HCPU_GetClockSrc>
2002c57c:	4604      	mov	r4, r0
2002c57e:	b928      	cbnz	r0, 2002c58c <HAL_PMU_Reboot+0x40>
2002c580:	f7f6 fb6a 	bl	20022c58 <HAL_HPAON_EnableXT48>
2002c584:	4629      	mov	r1, r5
2002c586:	4620      	mov	r0, r4
2002c588:	f7f8 fe14 	bl	200251b4 <HAL_RCC_HCPU_ClockSelect>
2002c58c:	4b10      	ldr	r3, [pc, #64]	@ (2002c5d0 <HAL_PMU_Reboot+0x84>)
2002c58e:	4c11      	ldr	r4, [pc, #68]	@ (2002c5d4 <HAL_PMU_Reboot+0x88>)
2002c590:	2000      	movs	r0, #0
2002c592:	6763      	str	r3, [r4, #116]	@ 0x74
2002c594:	f7ff ff9a 	bl	2002c4cc <HAL_Get_backup>
2002c598:	4601      	mov	r1, r0
2002c59a:	f020 407f 	bic.w	r0, r0, #4278190080	@ 0xff000000
2002c59e:	f020 000f 	bic.w	r0, r0, #15
2002c5a2:	b928      	cbnz	r0, 2002c5b0 <HAL_PMU_Reboot+0x64>
2002c5a4:	f441 41a0 	orr.w	r1, r1, #20480	@ 0x5000
2002c5a8:	f041 0150 	orr.w	r1, r1, #80	@ 0x50
2002c5ac:	f7ff ff88 	bl	2002c4c0 <HAL_Set_backup>
2002c5b0:	6823      	ldr	r3, [r4, #0]
2002c5b2:	075b      	lsls	r3, r3, #29
2002c5b4:	d506      	bpl.n	2002c5c4 <HAL_PMU_Reboot+0x78>
2002c5b6:	6823      	ldr	r3, [r4, #0]
2002c5b8:	4807      	ldr	r0, [pc, #28]	@ (2002c5d8 <HAL_PMU_Reboot+0x8c>)
2002c5ba:	f023 0304 	bic.w	r3, r3, #4
2002c5be:	6023      	str	r3, [r4, #0]
2002c5c0:	f7f5 fe1b 	bl	200221fa <HAL_Delay_us>
2002c5c4:	4a03      	ldr	r2, [pc, #12]	@ (2002c5d4 <HAL_PMU_Reboot+0x88>)
2002c5c6:	6813      	ldr	r3, [r2, #0]
2002c5c8:	f043 0304 	orr.w	r3, r3, #4
2002c5cc:	6013      	str	r3, [r2, #0]
2002c5ce:	e7fe      	b.n	2002c5ce <HAL_PMU_Reboot+0x82>
2002c5d0:	0a50c015 	.word	0x0a50c015
2002c5d4:	500ca000 	.word	0x500ca000
2002c5d8:	000186a0 	.word	0x000186a0

Disassembly of section .l1_ret_text_HAL_PMU_GetHpsysVoutRef:

2002c5dc <HAL_PMU_GetHpsysVoutRef>:
2002c5dc:	4b04      	ldr	r3, [pc, #16]	@ (2002c5f0 <HAL_PMU_GetHpsysVoutRef+0x14>)
2002c5de:	781a      	ldrb	r2, [r3, #0]
2002c5e0:	b122      	cbz	r2, 2002c5ec <HAL_PMU_GetHpsysVoutRef+0x10>
2002c5e2:	b118      	cbz	r0, 2002c5ec <HAL_PMU_GetHpsysVoutRef+0x10>
2002c5e4:	78db      	ldrb	r3, [r3, #3]
2002c5e6:	7003      	strb	r3, [r0, #0]
2002c5e8:	2000      	movs	r0, #0
2002c5ea:	4770      	bx	lr
2002c5ec:	2001      	movs	r0, #1
2002c5ee:	4770      	bx	lr
2002c5f0:	2004cc70 	.word	0x2004cc70

Disassembly of section .l1_ret_text_HAL_PMU_GetHpsysVoutRef2:

2002c5f4 <HAL_PMU_GetHpsysVoutRef2>:
2002c5f4:	4b04      	ldr	r3, [pc, #16]	@ (2002c608 <HAL_PMU_GetHpsysVoutRef2+0x14>)
2002c5f6:	781a      	ldrb	r2, [r3, #0]
2002c5f8:	b122      	cbz	r2, 2002c604 <HAL_PMU_GetHpsysVoutRef2+0x10>
2002c5fa:	b118      	cbz	r0, 2002c604 <HAL_PMU_GetHpsysVoutRef2+0x10>
2002c5fc:	7b5b      	ldrb	r3, [r3, #13]
2002c5fe:	7003      	strb	r3, [r0, #0]
2002c600:	2000      	movs	r0, #0
2002c602:	4770      	bx	lr
2002c604:	2001      	movs	r0, #1
2002c606:	4770      	bx	lr
2002c608:	2004cc70 	.word	0x2004cc70
