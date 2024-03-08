
user/_threads:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <thread_create>:
static struct thread* current_thread = NULL;
static int id = 1;
static jmp_buf env_st;
// static jmp_buf env_tmp;

struct thread *thread_create(void (*f)(void *), void *arg){
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	89aa                	mv	s3,a0
  10:	892e                	mv	s2,a1
    struct thread *t = (struct thread*) malloc(sizeof(struct thread));
  12:	0a800513          	li	a0,168
  16:	00001097          	auipc	ra,0x1
  1a:	890080e7          	jalr	-1904(ra) # 8a6 <malloc>
  1e:	84aa                	mv	s1,a0
    unsigned long new_stack_p;
    unsigned long new_stack;
    new_stack = (unsigned long) malloc(sizeof(unsigned long)*0x100);
  20:	6505                	lui	a0,0x1
  22:	80050513          	addi	a0,a0,-2048 # 800 <printf+0x18>
  26:	00001097          	auipc	ra,0x1
  2a:	880080e7          	jalr	-1920(ra) # 8a6 <malloc>
    new_stack_p = new_stack +0x100*8-0x2*8;
    t->fp = f;
  2e:	0134b023          	sd	s3,0(s1)
    t->arg = arg;
  32:	0124b423          	sd	s2,8(s1)
    t->ID  = id;
  36:	00001717          	auipc	a4,0x1
  3a:	9e670713          	addi	a4,a4,-1562 # a1c <id>
  3e:	431c                	lw	a5,0(a4)
  40:	08f4aa23          	sw	a5,148(s1)
    t->buf_set = 0;
  44:	0804a823          	sw	zero,144(s1)
    t->stack = (void*) new_stack;
  48:	e888                	sd	a0,16(s1)
    new_stack_p = new_stack +0x100*8-0x2*8;
  4a:	7f050513          	addi	a0,a0,2032
    t->stack_p = (void*) new_stack_p;
  4e:	ec88                	sd	a0,24(s1)
    id++;
  50:	2785                	addiw	a5,a5,1
  52:	c31c                	sw	a5,0(a4)
    return t;
}
  54:	8526                	mv	a0,s1
  56:	70a2                	ld	ra,40(sp)
  58:	7402                	ld	s0,32(sp)
  5a:	64e2                	ld	s1,24(sp)
  5c:	6942                	ld	s2,16(sp)
  5e:	69a2                	ld	s3,8(sp)
  60:	6145                	addi	sp,sp,48
  62:	8082                	ret

0000000000000064 <thread_add_runqueue>:
void thread_add_runqueue(struct thread *t){
  64:	1141                	addi	sp,sp,-16
  66:	e422                	sd	s0,8(sp)
  68:	0800                	addi	s0,sp,16
    if(current_thread == NULL){
  6a:	00001797          	auipc	a5,0x1
  6e:	9b67b783          	ld	a5,-1610(a5) # a20 <current_thread>
  72:	cb89                	beqz	a5,84 <thread_add_runqueue+0x20>
        current_thread = t;
        t->next = t;
        t-> previous = t;
    }
    else{
        struct thread *tail = current_thread->previous;
  74:	6fd8                	ld	a4,152(a5)
        tail->next = t;
  76:	f348                	sd	a0,160(a4)
        t->previous = tail;
  78:	ed58                	sd	a4,152(a0)
        t->next = current_thread;
  7a:	f15c                	sd	a5,160(a0)
        current_thread->previous = tail;
  7c:	efd8                	sd	a4,152(a5)
    }
}
  7e:	6422                	ld	s0,8(sp)
  80:	0141                	addi	sp,sp,16
  82:	8082                	ret
        current_thread = t;
  84:	00001797          	auipc	a5,0x1
  88:	98a7be23          	sd	a0,-1636(a5) # a20 <current_thread>
        t->next = t;
  8c:	f148                	sd	a0,160(a0)
        t-> previous = t;
  8e:	ed48                	sd	a0,152(a0)
  90:	b7fd                	j	7e <thread_add_runqueue+0x1a>

0000000000000092 <schedule>:
        current_thread->fp(current_thread->arg);
        thread_exit();
    }
    longjmp(current_thread->env, 1);
}
void schedule(void){
  92:	1141                	addi	sp,sp,-16
  94:	e422                	sd	s0,8(sp)
  96:	0800                	addi	s0,sp,16
    current_thread = current_thread->next;
  98:	00001797          	auipc	a5,0x1
  9c:	98878793          	addi	a5,a5,-1656 # a20 <current_thread>
  a0:	6398                	ld	a4,0(a5)
  a2:	7358                	ld	a4,160(a4)
  a4:	e398                	sd	a4,0(a5)
}
  a6:	6422                	ld	s0,8(sp)
  a8:	0141                	addi	sp,sp,16
  aa:	8082                	ret

00000000000000ac <thread_exit>:
void thread_exit(void){
  ac:	1101                	addi	sp,sp,-32
  ae:	ec06                	sd	ra,24(sp)
  b0:	e822                	sd	s0,16(sp)
  b2:	e426                	sd	s1,8(sp)
  b4:	1000                	addi	s0,sp,32
    if(current_thread->next != current_thread){
  b6:	00001717          	auipc	a4,0x1
  ba:	96a73703          	ld	a4,-1686(a4) # a20 <current_thread>
  be:	735c                	ld	a5,160(a4)
  c0:	02f70e63          	beq	a4,a5,fc <thread_exit+0x50>
        struct thread *thread_to_execute = current_thread->next; 
        current_thread->previous->next = current_thread->next;
  c4:	6f54                	ld	a3,152(a4)
  c6:	f2dc                	sd	a5,160(a3)
        current_thread->next->previous = current_thread->previous;
  c8:	6f58                	ld	a4,152(a4)
  ca:	efd8                	sd	a4,152(a5)
        current_thread = thread_to_execute;
  cc:	00001497          	auipc	s1,0x1
  d0:	95448493          	addi	s1,s1,-1708 # a20 <current_thread>
  d4:	e09c                	sd	a5,0(s1)
        free(current_thread->stack);
  d6:	6b88                	ld	a0,16(a5)
  d8:	00000097          	auipc	ra,0x0
  dc:	746080e7          	jalr	1862(ra) # 81e <free>
        free(current_thread);
  e0:	6088                	ld	a0,0(s1)
  e2:	00000097          	auipc	ra,0x0
  e6:	73c080e7          	jalr	1852(ra) # 81e <free>
        dispatch();
  ea:	00000097          	auipc	ra,0x0
  ee:	046080e7          	jalr	70(ra) # 130 <dispatch>
        free(current_thread->stack);
        free(current_thread);
        current_thread = NULL;
        longjmp(env_st, 1);
    }
}
  f2:	60e2                	ld	ra,24(sp)
  f4:	6442                	ld	s0,16(sp)
  f6:	64a2                	ld	s1,8(sp)
  f8:	6105                	addi	sp,sp,32
  fa:	8082                	ret
        free(current_thread->stack);
  fc:	6b08                	ld	a0,16(a4)
  fe:	00000097          	auipc	ra,0x0
 102:	720080e7          	jalr	1824(ra) # 81e <free>
        free(current_thread);
 106:	00001497          	auipc	s1,0x1
 10a:	91a48493          	addi	s1,s1,-1766 # a20 <current_thread>
 10e:	6088                	ld	a0,0(s1)
 110:	00000097          	auipc	ra,0x0
 114:	70e080e7          	jalr	1806(ra) # 81e <free>
        current_thread = NULL;
 118:	0004b023          	sd	zero,0(s1)
        longjmp(env_st, 1);
 11c:	4585                	li	a1,1
 11e:	00001517          	auipc	a0,0x1
 122:	91250513          	addi	a0,a0,-1774 # a30 <env_st>
 126:	00001097          	auipc	ra,0x1
 12a:	89c080e7          	jalr	-1892(ra) # 9c2 <longjmp>
}
 12e:	b7d1                	j	f2 <thread_exit+0x46>

