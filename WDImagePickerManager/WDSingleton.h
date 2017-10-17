
// .h
#define WDSingletonH(name) +(instancetype)shared##name;

// .m
#define WDSingletonM(name) static id _instance;\
+(instancetype)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super allocWithZone:zone];\
});\
return _instance;\
}\
\
-(id)copyWithZone:(NSZone *)zone\
{\
return _instance;\
}\
\
-(id)mutableCopyWithZone:(NSZone *)zone\
{\
return _instance;\
}\
\
\
\
+(instancetype)shared##name\
{\
if (!_instance) {\
_instance = [[self alloc] init];\
}\
return _instance;\
}
