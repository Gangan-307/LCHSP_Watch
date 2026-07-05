
build_sf32lb52-lchspi-ulp_hcpu\lcpu\lcpu.elf:     file format elf32-littlearm


Disassembly of section .text:

00400000 <__Vectors>:
  400000:	204019a8 	.word	0x204019a8
  400004:	0040027d 	.word	0x0040027d
  400008:	0040035d 	.word	0x0040035d
  40000c:	000008a9 	.word	0x000008a9
  400010:	000008e5 	.word	0x000008e5
  400014:	004002c7 	.word	0x004002c7
  400018:	004002c7 	.word	0x004002c7
  40001c:	004002c7 	.word	0x004002c7
	...
  40002c:	004002c7 	.word	0x004002c7
  400030:	004002c7 	.word	0x004002c7
  400034:	00000000 	.word	0x00000000
  400038:	0000080d 	.word	0x0000080d
  40003c:	00400d89 	.word	0x00400d89
  400040:	00400cb5 	.word	0x00400cb5
  400044:	00004fa1 	.word	0x00004fa1
  400048:	004002c7 	.word	0x004002c7
  40004c:	004002c7 	.word	0x004002c7
  400050:	004002c7 	.word	0x004002c7
  400054:	004002c7 	.word	0x004002c7
  400058:	004002c7 	.word	0x004002c7
  40005c:	004002c7 	.word	0x004002c7
  400060:	004002c7 	.word	0x004002c7
  400064:	004002c7 	.word	0x004002c7
  400068:	004002c7 	.word	0x004002c7
  40006c:	00007361 	.word	0x00007361
  400070:	004002c7 	.word	0x004002c7
  400074:	004002c7 	.word	0x004002c7
  400078:	004002c7 	.word	0x004002c7
  40007c:	00005901 	.word	0x00005901
  400080:	004002c7 	.word	0x004002c7
  400084:	004002c7 	.word	0x004002c7
  400088:	00400955 	.word	0x00400955
  40008c:	004002c7 	.word	0x004002c7
  400090:	004002c7 	.word	0x004002c7
  400094:	004002c7 	.word	0x004002c7
  400098:	004002c7 	.word	0x004002c7
  40009c:	00400a4d 	.word	0x00400a4d
  4000a0:	004002c7 	.word	0x004002c7
  4000a4:	004002c7 	.word	0x004002c7
  4000a8:	004002c7 	.word	0x004002c7
  4000ac:	004002c7 	.word	0x004002c7
  4000b0:	004002c7 	.word	0x004002c7
  4000b4:	004002c7 	.word	0x004002c7
  4000b8:	004002c7 	.word	0x004002c7
  4000bc:	004002c7 	.word	0x004002c7
	...