0000000000000130 <dispatch>:
void dispatch(void){
 130:	1141                	addi	sp,sp,-16
 132:	e406                	sd	ra,8(sp)
 134:	e022                	sd	s0,0(sp)
 136:	0800                	addi	s0,sp,16
    if (!current_thread->buf_set) {
 138:	00001797          	auipc	a5,0x1
 13c:	8e87b783          	ld	a5,-1816(a5) # a20 <current_thread>
 140:	0907a703          	lw	a4,144(a5)
 144:	ef09                	bnez	a4,15e <dispatch+0x2e>
        current_thread->buf_set = 1;
 146:	4705                	li	a4,1
 148:	08e7a823          	sw	a4,144(a5)
        current_thread->env[0].sp = (unsigned long) current_thread->stack_p;
 14c:	6f98                	ld	a4,24(a5)
 14e:	e7d8                	sd	a4,136(a5)
        current_thread->fp(current_thread->arg);
 150:	6398                	ld	a4,0(a5)
 152:	6788                	ld	a0,8(a5)
 154:	9702                	jalr	a4
        thread_exit();
 156:	00000097          	auipc	ra,0x0
 15a:	f56080e7          	jalr	-170(ra) # ac <thread_exit>
    longjmp(current_thread->env, 1);
 15e:	4585                	li	a1,1
 160:	00001517          	auipc	a0,0x1
 164:	8c053503          	ld	a0,-1856(a0) # a20 <current_thread>
 168:	02050513          	addi	a0,a0,32
 16c:	00001097          	auipc	ra,0x1
 170:	856080e7          	jalr	-1962(ra) # 9c2 <longjmp>
}
 174:	60a2                	ld	ra,8(sp)
 176:	6402                	ld	s0,0(sp)
 178:	0141                	addi	sp,sp,16
 17a:	8082                	ret

000000000000017c <thread_yield>:
void thread_yield(void){
 17c:	1141                	addi	sp,sp,-16
 17e:	e406                	sd	ra,8(sp)
 180:	e022                	sd	s0,0(sp)
 182:	0800                	addi	s0,sp,16
    if (setjmp(current_thread->env) == 0) {
 184:	00001517          	auipc	a0,0x1
 188:	89c53503          	ld	a0,-1892(a0) # a20 <current_thread>
 18c:	02050513          	addi	a0,a0,32
 190:	00000097          	auipc	ra,0x0
 194:	7fa080e7          	jalr	2042(ra) # 98a <setjmp>
 198:	c509                	beqz	a0,1a2 <thread_yield+0x26>
}
 19a:	60a2                	ld	ra,8(sp)
 19c:	6402                	ld	s0,0(sp)
 19e:	0141                	addi	sp,sp,16
 1a0:	8082                	ret
        schedule();
 1a2:	00000097          	auipc	ra,0x0
 1a6:	ef0080e7          	jalr	-272(ra) # 92 <schedule>
        dispatch();
 1aa:	00000097          	auipc	ra,0x0
 1ae:	f86080e7          	jalr	-122(ra) # 130 <dispatch>
    return;
 1b2:	b7e5                	j	19a <thread_yield+0x1e>

00000000000001b4 <thread_start_threading>:
void thread_start_threading(void){
 1b4:	1101                	addi	sp,sp,-32
 1b6:	ec06                	sd	ra,24(sp)
 1b8:	e822                	sd	s0,16(sp)
 1ba:	e426                	sd	s1,8(sp)
 1bc:	1000                	addi	s0,sp,32
    setjmp(env_st);
 1be:	00001517          	auipc	a0,0x1
 1c2:	87250513          	addi	a0,a0,-1934 # a30 <env_st>
 1c6:	00000097          	auipc	ra,0x0
 1ca:	7c4080e7          	jalr	1988(ra) # 98a <setjmp>
    while (current_thread != NULL) {
 1ce:	00001497          	auipc	s1,0x1
 1d2:	85248493          	addi	s1,s1,-1966 # a20 <current_thread>
 1d6:	609c                	ld	a5,0(s1)
 1d8:	c791                	beqz	a5,1e4 <thread_start_threading+0x30>
        dispatch();
 1da:	00000097          	auipc	ra,0x0
 1de:	f56080e7          	jalr	-170(ra) # 130 <dispatch>
 1e2:	bfd5                	j	1d6 <thread_start_threading+0x22>
    }
    return;
}
 1e4:	60e2                	ld	ra,24(sp)
 1e6:	6442                	ld	s0,16(sp)
 1e8:	64a2                	ld	s1,8(sp)
 1ea:	6105                	addi	sp,sp,32
 1ec:	8082                	ret

00000000000001ee <thread_assign_task>:

// part 2
void thread_assign_task(struct thread *t, void (*f)(void *), void *arg){
 1ee:	1141                	addi	sp,sp,-16
 1f0:	e422                	sd	s0,8(sp)
 1f2:	0800                	addi	s0,sp,16
    // TODO
}
 1f4:	6422                	ld	s0,8(sp)
 1f6:	0141                	addi	sp,sp,16
 1f8:	8082                	ret

00000000000001fa <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 1fa:	1141                	addi	sp,sp,-16
 1fc:	e422                	sd	s0,8(sp)
 1fe:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 200:	87aa                	mv	a5,a0
 202:	0585                	addi	a1,a1,1
 204:	0785                	addi	a5,a5,1
 206:	fff5c703          	lbu	a4,-1(a1)
 20a:	fee78fa3          	sb	a4,-1(a5)
 20e:	fb75                	bnez	a4,202 <strcpy+0x8>
    ;
  return os;
}
 210:	6422                	ld	s0,8(sp)
 212:	0141                	addi	sp,sp,16
 214:	8082                	ret

0000000000000216 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 216:	1141                	addi	sp,sp,-16
 218:	e422                	sd	s0,8(sp)
 21a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 21c:	00054783          	lbu	a5,0(a0)
 220:	cb91                	beqz	a5,234 <strcmp+0x1e>
 222:	0005c703          	lbu	a4,0(a1)
 226:	00f71763          	bne	a4,a5,234 <strcmp+0x1e>
    p++, q++;
 22a:	0505                	addi	a0,a0,1
 22c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 22e:	00054783          	lbu	a5,0(a0)
 232:	fbe5                	bnez	a5,222 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 234:	0005c503          	lbu	a0,0(a1)
}
 238:	40a7853b          	subw	a0,a5,a0
 23c:	6422                	ld	s0,8(sp)
 23e:	0141                	addi	sp,sp,16
 240:	8082                	ret

