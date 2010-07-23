// $Date$ 
// $Revision$
// $Author$
#ifdef INMAIN
#define EXTERN
#else
#define EXTERN extern
#endif

void getPROGversion(char *PROGversion);
int getmaxrevision(void);
void version(void);
int getrevision(char *svn);
char *hostlistfile;
char *host;
#ifdef pp_LINUX
char  pid[20];
#endif
int nhostinfo;

typedef struct {
  char *hostname;
  int ncores;
} hostdata;

hostdata *hostinfo;
