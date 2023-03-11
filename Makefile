CXX			?= g++
SRCDIR		= ./x86-simd-sort/src
UTILS		= ./x86-simd-sort/utils
SRCS		= $(wildcard $(SRCDIR)/*.hpp)
CXXFLAGS	+= -I$(SRCDIR) -I$(UTILS)
CXXFLAGS	+= -fPIC -shared -O3

all : lib

lib: jlavx512qsort.cpp
		$(CXX) $(CXXFLAGS) -march=icelake-client -o libjlavx512qsort.so jlavx512qsort.cpp

clean:
		rm -f libjlavx512qsort.so