0000000000000242 <strlen>:

uint
strlen(const char *s)
{
 242:	1141                	addi	sp,sp,-16
 244:	e422                	sd	s0,8(sp)
 246:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 248:	00054783          	lbu	a5,0(a0)
 24c:	cf91                	beqz	a5,268 <strlen+0x26>
 24e:	0505                	addi	a0,a0,1
 250:	87aa                	mv	a5,a0
 252:	4685                	li	a3,1
 254:	9e89                	subw	a3,a3,a0
 256:	00f6853b          	addw	a0,a3,a5
 25a:	0785                	addi	a5,a5,1
 25c:	fff7c703          	lbu	a4,-1(a5)
 260:	fb7d                	bnez	a4,256 <strlen+0x14>
    ;
  return n;
}
 262:	6422                	ld	s0,8(sp)
 264:	0141                	addi	sp,sp,16
 266:	8082                	ret
  for(n = 0; s[n]; n++)
 268:	4501                	li	a0,0
 26a:	bfe5                	j	262 <strlen+0x20>

000000000000026c <memset>:

void*
memset(void *dst, int c, uint n)
{
 26c:	1141                	addi	sp,sp,-16
 26e:	e422                	sd	s0,8(sp)
 270:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 272:	ce09                	beqz	a2,28c <memset+0x20>
 274:	87aa                	mv	a5,a0
 276:	fff6071b          	addiw	a4,a2,-1
 27a:	1702                	slli	a4,a4,0x20
 27c:	9301                	srli	a4,a4,0x20
 27e:	0705                	addi	a4,a4,1
 280:	972a                	add	a4,a4,a0
    cdst[i] = c;
 282:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 286:	0785                	addi	a5,a5,1
 288:	fee79de3          	bne	a5,a4,282 <memset+0x16>
  }
  return dst;
}
 28c:	6422                	ld	s0,8(sp)
 28e:	0141                	addi	sp,sp,16
 290:	8082                	ret

0000000000000292 <strchr>:

char*
strchr(const char *s, char c)
{
 292:	1141                	addi	sp,sp,-16
 294:	e422                	sd	s0,8(sp)
 296:	0800                	addi	s0,sp,16
  for(; *s; s++)
 298:	00054783          	lbu	a5,0(a0)
 29c:	cb99                	beqz	a5,2b2 <strchr+0x20>
    if(*s == c)
 29e:	00f58763          	beq	a1,a5,2ac <strchr+0x1a>
  for(; *s; s++)
 2a2:	0505                	addi	a0,a0,1
 2a4:	00054783          	lbu	a5,0(a0)
 2a8:	fbfd                	bnez	a5,29e <strchr+0xc>
      return (char*)s;
  return 0;
 2aa:	4501                	li	a0,0
}
 2ac:	6422                	ld	s0,8(sp)
 2ae:	0141                	addi	sp,sp,16
 2b0:	8082                	ret
  return 0;
 2b2:	4501                	li	a0,0
 2b4:	bfe5                	j	2ac <strchr+0x1a>

00000000000002b6 <gets>:

