#include <math.h>
#include "calc.h"

//定义四则运算的操作名字   实际上真正的运算都是最火那句返回值做了运算  具体实现在 calc.h 中
#define DEFINE_BINARY_OPERATION(name) \
        struct number name(struct number x, struct number y) { \
                if (IS_DECIMAL(x) || IS_DECIMAL(y)) { \
                        ENSURE_DECIMAL(x); \
                        ENSURE_DECIMAL(y); \
                        return name##_DECIMAL(x, y); \
                } \
                else { \
                        return name##_INTEGER(x, y); \
                } \
        }

DEFINE_BINARY_OPERATION(ADD);
DEFINE_BINARY_OPERATION(SUBTRACT);
DEFINE_BINARY_OPERATION(MULTIPLY);
DEFINE_BINARY_OPERATION(DIVIDE);

struct number NEGATE(struct number x) {
        if (IS_DECIMAL(x))
                x.decimal = -x.decimal;
        else
                x.integer = -x.integer;

        return x;
}
