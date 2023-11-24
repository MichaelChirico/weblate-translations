/*
 *  R : A Computer Language for Statistical Data Analysis
 *  Copyright (C) 1998-2023    The R Core Team
 *
 *  This header file is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU Lesser General Public License as published by
 *  the Free Software Foundation; either version 2.1 of the License, or
 *  (at your option) any later version.
 *
 *  This file is part of R. R is distributed under the terms of the
 *  GNU General Public License, either Version 2, June 1991 or Version 3,
 *  June 2007. See doc/COPYRIGHTS for details of the copyright status of R.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public License
 *  along with this program; if not, a copy is available at
 *  https://www.R-project.org/Licenses/
 */

/* Included by R.h: API */

#ifndef R_EXT_PRINT_H_
#define R_EXT_PRINT_H_

#ifdef  __cplusplus
/* If the vprintf interface is defined at all in C++ it may only be
   defined in namespace std.  It is part of the C++11 standard. */
# if __cplusplus >= 201103L && !defined(R_USE_C99_IN_CXX)
#  define R_USE_C99_IN_CXX
# endif
# ifdef R_USE_C99_IN_CXX
#  include <cstdarg>
#  define R_VA_LIST std::va_list
# endif
extern "C" {
#else
# include <stdarg.h>
# define R_VA_LIST va_list
#endif

void Rprintf(const char *, ...)
#ifdef __GNUC__
__attribute__ ((format (printf, 1, 2)))
#endif
;

void REprintf(const char *, ...)
#ifdef __GNUC__
__attribute__ ((format (printf, 1, 2)))
#endif
;

#if !defined(__cplusplus) || defined R_USE_C99_IN_CXX

void Rvprintf(const char *, R_VA_LIST)
#ifdef __GNUC__
__attribute__ ((format (printf, 1, 0)))
#endif
;

void REvprintf(const char *, R_VA_LIST)
#ifdef __GNUC__
__attribute__ ((format (printf, 1, 0)))
#endif
;

#endif

#ifdef  __cplusplus
}
#endif

#endif /* R_EXT_PRINT_H_ */