char*
gets(char *buf, int max)
{
 2b6:	711d                	addi	sp,sp,-96
 2b8:	ec86                	sd	ra,88(sp)
 2ba:	e8a2                	sd	s0,80(sp)
 2bc:	e4a6                	sd	s1,72(sp)
 2be:	e0ca                	sd	s2,64(sp)
 2c0:	fc4e                	sd	s3,56(sp)
 2c2:	f852                	sd	s4,48(sp)
 2c4:	f456                	sd	s5,40(sp)
 2c6:	f05a                	sd	s6,32(sp)
 2c8:	ec5e                	sd	s7,24(sp)
 2ca:	1080                	addi	s0,sp,96
 2cc:	8baa                	mv	s7,a0
 2ce:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2d0:	892a                	mv	s2,a0
 2d2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2d4:	4aa9                	li	s5,10
 2d6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2d8:	89a6                	mv	s3,s1
 2da:	2485                	addiw	s1,s1,1
 2dc:	0344d863          	bge	s1,s4,30c <gets+0x56>
    cc = read(0, &c, 1);
 2e0:	4605                	li	a2,1
 2e2:	faf40593          	addi	a1,s0,-81
 2e6:	4501                	li	a0,0
 2e8:	00000097          	auipc	ra,0x0
 2ec:	1a0080e7          	jalr	416(ra) # 488 <read>
    if(cc < 1)
 2f0:	00a05e63          	blez	a0,30c <gets+0x56>
    buf[i++] = c;
 2f4:	faf44783          	lbu	a5,-81(s0)
 2f8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2fc:	01578763          	beq	a5,s5,30a <gets+0x54>
 300:	0905                	addi	s2,s2,1
 302:	fd679be3          	bne	a5,s6,2d8 <gets+0x22>
  for(i=0; i+1 < max; ){
 306:	89a6                	mv	s3,s1
 308:	a011                	j	30c <gets+0x56>
 30a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 30c:	99de                	add	s3,s3,s7
 30e:	00098023          	sb	zero,0(s3)
  return buf;
}
 312:	855e                	mv	a0,s7
 314:	60e6                	ld	ra,88(sp)
 316:	6446                	ld	s0,80(sp)
 318:	64a6                	ld	s1,72(sp)
 31a:	6906                	ld	s2,64(sp)
 31c:	79e2                	ld	s3,56(sp)
 31e:	7a42                	ld	s4,48(sp)
 320:	7aa2                	ld	s5,40(sp)
 322:	7b02                	ld	s6,32(sp)
 324:	6be2                	ld	s7,24(sp)
 326:	6125                	addi	sp,sp,96
 328:	8082                	ret

000000000000032a <stat>:

int
stat(const char *n, struct stat *st)
{
 32a:	1101                	addi	sp,sp,-32
 32c:	ec06                	sd	ra,24(sp)
 32e:	e822                	sd	s0,16(sp)
 330:	e426                	sd	s1,8(sp)
 332:	e04a                	sd	s2,0(sp)
 334:	1000                	addi	s0,sp,32
 336:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 338:	4581                	li	a1,0
 33a:	00000097          	auipc	ra,0x0
 33e:	176080e7          	jalr	374(ra) # 4b0 <open>
  if(fd < 0)
 342:	02054563          	bltz	a0,36c <stat+0x42>
 346:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 348:	85ca                	mv	a1,s2
 34a:	00000097          	auipc	ra,0x0
 34e:	17e080e7          	jalr	382(ra) # 4c8 <fstat>
 352:	892a                	mv	s2,a0
  close(fd);
 354:	8526                	mv	a0,s1
 356:	00000097          	auipc	ra,0x0
 35a:	142080e7          	jalr	322(ra) # 498 <close>
  return r;
}
 35e:	854a                	mv	a0,s2
 360:	60e2                	ld	ra,24(sp)
 362:	6442                	ld	s0,16(sp)
 364:	64a2                	ld	s1,8(sp)
 366:	6902                	ld	s2,0(sp)
 368:	6105                	addi	sp,sp,32
 36a:	8082                	ret
    return -1;
 36c:	597d                	li	s2,-1
 36e:	bfc5                	j	35e <stat+0x34>

0000000000000370 <atoi>:

int
atoi(const char *s)
{
 370:	1141                	addi	sp,sp,-16
 372:	e422                	sd	s0,8(sp)
 374:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 376:	00054603          	lbu	a2,0(a0)
 37a:	fd06079b          	addiw	a5,a2,-48
 37e:	0ff7f793          	andi	a5,a5,255
 382:	4725                	li	a4,9
 384:	02f76963          	bltu	a4,a5,3b6 <atoi+0x46>
 388:	86aa                	mv	a3,a0
  n = 0;
 38a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 38c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 38e:	0685                	addi	a3,a3,1
 390:	0025179b          	slliw	a5,a0,0x2
 394:	9fa9                	addw	a5,a5,a0
 396:	0017979b          	slliw	a5,a5,0x1
 39a:	9fb1                	addw	a5,a5,a2
 39c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3a0:	0006c603          	lbu	a2,0(a3)
 3a4:	fd06071b          	addiw	a4,a2,-48
 3a8:	0ff77713          	andi	a4,a4,255
 3ac:	fee5f1e3          	bgeu	a1,a4,38e <atoi+0x1e>
  return n;
}
 3b0:	6422                	ld	s0,8(sp)
 3b2:	0141                	addi	sp,sp,16
 3b4:	8082                	ret
  n = 0;
 3b6:	4501                	li	a0,0
 3b8:	bfe5                	j	3b0 <atoi+0x40>

00000000000003ba <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3ba:	1141                	addi	sp,sp,-16
 3bc:	e422                	sd	s0,8(sp)
 3be:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3c0:	02b57663          	bgeu	a0,a1,3ec <memmove+0x32>
    while(n-- > 0)
 3c4:	02c05163          	blez	a2,3e6 <memmove+0x2c>
 3c8:	fff6079b          	addiw	a5,a2,-1
 3cc:	1782                	slli	a5,a5,0x20
 3ce:	9381                	srli	a5,a5,0x20
 3d0:	0785                	addi	a5,a5,1
 3d2:	97aa                	add	a5,a5,a0
  dst = vdst;
 3d4:	872a                	mv	a4,a0
      *dst++ = *src++;
 3d6:	0585                	addi	a1,a1,1
 3d8:	0705                	addi	a4,a4,1
 3da:	fff5c683          	lbu	a3,-1(a1)
 3de:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3e2:	fee79ae3          	bne	a5,a4,3d6 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3e6:	6422                	ld	s0,8(sp)
 3e8:	0141                	addi	sp,sp,16
 3ea:	8082                	ret
    dst += n;
 3ec:	00c50733          	add	a4,a0,a2
    src += n;
 3f0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3f2:	fec05ae3          	blez	a2,3e6 <memmove+0x2c>
 3f6:	fff6079b          	addiw	a5,a2,-1
 3fa:	1782                	slli	a5,a5,0x20
 3fc:	9381                	srli	a5,a5,0x20
 3fe:	fff7c793          	not	a5,a5
 402:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 404:	15fd                	addi	a1,a1,-1
 406:	177d                	addi	a4,a4,-1
 408:	0005c683          	lbu	a3,0(a1)
 40c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 410:	fee79ae3          	bne	a5,a4,404 <memmove+0x4a>
 414:	bfc9                	j	3e6 <memmove+0x2c>

0000000000000416 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 416:	1141                	addi	sp,sp,-16
 418:	e422                	sd	s0,8(sp)
 41a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 41c:	ca05                	beqz	a2,44c <memcmp+0x36>
 41e:	fff6069b          	addiw	a3,a2,-1
 422:	1682                	slli	a3,a3,0x20
 424:	9281                	srli	a3,a3,0x20
 426:	0685                	addi	a3,a3,1
 428:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 42a:	00054783          	lbu	a5,0(a0)
 42e:	0005c703          	lbu	a4,0(a1)
 432:	00e79863          	bne	a5,a4,442 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 436:	0505                	addi	a0,a0,1
    p2++;
 438:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 43a:	fed518e3          	bne	a0,a3,42a <memcmp+0x14>
  }
  return 0;
 43e:	4501                	li	a0,0
 440:	a019                	j	446 <memcmp+0x30>
      return *p1 - *p2;
 442:	40e7853b          	subw	a0,a5,a4
}
 446:	6422                	ld	s0,8(sp)
 448:	0141                	addi	sp,sp,16
 44a:	8082                	ret
  return 0;
 44c:	4501                	li	a0,0
 44e:	bfe5                	j	446 <memcmp+0x30>