00400100 <deregister_tm_clones>:
  400100:	4803      	ldr	r0, [pc, #12]	@ (400110 <deregister_tm_clones+0x10>)
  400102:	4b04      	ldr	r3, [pc, #16]	@ (400114 <deregister_tm_clones+0x14>)
  400104:	4283      	cmp	r3, r0
  400106:	d002      	beq.n	40010e <deregister_tm_clones+0xe>
  400108:	4b03      	ldr	r3, [pc, #12]	@ (400118 <deregister_tm_clones+0x18>)
  40010a:	b103      	cbz	r3, 40010e <deregister_tm_clones+0xe>
  40010c:	4718      	bx	r3
  40010e:	4770      	bx	lr
  400110:	204015a4 	.word	0x204015a4
  400114:	204015a4 	.word	0x204015a4
  400118:	00000000 	.word	0x00000000

0040011c <register_tm_clones>:
  40011c:	4b06      	ldr	r3, [pc, #24]	@ (400138 <register_tm_clones+0x1c>)
  40011e:	4907      	ldr	r1, [pc, #28]	@ (40013c <register_tm_clones+0x20>)
  400120:	1ac9      	subs	r1, r1, r3
  400122:	1089      	asrs	r1, r1, #2
  400124:	bf48      	it	mi
  400126:	3101      	addmi	r1, #1
  400128:	1049      	asrs	r1, r1, #1
  40012a:	d003      	beq.n	400134 <register_tm_clones+0x18>
  40012c:	4b04      	ldr	r3, [pc, #16]	@ (400140 <register_tm_clones+0x24>)
  40012e:	b10b      	cbz	r3, 400134 <register_tm_clones+0x18>
  400130:	4801      	ldr	r0, [pc, #4]	@ (400138 <register_tm_clones+0x1c>)
  400132:	4718      	bx	r3
  400134:	4770      	bx	lr
  400136:	bf00      	nop
  400138:	204015a4 	.word	0x204015a4
  40013c:	204015a4 	.word	0x204015a4
  400140:	00000000 	.word	0x00000000

00400144 <__do_global_dtors_aux>:
  400144:	b510      	push	{r4, lr}
  400146:	4c06      	ldr	r4, [pc, #24]	@ (400160 <__do_global_dtors_aux+0x1c>)
  400148:	7823      	ldrb	r3, [r4, #0]
  40014a:	b943      	cbnz	r3, 40015e <__do_global_dtors_aux+0x1a>
  40014c:	f7ff ffd8 	bl	400100 <deregister_tm_clones>
  400150:	4b04      	ldr	r3, [pc, #16]	@ (400164 <__do_global_dtors_aux+0x20>)
  400152:	b113      	cbz	r3, 40015a <__do_global_dtors_aux+0x16>
  400154:	4804      	ldr	r0, [pc, #16]	@ (400168 <__do_global_dtors_aux+0x24>)
  400156:	f3af 8000 	nop.w
  40015a:	2301      	movs	r3, #1
  40015c:	7023      	strb	r3, [r4, #0]
  40015e:	bd10      	pop	{r4, pc}
  400160:	204019a8 	.word	0x204019a8
  400164:	00000000 	.word	0x00000000
  400168:	0040154c 	.word	0x0040154c

0040016c <frame_dummy>:
  40016c:	b508      	push	{r3, lr}
  40016e:	4b05      	ldr	r3, [pc, #20]	@ (400184 <frame_dummy+0x18>)
  400170:	b11b      	cbz	r3, 40017a <frame_dummy+0xe>
  400172:	4905      	ldr	r1, [pc, #20]	@ (400188 <frame_dummy+0x1c>)
  400174:	4805      	ldr	r0, [pc, #20]	@ (40018c <frame_dummy+0x20>)
  400176:	f3af 8000 	nop.w
  40017a:	e8bd 4008 	ldmia.w	sp!, {r3, lr}
  40017e:	f7ff bfcd 	b.w	40011c <register_tm_clones>
  400182:	bf00      	nop
  400184:	00000000 	.word	0x00000000
  400188:	204019ac 	.word	0x204019ac
  40018c:	0040154c 	.word	0x0040154c

00400190 <HAL_MspInit>:
  400190:	4770      	bx	lr

00400192 <SystemClock_Config>:
  400192:	4770      	bx	lr

00400194 <rc10k_cal_hook_func>:
  400194:	b537      	push	{r0, r1, r2, r4, r5, lr}
  400196:	f640 32b8 	movw	r2, #3000	@ 0xbb8
  40019a:	4b08      	ldr	r3, [pc, #32]	@ (4001bc <rc10k_cal_hook_func+0x28>)
  40019c:	4c08      	ldr	r4, [pc, #32]	@ (4001c0 <rc10k_cal_hook_func+0x2c>)
  40019e:	6c9d      	ldr	r5, [r3, #72]	@ 0x48
  4001a0:	6823      	ldr	r3, [r4, #0]
  4001a2:	1aeb      	subs	r3, r5, r3
  4001a4:	4293      	cmp	r3, r2
  4001a6:	d906      	bls.n	4001b6 <rc10k_cal_hook_func+0x22>
  4001a8:	f000 f92c 	bl	400404 <HAL_RC_CAL_GetLPCycle_ex>
  4001ac:	a901      	add	r1, sp, #4
  4001ae:	f000 f939 	bl	400424 <HAL_RC_CALget_curr_cycle_on_48M>
  4001b2:	b900      	cbnz	r0, 4001b6 <rc10k_cal_hook_func+0x22>
  4001b4:	6025      	str	r5, [r4, #0]
  4001b6:	b003      	add	sp, #12
  4001b8:	bd30      	pop	{r4, r5, pc}
  4001ba:	bf00      	nop
  4001bc:	40040000 	.word	0x40040000
  4001c0:	204019c4 	.word	0x204019c4

004001c4 <rc10k_cal_init>:
  4001c4:	b507      	push	{r0, r1, r2, lr}
  4001c6:	4b0b      	ldr	r3, [pc, #44]	@ (4001f4 <rc10k_cal_init+0x30>)
  4001c8:	f893 30db 	ldrb.w	r3, [r3, #219]	@ 0xdb
  4001cc:	b173      	cbz	r3, 4001ec <rc10k_cal_init+0x28>
  4001ce:	4b0a      	ldr	r3, [pc, #40]	@ (4001f8 <rc10k_cal_init+0x34>)
  4001d0:	480a      	ldr	r0, [pc, #40]	@ (4001fc <rc10k_cal_init+0x38>)
  4001d2:	6c9a      	ldr	r2, [r3, #72]	@ 0x48
  4001d4:	4b0a      	ldr	r3, [pc, #40]	@ (400200 <rc10k_cal_init+0x3c>)
  4001d6:	601a      	str	r2, [r3, #0]
  4001d8:	f455 fd92 	bl	55d00 <rt_thread_idle_sethook>
  4001dc:	2014      	movs	r0, #20
  4001de:	f000 f917 	bl	400410 <HAL_RC_CAL_SetLPCycle_ex>
  4001e2:	f000 f90f 	bl	400404 <HAL_RC_CAL_GetLPCycle_ex>
  4001e6:	a901      	add	r1, sp, #4
  4001e8:	f000 f91c 	bl	400424 <HAL_RC_CALget_curr_cycle_on_48M>
  4001ec:	2000      	movs	r0, #0
  4001ee:	b003      	add	sp, #12
  4001f0:	f85d fb04 	ldr.w	pc, [sp], #4
  4001f4:	2040fd00 	.word	0x2040fd00
  4001f8:	40040000 	.word	0x40040000
  4001fc:	00400195 	.word	0x00400195
  400200:	204019c4 	.word	0x204019c4

00400204 <main>:
  400204:	2000      	movs	r0, #0
  400206:	4770      	bx	lr

00400208 <HAL_PreInit>:
  400208:	b508      	push	{r3, lr}
  40020a:	f401 fed1 	bl	1fb0 <HAL_LPAON_EnableXT48>
  40020e:	f04f 4280 	mov.w	r2, #1073741824	@ 0x40000000
  400212:	6913      	ldr	r3, [r2, #16]
  400214:	2101      	movs	r1, #1
  400216:	f023 0303 	bic.w	r3, r3, #3
  40021a:	f043 0301 	orr.w	r3, r3, #1
  40021e:	6113      	str	r3, [r2, #16]
  400220:	6913      	ldr	r3, [r2, #16]
  400222:	2002      	movs	r0, #2
  400224:	f043 0310 	orr.w	r3, r3, #16
  400228:	6113      	str	r3, [r2, #16]
  40022a:	2203      	movs	r2, #3
  40022c:	f402 f88c 	bl	2348 <HAL_RCC_LCPU_SetDiv>
  400230:	e8bd 4008 	ldmia.w	sp!, {r3, lr}
  400234:	f7ff bfac 	b.w	400190 <HAL_MspInit>

00400238 <hw_preinit0>:
  400238:	4770      	bx	lr
	...

0040023c <SystemInit>:
  40023c:	b508      	push	{r3, lr}
  40023e:	4a0b      	ldr	r2, [pc, #44]	@ (40026c <SystemInit+0x30>)
  400240:	4b0b      	ldr	r3, [pc, #44]	@ (400270 <SystemInit+0x34>)
  400242:	609a      	str	r2, [r3, #8]
  400244:	f8d3 2088 	ldr.w	r2, [r3, #136]	@ 0x88
  400248:	f042 023f 	orr.w	r2, r2, #63	@ 0x3f
  40024c:	f8c3 2088 	str.w	r2, [r3, #136]	@ 0x88
  400250:	f7ff fff2 	bl	400238 <hw_preinit0>
  400254:	f450 f9ba 	bl	505cc <mpu_config>
  400258:	f405 fe76 	bl	5f48 <cache_enable>
  40025c:	f000 fc65 	bl	400b2a <SystemPowerOnModeInit>
  400260:	f451 f836 	bl	512d0 <rom_scatterload>
  400264:	4b03      	ldr	r3, [pc, #12]	@ (400274 <SystemInit+0x38>)
  400266:	4a04      	ldr	r2, [pc, #16]	@ (400278 <SystemInit+0x3c>)
  400268:	601a      	str	r2, [r3, #0]
  40026a:	bd08      	pop	{r3, pc}
  40026c:	00400000 	.word	0x00400000
  400270:	e000ed00 	.word	0xe000ed00
  400274:	20401568 	.word	0x20401568
  400278:	017d7840 	.word	0x017d7840

0040027c <Reset_Handler>:
  40027c:	f8df d048 	ldr.w	sp, [pc, #72]	@ 4002c8 <BTIM3_IRQHandler+0x2>
  400280:	4812      	ldr	r0, [pc, #72]	@ (4002cc <BTIM3_IRQHandler+0x6>)
  400282:	f380 880a 	msr	MSPLIM, r0
  400286:	f7ff ffd9 	bl	40023c <SystemInit>
  40028a:	4c11      	ldr	r4, [pc, #68]	@ (4002d0 <BTIM3_IRQHandler+0xa>)
  40028c:	4d11      	ldr	r5, [pc, #68]	@ (4002d4 <BTIM3_IRQHandler+0xe>)
  40028e:	42ac      	cmp	r4, r5
  400290:	da09      	bge.n	4002a6 <Reset_Handler+0x2a>
  400292:	6821      	ldr	r1, [r4, #0]
  400294:	6862      	ldr	r2, [r4, #4]
  400296:	68a3      	ldr	r3, [r4, #8]
  400298:	3b04      	subs	r3, #4
  40029a:	bfa2      	ittt	ge
  40029c:	58c8      	ldrge	r0, [r1, r3]
  40029e:	50d0      	strge	r0, [r2, r3]
  4002a0:	e7fa      	bge.n	400298 <Reset_Handler+0x1c>
  4002a2:	340c      	adds	r4, #12
  4002a4:	e7f3      	b.n	40028e <Reset_Handler+0x12>
  4002a6:	4b0c      	ldr	r3, [pc, #48]	@ (4002d8 <BTIM3_IRQHandler+0x12>)
  4002a8:	4c0c      	ldr	r4, [pc, #48]	@ (4002dc <BTIM3_IRQHandler+0x16>)
  4002aa:	42a3      	cmp	r3, r4
  4002ac:	da08      	bge.n	4002c0 <Reset_Handler+0x44>
  4002ae:	6819      	ldr	r1, [r3, #0]
  4002b0:	685a      	ldr	r2, [r3, #4]
  4002b2:	2000      	movs	r0, #0
  4002b4:	3a04      	subs	r2, #4
  4002b6:	bfa4      	itt	ge
  4002b8:	5088      	strge	r0, [r1, r2]
  4002ba:	e7fb      	bge.n	4002b4 <Reset_Handler+0x38>
  4002bc:	3308      	adds	r3, #8
  4002be:	e7f4      	b.n	4002aa <Reset_Handler+0x2e>
  4002c0:	f000 fe42 	bl	400f48 <entry>
  4002c4:	e7fe      	b.n	4002c4 <Reset_Handler+0x48>

004002c6 <BTIM3_IRQHandler>:
  4002c6:	e7fe      	b.n	4002c6 <BTIM3_IRQHandler>
  4002c8:	204019a8 	.word	0x204019a8
  4002cc:	204015a8 	.word	0x204015a8
  4002d0:	00401560 	.word	0x00401560
  4002d4:	00401560 	.word	0x00401560
  4002d8:	00401560 	.word	0x00401560
  4002dc:	00401568 	.word	0x00401568

004002e0 <__aeabi_unwind_cpp_pr0>:
  4002e0:	2000      	movs	r0, #0
  4002e2:	4770      	bx	lr

004002e4 <HAL_PostMspInit>:
  4002e4:	4770      	bx	lr

004002e6 <HAL_Init>:
  4002e6:	b508      	push	{r3, lr}
  4002e8:	f7ff ff8e 	bl	400208 <HAL_PreInit>
  4002ec:	f7ff fffa 	bl	4002e4 <HAL_PostMspInit>
  4002f0:	f000 f9df 	bl	4006b2 <HAL_RCC_Init>
  4002f4:	2003      	movs	r0, #3
  4002f6:	f401 fefb 	bl	20f0 <HAL_NVIC_SetPriorityGrouping>
  4002fa:	2000      	movs	r0, #0
  4002fc:	f000 fd41 	bl	400d82 <HAL_InitTick>
  400300:	3800      	subs	r0, #0
  400302:	bf18      	it	ne
  400304:	2001      	movne	r0, #1
  400306:	bd08      	pop	{r3, pc}

00400308 <HAL_IncTick>:
  400308:	4a02      	ldr	r2, [pc, #8]	@ (400314 <HAL_IncTick+0xc>)
  40030a:	6813      	ldr	r3, [r2, #0]
  40030c:	3301      	adds	r3, #1
  40030e:	6013      	str	r3, [r2, #0]
  400310:	4770      	bx	lr
  400312:	bf00      	nop
  400314:	204019c8 	.word	0x204019c8

00400318 <HAL_Delay_us>:
  400318:	4603      	mov	r3, r0
  40031a:	b570      	push	{r4, r5, r6, lr}
  40031c:	b1b8      	cbz	r0, 40034e <HAL_Delay_us+0x36>
  40031e:	f242 7510 	movw	r5, #10000	@ 0x2710
  400322:	f04f 26e0 	mov.w	r6, #3758153728	@ 0xe000e000
  400326:	42ab      	cmp	r3, r5
  400328:	bf84      	itt	hi
  40032a:	f5a3 541c 	subhi.w	r4, r3, #9984	@ 0x2700
  40032e:	f242 7310 	movwhi	r3, #10000	@ 0x2710
  400332:	6932      	ldr	r2, [r6, #16]
  400334:	bf98      	it	ls
  400336:	2400      	movls	r4, #0
  400338:	4618      	mov	r0, r3
  40033a:	bf88      	it	hi
  40033c:	3c10      	subhi	r4, #16
  40033e:	07d3      	lsls	r3, r2, #31
  400340:	d508      	bpl.n	400354 <HAL_Delay_us+0x3c>
  400342:	f401 fca5 	bl	1c90 <HAL_Delay_us2_>
  400346:	4623      	mov	r3, r4
  400348:	2c00      	cmp	r4, #0
  40034a:	d1ec      	bne.n	400326 <HAL_Delay_us+0xe>
  40034c:	e001      	b.n	400352 <HAL_Delay_us+0x3a>
  40034e:	f401 fcbd 	bl	1ccc <HAL_Delay_us_>
  400352:	bd70      	pop	{r4, r5, r6, pc}
  400354:	f401 fcba 	bl	1ccc <HAL_Delay_us_>
  400358:	e7f5      	b.n	400346 <HAL_Delay_us+0x2e>
	...

0040035c <NMI_Handler>:
  40035c:	b508      	push	{r3, lr}
  40035e:	4b05      	ldr	r3, [pc, #20]	@ (400374 <NMI_Handler+0x18>)
  400360:	691b      	ldr	r3, [r3, #16]
  400362:	005b      	lsls	r3, r3, #1
  400364:	d502      	bpl.n	40036c <NMI_Handler+0x10>
  400366:	f000 fbb5 	bl	400ad4 <DBG_Trigger_IRQHandler>
  40036a:	bd08      	pop	{r3, pc}
  40036c:	f000 fcac 	bl	400cc8 <WDT_IRQHandler>
  400370:	e7fb      	b.n	40036a <NMI_Handler+0xe>
  400372:	bf00      	nop
  400374:	4000f000 	.word	0x4000f000

00400378 <HAL_GPIO_Restore>:
  400378:	4b11      	ldr	r3, [pc, #68]	@ (4003c0 <HAL_GPIO_Restore+0x48>)
  40037a:	b5f0      	push	{r4, r5, r6, r7, lr}
  40037c:	4298      	cmp	r0, r3
  40037e:	d11b      	bne.n	4003b8 <HAL_GPIO_Restore+0x40>
  400380:	2a03      	cmp	r2, #3
  400382:	d11b      	bne.n	4003bc <HAL_GPIO_Restore+0x44>
  400384:	2400      	movs	r4, #0
  400386:	271c      	movs	r7, #28
  400388:	fb07 f604 	mul.w	r6, r7, r4
  40038c:	198d      	adds	r5, r1, r6
  40038e:	598e      	ldr	r6, [r1, r6]
  400390:	eb00 13c4 	add.w	r3, r0, r4, lsl #7
  400394:	605e      	str	r6, [r3, #4]
  400396:	686e      	ldr	r6, [r5, #4]
  400398:	3401      	adds	r4, #1
  40039a:	611e      	str	r6, [r3, #16]
  40039c:	68ee      	ldr	r6, [r5, #12]
  40039e:	42a2      	cmp	r2, r4
  4003a0:	629e      	str	r6, [r3, #40]	@ 0x28
  4003a2:	692e      	ldr	r6, [r5, #16]
  4003a4:	639e      	str	r6, [r3, #56]	@ 0x38
  4003a6:	696e      	ldr	r6, [r5, #20]
  4003a8:	645e      	str	r6, [r3, #68]	@ 0x44
  4003aa:	69ae      	ldr	r6, [r5, #24]
  4003ac:	651e      	str	r6, [r3, #80]	@ 0x50
  4003ae:	68ad      	ldr	r5, [r5, #8]
  4003b0:	61dd      	str	r5, [r3, #28]
  4003b2:	d8e9      	bhi.n	400388 <HAL_GPIO_Restore+0x10>
  4003b4:	2000      	movs	r0, #0
  4003b6:	bdf0      	pop	{r4, r5, r6, r7, pc}
  4003b8:	2a02      	cmp	r2, #2
  4003ba:	e7e2      	b.n	400382 <HAL_GPIO_Restore+0xa>
  4003bc:	2001      	movs	r0, #1
  4003be:	e7fa      	b.n	4003b6 <HAL_GPIO_Restore+0x3e>
  4003c0:	500a0000 	.word	0x500a0000

004003c4 <HAL_RC_locked>:
  4003c4:	b507      	push	{r0, r1, r2, lr}
  4003c6:	2100      	movs	r1, #0
  4003c8:	2002      	movs	r0, #2
  4003ca:	f000 f8ad 	bl	400528 <HAL_MAILBOX_GetMutex>
  4003ce:	2100      	movs	r1, #0
  4003d0:	9001      	str	r0, [sp, #4]
  4003d2:	a801      	add	r0, sp, #4
  4003d4:	f000 f8c4 	bl	400560 <HAL_MAILBOX_Lock>
  4003d8:	3800      	subs	r0, #0
  4003da:	bf18      	it	ne
  4003dc:	2001      	movne	r0, #1
  4003de:	4240      	negs	r0, r0
  4003e0:	b003      	add	sp, #12
  4003e2:	f85d fb04 	ldr.w	pc, [sp], #4

004003e6 <HAL_RC_unlocked>:
  4003e6:	b507      	push	{r0, r1, r2, lr}
  4003e8:	2100      	movs	r1, #0
  4003ea:	2002      	movs	r0, #2
  4003ec:	f000 f89c 	bl	400528 <HAL_MAILBOX_GetMutex>
  4003f0:	2100      	movs	r1, #0
  4003f2:	9001      	str	r0, [sp, #4]
  4003f4:	a801      	add	r0, sp, #4
  4003f6:	f000 f8c5 	bl	400584 <HAL_MAILBOX_UnLock>
  4003fa:	b003      	add	sp, #12
  4003fc:	f85d fb04 	ldr.w	pc, [sp], #4

00400400 <HAL_LRC_Delay>:
  400400:	f000 bcb0 	b.w	400d64 <HAL_Delay>

00400404 <HAL_RC_CAL_GetLPCycle_ex>:
  400404:	4b01      	ldr	r3, [pc, #4]	@ (40040c <HAL_RC_CAL_GetLPCycle_ex+0x8>)
  400406:	7818      	ldrb	r0, [r3, #0]
  400408:	4770      	bx	lr
  40040a:	bf00      	nop
  40040c:	2040156c 	.word	0x2040156c

00400410 <HAL_RC_CAL_SetLPCycle_ex>:
  400410:	b118      	cbz	r0, 40041a <HAL_RC_CAL_SetLPCycle_ex+0xa>
  400412:	4b03      	ldr	r3, [pc, #12]	@ (400420 <HAL_RC_CAL_SetLPCycle_ex+0x10>)
  400414:	7018      	strb	r0, [r3, #0]
  400416:	2000      	movs	r0, #0
  400418:	4770      	bx	lr
  40041a:	f04f 30ff 	mov.w	r0, #4294967295
  40041e:	4770      	bx	lr
  400420:	2040156c 	.word	0x2040156c

00400424 <HAL_RC_CALget_curr_cycle_on_48M>:
  400424:	b573      	push	{r0, r1, r4, r5, r6, lr}
  400426:	4606      	mov	r6, r0
  400428:	460d      	mov	r5, r1
  40042a:	f401 fc8e 	bl	1d4a <HAL_GetLXTEnabled>
  40042e:	2800      	cmp	r0, #0
  400430:	d16d      	bne.n	40050e <HAL_RC_CALget_curr_cycle_on_48M+0xea>
  400432:	f7ff ffc7 	bl	4003c4 <HAL_RC_locked>
  400436:	2800      	cmp	r0, #0
  400438:	d16c      	bne.n	400514 <HAL_RC_CALget_curr_cycle_on_48M+0xf0>
  40043a:	4c38      	ldr	r4, [pc, #224]	@ (40051c <HAL_RC_CALget_curr_cycle_on_48M+0xf8>)
  40043c:	2001      	movs	r0, #1
  40043e:	f8d4 3114 	ldr.w	r3, [r4, #276]	@ 0x114
  400442:	f36f 43dc 	bfc	r3, #19, #10
  400446:	f443 2300 	orr.w	r3, r3, #524288	@ 0x80000
  40044a:	f8c4 3114 	str.w	r3, [r4, #276]	@ 0x114
  40044e:	f8d4 3114 	ldr.w	r3, [r4, #276]	@ 0x114
  400452:	f043 5300 	orr.w	r3, r3, #536870912	@ 0x20000000
  400456:	f8c4 3114 	str.w	r3, [r4, #276]	@ 0x114
  40045a:	f8d4 3114 	ldr.w	r3, [r4, #276]	@ 0x114
  40045e:	f423 3380 	bic.w	r3, r3, #65536	@ 0x10000
  400462:	f8c4 3114 	str.w	r3, [r4, #276]	@ 0x114
  400466:	f8d4 3114 	ldr.w	r3, [r4, #276]	@ 0x114
  40046a:	f8c4 3114 	str.w	r3, [r4, #276]	@ 0x114
  40046e:	f8d4 3114 	ldr.w	r3, [r4, #276]	@ 0x114
  400472:	f36f 030f 	bfc	r3, #0, #16
  400476:	f8c4 3114 	str.w	r3, [r4, #276]	@ 0x114
  40047a:	f8d4 3114 	ldr.w	r3, [r4, #276]	@ 0x114
  40047e:	431e      	orrs	r6, r3
  400480:	f8c4 6114 	str.w	r6, [r4, #276]	@ 0x114
  400484:	f8d4 3114 	ldr.w	r3, [r4, #276]	@ 0x114
  400488:	f443 3300 	orr.w	r3, r3, #131072	@ 0x20000
  40048c:	f8c4 3114 	str.w	r3, [r4, #276]	@ 0x114
  400490:	f7ff ffb6 	bl	400400 <HAL_LRC_Delay>
  400494:	f8d4 3118 	ldr.w	r3, [r4, #280]	@ 0x118
  400498:	2b00      	cmp	r3, #0
  40049a:	dafb      	bge.n	400494 <HAL_RC_CALget_curr_cycle_on_48M+0x70>
  40049c:	4820      	ldr	r0, [pc, #128]	@ (400520 <HAL_RC_CALget_curr_cycle_on_48M+0xfc>)
  40049e:	f8d4 2118 	ldr.w	r2, [r4, #280]	@ 0x118
  4004a2:	6801      	ldr	r1, [r0, #0]
  4004a4:	4e1f      	ldr	r6, [pc, #124]	@ (400524 <HAL_RC_CALget_curr_cycle_on_48M+0x100>)
  4004a6:	f022 4200 	bic.w	r2, r2, #2147483648	@ 0x80000000
  4004aa:	b371      	cbz	r1, 40050a <HAL_RC_CALget_curr_cycle_on_48M+0xe6>
  4004ac:	6833      	ldr	r3, [r6, #0]
  4004ae:	4293      	cmp	r3, r2
  4004b0:	d21d      	bcs.n	4004ee <HAL_RC_CALget_curr_cycle_on_48M+0xca>
  4004b2:	1ad4      	subs	r4, r2, r3
  4004b4:	2cfa      	cmp	r4, #250	@ 0xfa
  4004b6:	d923      	bls.n	400500 <HAL_RC_CALget_curr_cycle_on_48M+0xdc>
  4004b8:	4299      	cmp	r1, r3
  4004ba:	d921      	bls.n	400500 <HAL_RC_CALget_curr_cycle_on_48M+0xdc>
  4004bc:	1ac9      	subs	r1, r1, r3
  4004be:	29fa      	cmp	r1, #250	@ 0xfa
  4004c0:	d91e      	bls.n	400500 <HAL_RC_CALget_curr_cycle_on_48M+0xdc>
  4004c2:	eb03 0443 	add.w	r4, r3, r3, lsl #1
  4004c6:	230d      	movs	r3, #13
  4004c8:	3408      	adds	r4, #8
  4004ca:	fb03 4402 	mla	r4, r3, r2, r4
  4004ce:	0924      	lsrs	r4, r4, #4
  4004d0:	6002      	str	r2, [r0, #0]
  4004d2:	2204      	movs	r2, #4
  4004d4:	2002      	movs	r0, #2
  4004d6:	eb0d 0102 	add.w	r1, sp, r2
  4004da:	6034      	str	r4, [r6, #0]
  4004dc:	9401      	str	r4, [sp, #4]
  4004de:	f401 fce1 	bl	1ea4 <HAL_LCPU_CONFIG_set>
  4004e2:	602c      	str	r4, [r5, #0]
  4004e4:	f7ff ff7f 	bl	4003e6 <HAL_RC_unlocked>
  4004e8:	2000      	movs	r0, #0
  4004ea:	b002      	add	sp, #8
  4004ec:	bd70      	pop	{r4, r5, r6, pc}
  4004ee:	d907      	bls.n	400500 <HAL_RC_CALget_curr_cycle_on_48M+0xdc>
  4004f0:	1a9c      	subs	r4, r3, r2
  4004f2:	2cc8      	cmp	r4, #200	@ 0xc8
  4004f4:	d904      	bls.n	400500 <HAL_RC_CALget_curr_cycle_on_48M+0xdc>
  4004f6:	4299      	cmp	r1, r3
  4004f8:	d202      	bcs.n	400500 <HAL_RC_CALget_curr_cycle_on_48M+0xdc>
  4004fa:	1a59      	subs	r1, r3, r1
  4004fc:	29c8      	cmp	r1, #200	@ 0xc8
  4004fe:	e7df      	b.n	4004c0 <HAL_RC_CALget_curr_cycle_on_48M+0x9c>
  400500:	ebc3 1403 	rsb	r4, r3, r3, lsl #4
  400504:	4414      	add	r4, r2
  400506:	3408      	adds	r4, #8
  400508:	e7e1      	b.n	4004ce <HAL_RC_CALget_curr_cycle_on_48M+0xaa>
  40050a:	4614      	mov	r4, r2
  40050c:	e7e0      	b.n	4004d0 <HAL_RC_CALget_curr_cycle_on_48M+0xac>
  40050e:	f04f 30ff 	mov.w	r0, #4294967295
  400512:	e7ea      	b.n	4004ea <HAL_RC_CALget_curr_cycle_on_48M+0xc6>
  400514:	f06f 0002 	mvn.w	r0, #2
  400518:	e7e7      	b.n	4004ea <HAL_RC_CALget_curr_cycle_on_48M+0xc6>
  40051a:	bf00      	nop
  40051c:	40090000 	.word	0x40090000
  400520:	204019d0 	.word	0x204019d0
  400524:	204019cc 	.word	0x204019cc

00400528 <HAL_MAILBOX_GetMutex>:
  400528:	2801      	cmp	r0, #1
  40052a:	b508      	push	{r3, lr}
  40052c:	d108      	bne.n	400540 <HAL_MAILBOX_GetMutex+0x18>
  40052e:	2903      	cmp	r1, #3
  400530:	d80e      	bhi.n	400550 <HAL_MAILBOX_GetMutex+0x28>
  400532:	4808      	ldr	r0, [pc, #32]	@ (400554 <HAL_MAILBOX_GetMutex+0x2c>)
  400534:	e000      	b.n	400538 <HAL_MAILBOX_GetMutex+0x10>
  400536:	4808      	ldr	r0, [pc, #32]	@ (400558 <HAL_MAILBOX_GetMutex+0x30>)
  400538:	2318      	movs	r3, #24
  40053a:	fb03 0001 	mla	r0, r3, r1, r0
  40053e:	e008      	b.n	400552 <HAL_MAILBOX_GetMutex+0x2a>
  400540:	2901      	cmp	r1, #1
  400542:	d805      	bhi.n	400550 <HAL_MAILBOX_GetMutex+0x28>
  400544:	2802      	cmp	r0, #2
  400546:	d0f6      	beq.n	400536 <HAL_MAILBOX_GetMutex+0xe>
  400548:	21b0      	movs	r1, #176	@ 0xb0
  40054a:	4804      	ldr	r0, [pc, #16]	@ (40055c <HAL_MAILBOX_GetMutex+0x34>)
  40054c:	f000 fc48 	bl	400de0 <HAL_AssertFailed>
  400550:	2000      	movs	r0, #0
  400552:	bd08      	pop	{r3, pc}
  400554:	50082000 	.word	0x50082000
  400558:	40002000 	.word	0x40002000
  40055c:	00401174 	.word	0x00401174

00400560 <HAL_MAILBOX_Lock>:
  400560:	b508      	push	{r3, lr}
  400562:	b138      	cbz	r0, 400574 <HAL_MAILBOX_Lock+0x14>
  400564:	6800      	ldr	r0, [r0, #0]
  400566:	b148      	cbz	r0, 40057c <HAL_MAILBOX_Lock+0x1c>
  400568:	6940      	ldr	r0, [r0, #20]
  40056a:	2800      	cmp	r0, #0
  40056c:	db08      	blt.n	400580 <HAL_MAILBOX_Lock+0x20>
  40056e:	f000 000f 	and.w	r0, r0, #15
  400572:	bd08      	pop	{r3, pc}
  400574:	2002      	movs	r0, #2
  400576:	f7ff ffd7 	bl	400528 <HAL_MAILBOX_GetMutex>
  40057a:	e7f4      	b.n	400566 <HAL_MAILBOX_Lock+0x6>
  40057c:	2004      	movs	r0, #4
  40057e:	e7f8      	b.n	400572 <HAL_MAILBOX_Lock+0x12>
  400580:	2000      	movs	r0, #0
  400582:	e7f6      	b.n	400572 <HAL_MAILBOX_Lock+0x12>

00400584 <HAL_MAILBOX_UnLock>:
  400584:	b508      	push	{r3, lr}
  400586:	b130      	cbz	r0, 400596 <HAL_MAILBOX_UnLock+0x12>
  400588:	6800      	ldr	r0, [r0, #0]
  40058a:	b118      	cbz	r0, 400594 <HAL_MAILBOX_UnLock+0x10>
  40058c:	6943      	ldr	r3, [r0, #20]
  40058e:	f043 4300 	orr.w	r3, r3, #2147483648	@ 0x80000000
  400592:	6143      	str	r3, [r0, #20]
  400594:	bd08      	pop	{r3, pc}
  400596:	2002      	movs	r0, #2
  400598:	f7ff ffc6 	bl	400528 <HAL_MAILBOX_GetMutex>
  40059c:	e7f5      	b.n	40058a <HAL_MAILBOX_UnLock+0x6>

0040059e <HAL_MAILBOX_IRQHandler>:
  40059e:	b570      	push	{r4, r5, r6, lr}
  4005a0:	4605      	mov	r5, r0
  4005a2:	2600      	movs	r6, #0
  4005a4:	6803      	ldr	r3, [r0, #0]
  4005a6:	691c      	ldr	r4, [r3, #16]
  4005a8:	609c      	str	r4, [r3, #8]
  4005aa:	b904      	cbnz	r4, 4005ae <HAL_MAILBOX_IRQHandler+0x10>
  4005ac:	bd70      	pop	{r4, r5, r6, pc}
  4005ae:	07e3      	lsls	r3, r4, #31
  4005b0:	d504      	bpl.n	4005bc <HAL_MAILBOX_IRQHandler+0x1e>
  4005b2:	68ab      	ldr	r3, [r5, #8]
  4005b4:	b113      	cbz	r3, 4005bc <HAL_MAILBOX_IRQHandler+0x1e>
  4005b6:	4628      	mov	r0, r5
  4005b8:	b2f1      	uxtb	r1, r6
  4005ba:	4798      	blx	r3
  4005bc:	0864      	lsrs	r4, r4, #1
  4005be:	3601      	adds	r6, #1
  4005c0:	e7f3      	b.n	4005aa <HAL_MAILBOX_IRQHandler+0xc>
	...

004005c4 <HAL_PTC_Init>:
  4005c4:	b510      	push	{r4, lr}
  4005c6:	4604      	mov	r4, r0
  4005c8:	b918      	cbnz	r0, 4005d2 <HAL_PTC_Init+0xe>
  4005ca:	2115      	movs	r1, #21
  4005cc:	480c      	ldr	r0, [pc, #48]	@ (400600 <HAL_PTC_Init+0x3c>)
  4005ce:	f000 fc07 	bl	400de0 <HAL_AssertFailed>
  4005d2:	7d23      	ldrb	r3, [r4, #20]
  4005d4:	2b07      	cmp	r3, #7
  4005d6:	d903      	bls.n	4005e0 <HAL_PTC_Init+0x1c>
  4005d8:	2116      	movs	r1, #22
  4005da:	4809      	ldr	r0, [pc, #36]	@ (400600 <HAL_PTC_Init+0x3c>)
  4005dc:	f000 fc00 	bl	400de0 <HAL_AssertFailed>
  4005e0:	6823      	ldr	r3, [r4, #0]
  4005e2:	7d22      	ldrb	r2, [r4, #20]
  4005e4:	3310      	adds	r3, #16
  4005e6:	eb03 1302 	add.w	r3, r3, r2, lsl #4
  4005ea:	68a2      	ldr	r2, [r4, #8]
  4005ec:	6063      	str	r3, [r4, #4]
  4005ee:	605a      	str	r2, [r3, #4]
  4005f0:	6863      	ldr	r3, [r4, #4]
  4005f2:	68e2      	ldr	r2, [r4, #12]
  4005f4:	2000      	movs	r0, #0
  4005f6:	609a      	str	r2, [r3, #8]
  4005f8:	2301      	movs	r3, #1
  4005fa:	7623      	strb	r3, [r4, #24]
  4005fc:	bd10      	pop	{r4, pc}
  4005fe:	bf00      	nop
  400600:	0040123b 	.word	0x0040123b

00400604 <HAL_PTC_Enable>:
  400604:	2201      	movs	r2, #1
  400606:	b510      	push	{r4, lr}
  400608:	7d03      	ldrb	r3, [r0, #20]
  40060a:	6804      	ldr	r4, [r0, #0]
  40060c:	fa02 f303 	lsl.w	r3, r2, r3
  400610:	b1b1      	cbz	r1, 400640 <HAL_PTC_Enable+0x3c>
  400612:	6861      	ldr	r1, [r4, #4]
  400614:	430b      	orrs	r3, r1
  400616:	f443 3380 	orr.w	r3, r3, #65536	@ 0x10000
  40061a:	6063      	str	r3, [r4, #4]
  40061c:	6804      	ldr	r4, [r0, #0]
  40061e:	7d01      	ldrb	r1, [r0, #20]
  400620:	68a3      	ldr	r3, [r4, #8]
  400622:	408a      	lsls	r2, r1
  400624:	4313      	orrs	r3, r2
  400626:	ea43 4302 	orr.w	r3, r3, r2, lsl #16
  40062a:	60a3      	str	r3, [r4, #8]
  40062c:	7cc2      	ldrb	r2, [r0, #19]
  40062e:	7d83      	ldrb	r3, [r0, #22]
  400630:	ea43 4302 	orr.w	r3, r3, r2, lsl #16
  400634:	6842      	ldr	r2, [r0, #4]
  400636:	6013      	str	r3, [r2, #0]
  400638:	2202      	movs	r2, #2
  40063a:	7602      	strb	r2, [r0, #24]
  40063c:	2000      	movs	r0, #0
  40063e:	bd10      	pop	{r4, pc}
  400640:	68a1      	ldr	r1, [r4, #8]
  400642:	ea43 4303 	orr.w	r3, r3, r3, lsl #16
  400646:	ea21 0303 	bic.w	r3, r1, r3
  40064a:	60a3      	str	r3, [r4, #8]
  40064c:	e7f5      	b.n	40063a <HAL_PTC_Enable+0x36>

0040064e <HAL_PTC_IRQHandler>:
  40064e:	2301      	movs	r3, #1
  400650:	6802      	ldr	r2, [r0, #0]
  400652:	7d00      	ldrb	r0, [r0, #20]
  400654:	6851      	ldr	r1, [r2, #4]
  400656:	4083      	lsls	r3, r0
  400658:	430b      	orrs	r3, r1
  40065a:	6053      	str	r3, [r2, #4]
  40065c:	4770      	bx	lr
	...

00400660 <HAL_RCC_EnableModule>:
  400660:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
  400662:	1c43      	adds	r3, r0, #1
  400664:	d014      	beq.n	400690 <HAL_RCC_EnableModule+0x30>
  400666:	f010 0fe0 	tst.w	r0, #224	@ 0xe0
  40066a:	f3c0 2681 	ubfx	r6, r0, #10, #2
  40066e:	f3c0 2501 	ubfx	r5, r0, #8, #2
  400672:	b2c7      	uxtb	r7, r0
  400674:	d004      	beq.n	400680 <HAL_RCC_EnableModule+0x20>
  400676:	f44f 61f6 	mov.w	r1, #1968	@ 0x7b0
  40067a:	480c      	ldr	r0, [pc, #48]	@ (4006ac <HAL_RCC_EnableModule+0x4c>)
  40067c:	f000 fbb0 	bl	400de0 <HAL_AssertFailed>
  400680:	b93e      	cbnz	r6, 400692 <HAL_RCC_EnableModule+0x32>
  400682:	00ad      	lsls	r5, r5, #2
  400684:	f105 44a0 	add.w	r4, r5, #1342177280	@ 0x50000000
  400688:	3410      	adds	r4, #16
  40068a:	2301      	movs	r3, #1
  40068c:	40bb      	lsls	r3, r7
  40068e:	6023      	str	r3, [r4, #0]
  400690:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
  400692:	2e01      	cmp	r6, #1
  400694:	d104      	bne.n	4006a0 <HAL_RCC_EnableModule+0x40>
  400696:	00ad      	lsls	r5, r5, #2
  400698:	f105 4480 	add.w	r4, r5, #1073741824	@ 0x40000000
  40069c:	3408      	adds	r4, #8
  40069e:	e7f4      	b.n	40068a <HAL_RCC_EnableModule+0x2a>
  4006a0:	f240 71c2 	movw	r1, #1986	@ 0x7c2
  4006a4:	4801      	ldr	r0, [pc, #4]	@ (4006ac <HAL_RCC_EnableModule+0x4c>)
  4006a6:	f000 fb9b 	bl	400de0 <HAL_AssertFailed>
  4006aa:	e7ee      	b.n	40068a <HAL_RCC_EnableModule+0x2a>
  4006ac:	0040129b 	.word	0x0040129b

004006b0 <HAL_RCC_MspInit>:
  4006b0:	4770      	bx	lr

004006b2 <HAL_RCC_Init>:
  4006b2:	b508      	push	{r3, lr}
  4006b4:	f7ff fffc 	bl	4006b0 <HAL_RCC_MspInit>
  4006b8:	bd08      	pop	{r3, pc}
	...

004006bc <bt_audiopath_init>:
  4006bc:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
  4006be:	4e12      	ldr	r6, [pc, #72]	@ (400708 <bt_audiopath_init+0x4c>)
  4006c0:	4b12      	ldr	r3, [pc, #72]	@ (40070c <bt_audiopath_init+0x50>)
  4006c2:	4c13      	ldr	r4, [pc, #76]	@ (400710 <bt_audiopath_init+0x54>)
  4006c4:	6033      	str	r3, [r6, #0]
  4006c6:	3320      	adds	r3, #32
  4006c8:	6023      	str	r3, [r4, #0]
  4006ca:	4a12      	ldr	r2, [pc, #72]	@ (400714 <bt_audiopath_init+0x58>)
  4006cc:	4b12      	ldr	r3, [pc, #72]	@ (400718 <bt_audiopath_init+0x5c>)
  4006ce:	4f13      	ldr	r7, [pc, #76]	@ (40071c <bt_audiopath_init+0x60>)
  4006d0:	601a      	str	r2, [r3, #0]
  4006d2:	4b13      	ldr	r3, [pc, #76]	@ (400720 <bt_audiopath_init+0x64>)
  4006d4:	4d13      	ldr	r5, [pc, #76]	@ (400724 <bt_audiopath_init+0x68>)
  4006d6:	603b      	str	r3, [r7, #0]
  4006d8:	f503 73e6 	add.w	r3, r3, #460	@ 0x1cc
  4006dc:	602b      	str	r3, [r5, #0]
  4006de:	4b12      	ldr	r3, [pc, #72]	@ (400728 <bt_audiopath_init+0x6c>)
  4006e0:	f502 726b 	add.w	r2, r2, #940	@ 0x3ac
  4006e4:	4811      	ldr	r0, [pc, #68]	@ (40072c <bt_audiopath_init+0x70>)
  4006e6:	601a      	str	r2, [r3, #0]
  4006e8:	f405 f9b0 	bl	5a4c <bt_sco_data_handle_callback+0xd0>
  4006ec:	6839      	ldr	r1, [r7, #0]
  4006ee:	6830      	ldr	r0, [r6, #0]
  4006f0:	f44f 72e6 	mov.w	r2, #460	@ 0x1cc
  4006f4:	f454 fa7e 	bl	54bf4 <rt_ringbuffer_init>
  4006f8:	6820      	ldr	r0, [r4, #0]
  4006fa:	f44f 72e6 	mov.w	r2, #460	@ 0x1cc
  4006fe:	6829      	ldr	r1, [r5, #0]
  400700:	f454 fa78 	bl	54bf4 <rt_ringbuffer_init>
  400704:	2000      	movs	r0, #0
  400706:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
  400708:	2040e6e8 	.word	0x2040e6e8
  40070c:	2040e000 	.word	0x2040e000
  400710:	2040e6ec 	.word	0x2040e6ec
  400714:	2040e040 	.word	0x2040e040
  400718:	2040e6f0 	.word	0x2040e6f0
  40071c:	2040e6f4 	.word	0x2040e6f4
  400720:	2040e050 	.word	0x2040e050
  400724:	2040e6f8 	.word	0x2040e6f8
  400728:	2040e6fc 	.word	0x2040e6fc
  40072c:	0000597d 	.word	0x0000597d

00400730 <patch_install>:
  400730:	4a04      	ldr	r2, [pc, #16]	@ (400744 <patch_install+0x14>)
  400732:	4b05      	ldr	r3, [pc, #20]	@ (400748 <patch_install+0x18>)
  400734:	601a      	str	r2, [r3, #0]
  400736:	3a01      	subs	r2, #1
  400738:	6812      	ldr	r2, [r2, #0]
  40073a:	b10a      	cbz	r2, 400740 <patch_install+0x10>
  40073c:	681b      	ldr	r3, [r3, #0]
  40073e:	4718      	bx	r3
  400740:	4770      	bx	lr
  400742:	bf00      	nop
  400744:	00406001 	.word	0x00406001
  400748:	204019d4 	.word	0x204019d4

0040074c <bluetooth_init>:
  40074c:	b510      	push	{r4, lr}
  40074e:	2001      	movs	r0, #1
  400750:	f000 f946 	bl	4009e0 <rf_ptc_config>
  400754:	f451 fed0 	bl	524f8 <rt_hw_ble_int_init>
  400758:	f401 faf7 	bl	1d4a <HAL_GetLXTEnabled>
  40075c:	b928      	cbnz	r0, 40076a <bluetooth_init+0x1e>
  40075e:	f450 fd7d 	bl	5125c <rom_config_set_default_sleep_mode+0x7>
  400762:	f7ff fe4f 	bl	400404 <HAL_RC_CAL_GetLPCycle_ex>
  400766:	f450 fd6d 	bl	51244 <rom_config_set_default_link_config+0xb>
  40076a:	2003      	movs	r0, #3
  40076c:	f450 fd7a 	bl	51264 <rom_config_set_default_xtal_enabled+0x7>
  400770:	2400      	movs	r4, #0
  400772:	230e      	movs	r3, #14
  400774:	4a0c      	ldr	r2, [pc, #48]	@ (4007a8 <bluetooth_init+0x5c>)
  400776:	490d      	ldr	r1, [pc, #52]	@ (4007ac <bluetooth_init+0x60>)
  400778:	4610      	mov	r0, r2
  40077a:	e9c2 4407 	strd	r4, r4, [r2, #28]
  40077e:	7513      	strb	r3, [r2, #20]
  400780:	f453 fc46 	bl	54010 <rt_pm_device_register>
  400784:	480a      	ldr	r0, [pc, #40]	@ (4007b0 <bluetooth_init+0x64>)
  400786:	f455 fabb 	bl	55d00 <rt_thread_idle_sethook>
  40078a:	480a      	ldr	r0, [pc, #40]	@ (4007b4 <bluetooth_init+0x68>)
  40078c:	f453 fd1e 	bl	541cc <rt_pm_override_mode_select>
  400790:	f7ff ffce 	bl	400730 <patch_install>
  400794:	f000 f8c2 	bl	40091c <bluetooth_config>
  400798:	f401 fe02 	bl	23a0 <HAL_RCC_SetMacFreq>
  40079c:	4620      	mov	r0, r4
  40079e:	f404 fbbd 	bl	4f1c <ble_aon_irq_handler+0x2b>
  4007a2:	4620      	mov	r0, r4
  4007a4:	bd10      	pop	{r4, pc}
  4007a6:	bf00      	nop
  4007a8:	204019d8 	.word	0x204019d8
  4007ac:	00401360 	.word	0x00401360
  4007b0:	00017955 	.word	0x00017955
  4007b4:	004007b9 	.word	0x004007b9

004007b8 <bluetooth_select_pm_mode>:
  4007b8:	3001      	adds	r0, #1
  4007ba:	b508      	push	{r3, lr}
  4007bc:	d001      	beq.n	4007c2 <bluetooth_select_pm_mode+0xa>
  4007be:	2001      	movs	r0, #1
  4007c0:	bd08      	pop	{r3, pc}
  4007c2:	f417 fabd 	bl	17d40 <bluetooth_stack_suspend>
  4007c6:	2800      	cmp	r0, #0
  4007c8:	d1f9      	bne.n	4007be <bluetooth_select_pm_mode+0x6>
  4007ca:	2003      	movs	r0, #3
  4007cc:	e7f8      	b.n	4007c0 <bluetooth_select_pm_mode+0x8>
	...

004007d0 <bluetooth_pm_suspend>:
  4007d0:	b508      	push	{r3, lr}
  4007d2:	4b09      	ldr	r3, [pc, #36]	@ (4007f8 <bluetooth_pm_suspend+0x28>)
  4007d4:	4602      	mov	r2, r0
  4007d6:	6a18      	ldr	r0, [r3, #32]
  4007d8:	f010 0020 	ands.w	r0, r0, #32
  4007dc:	d006      	beq.n	4007ec <bluetooth_pm_suspend+0x1c>
  4007de:	4b07      	ldr	r3, [pc, #28]	@ (4007fc <bluetooth_pm_suspend+0x2c>)
  4007e0:	429a      	cmp	r2, r3
  4007e2:	d104      	bne.n	4007ee <bluetooth_pm_suspend+0x1e>
  4007e4:	2901      	cmp	r1, #1
  4007e6:	d904      	bls.n	4007f2 <bluetooth_pm_suspend+0x22>
  4007e8:	f417 faaa 	bl	17d40 <bluetooth_stack_suspend>
  4007ec:	bd08      	pop	{r3, pc}
  4007ee:	2000      	movs	r0, #0
  4007f0:	e7fc      	b.n	4007ec <bluetooth_pm_suspend+0x1c>
  4007f2:	f04f 30ff 	mov.w	r0, #4294967295
  4007f6:	e7f9      	b.n	4007ec <bluetooth_pm_suspend+0x1c>
  4007f8:	40040000 	.word	0x40040000
  4007fc:	204019d8 	.word	0x204019d8

00400800 <ble_standby_sleep_pre_handler>:
  400800:	f404 bc2e 	b.w	5060 <ble_standby_sleep_after_handler_rom+0x4f>

00400804 <ble_standby_sleep_after_handler>:
  400804:	b508      	push	{r3, lr}
  400806:	f401 fdcb 	bl	23a0 <HAL_RCC_SetMacFreq>
  40080a:	f404 fc01 	bl	5010 <ble_memory_config+0x18>
  40080e:	e8bd 4008 	ldmia.w	sp!, {r3, lr}
  400812:	2000      	movs	r0, #0
  400814:	f000 b8e4 	b.w	4009e0 <rf_ptc_config>

00400818 <rom_port_get>:
  400818:	b510      	push	{r4, lr}
  40081a:	b148      	cbz	r0, 400830 <rom_port_get+0x18>
  40081c:	2801      	cmp	r0, #1
  40081e:	d009      	beq.n	400834 <rom_port_get+0x1c>
  400820:	f44f 620e 	mov.w	r2, #2272	@ 0x8e0
  400824:	4904      	ldr	r1, [pc, #16]	@ (400838 <rom_port_get+0x20>)
  400826:	4805      	ldr	r0, [pc, #20]	@ (40083c <rom_port_get+0x24>)
  400828:	f450 fd98 	bl	5135c <rt_assert_handler>
  40082c:	4620      	mov	r0, r4
  40082e:	bd10      	pop	{r4, pc}
  400830:	2402      	movs	r4, #2
  400832:	e7fb      	b.n	40082c <rom_port_get+0x14>
  400834:	2406      	movs	r4, #6
  400836:	e7f9      	b.n	40082c <rom_port_get+0x14>
  400838:	00401378 	.word	0x00401378
  40083c:	0040130c 	.word	0x0040130c

00400840 <act_config>:
  400840:	2206      	movs	r2, #6
  400842:	b538      	push	{r3, r4, r5, lr}
  400844:	4c0d      	ldr	r4, [pc, #52]	@ (40087c <act_config+0x3c>)
  400846:	2302      	movs	r3, #2
  400848:	2501      	movs	r5, #1
  40084a:	70a2      	strb	r2, [r4, #2]
  40084c:	2203      	movs	r2, #3
  40084e:	2004      	movs	r0, #4
  400850:	7023      	strb	r3, [r4, #0]
  400852:	70e2      	strb	r2, [r4, #3]
  400854:	7123      	strb	r3, [r4, #4]
  400856:	7065      	strb	r5, [r4, #1]
  400858:	f450 fcbe 	bl	511d8 <rom_config_em_memory+0x33>
  40085c:	8843      	ldrh	r3, [r0, #2]
  40085e:	2014      	movs	r0, #20
  400860:	3b02      	subs	r3, #2
  400862:	71e3      	strb	r3, [r4, #7]
  400864:	f450 fcb8 	bl	511d8 <rom_config_em_memory+0x33>
  400868:	8843      	ldrh	r3, [r0, #2]
  40086a:	7165      	strb	r5, [r4, #5]
  40086c:	3b02      	subs	r3, #2
  40086e:	7223      	strb	r3, [r4, #8]
  400870:	71a5      	strb	r5, [r4, #6]
  400872:	4620      	mov	r0, r4
  400874:	e8bd 4038 	ldmia.w	sp!, {r3, r4, r5, lr}
  400878:	f450 bcde 	b.w	51238 <rom_config_set_controller_enabled+0x7>
  40087c:	2040ead4 	.word	0x2040ead4

00400880 <mem_config>:
  400880:	b500      	push	{lr}
  400882:	4a16      	ldr	r2, [pc, #88]	@ (4008dc <mem_config+0x5c>)
  400884:	b091      	sub	sp, #68	@ 0x44
  400886:	7953      	ldrb	r3, [r2, #5]
  400888:	7990      	ldrb	r0, [r2, #6]
  40088a:	005b      	lsls	r3, r3, #1
  40088c:	f003 0302 	and.w	r3, r3, #2
  400890:	f000 0001 	and.w	r0, r0, #1
  400894:	4318      	orrs	r0, r3
  400896:	f450 fccb 	bl	51230 <rom_config_get_default_attribute_4_em+0x57>
  40089a:	2228      	movs	r2, #40	@ 0x28
  40089c:	2100      	movs	r1, #0
  40089e:	a806      	add	r0, sp, #24
  4008a0:	f000 fc60 	bl	401164 <memset>
  4008a4:	f44f 7200 	mov.w	r2, #512	@ 0x200
  4008a8:	4b0d      	ldr	r3, [pc, #52]	@ (4008e0 <mem_config+0x60>)
  4008aa:	2106      	movs	r1, #6
  4008ac:	e9cd 3203 	strd	r3, r2, [sp, #12]
  4008b0:	2300      	movs	r3, #0
  4008b2:	e9cd 3101 	strd	r3, r1, [sp, #4]
  4008b6:	f44f 7327 	mov.w	r3, #668	@ 0x29c
  4008ba:	2201      	movs	r2, #1
  4008bc:	f44f 5180 	mov.w	r1, #4096	@ 0x1000
  4008c0:	9300      	str	r3, [sp, #0]
  4008c2:	a806      	add	r0, sp, #24
  4008c4:	f44f 5300 	mov.w	r3, #8192	@ 0x2000
  4008c8:	f44f fe02 	bl	504d0 <mem_env_config>
  4008cc:	a806      	add	r0, sp, #24
  4008ce:	f404 fb93 	bl	4ff8 <ble_memory_config>
  4008d2:	f409 fa97 	bl	9e04 <em_config_customized>
  4008d6:	b011      	add	sp, #68	@ 0x44
  4008d8:	f85d fb04 	ldr.w	pc, [sp], #4
  4008dc:	2040ead4 	.word	0x2040ead4
  4008e0:	2040fe00 	.word	0x2040fe00

004008e4 <port_config>:
  4008e4:	b510      	push	{r4, lr}
  4008e6:	2000      	movs	r0, #0
  4008e8:	f7ff ff96 	bl	400818 <rom_port_get>
  4008ec:	4b08      	ldr	r3, [pc, #32]	@ (400910 <port_config+0x2c>)
  4008ee:	f853 3020 	ldr.w	r3, [r3, r0, lsl #2]
  4008f2:	4798      	blx	r3
  4008f4:	4604      	mov	r4, r0
  4008f6:	b928      	cbnz	r0, 400904 <port_config+0x20>
  4008f8:	f640 2253 	movw	r2, #2643	@ 0xa53
  4008fc:	4905      	ldr	r1, [pc, #20]	@ (400914 <port_config+0x30>)
  4008fe:	4806      	ldr	r0, [pc, #24]	@ (400918 <port_config+0x34>)
  400900:	f450 fd2c 	bl	5135c <rt_assert_handler>
  400904:	4620      	mov	r0, r4
  400906:	e8bd 4010 	ldmia.w	sp!, {r4, lr}
  40090a:	2100      	movs	r1, #0
  40090c:	f450 bcbc 	b.w	51288 <rom_config_set_swprofiling+0xb>
  400910:	0005fdcc 	.word	0x0005fdcc
  400914:	0040136c 	.word	0x0040136c
  400918:	0040130e 	.word	0x0040130e

0040091c <bluetooth_config>:
  40091c:	b508      	push	{r3, lr}
  40091e:	f7ff ff8f 	bl	400840 <act_config>
  400922:	f7ff ffad 	bl	400880 <mem_config>
  400926:	f7ff ffdd 	bl	4008e4 <port_config>
  40092a:	bd08      	pop	{r3, pc}

0040092c <ptc_save_phase>:
  40092c:	4b07      	ldr	r3, [pc, #28]	@ (40094c <ptc_save_phase+0x20>)
  40092e:	f8d3 2098 	ldr.w	r2, [r3, #152]	@ 0x98
  400932:	f3c2 030b 	ubfx	r3, r2, #0, #12
  400936:	0512      	lsls	r2, r2, #20
  400938:	bf44      	itt	mi
  40093a:	f483 637f 	eormi.w	r3, r3, #4080	@ 0xff0
  40093e:	f083 030f 	eormi.w	r3, r3, #15
  400942:	b113      	cbz	r3, 40094a <ptc_save_phase+0x1e>
  400944:	4a02      	ldr	r2, [pc, #8]	@ (400950 <ptc_save_phase+0x24>)
  400946:	6812      	ldr	r2, [r2, #0]
  400948:	6013      	str	r3, [r2, #0]
  40094a:	4770      	bx	lr
  40094c:	40084000 	.word	0x40084000
  400950:	20401570 	.word	0x20401570

00400954 <PTC2_IRQHandler>:
  400954:	b510      	push	{r4, lr}
  400956:	4b07      	ldr	r3, [pc, #28]	@ (400974 <PTC2_IRQHandler+0x20>)
  400958:	681c      	ldr	r4, [r3, #0]
  40095a:	f452 f87d 	bl	52a58 <rt_interrupt_enter>
  40095e:	07a3      	lsls	r3, r4, #30
  400960:	d504      	bpl.n	40096c <PTC2_IRQHandler+0x18>
  400962:	4805      	ldr	r0, [pc, #20]	@ (400978 <PTC2_IRQHandler+0x24>)
  400964:	f7ff fe73 	bl	40064e <HAL_PTC_IRQHandler>
  400968:	f7ff ffe0 	bl	40092c <ptc_save_phase>
  40096c:	e8bd 4010 	ldmia.w	sp!, {r4, lr}
  400970:	f452 b88a 	b.w	52a88 <rt_interrupt_leave>
  400974:	4000c000 	.word	0x4000c000
  400978:	20401a18 	.word	0x20401a18

0040097c <ptc_config>:
  40097c:	b570      	push	{r4, r5, r6, lr}
  40097e:	4616      	mov	r6, r2
  400980:	221c      	movs	r2, #28
  400982:	4350      	muls	r0, r2
  400984:	4d11      	ldr	r5, [pc, #68]	@ (4009cc <ptc_config+0x50>)
  400986:	4a12      	ldr	r2, [pc, #72]	@ (4009d0 <ptc_config+0x54>)
  400988:	182c      	adds	r4, r5, r0
  40098a:	502a      	str	r2, [r5, r0]
  40098c:	2201      	movs	r2, #1
  40098e:	7522      	strb	r2, [r4, #20]
  400990:	4a10      	ldr	r2, [pc, #64]	@ (4009d4 <ptc_config+0x58>)
  400992:	2005      	movs	r0, #5
  400994:	6812      	ldr	r2, [r2, #0]
  400996:	74e0      	strb	r0, [r4, #19]
  400998:	60a2      	str	r2, [r4, #8]
  40099a:	2200      	movs	r2, #0
  40099c:	2012      	movs	r0, #18
  40099e:	75a1      	strb	r1, [r4, #22]
  4009a0:	4611      	mov	r1, r2
  4009a2:	60e2      	str	r2, [r4, #12]
  4009a4:	74a6      	strb	r6, [r4, #18]
  4009a6:	8223      	strh	r3, [r4, #16]
  4009a8:	f401 fb80 	bl	20ac <HAL_NVIC_SetPriority>
  4009ac:	4620      	mov	r0, r4
  4009ae:	f7ff fe09 	bl	4005c4 <HAL_PTC_Init>
  4009b2:	b128      	cbz	r0, 4009c0 <ptc_config+0x44>
  4009b4:	f44f 72cb 	mov.w	r2, #406	@ 0x196
  4009b8:	4907      	ldr	r1, [pc, #28]	@ (4009d8 <ptc_config+0x5c>)
  4009ba:	4808      	ldr	r0, [pc, #32]	@ (4009dc <ptc_config+0x60>)
  4009bc:	f450 fcce 	bl	5135c <rt_assert_handler>
  4009c0:	4620      	mov	r0, r4
  4009c2:	e8bd 4070 	ldmia.w	sp!, {r4, r5, r6, lr}
  4009c6:	2101      	movs	r1, #1
  4009c8:	f7ff be1c 	b.w	400604 <HAL_PTC_Enable>
  4009cc:	20401a18 	.word	0x20401a18
  4009d0:	4000c000 	.word	0x4000c000
  4009d4:	20401570 	.word	0x20401570
  4009d8:	00401385 	.word	0x00401385
  4009dc:	00401311 	.word	0x00401311

004009e0 <rf_ptc_config>:
  4009e0:	b510      	push	{r4, lr}
  4009e2:	b128      	cbz	r0, 4009f0 <rf_ptc_config+0x10>
  4009e4:	2200      	movs	r2, #0
  4009e6:	4b08      	ldr	r3, [pc, #32]	@ (400a08 <rf_ptc_config+0x28>)
  4009e8:	681b      	ldr	r3, [r3, #0]
  4009ea:	601a      	str	r2, [r3, #0]
  4009ec:	605a      	str	r2, [r3, #4]
  4009ee:	811a      	strh	r2, [r3, #8]
  4009f0:	f44f 6081 	mov.w	r0, #1032	@ 0x408
  4009f4:	f7ff fe34 	bl	400660 <HAL_RCC_EnableModule>
  4009f8:	e8bd 4010 	ldmia.w	sp!, {r4, lr}
  4009fc:	2300      	movs	r3, #0
  4009fe:	2169      	movs	r1, #105	@ 0x69
  400a00:	461a      	mov	r2, r3
  400a02:	4618      	mov	r0, r3
  400a04:	f7ff bfba 	b.w	40097c <ptc_config>
  400a08:	20401570 	.word	0x20401570

00400a0c <hcpu2lcpu_notification_callback>:
  400a0c:	2907      	cmp	r1, #7
  400a0e:	b510      	push	{r4, lr}
  400a10:	460c      	mov	r4, r1
  400a12:	d904      	bls.n	400a1e <hcpu2lcpu_notification_callback+0x12>
  400a14:	2234      	movs	r2, #52	@ 0x34
  400a16:	490a      	ldr	r1, [pc, #40]	@ (400a40 <hcpu2lcpu_notification_callback+0x34>)
  400a18:	480a      	ldr	r0, [pc, #40]	@ (400a44 <hcpu2lcpu_notification_callback+0x38>)
  400a1a:	f450 fc9f 	bl	5135c <rt_assert_handler>
  400a1e:	4b0a      	ldr	r3, [pc, #40]	@ (400a48 <hcpu2lcpu_notification_callback+0x3c>)
  400a20:	6a5a      	ldr	r2, [r3, #36]	@ 0x24
  400a22:	40e2      	lsrs	r2, r4
  400a24:	07d2      	lsls	r2, r2, #31
  400a26:	d503      	bpl.n	400a30 <hcpu2lcpu_notification_callback+0x24>
  400a28:	b91c      	cbnz	r4, 400a32 <hcpu2lcpu_notification_callback+0x26>
  400a2a:	6a98      	ldr	r0, [r3, #40]	@ 0x28
  400a2c:	f415 fe88 	bl	16740 <ipc_queue_data_ind_rom>
  400a30:	bd10      	pop	{r4, pc}
  400a32:	eb03 0384 	add.w	r3, r3, r4, lsl #2
  400a36:	6a98      	ldr	r0, [r3, #40]	@ 0x28
  400a38:	e8bd 4010 	ldmia.w	sp!, {r4, lr}
  400a3c:	f415 be64 	b.w	16708 <ipc_queue_data_ind>
  400a40:	00401390 	.word	0x00401390
  400a44:	0040131a 	.word	0x0040131a
  400a48:	2040e498 	.word	0x2040e498

00400a4c <HCPU2LCPU_IRQHandler>:
  400a4c:	b508      	push	{r3, lr}
  400a4e:	f452 f803 	bl	52a58 <rt_interrupt_enter>
  400a52:	4803      	ldr	r0, [pc, #12]	@ (400a60 <HCPU2LCPU_IRQHandler+0x14>)
  400a54:	f7ff fda3 	bl	40059e <HAL_MAILBOX_IRQHandler>
  400a58:	e8bd 4008 	ldmia.w	sp!, {r3, lr}
  400a5c:	f452 b814 	b.w	52a88 <rt_interrupt_leave>
  400a60:	20401574 	.word	0x20401574

00400a64 <sys_init_debug_trigger>:
  400a64:	b508      	push	{r3, lr}
  400a66:	4a06      	ldr	r2, [pc, #24]	@ (400a80 <sys_init_debug_trigger+0x1c>)
  400a68:	4806      	ldr	r0, [pc, #24]	@ (400a84 <sys_init_debug_trigger+0x20>)
  400a6a:	6913      	ldr	r3, [r2, #16]
  400a6c:	f043 5300 	orr.w	r3, r3, #536870912	@ 0x20000000
  400a70:	6113      	str	r3, [r2, #16]
  400a72:	f450 fc91 	bl	51398 <rt_assert_set_hook>
  400a76:	4804      	ldr	r0, [pc, #16]	@ (400a88 <sys_init_debug_trigger+0x24>)
  400a78:	f451 fdca 	bl	52610 <rt_hw_exception_install>
  400a7c:	2000      	movs	r0, #0
  400a7e:	bd08      	pop	{r3, pc}
  400a80:	4000f000 	.word	0x4000f000
  400a84:	00400aad 	.word	0x00400aad
  400a88:	00400a8d 	.word	0x00400a8d

00400a8c <exception_handler>:
  400a8c:	b510      	push	{r4, lr}
  400a8e:	4c06      	ldr	r4, [pc, #24]	@ (400aa8 <exception_handler+0x1c>)
  400a90:	6923      	ldr	r3, [r4, #16]
  400a92:	005b      	lsls	r3, r3, #1
  400a94:	d406      	bmi.n	400aa4 <exception_handler+0x18>
  400a96:	2001      	movs	r0, #1
  400a98:	f401 faac 	bl	1ff4 <HAL_LPAON_WakeCore>
  400a9c:	6923      	ldr	r3, [r4, #16]
  400a9e:	f043 5380 	orr.w	r3, r3, #268435456	@ 0x10000000
  400aa2:	6123      	str	r3, [r4, #16]
  400aa4:	2001      	movs	r0, #1
  400aa6:	bd10      	pop	{r4, pc}
  400aa8:	4000f000 	.word	0x4000f000

00400aac <assert_hook>:
  400aac:	b510      	push	{r4, lr}
  400aae:	4c08      	ldr	r4, [pc, #32]	@ (400ad0 <assert_hook+0x24>)
  400ab0:	6923      	ldr	r3, [r4, #16]
  400ab2:	005b      	lsls	r3, r3, #1
  400ab4:	d40a      	bmi.n	400acc <assert_hook+0x20>
  400ab6:	2001      	movs	r0, #1
  400ab8:	f401 fa9c 	bl	1ff4 <HAL_LPAON_WakeCore>
  400abc:	6923      	ldr	r3, [r4, #16]
  400abe:	f043 5380 	orr.w	r3, r3, #268435456	@ 0x10000000
  400ac2:	6123      	str	r3, [r4, #16]
  400ac4:	e8bd 4010 	ldmia.w	sp!, {r4, lr}
  400ac8:	f000 bb1e 	b.w	401108 <rt_hw_fatal_error>
  400acc:	bd10      	pop	{r4, pc}
  400ace:	bf00      	nop
  400ad0:	4000f000 	.word	0x4000f000

00400ad4 <DBG_Trigger_IRQHandler>:
  400ad4:	b508      	push	{r3, lr}
  400ad6:	f451 ffbf 	bl	52a58 <rt_interrupt_enter>
  400ada:	f240 1279 	movw	r2, #377	@ 0x179
  400ade:	4904      	ldr	r1, [pc, #16]	@ (400af0 <DBG_Trigger_IRQHandler+0x1c>)
  400ae0:	4804      	ldr	r0, [pc, #16]	@ (400af4 <DBG_Trigger_IRQHandler+0x20>)
  400ae2:	f450 fc3b 	bl	5135c <rt_assert_handler>
  400ae6:	e8bd 4008 	ldmia.w	sp!, {r3, lr}
  400aea:	f451 bfcd 	b.w	52a88 <rt_interrupt_leave>
  400aee:	bf00      	nop
  400af0:	004013b0 	.word	0x004013b0
  400af4:	0040130c 	.word	0x0040130c

00400af8 <sifli_exit_idle>:
  400af8:	4770      	bx	lr

00400afa <sifli_resume>:
  400afa:	4770      	bx	lr

00400afc <sifli_suspend>:
  400afc:	2901      	cmp	r1, #1
  400afe:	b508      	push	{r3, lr}
  400b00:	d801      	bhi.n	400b06 <sifli_suspend+0xa>
  400b02:	2000      	movs	r0, #0
  400b04:	bd08      	pop	{r3, pc}
  400b06:	f415 fdb9 	bl	1667c <ipc_queue_check_idle>
  400b0a:	b908      	cbnz	r0, 400b10 <sifli_suspend+0x14>
  400b0c:	2007      	movs	r0, #7
  400b0e:	e7f9      	b.n	400b04 <sifli_suspend+0x8>
  400b10:	f415 fdd2 	bl	166b8 <ipc_queue_check_idle_rom>
  400b14:	2800      	cmp	r0, #0
  400b16:	d0f9      	beq.n	400b0c <sifli_suspend+0x10>
  400b18:	4b02      	ldr	r3, [pc, #8]	@ (400b24 <sifli_suspend+0x28>)
  400b1a:	6a5a      	ldr	r2, [r3, #36]	@ 0x24
  400b1c:	6a1b      	ldr	r3, [r3, #32]
  400b1e:	421a      	tst	r2, r3
  400b20:	d0ef      	beq.n	400b02 <sifli_suspend+0x6>
  400b22:	e7f3      	b.n	400b0c <sifli_suspend+0x10>
  400b24:	40040000 	.word	0x40040000

00400b28 <rt_application_init_power_on_mode>:
  400b28:	4770      	bx	lr

00400b2a <SystemPowerOnModeInit>:
  400b2a:	b508      	push	{r3, lr}
  400b2c:	f000 fcb6 	bl	40149c <SystemPowerOnInitLCPU>
  400b30:	bd08      	pop	{r3, pc}
	...

00400b34 <SystemPowerOnModeGet>:
  400b34:	4b01      	ldr	r3, [pc, #4]	@ (400b3c <SystemPowerOnModeGet+0x8>)
  400b36:	7818      	ldrb	r0, [r3, #0]
  400b38:	4770      	bx	lr
  400b3a:	bf00      	nop
  400b3c:	2040fd54 	.word	0x2040fd54

00400b40 <sifli_standby_handler>:
  400b40:	b510      	push	{r4, lr}
  400b42:	4c0f      	ldr	r4, [pc, #60]	@ (400b80 <sifli_standby_handler+0x40>)
  400b44:	6a23      	ldr	r3, [r4, #32]
  400b46:	069a      	lsls	r2, r3, #26
  400b48:	d406      	bmi.n	400b58 <sifli_standby_handler+0x18>
  400b4a:	f459 fe57 	bl	5a7fc <sifli_standby_handler_core>
  400b4e:	6a23      	ldr	r3, [r4, #32]
  400b50:	069b      	lsls	r3, r3, #26
  400b52:	d40b      	bmi.n	400b6c <sifli_standby_handler+0x2c>
  400b54:	2000      	movs	r0, #0
  400b56:	bd10      	pop	{r4, pc}
  400b58:	4b0a      	ldr	r3, [pc, #40]	@ (400b84 <sifli_standby_handler+0x44>)
  400b5a:	2b00      	cmp	r3, #0
  400b5c:	d0f5      	beq.n	400b4a <sifli_standby_handler+0xa>
  400b5e:	f7ff fe4f 	bl	400800 <ble_standby_sleep_pre_handler>
  400b62:	2800      	cmp	r0, #0
  400b64:	d0f1      	beq.n	400b4a <sifli_standby_handler+0xa>
  400b66:	f04f 30ff 	mov.w	r0, #4294967295
  400b6a:	e7f4      	b.n	400b56 <sifli_standby_handler+0x16>
  400b6c:	4c06      	ldr	r4, [pc, #24]	@ (400b88 <sifli_standby_handler+0x48>)
  400b6e:	6823      	ldr	r3, [r4, #0]
  400b70:	2b00      	cmp	r3, #0
  400b72:	d0ef      	beq.n	400b54 <sifli_standby_handler+0x14>
  400b74:	f7ff fe46 	bl	400804 <ble_standby_sleep_after_handler>
  400b78:	2300      	movs	r3, #0
  400b7a:	6023      	str	r3, [r4, #0]
  400b7c:	e7ea      	b.n	400b54 <sifli_standby_handler+0x14>
  400b7e:	bf00      	nop
  400b80:	40040000 	.word	0x40040000
  400b84:	00400801 	.word	0x00400801
  400b88:	20401aa4 	.word	0x20401aa4

00400b8c <low_power_init>:
  400b8c:	b510      	push	{r4, lr}
  400b8e:	2200      	movs	r2, #0
  400b90:	21fc      	movs	r1, #252	@ 0xfc
  400b92:	480c      	ldr	r0, [pc, #48]	@ (400bc4 <low_power_init+0x38>)
  400b94:	f454 fd36 	bl	55604 <rt_system_pm_init>
  400b98:	2001      	movs	r0, #1
  400b9a:	490b      	ldr	r1, [pc, #44]	@ (400bc8 <low_power_init+0x3c>)
  400b9c:	f453 fb1a 	bl	541d4 <rt_pm_policy_register>
  400ba0:	490a      	ldr	r1, [pc, #40]	@ (400bcc <low_power_init+0x40>)
  400ba2:	2000      	movs	r0, #0
  400ba4:	f453 fa34 	bl	54010 <rt_pm_device_register>
  400ba8:	f415 fc64 	bl	16474 <init_default_wakeup_src>
  400bac:	4b08      	ldr	r3, [pc, #32]	@ (400bd0 <low_power_init+0x44>)
  400bae:	4c09      	ldr	r4, [pc, #36]	@ (400bd4 <low_power_init+0x48>)
  400bb0:	6c9b      	ldr	r3, [r3, #72]	@ 0x48
  400bb2:	60a3      	str	r3, [r4, #8]
  400bb4:	f455 fb14 	bl	561e0 <rt_tick_get>
  400bb8:	2301      	movs	r3, #1
  400bba:	60e0      	str	r0, [r4, #12]
  400bbc:	7023      	strb	r3, [r4, #0]
  400bbe:	2000      	movs	r0, #0
  400bc0:	bd10      	pop	{r4, pc}
  400bc2:	bf00      	nop
  400bc4:	20401580 	.word	0x20401580
  400bc8:	004013e4 	.word	0x004013e4
  400bcc:	004013d8 	.word	0x004013d8
  400bd0:	40040000 	.word	0x40040000
  400bd4:	20401a84 	.word	0x20401a84

00400bd8 <sifli_shutdown_handler>:
  400bd8:	4770      	bx	lr
	...

00400bdc <sifli_sleep>:
  400bdc:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
  400bde:	4b2c      	ldr	r3, [pc, #176]	@ (400c90 <sifli_sleep+0xb4>)
  400be0:	6019      	str	r1, [r3, #0]
  400be2:	3902      	subs	r1, #2
  400be4:	2903      	cmp	r1, #3
  400be6:	d805      	bhi.n	400bf4 <sifli_sleep+0x18>
  400be8:	e8df f001 	tbb	[pc, r1]
  400bec:	0209414a 	.word	0x0209414a
  400bf0:	f7ff fff2 	bl	400bd8 <sifli_shutdown_handler>
  400bf4:	4b27      	ldr	r3, [pc, #156]	@ (400c94 <sifli_sleep+0xb8>)
  400bf6:	6a5a      	ldr	r2, [r3, #36]	@ 0x24
  400bf8:	4b27      	ldr	r3, [pc, #156]	@ (400c98 <sifli_sleep+0xbc>)
  400bfa:	601a      	str	r2, [r3, #0]
  400bfc:	e03f      	b.n	400c7e <sifli_sleep+0xa2>
  400bfe:	2009      	movs	r0, #9
  400c00:	f453 f84a 	bl	53c98 <rt_object_get_information>
  400c04:	4604      	mov	r4, r0
  400c06:	6845      	ldr	r5, [r0, #4]
  400c08:	1d07      	adds	r7, r0, #4
  400c0a:	42bd      	cmp	r5, r7
  400c0c:	d11d      	bne.n	400c4a <sifli_sleep+0x6e>
  400c0e:	4e21      	ldr	r6, [pc, #132]	@ (400c94 <sifli_sleep+0xb8>)
  400c10:	f7ff ff96 	bl	400b40 <sifli_standby_handler>
  400c14:	6cb2      	ldr	r2, [r6, #72]	@ 0x48
  400c16:	4b21      	ldr	r3, [pc, #132]	@ (400c9c <sifli_sleep+0xc0>)
  400c18:	4821      	ldr	r0, [pc, #132]	@ (400ca0 <sifli_sleep+0xc4>)
  400c1a:	619a      	str	r2, [r3, #24]
  400c1c:	f451 f83a 	bl	51c94 <rt_device_find>
  400c20:	4605      	mov	r5, r0
  400c22:	b118      	cbz	r0, 400c2c <sifli_sleep+0x50>
  400c24:	2204      	movs	r2, #4
  400c26:	2101      	movs	r1, #1
  400c28:	f450 ffba 	bl	51ba0 <rt_device_control>
  400c2c:	6c73      	ldr	r3, [r6, #68]	@ 0x44
  400c2e:	481d      	ldr	r0, [pc, #116]	@ (400ca4 <sifli_sleep+0xc8>)
  400c30:	f023 0301 	bic.w	r3, r3, #1
  400c34:	6473      	str	r3, [r6, #68]	@ 0x44
  400c36:	f401 f871 	bl	1d1c <HAL_GPIO_ClearInterrupt>
  400c3a:	6864      	ldr	r4, [r4, #4]
  400c3c:	42bc      	cmp	r4, r7
  400c3e:	d10c      	bne.n	400c5a <sifli_sleep+0x7e>
  400c40:	f415 febc 	bl	169bc <ipc_queue_restore_all>
  400c44:	f415 feee 	bl	16a24 <ipc_queue_restore_all_rom>
  400c48:	e7d4      	b.n	400bf4 <sifli_sleep+0x18>
  400c4a:	f1a5 000c 	sub.w	r0, r5, #12
  400c4e:	2204      	movs	r2, #4
  400c50:	2102      	movs	r1, #2
  400c52:	f450 ffa5 	bl	51ba0 <rt_device_control>
  400c56:	682d      	ldr	r5, [r5, #0]
  400c58:	e7d7      	b.n	400c0a <sifli_sleep+0x2e>
  400c5a:	f1a4 000c 	sub.w	r0, r4, #12
  400c5e:	4285      	cmp	r5, r0
  400c60:	d003      	beq.n	400c6a <sifli_sleep+0x8e>
  400c62:	2204      	movs	r2, #4
  400c64:	2101      	movs	r1, #1
  400c66:	f450 ff9b 	bl	51ba0 <rt_device_control>
  400c6a:	6824      	ldr	r4, [r4, #0]
  400c6c:	e7e6      	b.n	400c3c <sifli_sleep+0x60>
  400c6e:	f459 fc63 	bl	5a538 <sifli_deep_handler>
  400c72:	4b08      	ldr	r3, [pc, #32]	@ (400c94 <sifli_sleep+0xb8>)
  400c74:	2800      	cmp	r0, #0
  400c76:	6c9a      	ldr	r2, [r3, #72]	@ 0x48
  400c78:	4b08      	ldr	r3, [pc, #32]	@ (400c9c <sifli_sleep+0xc0>)
  400c7a:	619a      	str	r2, [r3, #24]
  400c7c:	dbba      	blt.n	400bf4 <sifli_sleep+0x18>
  400c7e:	bdf8      	pop	{r3, r4, r5, r6, r7, pc}
  400c80:	f459 fca6 	bl	5a5d0 <sifli_light_handler>
  400c84:	4b03      	ldr	r3, [pc, #12]	@ (400c94 <sifli_sleep+0xb8>)
  400c86:	6c9a      	ldr	r2, [r3, #72]	@ 0x48
  400c88:	4b04      	ldr	r3, [pc, #16]	@ (400c9c <sifli_sleep+0xc0>)
  400c8a:	619a      	str	r2, [r3, #24]
  400c8c:	e7b2      	b.n	400bf4 <sifli_sleep+0x18>
  400c8e:	bf00      	nop
  400c90:	2040e8c0 	.word	0x2040e8c0
  400c94:	40040000 	.word	0x40040000
  400c98:	2040fd58 	.word	0x2040fd58
  400c9c:	20401a84 	.word	0x20401a84
  400ca0:	00401341 	.word	0x00401341
  400ca4:	40080000 	.word	0x40080000

00400ca8 <pm_set_last_latch_tick>:
  400ca8:	4b01      	ldr	r3, [pc, #4]	@ (400cb0 <pm_set_last_latch_tick+0x8>)
  400caa:	60d8      	str	r0, [r3, #12]
  400cac:	4770      	bx	lr
  400cae:	bf00      	nop
  400cb0:	20401a84 	.word	0x20401a84

00400cb4 <AON_IRQHandler>:
  400cb4:	b508      	push	{r3, lr}
  400cb6:	f451 fecf 	bl	52a58 <rt_interrupt_enter>
  400cba:	f400 fb93 	bl	13e4 <AON_LCPU_IRQHandler>
  400cbe:	e8bd 4008 	ldmia.w	sp!, {r3, lr}
  400cc2:	f451 bee1 	b.w	52a88 <rt_interrupt_leave>

00400cc6 <wdt_store_exception_information>:
  400cc6:	4770      	bx	lr

00400cc8 <WDT_IRQHandler>:
  400cc8:	b538      	push	{r3, r4, r5, lr}
  400cca:	4b18      	ldr	r3, [pc, #96]	@ (400d2c <WDT_IRQHandler+0x64>)
  400ccc:	681a      	ldr	r2, [r3, #0]
  400cce:	bb2a      	cbnz	r2, 400d1c <WDT_IRQHandler+0x54>
  400cd0:	2401      	movs	r4, #1
  400cd2:	4d17      	ldr	r5, [pc, #92]	@ (400d30 <WDT_IRQHandler+0x68>)
  400cd4:	601c      	str	r4, [r3, #0]
  400cd6:	692b      	ldr	r3, [r5, #16]
  400cd8:	005a      	lsls	r2, r3, #1
  400cda:	d41f      	bmi.n	400d1c <WDT_IRQHandler+0x54>
  400cdc:	f7ff fff3 	bl	400cc6 <wdt_store_exception_information>
  400ce0:	4620      	mov	r0, r4
  400ce2:	f401 f987 	bl	1ff4 <HAL_LPAON_WakeCore>
  400ce6:	692b      	ldr	r3, [r5, #16]
  400ce8:	4620      	mov	r0, r4
  400cea:	f043 5380 	orr.w	r3, r3, #268435456	@ 0x10000000
  400cee:	612b      	str	r3, [r5, #16]
  400cf0:	4b10      	ldr	r3, [pc, #64]	@ (400d34 <WDT_IRQHandler+0x6c>)
  400cf2:	4d11      	ldr	r5, [pc, #68]	@ (400d38 <WDT_IRQHandler+0x70>)
  400cf4:	f64b 3481 	movw	r4, #48001	@ 0xbb81
  400cf8:	602b      	str	r3, [r5, #0]
  400cfa:	f000 f833 	bl	400d64 <HAL_Delay>
  400cfe:	2234      	movs	r2, #52	@ 0x34
  400d00:	682b      	ldr	r3, [r5, #0]
  400d02:	60da      	str	r2, [r3, #12]
  400d04:	682b      	ldr	r3, [r5, #0]
  400d06:	695b      	ldr	r3, [r3, #20]
  400d08:	079b      	lsls	r3, r3, #30
  400d0a:	d408      	bmi.n	400d1e <WDT_IRQHandler+0x56>
  400d0c:	2001      	movs	r0, #1
  400d0e:	f000 f829 	bl	400d64 <HAL_Delay>
  400d12:	4a07      	ldr	r2, [pc, #28]	@ (400d30 <WDT_IRQHandler+0x68>)
  400d14:	6813      	ldr	r3, [r2, #0]
  400d16:	f043 0301 	orr.w	r3, r3, #1
  400d1a:	6013      	str	r3, [r2, #0]
  400d1c:	bd38      	pop	{r3, r4, r5, pc}
  400d1e:	3c01      	subs	r4, #1
  400d20:	d0f4      	beq.n	400d0c <WDT_IRQHandler+0x44>
  400d22:	2001      	movs	r0, #1
  400d24:	f400 ffd2 	bl	1ccc <HAL_Delay_us_>
  400d28:	e7ec      	b.n	400d04 <WDT_IRQHandler+0x3c>
  400d2a:	bf00      	nop
  400d2c:	20401aa8 	.word	0x20401aa8
  400d30:	4000f000 	.word	0x4000f000
  400d34:	4000b000 	.word	0x4000b000
  400d38:	20401aac 	.word	0x20401aac

00400d3c <lcpu_thread_init_hook>:
  400d3c:	b510      	push	{r4, lr}
  400d3e:	6ac2      	ldr	r2, [r0, #44]	@ 0x2c
  400d40:	6a81      	ldr	r1, [r0, #40]	@ 0x28
  400d42:	3a04      	subs	r2, #4
  400d44:	4604      	mov	r4, r0
  400d46:	440a      	add	r2, r1
  400d48:	4b05      	ldr	r3, [pc, #20]	@ (400d60 <lcpu_thread_init_hook+0x24>)
  400d4a:	e9d0 0108 	ldrd	r0, r1, [r0, #32]
  400d4e:	f451 fc85 	bl	5265c <rt_hw_stack_init>
  400d52:	61e0      	str	r0, [r4, #28]
  400d54:	6aa1      	ldr	r1, [r4, #40]	@ 0x28
  400d56:	e8bd 4010 	ldmia.w	sp!, {r4, lr}
  400d5a:	f000 b92d 	b.w	400fb8 <rt_hw_set_stack_limit>
  400d5e:	bf00      	nop
  400d60:	00055ad1 	.word	0x00055ad1

00400d64 <HAL_Delay>:
  400d64:	b507      	push	{r0, r1, r2, lr}
  400d66:	9001      	str	r0, [sp, #4]
  400d68:	9b01      	ldr	r3, [sp, #4]
  400d6a:	b913      	cbnz	r3, 400d72 <HAL_Delay+0xe>
  400d6c:	b003      	add	sp, #12
  400d6e:	f85d fb04 	ldr.w	pc, [sp], #4
  400d72:	f44f 707a 	mov.w	r0, #1000	@ 0x3e8
  400d76:	f7ff facf 	bl	400318 <HAL_Delay_us>
  400d7a:	9b01      	ldr	r3, [sp, #4]
  400d7c:	3b01      	subs	r3, #1
  400d7e:	9301      	str	r3, [sp, #4]
  400d80:	e7f2      	b.n	400d68 <HAL_Delay+0x4>

00400d82 <HAL_InitTick>:
  400d82:	2000      	movs	r0, #0
  400d84:	4770      	bx	lr
	...

00400d88 <SysTick_Handler>:
  400d88:	b570      	push	{r4, r5, r6, lr}
  400d8a:	4d14      	ldr	r5, [pc, #80]	@ (400ddc <SysTick_Handler+0x54>)
  400d8c:	f451 fe64 	bl	52a58 <rt_interrupt_enter>
  400d90:	6a6b      	ldr	r3, [r5, #36]	@ 0x24
  400d92:	f7ff fab9 	bl	400308 <HAL_IncTick>
  400d96:	f455 fa23 	bl	561e0 <rt_tick_get>
  400d9a:	6aeb      	ldr	r3, [r5, #44]	@ 0x2c
  400d9c:	4604      	mov	r4, r0
  400d9e:	069b      	lsls	r3, r3, #26
  400da0:	d405      	bmi.n	400dae <SysTick_Handler+0x26>
  400da2:	f455 fa25 	bl	561f0 <rt_tick_increase>
  400da6:	e8bd 4070 	ldmia.w	sp!, {r4, r5, r6, lr}
  400daa:	f451 be6d 	b.w	52a88 <rt_interrupt_leave>
  400dae:	6cad      	ldr	r5, [r5, #72]	@ 0x48
  400db0:	1c46      	adds	r6, r0, #1
  400db2:	f401 f92f 	bl	2014 <HAL_LPTIM_GetFreq>
  400db6:	2301      	movs	r3, #1
  400db8:	4602      	mov	r2, r0
  400dba:	4629      	mov	r1, r5
  400dbc:	4630      	mov	r0, r6
  400dbe:	f44f fd8b 	bl	508d8 <pm_latch_tick>
  400dc2:	4284      	cmp	r4, r0
  400dc4:	d0ef      	beq.n	400da6 <SysTick_Handler+0x1e>
  400dc6:	4286      	cmp	r6, r0
  400dc8:	d0eb      	beq.n	400da2 <SysTick_Handler+0x1a>
  400dca:	f455 fa11 	bl	561f0 <rt_tick_increase>
  400dce:	f455 fa0f 	bl	561f0 <rt_tick_increase>
  400dd2:	1ca0      	adds	r0, r4, #2
  400dd4:	f7ff ff68 	bl	400ca8 <pm_set_last_latch_tick>
  400dd8:	e7e5      	b.n	400da6 <SysTick_Handler+0x1e>
  400dda:	bf00      	nop
  400ddc:	40040000 	.word	0x40040000

00400de0 <HAL_AssertFailed>:
  400de0:	2300      	movs	r3, #0
  400de2:	b507      	push	{r0, r1, r2, lr}
  400de4:	f240 224f 	movw	r2, #591	@ 0x24f
  400de8:	4905      	ldr	r1, [pc, #20]	@ (400e00 <HAL_AssertFailed+0x20>)
  400dea:	4806      	ldr	r0, [pc, #24]	@ (400e04 <HAL_AssertFailed+0x24>)
  400dec:	9301      	str	r3, [sp, #4]
  400dee:	f450 fab5 	bl	5135c <rt_assert_handler>
  400df2:	9b01      	ldr	r3, [sp, #4]
  400df4:	2b00      	cmp	r3, #0
  400df6:	d0fc      	beq.n	400df2 <HAL_AssertFailed+0x12>
  400df8:	b003      	add	sp, #12
  400dfa:	f85d fb04 	ldr.w	pc, [sp], #4
  400dfe:	bf00      	nop
  400e00:	004013ec 	.word	0x004013ec
  400e04:	0040130c 	.word	0x0040130c

00400e08 <rt_hw_preboard_init>:
  400e08:	4770      	bx	lr
	...

00400e0c <rt_hw_board_init>:
  400e0c:	b508      	push	{r3, lr}
  400e0e:	f7ff fffb 	bl	400e08 <rt_hw_preboard_init>
  400e12:	f7ff fa68 	bl	4002e6 <HAL_Init>
  400e16:	4808      	ldr	r0, [pc, #32]	@ (400e38 <rt_hw_board_init+0x2c>)
  400e18:	f454 ffc8 	bl	55dac <rt_thread_inited_sethook>
  400e1c:	f7ff f9b9 	bl	400192 <SystemClock_Config>
  400e20:	f451 fc3a 	bl	52698 <rt_hw_systick_init>
  400e24:	f451 fc82 	bl	5272c <rt_hw_watchdog_init>
  400e28:	4904      	ldr	r1, [pc, #16]	@ (400e3c <rt_hw_board_init+0x30>)
  400e2a:	4805      	ldr	r0, [pc, #20]	@ (400e40 <rt_hw_board_init+0x34>)
  400e2c:	f454 fb9c 	bl	55568 <rt_system_heap_init>
  400e30:	e8bd 4008 	ldmia.w	sp!, {r3, lr}
  400e34:	f000 b80e 	b.w	400e54 <rt_components_board_init>
  400e38:	00400d3d 	.word	0x00400d3d
  400e3c:	20405c00 	.word	0x20405c00
  400e40:	20401cb8 	.word	0x20401cb8

00400e44 <rti_start>:
  400e44:	2000      	movs	r0, #0
  400e46:	4770      	bx	lr

00400e48 <rti_board_start>:
  400e48:	2000      	movs	r0, #0
  400e4a:	4770      	bx	lr

00400e4c <rti_board_end>:
  400e4c:	2000      	movs	r0, #0
  400e4e:	4770      	bx	lr

00400e50 <rti_end>:
  400e50:	2000      	movs	r0, #0
  400e52:	4770      	bx	lr

00400e54 <rt_components_board_init>:
  400e54:	b538      	push	{r3, r4, r5, lr}
  400e56:	4c04      	ldr	r4, [pc, #16]	@ (400e68 <rt_components_board_init+0x14>)
  400e58:	4d04      	ldr	r5, [pc, #16]	@ (400e6c <rt_components_board_init+0x18>)
  400e5a:	42ac      	cmp	r4, r5
  400e5c:	d300      	bcc.n	400e60 <rt_components_board_init+0xc>
  400e5e:	bd38      	pop	{r3, r4, r5, pc}
  400e60:	f854 3b04 	ldr.w	r3, [r4], #4
  400e64:	4798      	blx	r3
  400e66:	e7f8      	b.n	400e5a <rt_components_board_init+0x6>
  400e68:	00401524 	.word	0x00401524
  400e6c:	00401528 	.word	0x00401528

00400e70 <rt_components_init>:
  400e70:	b538      	push	{r3, r4, r5, lr}
  400e72:	4c05      	ldr	r4, [pc, #20]	@ (400e88 <rt_components_init+0x18>)
  400e74:	4d05      	ldr	r5, [pc, #20]	@ (400e8c <rt_components_init+0x1c>)
  400e76:	42ac      	cmp	r4, r5
  400e78:	d300      	bcc.n	400e7c <rt_components_init+0xc>
  400e7a:	bd38      	pop	{r3, r4, r5, pc}
  400e7c:	f854 3b04 	ldr.w	r3, [r4], #4
  400e80:	2b00      	cmp	r3, #0
  400e82:	d0f8      	beq.n	400e76 <rt_components_init+0x6>
  400e84:	4798      	blx	r3
  400e86:	e7f6      	b.n	400e76 <rt_components_init+0x6>
  400e88:	00401528 	.word	0x00401528
  400e8c:	00401548 	.word	0x00401548

00400e90 <main_thread_entry>:
  400e90:	b513      	push	{r0, r1, r4, lr}
  400e92:	2402      	movs	r4, #2
  400e94:	f88d 4006 	strb.w	r4, [sp, #6]
  400e98:	f454 ffd8 	bl	55e4c <rt_thread_self>
  400e9c:	f890 3035 	ldrb.w	r3, [r0, #53]	@ 0x35
  400ea0:	f88d 3007 	strb.w	r3, [sp, #7]
  400ea4:	f454 ffd2 	bl	55e4c <rt_thread_self>
  400ea8:	4621      	mov	r1, r4
  400eaa:	f10d 0206 	add.w	r2, sp, #6
  400eae:	f454 fce1 	bl	55874 <rt_thread_control>
  400eb2:	f7ff ffdd 	bl	400e70 <rt_components_init>
  400eb6:	f454 ffc9 	bl	55e4c <rt_thread_self>
  400eba:	4621      	mov	r1, r4
  400ebc:	f10d 0207 	add.w	r2, sp, #7
  400ec0:	f454 fcd8 	bl	55874 <rt_thread_control>
  400ec4:	f7ff f99e 	bl	400204 <main>
  400ec8:	b002      	add	sp, #8
  400eca:	bd10      	pop	{r4, pc}

00400ecc <pre_main>:
  400ecc:	4770      	bx	lr
	...

00400ed0 <rt_application_init>:
  400ed0:	2302      	movs	r3, #2
  400ed2:	2214      	movs	r2, #20
  400ed4:	b513      	push	{r0, r1, r4, lr}
  400ed6:	490b      	ldr	r1, [pc, #44]	@ (400f04 <rt_application_init+0x34>)
  400ed8:	e9cd 3200 	strd	r3, r2, [sp]
  400edc:	480a      	ldr	r0, [pc, #40]	@ (400f08 <rt_application_init+0x38>)
  400ede:	f44f 6380 	mov.w	r3, #1024	@ 0x400
  400ee2:	2200      	movs	r2, #0
  400ee4:	f454 fd0e 	bl	55904 <rt_thread_create>
  400ee8:	4604      	mov	r4, r0
  400eea:	b928      	cbnz	r0, 400ef8 <rt_application_init+0x28>
  400eec:	f44f 72b3 	mov.w	r2, #358	@ 0x166
  400ef0:	4906      	ldr	r1, [pc, #24]	@ (400f0c <rt_application_init+0x3c>)
  400ef2:	4807      	ldr	r0, [pc, #28]	@ (400f10 <rt_application_init+0x40>)
  400ef4:	f450 fa32 	bl	5135c <rt_assert_handler>
  400ef8:	4620      	mov	r0, r4
  400efa:	b002      	add	sp, #8
  400efc:	e8bd 4010 	ldmia.w	sp!, {r4, lr}
  400f00:	f455 b842 	b.w	55f88 <rt_thread_startup>
  400f04:	00400e91 	.word	0x00400e91
  400f08:	00401345 	.word	0x00401345
  400f0c:	004013fd 	.word	0x004013fd
  400f10:	0040134a 	.word	0x0040134a

00400f14 <rtthread_startup>:
  400f14:	b508      	push	{r3, lr}
  400f16:	f7ff f461 	bl	7dc <rt_hw_interrupt_disable>
  400f1a:	f7ff fe05 	bl	400b28 <rt_application_init_power_on_mode>
  400f1e:	f7ff ff75 	bl	400e0c <rt_hw_board_init>
  400f22:	f7ff fe07 	bl	400b34 <SystemPowerOnModeGet>
  400f26:	b908      	cbnz	r0, 400f2c <rtthread_startup+0x18>
  400f28:	f454 fa83 	bl	55432 <rt_show_version>
  400f2c:	f454 fc98 	bl	55860 <rt_system_timer_init>
  400f30:	f454 fc6c 	bl	5580c <rt_system_scheduler_init>
  400f34:	f7ff ffcc 	bl	400ed0 <rt_application_init>
  400f38:	f454 fc9a 	bl	55870 <rt_system_timer_thread_init>
  400f3c:	f000 f81e 	bl	400f7c <rt_thread_idle_init>
  400f40:	f454 fc7a 	bl	55838 <rt_system_scheduler_start>
  400f44:	2000      	movs	r0, #0
  400f46:	bd08      	pop	{r3, pc}

00400f48 <entry>:
  400f48:	b508      	push	{r3, lr}
  400f4a:	f7ff ffbf 	bl	400ecc <pre_main>
  400f4e:	f7ff ffe1 	bl	400f14 <rtthread_startup>
  400f52:	2000      	movs	r0, #0
  400f54:	bd08      	pop	{r3, pc}
	...

00400f58 <rt_thread_idle_entry>:
  400f58:	b538      	push	{r3, r4, r5, lr}
  400f5a:	2400      	movs	r4, #0
  400f5c:	4d06      	ldr	r5, [pc, #24]	@ (400f78 <rt_thread_idle_entry+0x20>)
  400f5e:	f855 3b04 	ldr.w	r3, [r5], #4
  400f62:	b103      	cbz	r3, 400f66 <rt_thread_idle_entry+0xe>
  400f64:	4798      	blx	r3
  400f66:	3401      	adds	r4, #1
  400f68:	2c04      	cmp	r4, #4
  400f6a:	d1f8      	bne.n	400f5e <rt_thread_idle_entry+0x6>
  400f6c:	f454 fe4a 	bl	55c04 <rt_thread_idle_excute>
  400f70:	f454 fb88 	bl	55684 <rt_system_power_manager>
  400f74:	e7f1      	b.n	400f5a <rt_thread_idle_entry+0x2>
  400f76:	bf00      	nop
  400f78:	2040efec 	.word	0x2040efec

00400f7c <rt_thread_idle_init>:
  400f7c:	b51f      	push	{r0, r1, r2, r3, r4, lr}
  400f7e:	2307      	movs	r3, #7
  400f80:	2220      	movs	r2, #32
  400f82:	e9cd 3202 	strd	r3, r2, [sp, #8]
  400f86:	f44f 7300 	mov.w	r3, #512	@ 0x200
  400f8a:	9301      	str	r3, [sp, #4]
  400f8c:	4b06      	ldr	r3, [pc, #24]	@ (400fa8 <rt_thread_idle_init+0x2c>)
  400f8e:	4a07      	ldr	r2, [pc, #28]	@ (400fac <rt_thread_idle_init+0x30>)
  400f90:	9300      	str	r3, [sp, #0]
  400f92:	4907      	ldr	r1, [pc, #28]	@ (400fb0 <rt_thread_idle_init+0x34>)
  400f94:	2300      	movs	r3, #0
  400f96:	4807      	ldr	r0, [pc, #28]	@ (400fb4 <rt_thread_idle_init+0x38>)
  400f98:	f454 fecc 	bl	55d34 <rt_thread_init>
  400f9c:	4805      	ldr	r0, [pc, #20]	@ (400fb4 <rt_thread_idle_init+0x38>)
  400f9e:	b005      	add	sp, #20
  400fa0:	f85d eb04 	ldr.w	lr, [sp], #4
  400fa4:	f454 bff0 	b.w	55f88 <rt_thread_startup>
  400fa8:	20401ab8 	.word	0x20401ab8
  400fac:	00400f59 	.word	0x00400f59
  400fb0:	00401359 	.word	0x00401359
  400fb4:	2040ef70 	.word	0x2040ef70

00400fb8 <rt_hw_set_stack_limit>:
  400fb8:	4770      	bx	lr
  400fba:	0000      	movs	r0, r0
  400fbc:	f3ef 8010 	mrs	r0, PRIMASK
  400fc0:	b672      	cpsid	i
  400fc2:	4770      	bx	lr
  400fc4:	f380 8810 	msr	PRIMASK, r0
  400fc8:	4770      	bx	lr
  400fca:	bf40      	sev
  400fcc:	4a5f      	ldr	r2, [pc, #380]	@ (40114c <rt_hw_fatal_error+0x44>)
  400fce:	6813      	ldr	r3, [r2, #0]
  400fd0:	2b01      	cmp	r3, #1
  400fd2:	d004      	beq.n	400fde <_reswitch>
  400fd4:	f04f 0301 	mov.w	r3, #1
  400fd8:	6013      	str	r3, [r2, #0]
  400fda:	4a5d      	ldr	r2, [pc, #372]	@ (401150 <rt_hw_fatal_error+0x48>)
  400fdc:	6010      	str	r0, [r2, #0]

00400fde <_reswitch>:
  400fde:	4a5d      	ldr	r2, [pc, #372]	@ (401154 <rt_hw_fatal_error+0x4c>)
  400fe0:	6011      	str	r1, [r2, #0]
  400fe2:	485d      	ldr	r0, [pc, #372]	@ (401158 <rt_hw_fatal_error+0x50>)
  400fe4:	f04f 5180 	mov.w	r1, #268435456	@ 0x10000000
  400fe8:	6001      	str	r1, [r0, #0]
  400fea:	4770      	bx	lr
  400fec:	f3ef 8210 	mrs	r2, PRIMASK
  400ff0:	b672      	cpsid	i
  400ff2:	4856      	ldr	r0, [pc, #344]	@ (40114c <rt_hw_fatal_error+0x44>)
  400ff4:	6801      	ldr	r1, [r0, #0]
  400ff6:	b1c9      	cbz	r1, 40102c <pendsv_exit>
  400ff8:	f04f 0100 	mov.w	r1, #0
  400ffc:	6001      	str	r1, [r0, #0]
  400ffe:	4854      	ldr	r0, [pc, #336]	@ (401150 <rt_hw_fatal_error+0x48>)
  401000:	6801      	ldr	r1, [r0, #0]
  401002:	b149      	cbz	r1, 401018 <switch_to_thread>
  401004:	f3ef 8109 	mrs	r1, PSP
  401008:	e921 0ff0 	stmdb	r1!, {r4, r5, r6, r7, r8, r9, sl, fp}
  40100c:	f3ef 840b 	mrs	r4, PSPLIM
  401010:	f841 4d04 	str.w	r4, [r1, #-4]!
  401014:	6800      	ldr	r0, [r0, #0]
  401016:	6001      	str	r1, [r0, #0]

00401018 <switch_to_thread>:
  401018:	494e      	ldr	r1, [pc, #312]	@ (401154 <rt_hw_fatal_error+0x4c>)
  40101a:	6809      	ldr	r1, [r1, #0]
  40101c:	6809      	ldr	r1, [r1, #0]
  40101e:	c910      	ldmia	r1!, {r4}
  401020:	f384 880b 	msr	PSPLIM, r4
  401024:	e8b1 0ff0 	ldmia.w	r1!, {r4, r5, r6, r7, r8, r9, sl, fp}
  401028:	f381 8809 	msr	PSP, r1

0040102c <pendsv_exit>:
  40102c:	f382 8810 	msr	PRIMASK, r2
  401030:	f04e 0e04 	orr.w	lr, lr, #4
  401034:	4770      	bx	lr
  401036:	4849      	ldr	r0, [pc, #292]	@ (40115c <rt_hw_fatal_error+0x54>)
  401038:	f44f 017f 	mov.w	r1, #16711680	@ 0xff0000
  40103c:	f8d0 2000 	ldr.w	r2, [r0]
  401040:	ea41 0102 	orr.w	r1, r1, r2
  401044:	6001      	str	r1, [r0, #0]
  401046:	4770      	bx	lr
  401048:	4942      	ldr	r1, [pc, #264]	@ (401154 <rt_hw_fatal_error+0x4c>)
  40104a:	6008      	str	r0, [r1, #0]
  40104c:	4940      	ldr	r1, [pc, #256]	@ (401150 <rt_hw_fatal_error+0x48>)
  40104e:	f04f 0000 	mov.w	r0, #0
  401052:	6008      	str	r0, [r1, #0]
  401054:	493d      	ldr	r1, [pc, #244]	@ (40114c <rt_hw_fatal_error+0x44>)
  401056:	f04f 0001 	mov.w	r0, #1
  40105a:	6008      	str	r0, [r1, #0]
  40105c:	483f      	ldr	r0, [pc, #252]	@ (40115c <rt_hw_fatal_error+0x54>)
  40105e:	f44f 017f 	mov.w	r1, #16711680	@ 0xff0000
  401062:	f8d0 2000 	ldr.w	r2, [r0]
  401066:	ea41 0102 	orr.w	r1, r1, r2
  40106a:	6001      	str	r1, [r0, #0]
  40106c:	483a      	ldr	r0, [pc, #232]	@ (401158 <rt_hw_fatal_error+0x50>)
  40106e:	f04f 5180 	mov.w	r1, #268435456	@ 0x10000000
  401072:	6001      	str	r1, [r0, #0]
  401074:	483a      	ldr	r0, [pc, #232]	@ (401160 <rt_hw_fatal_error+0x58>)
  401076:	6800      	ldr	r0, [r0, #0]
  401078:	6800      	ldr	r0, [r0, #0]
  40107a:	bf00      	nop
  40107c:	f380 8808 	msr	MSP, r0
  401080:	b661      	cpsie	f
  401082:	b662      	cpsie	i
  401084:	4770      	bx	lr
  401086:	bf00      	nop
  401088:	bf20      	wfe
  40108a:	4770      	bx	lr
  40108c:	f3ef 8008 	mrs	r0, MSP
  401090:	f01e 0f04 	tst.w	lr, #4
  401094:	d001      	beq.n	40109a <_get_sp_done>
  401096:	f3ef 8009 	mrs	r0, PSP

0040109a <_get_sp_done>:
  40109a:	e920 0ff0 	stmdb	r0!, {r4, r5, r6, r7, r8, r9, sl, fp}
  40109e:	f3ef 840b 	mrs	r4, PSPLIM
  4010a2:	f840 4d04 	str.w	r4, [r0, #-4]!
  4010a6:	f840 ed04 	str.w	lr, [r0, #-4]!
  4010aa:	f01e 0f04 	tst.w	lr, #4
  4010ae:	d002      	beq.n	4010b6 <_update_msp>
  4010b0:	f380 8809 	msr	PSP, r0
  4010b4:	e001      	b.n	4010ba <_update_done>

004010b6 <_update_msp>:
  4010b6:	f380 8808 	msr	MSP, r0

004010ba <_update_done>:
  4010ba:	b500      	push	{lr}
  4010bc:	f451 faaf 	bl	5261e <rt_hw_hard_fault_exception>
  4010c0:	f85d eb04 	ldr.w	lr, [sp], #4
  4010c4:	f04e 0e04 	orr.w	lr, lr, #4
  4010c8:	4770      	bx	lr
  4010ca:	f3ef 8008 	mrs	r0, MSP
  4010ce:	f01e 0f04 	tst.w	lr, #4
  4010d2:	d001      	beq.n	4010d8 <_mm_get_sp_done>
  4010d4:	f3ef 8009 	mrs	r0, PSP

004010d8 <_mm_get_sp_done>:
  4010d8:	e920 0ff0 	stmdb	r0!, {r4, r5, r6, r7, r8, r9, sl, fp}
  4010dc:	f3ef 840b 	mrs	r4, PSPLIM
  4010e0:	f840 4d04 	str.w	r4, [r0, #-4]!
  4010e4:	f840 ed04 	str.w	lr, [r0, #-4]!
  4010e8:	f01e 0f04 	tst.w	lr, #4
  4010ec:	d002      	beq.n	4010f4 <_mm_update_msp>
  4010ee:	f380 8809 	msr	PSP, r0
  4010f2:	e001      	b.n	4010f8 <_mm_update_done>

004010f4 <_mm_update_msp>:
  4010f4:	f380 8808 	msr	MSP, r0

004010f8 <_mm_update_done>:
  4010f8:	b500      	push	{lr}
  4010fa:	f451 fa93 	bl	52624 <rt_hw_mem_manage_exception>
  4010fe:	f85d eb04 	ldr.w	lr, [sp], #4
  401102:	f04e 0e04 	orr.w	lr, lr, #4
  401106:	4770      	bx	lr

00401108 <rt_hw_fatal_error>:
  401108:	b410      	push	{r4}
  40110a:	f3ef 8403 	mrs	r4, PSR
  40110e:	b410      	push	{r4}
  401110:	467c      	mov	r4, pc
  401112:	b500      	push	{lr}
  401114:	b500      	push	{lr}
  401116:	f84d cd04 	str.w	ip, [sp, #-4]!
  40111a:	b40f      	push	{r0, r1, r2, r3}
  40111c:	9c08      	ldr	r4, [sp, #32]
  40111e:	e92d 0ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp}
  401122:	f3ef 840b 	mrs	r4, PSPLIM
  401126:	b410      	push	{r4}
  401128:	4668      	mov	r0, sp
  40112a:	f451 fa37 	bl	5259c <rt_hw_do_fatal_error>
  40112e:	bc10      	pop	{r4}
  401130:	f384 880b 	msr	PSPLIM, r4
  401134:	e8bd 0ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp}
  401138:	bc0f      	pop	{r0, r1, r2, r3}
  40113a:	f85d cb04 	ldr.w	ip, [sp], #4
  40113e:	f85d eb04 	ldr.w	lr, [sp], #4
  401142:	bc10      	pop	{r4}
  401144:	bc10      	pop	{r4}
  401146:	bc10      	pop	{r4}
  401148:	4770      	bx	lr
  40114a:	0000      	.short	0x0000
  40114c:	2040f8a4 	.word	0x2040f8a4
  401150:	2040f874 	.word	0x2040f874
  401154:	2040f878 	.word	0x2040f878
  401158:	e000ed04 	.word	0xe000ed04
  40115c:	e000ed20 	.word	0xe000ed20
  401160:	e000ed08 	.word	0xe000ed08

00401164 <memset>:
  401164:	4402      	add	r2, r0
  401166:	4603      	mov	r3, r0
  401168:	4293      	cmp	r3, r2
  40116a:	d100      	bne.n	40116e <memset+0xa>
  40116c:	4770      	bx	lr
  40116e:	f803 1b01 	strb.w	r1, [r3], #1
  401172:	e7f9      	b.n	401168 <memset+0x4>
  401174:	695c3a44 	.word	0x695c3a44
  401178:	7270746f 	.word	0x7270746f
  40117c:	63656a6f 	.word	0x63656a6f
  401180:	434c5c74 	.word	0x434c5c74
  401184:	5c505348 	.word	0x5c505348
  401188:	6e65704f 	.word	0x6e65704f
  40118c:	6c466953 	.word	0x6c466953
  401190:	69675c69 	.word	0x69675c69
  401194:	62756874 	.word	0x62756874
  401198:	5c6b6473 	.word	0x5c6b6473
  40119c:	6c466953 	.word	0x6c466953
  4011a0:	44532d69 	.word	0x44532d69
  4011a4:	32765c4b 	.word	0x32765c4b
  4011a8:	535c352e 	.word	0x535c352e
  4011ac:	696c4669 	.word	0x696c4669
  4011b0:	4b44532d 	.word	0x4b44532d
  4011b4:	2e32562d 	.word	0x2e32562d
  4011b8:	72645c35 	.word	0x72645c35
  4011bc:	72657669 	.word	0x72657669
  4011c0:	61685c73 	.word	0x61685c73
  4011c4:	66625c6c 	.word	0x66625c6c
  4011c8:	61685f30 	.word	0x61685f30
  4011cc:	616d5f6c 	.word	0x616d5f6c
  4011d0:	6f626c69 	.word	0x6f626c69
  4011d4:	00632e78 	.word	0x00632e78
  4011d8:	695c3a44 	.word	0x695c3a44
  4011dc:	7270746f 	.word	0x7270746f
  4011e0:	63656a6f 	.word	0x63656a6f
  4011e4:	434c5c74 	.word	0x434c5c74
  4011e8:	5c505348 	.word	0x5c505348
  4011ec:	6e65704f 	.word	0x6e65704f
  4011f0:	6c466953 	.word	0x6c466953
  4011f4:	69675c69 	.word	0x69675c69
  4011f8:	62756874 	.word	0x62756874
  4011fc:	5c6b6473 	.word	0x5c6b6473
  401200:	6c466953 	.word	0x6c466953
  401204:	44532d69 	.word	0x44532d69
  401208:	32765c4b 	.word	0x32765c4b
  40120c:	535c352e 	.word	0x535c352e
  401210:	696c4669 	.word	0x696c4669
  401214:	4b44532d 	.word	0x4b44532d
  401218:	2e32562d 	.word	0x2e32562d
  40121c:	72645c35 	.word	0x72645c35
  401220:	72657669 	.word	0x72657669
  401224:	61685c73 	.word	0x61685c73
  401228:	66625c6c 	.word	0x66625c6c
  40122c:	61685f30 	.word	0x61685f30
  401230:	69705f6c 	.word	0x69705f6c
  401234:	78756d6e 	.word	0x78756d6e
  401238:	4400632e 	.word	0x4400632e
  40123c:	6f695c3a 	.word	0x6f695c3a
  401240:	6f727074 	.word	0x6f727074
  401244:	7463656a 	.word	0x7463656a
  401248:	48434c5c 	.word	0x48434c5c
  40124c:	4f5c5053 	.word	0x4f5c5053
  401250:	536e6570 	.word	0x536e6570
  401254:	696c4669 	.word	0x696c4669
  401258:	7469675c 	.word	0x7469675c
  40125c:	73627568 	.word	0x73627568
  401260:	535c6b64 	.word	0x535c6b64
  401264:	696c4669 	.word	0x696c4669
  401268:	4b44532d 	.word	0x4b44532d
  40126c:	2e32765c 	.word	0x2e32765c
  401270:	69535c35 	.word	0x69535c35
  401274:	2d696c46 	.word	0x2d696c46
  401278:	2d4b4453 	.word	0x2d4b4453
  40127c:	352e3256 	.word	0x352e3256
  401280:	6972645c 	.word	0x6972645c
  401284:	73726576 	.word	0x73726576
  401288:	6c61685c 	.word	0x6c61685c
  40128c:	3066625c 	.word	0x3066625c
  401290:	6c61685f 	.word	0x6c61685f
  401294:	6374705f 	.word	0x6374705f
  401298:	4400632e 	.word	0x4400632e
  40129c:	6f695c3a 	.word	0x6f695c3a
  4012a0:	6f727074 	.word	0x6f727074
  4012a4:	7463656a 	.word	0x7463656a
  4012a8:	48434c5c 	.word	0x48434c5c
  4012ac:	4f5c5053 	.word	0x4f5c5053
  4012b0:	536e6570 	.word	0x536e6570
  4012b4:	696c4669 	.word	0x696c4669
  4012b8:	7469675c 	.word	0x7469675c
  4012bc:	73627568 	.word	0x73627568
  4012c0:	535c6b64 	.word	0x535c6b64
  4012c4:	696c4669 	.word	0x696c4669
  4012c8:	4b44532d 	.word	0x4b44532d
  4012cc:	2e32765c 	.word	0x2e32765c
  4012d0:	69535c35 	.word	0x69535c35
  4012d4:	2d696c46 	.word	0x2d696c46
  4012d8:	2d4b4453 	.word	0x2d4b4453
  4012dc:	352e3256 	.word	0x352e3256
  4012e0:	6972645c 	.word	0x6972645c
  4012e4:	73726576 	.word	0x73726576
  4012e8:	6c61685c 	.word	0x6c61685c
  4012ec:	3066625c 	.word	0x3066625c
  4012f0:	6c61685f 	.word	0x6c61685f
  4012f4:	6363725f 	.word	0x6363725f
  4012f8:	6300632e 	.word	0x6300632e
  4012fc:	626c6c61 	.word	0x626c6c61
  401300:	206b6361 	.word	0x206b6361
  401304:	4e203d21 	.word	0x4e203d21
  401308:	004c4c55 	.word	0x004c4c55
  40130c:	6c740030 	.word	0x6c740030
  401310:	5f545200 	.word	0x5f545200
  401314:	534c4146 	.word	0x534c4146
  401318:	5f710045 	.word	0x5f710045
  40131c:	20786469 	.word	0x20786469
  401320:	5049203c 	.word	0x5049203c
  401324:	57485f43 	.word	0x57485f43
  401328:	4555515f 	.word	0x4555515f
  40132c:	4e5f4555 	.word	0x4e5f4555
  401330:	48004d55 	.word	0x48004d55
  401334:	4f5f4c41 	.word	0x4f5f4c41
  401338:	3d3d204b 	.word	0x3d3d204b
  40133c:	72726520 	.word	0x72726520
  401340:	6e697000 	.word	0x6e697000
  401344:	69616d00 	.word	0x69616d00
  401348:	6974006e 	.word	0x6974006e
  40134c:	3d212064 	.word	0x3d212064
  401350:	5f545220 	.word	0x5f545220
  401354:	4c4c554e 	.word	0x4c4c554e
  401358:	64697400 	.word	0x64697400
  40135c:	0000656c 	.word	0x0000656c

00401360 <g_ble_mac_pm_ops>:
  401360:	004007d1 00000000 00000000              ..@.........

0040136c <__FUNCTION__.0>:
  40136c:	74726f70 6e6f635f 00676966              port_config.

00401378 <__FUNCTION__.3>:
  401378:	5f6d6f72 74726f70 7465675f               rom_port_get.

00401385 <__FUNCTION__.0>:
  401385:	5f637470 666e6f63                        ptc_config.

00401390 <__FUNCTION__.0>:
  401390:	75706368 70636c32 6f6e5f75 69666974     hcpu2lcpu_notifi
  4013a0:	69746163 635f6e6f 626c6c61 006b6361     cation_callback.

004013b0 <__FUNCTION__.1>:
  4013b0:	5f474244 67697254 5f726567 48515249     DBG_Trigger_IRQH
  4013c0:	6c646e61                                 andler.

004013c7 <__FUNCTION__.2>:
  4013c7:	705f6d70 725f6e69 6f747365 00006572     pm_pin_restore..
	...

004013d8 <sifli_pm_op>:
  4013d8:	00400afd 00400afb 00000000              ..@...@.....

004013e4 <pm_policy>:
  4013e4:	0000000a 00000003                       ........

004013ec <__FUNCTION__.0>:
  4013ec:	5f4c4148 65737341 61467472 64656c69     HAL_AssertFailed
	...

004013fd <__FUNCTION__.0>:
  4013fd:	615f7472 696c7070 69746163 695f6e6f     rt_application_i
  40140d:	0074696e                                 nit....

00401414 <HAL_PIN_Restore>:
  401414:	b510      	push	{r4, lr}
  401416:	4604      	mov	r4, r0
  401418:	b920      	cbnz	r0, 401424 <HAL_PIN_Restore+0x10>
  40141a:	f640 11d7 	movw	r1, #2519	@ 0x9d7
  40141e:	480a      	ldr	r0, [pc, #40]	@ (401448 <HAL_PIN_Restore+0x34>)
  401420:	f7ff fcde 	bl	400de0 <HAL_AssertFailed>
  401424:	6822      	ldr	r2, [r4, #0]
  401426:	4b09      	ldr	r3, [pc, #36]	@ (40144c <HAL_PIN_Restore+0x38>)
  401428:	2000      	movs	r0, #0
  40142a:	601a      	str	r2, [r3, #0]
  40142c:	6862      	ldr	r2, [r4, #4]
  40142e:	605a      	str	r2, [r3, #4]
  401430:	68a2      	ldr	r2, [r4, #8]
  401432:	609a      	str	r2, [r3, #8]
  401434:	68e2      	ldr	r2, [r4, #12]
  401436:	60da      	str	r2, [r3, #12]
  401438:	6922      	ldr	r2, [r4, #16]
  40143a:	f503 4340 	add.w	r3, r3, #49152	@ 0xc000
  40143e:	639a      	str	r2, [r3, #56]	@ 0x38
  401440:	6962      	ldr	r2, [r4, #20]
  401442:	63da      	str	r2, [r3, #60]	@ 0x3c
  401444:	bd10      	pop	{r4, pc}
  401446:	bf00      	nop
  401448:	004011d8 	.word	0x004011d8
  40144c:	40003000 	.word	0x40003000

00401450 <sifli_pm_run>:
  401450:	4770      	bx	lr

00401452 <sifli_enter_idle>:
  401452:	4770      	bx	lr

00401454 <pm_pin_restore>:
  401454:	b508      	push	{r3, lr}
  401456:	480c      	ldr	r0, [pc, #48]	@ (401488 <pm_pin_restore+0x34>)
  401458:	f7ff ffdc 	bl	401414 <HAL_PIN_Restore>
  40145c:	b128      	cbz	r0, 40146a <pm_pin_restore+0x16>
  40145e:	f240 1285 	movw	r2, #389	@ 0x185
  401462:	490a      	ldr	r1, [pc, #40]	@ (40148c <pm_pin_restore+0x38>)
  401464:	480a      	ldr	r0, [pc, #40]	@ (401490 <pm_pin_restore+0x3c>)
  401466:	f44f ff79 	bl	5135c <rt_assert_handler>
  40146a:	2202      	movs	r2, #2
  40146c:	4909      	ldr	r1, [pc, #36]	@ (401494 <pm_pin_restore+0x40>)
  40146e:	480a      	ldr	r0, [pc, #40]	@ (401498 <pm_pin_restore+0x44>)
  401470:	f7fe ff82 	bl	400378 <HAL_GPIO_Restore>
  401474:	b138      	cbz	r0, 401486 <pm_pin_restore+0x32>
  401476:	e8bd 4008 	ldmia.w	sp!, {r3, lr}
  40147a:	f240 1289 	movw	r2, #393	@ 0x189
  40147e:	4903      	ldr	r1, [pc, #12]	@ (40148c <pm_pin_restore+0x38>)
  401480:	4803      	ldr	r0, [pc, #12]	@ (401490 <pm_pin_restore+0x3c>)
  401482:	f44f bf6b 	b.w	5135c <rt_assert_handler>
  401486:	bd08      	pop	{r3, pc}
  401488:	20401a34 	.word	0x20401a34
  40148c:	004013c7 	.word	0x004013c7
  401490:	00401333 	.word	0x00401333
  401494:	20401a4c 	.word	0x20401a4c
  401498:	40080000 	.word	0x40080000

0040149c <SystemPowerOnInitLCPU>:
  40149c:	b538      	push	{r3, r4, r5, lr}
  40149e:	4c16      	ldr	r4, [pc, #88]	@ (4014f8 <SystemPowerOnInitLCPU+0x5c>)
  4014a0:	6823      	ldr	r3, [r4, #0]
  4014a2:	f003 0303 	and.w	r3, r3, #3
  4014a6:	2b03      	cmp	r3, #3
  4014a8:	4b14      	ldr	r3, [pc, #80]	@ (4014fc <SystemPowerOnInitLCPU+0x60>)
  4014aa:	d002      	beq.n	4014b2 <SystemPowerOnInitLCPU+0x16>
  4014ac:	2200      	movs	r2, #0
  4014ae:	701a      	strb	r2, [r3, #0]
  4014b0:	bd38      	pop	{r3, r4, r5, pc}
  4014b2:	2501      	movs	r5, #1
  4014b4:	701d      	strb	r5, [r3, #0]
  4014b6:	f455 fc25 	bl	56d04 <rt_wdt_restore>
  4014ba:	4a11      	ldr	r2, [pc, #68]	@ (401500 <SystemPowerOnInitLCPU+0x64>)
  4014bc:	6913      	ldr	r3, [r2, #16]
  4014be:	f043 5300 	orr.w	r3, r3, #536870912	@ 0x20000000
  4014c2:	6113      	str	r3, [r2, #16]
  4014c4:	6c63      	ldr	r3, [r4, #68]	@ 0x44
  4014c6:	f023 0302 	bic.w	r3, r3, #2
  4014ca:	6463      	str	r3, [r4, #68]	@ 0x44
  4014cc:	f7ff ffc2 	bl	401454 <pm_pin_restore>
  4014d0:	6c63      	ldr	r3, [r4, #68]	@ 0x44
  4014d2:	f023 0301 	bic.w	r3, r3, #1
  4014d6:	6463      	str	r3, [r4, #68]	@ 0x44
  4014d8:	f7fe ff05 	bl	4002e6 <HAL_Init>
  4014dc:	f7ff f17e 	bl	7dc <rt_hw_interrupt_disable>
  4014e0:	4b08      	ldr	r3, [pc, #32]	@ (401504 <SystemPowerOnInitLCPU+0x68>)
  4014e2:	601d      	str	r5, [r3, #0]
  4014e4:	f7fe fe55 	bl	400192 <SystemClock_Config>
  4014e8:	f451 f8d6 	bl	52698 <rt_hw_systick_init>
  4014ec:	f7ff f1b3 	bl	856 <rt_hw_cfg_pendsv_pri>
  4014f0:	f44f fbc4 	bl	50c7c <restore_context>
  4014f4:	e7dc      	b.n	4014b0 <SystemPowerOnInitLCPU+0x14>
  4014f6:	bf00      	nop
  4014f8:	40040000 	.word	0x40040000
  4014fc:	2040fd54 	.word	0x2040fd54
  401500:	4000f000 	.word	0x4000f000
  401504:	20401aa4 	.word	0x20401aa4

00401508 <_init>:
  401508:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
  40150a:	bf00      	nop
  40150c:	bcf8      	pop	{r3, r4, r5, r6, r7}
  40150e:	bc08      	pop	{r3}
  401510:	469e      	mov	lr, r3
  401512:	4770      	bx	lr

00401514 <_fini>:
  401514:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
  401516:	bf00      	nop
  401518:	bcf8      	pop	{r3, r4, r5, r6, r7}
  40151a:	bc08      	pop	{r3}
  40151c:	469e      	mov	lr, r3
  40151e:	4770      	bx	lr

00401520 <__rt_init_rti_start>:
  401520:	0e45 0040                                   E.@.

00401524 <__rt_init_rti_board_start>:
  401524:	0e49 0040                                   I.@.

00401528 <__rt_init_rti_board_end>:
  401528:	0e4d 0040                                   M.@.

0040152c <__rt_init_low_power_init>:
  40152c:	0b8d 0040                                   ..@.

00401530 <__rt_init_libc_system_init>:
  401530:	a6e1 0002                                   ....

00401534 <__rt_init_rc10k_cal_init>:
  401534:	01c5 0040                                   ..@.

00401538 <__rt_init_sys_init_lh_bt_audio_queue>:
  401538:	aced 0005                                   ....

0040153c <__rt_init_bt_audiopath_init>:
  40153c:	06bd 0040                                   ..@.

00401540 <__rt_init_bluetooth_init>:
  401540:	074d 0040                                   M.@.

00401544 <__rt_init_sys_init_debug_trigger>:
  401544:	0a65 0040                                   e.@.

00401548 <__rt_init_rti_end>:
  401548:	0e51 0040                                   Q.@.

0040154c <__EH_FRAME_BEGIN__>:
  40154c:	0000 0000                                   ....
