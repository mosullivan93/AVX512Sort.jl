WRAPSRC		:= jlavx512qsort.cpp
LIBEXT		:= so
LIBOUTNAME	= $(WRAPSRC:%.cpp=lib%.$(LIBEXT))

SRCDIR		:= ./x86-simd-sort/src
UTILS		:= ./x86-simd-sort/utils

# When unset, discover g++. Prioritise the latest version on the path.
ifeq (, $(and $(strip $(CXX)), $(filter-out default undefined, $(origin CXX))))
  override CXX	:= $(shell basename `which g++-12 g++-11 g++-10 g++-9 g++-8 g++ | head -n 1`)
endif

CXXFLAGS	+= $(OPTIMFLAG) $(MARCHFLAG)
override CXXFLAGS	+= -I$(SRCDIR) -I$(UTILS)
override CXXFLAGS	+= -fPIC
override LDFLAGS	+= -shared
OPTIMFLAG	:= -O5
MARCHFLAG	:= -march=sapphirerapids

test_cxx_flag = $(shell 2>/dev/null $(CXX) -o /dev/null $(1) -c -x c++ /dev/null; echo $$?)
# Attempt to determine the best flag, as long as we're not just trying to clean up.
ifneq (clean,$(strip $(MAKECMDGOALS)))
  ifeq ($(call test_cxx_flag,$(MARCHFLAG)), 1)
    $(info "$(MARCHFLAG) is not supported by GCC $(shell $(CXX) -dumpfullversion).. trying icelake-client...")
    MARCHFLAG	:= -march=icelake-client
    ifeq ($(call test_cxx_flag,$(MARCHFLAG)), 1)
      $(warning "$(MARCHFLAG) is not supported either.. using skylake-avx512 (not tested - let me know how you go!)")
      MARCHFLAG	:= -march=skylake-avx512
      ifeq ($(call test_cxx_flag,$(MARCHFLAG)), 1)
        $(error "Your compiler is too old to build using even the minimum necessary AVX512 instructions.")
      endif
    endif
  endif
endif

.PHONY: all
.DEFAULT_GOAL := all
all: lib

.PHONY: lib
lib: $(LIBOUTNAME)

$(LIBOUTNAME): $(WRAPSRC)
	$(CXX) $(CXXFLAGS) $(LDFLAGS) $? -o $@

.PHONY: clean
clean:
	$(RM) $(LIBOUTNAME)