0000000000000450 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 450:	1141                	addi	sp,sp,-16
 452:	e406                	sd	ra,8(sp)
 454:	e022                	sd	s0,0(sp)
 456:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 458:	00000097          	auipc	ra,0x0
 45c:	f62080e7          	jalr	-158(ra) # 3ba <memmove>
}
 460:	60a2                	ld	ra,8(sp)
 462:	6402                	ld	s0,0(sp)
 464:	0141                	addi	sp,sp,16
 466:	8082                	ret

0000000000000468 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 468:	4885                	li	a7,1
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <exit>:
.global exit
exit:
 li a7, SYS_exit
 470:	4889                	li	a7,2
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <wait>:
.global wait
wait:
 li a7, SYS_wait
 478:	488d                	li	a7,3
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 480:	4891                	li	a7,4
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <read>:
.global read
read:
 li a7, SYS_read
 488:	4895                	li	a7,5
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <write>:
.global write
write:
 li a7, SYS_write
 490:	48c1                	li	a7,16
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <close>:
.global close
close:
 li a7, SYS_close
 498:	48d5                	li	a7,21
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4a0:	4899                	li	a7,6
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4a8:	489d                	li	a7,7
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <open>:
.global open
open:
 li a7, SYS_open
 4b0:	48bd                	li	a7,15
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4b8:	48c5                	li	a7,17
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4c0:	48c9                	li	a7,18
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4c8:	48a1                	li	a7,8
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <link>:
.global link
link:
 li a7, SYS_link
 4d0:	48cd                	li	a7,19
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4d8:	48d1                	li	a7,20
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4e0:	48a5                	li	a7,9
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4e8:	48a9                	li	a7,10
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4f0:	48ad                	li	a7,11
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4f8:	48b1                	li	a7,12
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 500:	48b5                	li	a7,13
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 508:	48b9                	li	a7,14
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 510:	1101                	addi	sp,sp,-32
 512:	ec06                	sd	ra,24(sp)
 514:	e822                	sd	s0,16(sp)
 516:	1000                	addi	s0,sp,32
 518:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 51c:	4605                	li	a2,1
 51e:	fef40593          	addi	a1,s0,-17
 522:	00000097          	auipc	ra,0x0
 526:	f6e080e7          	jalr	-146(ra) # 490 <write>
}
 52a:	60e2                	ld	ra,24(sp)
 52c:	6442                	ld	s0,16(sp)
 52e:	6105                	addi	sp,sp,32
 530:	8082                	ret

0000000000000532 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 532:	7139                	addi	sp,sp,-64
 534:	fc06                	sd	ra,56(sp)
 536:	f822                	sd	s0,48(sp)
 538:	f426                	sd	s1,40(sp)
 53a:	f04a                	sd	s2,32(sp)
 53c:	ec4e                	sd	s3,24(sp)
 53e:	0080                	addi	s0,sp,64
 540:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 542:	c299                	beqz	a3,548 <printint+0x16>
 544:	0805c863          	bltz	a1,5d4 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 548:	2581                	sext.w	a1,a1
  neg = 0;
 54a:	4881                	li	a7,0
 54c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 550:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 552:	2601                	sext.w	a2,a2
 554:	00000517          	auipc	a0,0x0
 558:	4b450513          	addi	a0,a0,1204 # a08 <digits>
 55c:	883a                	mv	a6,a4
 55e:	2705                	addiw	a4,a4,1
 560:	02c5f7bb          	remuw	a5,a1,a2
 564:	1782                	slli	a5,a5,0x20
 566:	9381                	srli	a5,a5,0x20
 568:	97aa                	add	a5,a5,a0
 56a:	0007c783          	lbu	a5,0(a5)
 56e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 572:	0005879b          	sext.w	a5,a1
 576:	02c5d5bb          	divuw	a1,a1,a2
 57a:	0685                	addi	a3,a3,1
 57c:	fec7f0e3          	bgeu	a5,a2,55c <printint+0x2a>
  if(neg)
 580:	00088b63          	beqz	a7,596 <printint+0x64>
    buf[i++] = '-';
 584:	fd040793          	addi	a5,s0,-48
 588:	973e                	add	a4,a4,a5
 58a:	02d00793          	li	a5,45
 58e:	fef70823          	sb	a5,-16(a4)
 592:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 596:	02e05863          	blez	a4,5c6 <printint+0x94>
 59a:	fc040793          	addi	a5,s0,-64
 59e:	00e78933          	add	s2,a5,a4
 5a2:	fff78993          	addi	s3,a5,-1
 5a6:	99ba                	add	s3,s3,a4
 5a8:	377d                	addiw	a4,a4,-1
 5aa:	1702                	slli	a4,a4,0x20
 5ac:	9301                	srli	a4,a4,0x20
 5ae:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5b2:	fff94583          	lbu	a1,-1(s2)
 5b6:	8526                	mv	a0,s1
 5b8:	00000097          	auipc	ra,0x0
 5bc:	f58080e7          	jalr	-168(ra) # 510 <putc>
  while(--i >= 0)
 5c0:	197d                	addi	s2,s2,-1
 5c2:	ff3918e3          	bne	s2,s3,5b2 <printint+0x80>
}
 5c6:	70e2                	ld	ra,56(sp)
 5c8:	7442                	ld	s0,48(sp)
 5ca:	74a2                	ld	s1,40(sp)
 5cc:	7902                	ld	s2,32(sp)
 5ce:	69e2                	ld	s3,24(sp)
 5d0:	6121                	addi	sp,sp,64
 5d2:	8082                	ret
    x = -xx;
 5d4:	40b005bb          	negw	a1,a1
    neg = 1;
 5d8:	4885                	li	a7,1
    x = -xx;
 5da:	bf8d                	j	54c <printint+0x1a>

