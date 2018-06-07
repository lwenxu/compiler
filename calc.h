#define TRUE 1
#define FALSE 0
#define BOOL int

struct number {
  long integer;
  double decimal;
  BOOL is_decimal;
};
typedef struct number NUMBER;

struct number get_var(char *);
struct number set_var(char *, struct number);

struct number ADD(struct number x, struct number y);
struct number SUBTRACT(struct number x, struct number y);
struct number MULTIPLY(struct number x, struct number y);
struct number DIVIDE(struct number x, struct number y);
struct number NEGATE(struct number x);

//定义三个宏函数：判断小数，初始化小数和整数
#define IS_DECIMAL(x) x.is_decimal == TRUE
#define NEW_INTEGER(x) (struct number){ x, 0, FALSE }
#define NEW_DECIMAL(x) (struct number){ 0, x, TRUE }

//自动类型转换  int->double
#define ENSURE_DECIMAL(x) \
        if (!IS_DECIMAL(x)) { \
                x.decimal = (double)x.integer; \
                x.is_decimal = TRUE; \
        }

//输出值
#define PRINT_NUMBER(x) \
        do { \
                if (IS_DECIMAL(x)) \
                        printf("%lg\n", x.decimal); \
                else \
                        printf("%ld\n", x.integer); \
        } while (0)


//定义运算操作
#define ADD_INTEGER(x, y) NEW_INTEGER(x.integer + y.integer)
#define ADD_DECIMAL(x, y) NEW_DECIMAL(x.decimal + y.decimal)

#define SUBTRACT_INTEGER(x, y) NEW_INTEGER(x.integer - y.integer)
#define SUBTRACT_DECIMAL(x, y) NEW_DECIMAL(x.decimal - y.decimal);

#define MULTIPLY_INTEGER(x, y) NEW_INTEGER(x.integer * y.integer)
#define MULTIPLY_DECIMAL(x, y) NEW_DECIMAL(x.decimal * y.decimal)

#define DIVIDE_INTEGER(x, y) NEW_INTEGER(x.integer / y.integer)
#define DIVIDE_DECIMAL(x, y) NEW_DECIMAL(x.decimal / y.decimal)
