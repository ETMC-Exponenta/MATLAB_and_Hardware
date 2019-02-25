// Includes -------------------------------------------------------

//-----------------------------------------------------------------

// Const ----------------------------------------------------------
#define MSG_WAIT_TIME_MS 50
#define MSG_LEN 8
//-----------------------------------------------------------------

// Types ----------------------------------------------------------
typedef struct{
  uint32_t val;
  uint32_t prd;
}tmr_t;

//-----------------------------------------------------------------

// Macros ---------------------------------------------------------

//-----------------------------------------------------------------

// Prototypes -----------------------------------------------------
// timer
void timer_init (tmr_t* timer, uint32_t prd);
uint32_t timer_get_interval(tmr_t* timer);
void timer_upd (tmr_t* timer);
bool timer_rdy (tmr_t* timer);
// serial 
byte serial_read_buf (char* dst, byte dst_size, tmr_t* timeout_tmr);
bool serial_loop_back (byte buf_size, tmr_t* timeout_tmr);

//-----------------------------------------------------------------

// Global Vars ----------------------------------------------------
tmr_t msg_tmr;
//-----------------------------------------------------------------


// Init Fxn -------------------------------------------------------
void setup() {
  timer_init(&msg_tmr, MSG_WAIT_TIME_MS);
  Serial.begin(9600);
  pinMode(2, OUTPUT);   
}
//-----------------------------------------------------------------

// Main Fxn -------------------------------------------------------
void loop() {

  if (serial_loop_back (MSG_LEN, &msg_tmr )){
    digitalWrite(2, HIGH);
  }
  else {
    digitalWrite(2, LOW);
  }
}
//-----------------------------------------------------------------

// Functions

// Timer ----------------------------------------------------------
void timer_init (tmr_t* timer, uint32_t prd){
  timer->val = millis();
  timer->prd = prd;   
}

uint32_t timer_get_interval(tmr_t* timer){
  int32_t tmp;
  tmp = millis()-timer->val;
  if (tmp>0)
    return (tmp);
  else 
    return (-tmp);
}

void timer_upd (tmr_t* timer){
  timer->val = millis();
}

bool timer_rdy (tmr_t* timer){
  if (timer_get_interval(timer)>timer->prd){
    timer_upd(timer);
    return (true);
  }
  return (false);
}
//----------------------------------------------------------------

// Serial --------------------------------------------------------
byte serial_read_buf (char* dst, byte dst_size, tmr_t* timeout_tmr){
  byte bcnt=0;
  timer_upd (timeout_tmr);
  while (bcnt<dst_size){
    if (Serial.available()){
      dst[bcnt]=Serial.read();
      delayMicroseconds(100);// This delay added for stability
      bcnt++;
    }
    if (timer_rdy(timeout_tmr)){
      break;
    }
  }
  return bcnt;
}

bool serial_loop_back (byte buf_size, tmr_t* timeout_tmr){
  char  RecLine[buf_size];
  byte  RecSize=0;
  byte  tmpB;

  RecSize = serial_read_buf(RecLine,sizeof(RecLine), timeout_tmr);
  if (RecSize != 0){
    for(tmpB=0;tmpB<RecSize;tmpB++){
       Serial.print(RecLine[tmpB]);
     }
  }

  if (RecSize == buf_size){
   return(true);     
  }else{
   return false;
  }
 }

// clean buffer
void serial_clean_inc_buf(void){
    while (Serial.available()){
      Serial.read();
    }
}
//----------------------------------------------------------------