00000000000005dc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5dc:	7119                	addi	sp,sp,-128
 5de:	fc86                	sd	ra,120(sp)
 5e0:	f8a2                	sd	s0,112(sp)
 5e2:	f4a6                	sd	s1,104(sp)
 5e4:	f0ca                	sd	s2,96(sp)
 5e6:	ecce                	sd	s3,88(sp)
 5e8:	e8d2                	sd	s4,80(sp)
 5ea:	e4d6                	sd	s5,72(sp)
 5ec:	e0da                	sd	s6,64(sp)
 5ee:	fc5e                	sd	s7,56(sp)
 5f0:	f862                	sd	s8,48(sp)
 5f2:	f466                	sd	s9,40(sp)
 5f4:	f06a                	sd	s10,32(sp)
 5f6:	ec6e                	sd	s11,24(sp)
 5f8:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5fa:	0005c903          	lbu	s2,0(a1)
 5fe:	18090f63          	beqz	s2,79c <vprintf+0x1c0>
 602:	8aaa                	mv	s5,a0
 604:	8b32                	mv	s6,a2
 606:	00158493          	addi	s1,a1,1
  state = 0;
 60a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 60c:	02500a13          	li	s4,37
      if(c == 'd'){
 610:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 614:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 618:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 61c:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 620:	00000b97          	auipc	s7,0x0
 624:	3e8b8b93          	addi	s7,s7,1000 # a08 <digits>
 628:	a839                	j	646 <vprintf+0x6a>
        putc(fd, c);
 62a:	85ca                	mv	a1,s2
 62c:	8556                	mv	a0,s5
 62e:	00000097          	auipc	ra,0x0
 632:	ee2080e7          	jalr	-286(ra) # 510 <putc>
 636:	a019                	j	63c <vprintf+0x60>
    } else if(state == '%'){
 638:	01498f63          	beq	s3,s4,656 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 63c:	0485                	addi	s1,s1,1
 63e:	fff4c903          	lbu	s2,-1(s1)
 642:	14090d63          	beqz	s2,79c <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 646:	0009079b          	sext.w	a5,s2
    if(state == 0){
 64a:	fe0997e3          	bnez	s3,638 <vprintf+0x5c>
      if(c == '%'){
 64e:	fd479ee3          	bne	a5,s4,62a <vprintf+0x4e>
        state = '%';
 652:	89be                	mv	s3,a5
 654:	b7e5                	j	63c <vprintf+0x60>
      if(c == 'd'){
 656:	05878063          	beq	a5,s8,696 <vprintf+0xba>
      } else if(c == 'l') {
 65a:	05978c63          	beq	a5,s9,6b2 <vprintf+0xd6>
      } else if(c == 'x') {
 65e:	07a78863          	beq	a5,s10,6ce <vprintf+0xf2>
      } else if(c == 'p') {
 662:	09b78463          	beq	a5,s11,6ea <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 666:	07300713          	li	a4,115
 66a:	0ce78663          	beq	a5,a4,736 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 66e:	06300713          	li	a4,99
 672:	0ee78e63          	beq	a5,a4,76e <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 676:	11478863          	beq	a5,s4,786 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 67a:	85d2                	mv	a1,s4
 67c:	8556                	mv	a0,s5
 67e:	00000097          	auipc	ra,0x0
 682:	e92080e7          	jalr	-366(ra) # 510 <putc>
        putc(fd, c);
 686:	85ca                	mv	a1,s2
 688:	8556                	mv	a0,s5
 68a:	00000097          	auipc	ra,0x0
 68e:	e86080e7          	jalr	-378(ra) # 510 <putc>
      }
      state = 0;
 692:	4981                	li	s3,0
 694:	b765                	j	63c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 696:	008b0913          	addi	s2,s6,8
 69a:	4685                	li	a3,1
 69c:	4629                	li	a2,10
 69e:	000b2583          	lw	a1,0(s6)
 6a2:	8556                	mv	a0,s5
 6a4:	00000097          	auipc	ra,0x0
 6a8:	e8e080e7          	jalr	-370(ra) # 532 <printint>
 6ac:	8b4a                	mv	s6,s2
      state = 0;
 6ae:	4981                	li	s3,0
 6b0:	b771                	j	63c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b2:	008b0913          	addi	s2,s6,8
 6b6:	4681                	li	a3,0
 6b8:	4629                	li	a2,10
 6ba:	000b2583          	lw	a1,0(s6)
 6be:	8556                	mv	a0,s5
 6c0:	00000097          	auipc	ra,0x0
 6c4:	e72080e7          	jalr	-398(ra) # 532 <printint>
 6c8:	8b4a                	mv	s6,s2
      state = 0;
 6ca:	4981                	li	s3,0
 6cc:	bf85                	j	63c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6ce:	008b0913          	addi	s2,s6,8
 6d2:	4681                	li	a3,0
 6d4:	4641                	li	a2,16
 6d6:	000b2583          	lw	a1,0(s6)
 6da:	8556                	mv	a0,s5
 6dc:	00000097          	auipc	ra,0x0
 6e0:	e56080e7          	jalr	-426(ra) # 532 <printint>
 6e4:	8b4a                	mv	s6,s2
      state = 0;
 6e6:	4981                	li	s3,0
 6e8:	bf91                	j	63c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6ea:	008b0793          	addi	a5,s6,8
 6ee:	f8f43423          	sd	a5,-120(s0)
 6f2:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6f6:	03000593          	li	a1,48
 6fa:	8556                	mv	a0,s5
 6fc:	00000097          	auipc	ra,0x0
 700:	e14080e7          	jalr	-492(ra) # 510 <putc>
  putc(fd, 'x');
 704:	85ea                	mv	a1,s10
 706:	8556                	mv	a0,s5
 708:	00000097          	auipc	ra,0x0
 70c:	e08080e7          	jalr	-504(ra) # 510 <putc>
 710:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 712:	03c9d793          	srli	a5,s3,0x3c
 716:	97de                	add	a5,a5,s7
 718:	0007c583          	lbu	a1,0(a5)
 71c:	8556                	mv	a0,s5
 71e:	00000097          	auipc	ra,0x0
 722:	df2080e7          	jalr	-526(ra) # 510 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 726:	0992                	slli	s3,s3,0x4
 728:	397d                	addiw	s2,s2,-1
 72a:	fe0914e3          	bnez	s2,712 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 72e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 732:	4981                	li	s3,0
 734:	b721                	j	63c <vprintf+0x60>
        s = va_arg(ap, char*);
 736:	008b0993          	addi	s3,s6,8
 73a:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 73e:	02090163          	beqz	s2,760 <vprintf+0x184>
        while(*s != 0){
 742:	00094583          	lbu	a1,0(s2)
 746:	c9a1                	beqz	a1,796 <vprintf+0x1ba>
          putc(fd, *s);
 748:	8556                	mv	a0,s5
 74a:	00000097          	auipc	ra,0x0
 74e:	dc6080e7          	jalr	-570(ra) # 510 <putc>
          s++;
 752:	0905                	addi	s2,s2,1
        while(*s != 0){
 754:	00094583          	lbu	a1,0(s2)
 758:	f9e5                	bnez	a1,748 <vprintf+0x16c>
        s = va_arg(ap, char*);
 75a:	8b4e                	mv	s6,s3
      state = 0;
 75c:	4981                	li	s3,0
 75e:	bdf9                	j	63c <vprintf+0x60>
          s = "(null)";
 760:	00000917          	auipc	s2,0x0
 764:	2a090913          	addi	s2,s2,672 # a00 <longjmp_1+0x4>
        while(*s != 0){
 768:	02800593          	li	a1,40
 76c:	bff1                	j	748 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 76e:	008b0913          	addi	s2,s6,8
 772:	000b4583          	lbu	a1,0(s6)
 776:	8556                	mv	a0,s5
 778:	00000097          	auipc	ra,0x0
 77c:	d98080e7          	jalr	-616(ra) # 510 <putc>
 780:	8b4a                	mv	s6,s2
      state = 0;
 782:	4981                	li	s3,0
 784:	bd65                	j	63c <vprintf+0x60>
        putc(fd, c);
 786:	85d2                	mv	a1,s4
 788:	8556                	mv	a0,s5
 78a:	00000097          	auipc	ra,0x0
 78e:	d86080e7          	jalr	-634(ra) # 510 <putc>
      state = 0;
 792:	4981                	li	s3,0
 794:	b565                	j	63c <vprintf+0x60>
        s = va_arg(ap, char*);
 796:	8b4e                	mv	s6,s3
      state = 0;
 798:	4981                	li	s3,0
 79a:	b54d                	j	63c <vprintf+0x60>
    }
  }
}
 79c:	70e6                	ld	ra,120(sp)
 79e:	7446                	ld	s0,112(sp)
 7a0:	74a6                	ld	s1,104(sp)
 7a2:	7906                	ld	s2,96(sp)
 7a4:	69e6                	ld	s3,88(sp)
 7a6:	6a46                	ld	s4,80(sp)
 7a8:	6aa6                	ld	s5,72(sp)
 7aa:	6b06                	ld	s6,64(sp)
 7ac:	7be2                	ld	s7,56(sp)
 7ae:	7c42                	ld	s8,48(sp)
 7b0:	7ca2                	ld	s9,40(sp)
 7b2:	7d02                	ld	s10,32(sp)
 7b4:	6de2                	ld	s11,24(sp)
 7b6:	6109                	addi	sp,sp,128
 7b8:	8082                	ret

00000000000007ba <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7ba:	715d                	addi	sp,sp,-80
 7bc:	ec06                	sd	ra,24(sp)
 7be:	e822                	sd	s0,16(sp)
 7c0:	1000                	addi	s0,sp,32
 7c2:	e010                	sd	a2,0(s0)
 7c4:	e414                	sd	a3,8(s0)
 7c6:	e818                	sd	a4,16(s0)
 7c8:	ec1c                	sd	a5,24(s0)
 7ca:	03043023          	sd	a6,32(s0)
 7ce:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7d2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7d6:	8622                	mv	a2,s0
 7d8:	00000097          	auipc	ra,0x0
 7dc:	e04080e7          	jalr	-508(ra) # 5dc <vprintf>
}
 7e0:	60e2                	ld	ra,24(sp)
 7e2:	6442                	ld	s0,16(sp)
 7e4:	6161                	addi	sp,sp,80
 7e6:	8082                	ret

00000000000007e8 <printf>:

void
printf(const char *fmt, ...)
{
 7e8:	711d                	addi	sp,sp,-96
 7ea:	ec06                	sd	ra,24(sp)
 7ec:	e822                	sd	s0,16(sp)
 7ee:	1000                	addi	s0,sp,32
 7f0:	e40c                	sd	a1,8(s0)
 7f2:	e810                	sd	a2,16(s0)
 7f4:	ec14                	sd	a3,24(s0)
 7f6:	f018                	sd	a4,32(s0)
 7f8:	f41c                	sd	a5,40(s0)
 7fa:	03043823          	sd	a6,48(s0)
 7fe:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 802:	00840613          	addi	a2,s0,8
 806:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 80a:	85aa                	mv	a1,a0
 80c:	4505                	li	a0,1
 80e:	00000097          	auipc	ra,0x0
 812:	dce080e7          	jalr	-562(ra) # 5dc <vprintf>
}
 816:	60e2                	ld	ra,24(sp)
 818:	6442                	ld	s0,16(sp)
 81a:	6125                	addi	sp,sp,96
 81c:	8082                	ret

000000000000081e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 81e:	1141                	addi	sp,sp,-16
 820:	e422                	sd	s0,8(sp)
 822:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 824:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 828:	00000797          	auipc	a5,0x0
 82c:	2007b783          	ld	a5,512(a5) # a28 <freep>
 830:	a805                	j	860 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 832:	4618                	lw	a4,8(a2)
 834:	9db9                	addw	a1,a1,a4
 836:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 83a:	6398                	ld	a4,0(a5)
 83c:	6318                	ld	a4,0(a4)
 83e:	fee53823          	sd	a4,-16(a0)
 842:	a091                	j	886 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 844:	ff852703          	lw	a4,-8(a0)
 848:	9e39                	addw	a2,a2,a4
 84a:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 84c:	ff053703          	ld	a4,-16(a0)
 850:	e398                	sd	a4,0(a5)
 852:	a099                	j	898 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 854:	6398                	ld	a4,0(a5)
 856:	00e7e463          	bltu	a5,a4,85e <free+0x40>
 85a:	00e6ea63          	bltu	a3,a4,86e <free+0x50>
{
 85e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 860:	fed7fae3          	bgeu	a5,a3,854 <free+0x36>
 864:	6398                	ld	a4,0(a5)
 866:	00e6e463          	bltu	a3,a4,86e <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 86a:	fee7eae3          	bltu	a5,a4,85e <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 86e:	ff852583          	lw	a1,-8(a0)
 872:	6390                	ld	a2,0(a5)
 874:	02059713          	slli	a4,a1,0x20
 878:	9301                	srli	a4,a4,0x20
 87a:	0712                	slli	a4,a4,0x4
 87c:	9736                	add	a4,a4,a3
 87e:	fae60ae3          	beq	a2,a4,832 <free+0x14>
    bp->s.ptr = p->s.ptr;
 882:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 886:	4790                	lw	a2,8(a5)
 888:	02061713          	slli	a4,a2,0x20
 88c:	9301                	srli	a4,a4,0x20
 88e:	0712                	slli	a4,a4,0x4
 890:	973e                	add	a4,a4,a5
 892:	fae689e3          	beq	a3,a4,844 <free+0x26>
  } else
    p->s.ptr = bp;
 896:	e394                	sd	a3,0(a5)
  freep = p;
 898:	00000717          	auipc	a4,0x0
 89c:	18f73823          	sd	a5,400(a4) # a28 <freep>
}
 8a0:	6422                	ld	s0,8(sp)
 8a2:	0141                	addi	sp,sp,16
 8a4:	8082                	ret

00000000000008a6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8a6:	7139                	addi	sp,sp,-64
 8a8:	fc06                	sd	ra,56(sp)
 8aa:	f822                	sd	s0,48(sp)
 8ac:	f426                	sd	s1,40(sp)
 8ae:	f04a                	sd	s2,32(sp)
 8b0:	ec4e                	sd	s3,24(sp)
 8b2:	e852                	sd	s4,16(sp)
 8b4:	e456                	sd	s5,8(sp)
 8b6:	e05a                	sd	s6,0(sp)
 8b8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8ba:	02051493          	slli	s1,a0,0x20
 8be:	9081                	srli	s1,s1,0x20
 8c0:	04bd                	addi	s1,s1,15
 8c2:	8091                	srli	s1,s1,0x4
 8c4:	0014899b          	addiw	s3,s1,1
 8c8:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8ca:	00000517          	auipc	a0,0x0
 8ce:	15e53503          	ld	a0,350(a0) # a28 <freep>
 8d2:	c515                	beqz	a0,8fe <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8d6:	4798                	lw	a4,8(a5)
 8d8:	02977f63          	bgeu	a4,s1,916 <malloc+0x70>
 8dc:	8a4e                	mv	s4,s3
 8de:	0009871b          	sext.w	a4,s3
 8e2:	6685                	lui	a3,0x1
 8e4:	00d77363          	bgeu	a4,a3,8ea <malloc+0x44>
 8e8:	6a05                	lui	s4,0x1
 8ea:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8ee:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8f2:	00000917          	auipc	s2,0x0
 8f6:	13690913          	addi	s2,s2,310 # a28 <freep>
  if(p == (char*)-1)
 8fa:	5afd                	li	s5,-1
 8fc:	a88d                	j	96e <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 8fe:	00000797          	auipc	a5,0x0
 902:	1a278793          	addi	a5,a5,418 # aa0 <base>
 906:	00000717          	auipc	a4,0x0
 90a:	12f73123          	sd	a5,290(a4) # a28 <freep>
 90e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 910:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 914:	b7e1                	j	8dc <malloc+0x36>
      if(p->s.size == nunits)
 916:	02e48b63          	beq	s1,a4,94c <malloc+0xa6>
        p->s.size -= nunits;
 91a:	4137073b          	subw	a4,a4,s3
 91e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 920:	1702                	slli	a4,a4,0x20
 922:	9301                	srli	a4,a4,0x20
 924:	0712                	slli	a4,a4,0x4
 926:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 928:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 92c:	00000717          	auipc	a4,0x0
 930:	0ea73e23          	sd	a0,252(a4) # a28 <freep>
      return (void*)(p + 1);
 934:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 938:	70e2                	ld	ra,56(sp)
 93a:	7442                	ld	s0,48(sp)
 93c:	74a2                	ld	s1,40(sp)
 93e:	7902                	ld	s2,32(sp)
 940:	69e2                	ld	s3,24(sp)
 942:	6a42                	ld	s4,16(sp)
 944:	6aa2                	ld	s5,8(sp)
 946:	6b02                	ld	s6,0(sp)
 948:	6121                	addi	sp,sp,64
 94a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 94c:	6398                	ld	a4,0(a5)
 94e:	e118                	sd	a4,0(a0)
 950:	bff1                	j	92c <malloc+0x86>
  hp->s.size = nu;
 952:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 956:	0541                	addi	a0,a0,16
 958:	00000097          	auipc	ra,0x0
 95c:	ec6080e7          	jalr	-314(ra) # 81e <free>
  return freep;
 960:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 964:	d971                	beqz	a0,938 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 966:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 968:	4798                	lw	a4,8(a5)
 96a:	fa9776e3          	bgeu	a4,s1,916 <malloc+0x70>
    if(p == freep)
 96e:	00093703          	ld	a4,0(s2)
 972:	853e                	mv	a0,a5
 974:	fef719e3          	bne	a4,a5,966 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 978:	8552                	mv	a0,s4
 97a:	00000097          	auipc	ra,0x0
 97e:	b7e080e7          	jalr	-1154(ra) # 4f8 <sbrk>
  if(p == (char*)-1)
 982:	fd5518e3          	bne	a0,s5,952 <malloc+0xac>
        return 0;
 986:	4501                	li	a0,0
 988:	bf45                	j	938 <malloc+0x92>

000000000000098a <setjmp>:
 98a:	e100                	sd	s0,0(a0)
 98c:	e504                	sd	s1,8(a0)
 98e:	01253823          	sd	s2,16(a0)
 992:	01353c23          	sd	s3,24(a0)
 996:	03453023          	sd	s4,32(a0)
 99a:	03553423          	sd	s5,40(a0)
 99e:	03653823          	sd	s6,48(a0)
 9a2:	03753c23          	sd	s7,56(a0)
 9a6:	05853023          	sd	s8,64(a0)
 9aa:	05953423          	sd	s9,72(a0)
 9ae:	05a53823          	sd	s10,80(a0)
 9b2:	05b53c23          	sd	s11,88(a0)
 9b6:	06153023          	sd	ra,96(a0)
 9ba:	06253423          	sd	sp,104(a0)
 9be:	4501                	li	a0,0
 9c0:	8082                	ret

00000000000009c2 <longjmp>:
 9c2:	6100                	ld	s0,0(a0)
 9c4:	6504                	ld	s1,8(a0)
 9c6:	01053903          	ld	s2,16(a0)
 9ca:	01853983          	ld	s3,24(a0)
 9ce:	02053a03          	ld	s4,32(a0)
 9d2:	02853a83          	ld	s5,40(a0)
 9d6:	03053b03          	ld	s6,48(a0)
 9da:	03853b83          	ld	s7,56(a0)
 9de:	04053c03          	ld	s8,64(a0)
 9e2:	04853c83          	ld	s9,72(a0)
 9e6:	05053d03          	ld	s10,80(a0)
 9ea:	05853d83          	ld	s11,88(a0)
 9ee:	06053083          	ld	ra,96(a0)
 9f2:	06853103          	ld	sp,104(a0)
 9f6:	c199                	beqz	a1,9fc <longjmp_1>
 9f8:	852e                	mv	a0,a1
 9fa:	8082                	ret

00000000000009fc <longjmp_1>:
 9fc:	4505                	li	a0,1
 9fe:	8082                	ret
