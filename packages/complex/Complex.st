"======================================================================
|
|   Complex number declarations
|
|
 ======================================================================"


"======================================================================
|
| Copyright 2007 Free Software Foundation, Inc.
| Written by Paolo Bonzini
|
| This file is part of the GNU Smalltalk class library.
|
| The GNU Smalltalk class library is free software; you can redistribute it
| and/or modify it under the terms of the GNU Lesser General Public License
| as published by the Free Software Foundation; either version 2.1, or (at
| your option) any later version.
|
| The GNU Smalltalk class library is distributed in the hope that it will be
| useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
| MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser
| General Public License for more details.
|
| You should have received a copy of the GNU Lesser General Public License
| along with the GNU Smalltalk class library; see the file COPYING.LIB.
| If not, write to the Free Software Foundation, 59 Temple Place - Suite
| 330, Boston, MA 02110-1301, USA.
|
 ======================================================================"

Number subclass: #Complex
	instanceVariableNames: 're im'
	classVariableNames: 'Zero One I'
	poolDictionaries: ''
	category: 'Examples-Useful'!

Complex comment: 'I provide complex numbers, with full interoperability
with other kinds of numbers.  Complex numbers can be created from imaginary
numbers, which in turn are created with `Complex i'' or the #i method
(e.g. `3 i'').  Alternatively, they can be created from polar numbers.'!

!Complex class methodsFor: 'instance creation'!

initialize
    "Initialize some common complex numbers."
    Zero := Complex basicNew setReal: 0 imaginary: 0.
    One := Complex basicNew setReal: 1 imaginary: 0.
    I := Complex real: 0 imaginary: 1!

i
    "Return the imaginary unit, -1 sqrt."
    ^I!

new
   self shouldNotImplement!

rho: dist theta: angle
    "Return a complex number whose absolute value is dist and whose
     argument is angle."
    ^Complex
	realResult: dist * angle cos
	imaginary: dist * angle sin!

realResult: re imaginary: im
    "Private - Return a new complex number knowing that re and im have the
     same generality."
    im = 0 ifTrue: [ ^re ].
    ^self basicNew setReal: re imaginary: im!

real: re imaginary: im
    "Return a complex number with the given real and imaginary parts."
    im = 0 ifTrue: [ ^re ].
    re isComplex ifTrue: [ ^re + im i ].
    im isComplex ifTrue: [ ^re + im i ].

    re generality = im generality
	ifTrue: [ ^self basicNew setReal: re imaginary: im ].

    ^re generality < im generality
	ifTrue: [ ^self basicNew setReal: (im coerce: re) imaginary: im ]
	ifFalse: [ ^self basicNew setReal: re imaginary: (re coerce: im) ]! !

!Complex methodsFor: 'math'!

+ z
    "Sum the receiver with the (real or complex) number z."
    ^Complex
	realResult: self real + z real
	imaginary: self imaginary + z imaginary!

- z
    "Subtract the (real or complex) number z from the receiver."
    ^Complex
	realResult: self real - z real
	imaginary: self imaginary - z imaginary!

* z
    "Multiply the receiver by the (real or complex) number z."
    z isComplex ifFalse: [
	^Complex
	    realResult: self real * z
	    imaginary: self imaginary * z ].
    ^Complex
	realResult: (self real * z real) - (self imaginary * z imaginary)
	imaginary: (self real * z imaginary) + (self imaginary * z real)!

/ z
    "Divide the receiver by the (real or complex) number z."
    z isComplex ifFalse: [
	^Complex
	    realResult: self real / z
	    imaginary: self imaginary / z ].
    ^self * z reciprocal!

reciprocal
    "Return the reciprocal of the receiver."
    | absSquared |
    absSquared := self absSquared.
    ^Complex
	realResult: self real / absSquared
	imaginary: self imaginary negated / absSquared!

abs
    "Return the absolute value of the receiver."
    ^(self real squared + self imaginary squared) sqrt!

absSquared
    "Return the squared absolute value of the receiver."
    ^(self real squared + self imaginary squared)!

conjugate
    "Return the complex conjugate of the receiver."
    ^Complex
	realResult: self real
	imaginary: self imaginary negated!

!Complex methodsFor: 'transcendental functions'!

exp
    "Return e raised to the receiver."
    | expRe |
    expRe := self real exp.
    ^Complex
	realResult: expRe * self imaginary cos
	imaginary: expRe * self imaginary sin!

sqrt
    "Return the square root of the receiver.  Can be improved!"
    | abs |
    self imaginary < 0 ifTrue: [ ^self conjugate sqrt conjugate ].
    abs := self abs.
    ^Complex
	realResult: ((abs + self real) / 2) sqrt
	imaginary: ((abs - self real) / 2) sqrt!

sin
    "Return the sine of the receiver."
    | sinhIm |
    sinhIm := self imaginary sinh.
    ^Complex
	realResult: self real sin * (sinhIm squared + 1) sqrt
	imaginary: self real cos * sinhIm!

cos
    "Return the cosine of the receiver."
    | sinhIm |
    sinhIm := self imaginary sinh.
    ^Complex
	realResult: self real cos * (sinhIm squared + 1) sqrt
	imaginary: self real sin negated * sinhIm!

sinh
    "Return the hyperbolic sine of the receiver."
    | sinhRe |
    sinhRe := self real sinh.
    ^Complex
	realResult: sinhRe * self imaginary cos
	imaginary: (sinhRe squared + 1) sqrt * self imaginary sin!

cosh
    "Return the hyperbolic cosine of the receiver."
    | sinhRe |
    sinhRe := self real sinh.
    ^Complex
	realResult: (sinhRe squared + 1) sqrt * self imaginary cos
	imaginary: sinhRe * self imaginary sin!

arg
    "Return the argument of the receiver."
    ^self imaginary arcTan: self real!

arcTan
    "Return the arc-tangent of the receiver."
    | z |
    z := ((Complex i + self) / (Complex i - self) asFloat) ln.
    ^Complex real: 0 imaginary: z / 2!

arcTan: aNumber
    "Return the arc-tangent of aNumber divided by the receiver."
    | z |
    z := ((aNumber i + self) / (aNumber i - self) asFloat) ln.
    ^Complex real: 0 imaginary: z / 2!

ln
    "Return the natural logarithm of the receiver."
    ^Complex
	realResult: self absSquared ln / 2
	imaginary: self arg!

log
    "Return the base-10 logarithm of the receiver."
    | ln |
    ln := self ln.
    ^ln / ln real class ln10! 

tanh
    "Return the hyperbolic tangent of the receiver."
    ^self sinh / self cosh!

tan
    "Return the tangent of the receiver."
    ^self sin / self cos! !

!Complex methodsFor: 'comparing'!

< aNumber
    ^self abs < aNumber abs!

<= aNumber
    ^self abs <= aNumber abs!

>= aNumber
    ^self abs >= aNumber abs!

> aNumber
    ^self abs > aNumber abs!

= aNumber
    aNumber isNumber ifFalse: [ ^false ].
    ^self real = aNumber real and: [ self imaginary = aNumber imaginary ]!

~= aNumber
    aNumber isNumber ifFalse: [ ^true ].
    ^self real ~= aNumber real or: [ self imaginary ~= aNumber imaginary ]!

hash
    ^self real hash bitXor: self imaginary hash!

!Complex methodsFor: 'converting'!

asFloat
    ^Complex
	real: self real asFloat
	imaginary: self imaginary asFloat!

asFloatD
    ^Complex
	real: self real asFloatD
	imaginary: self imaginary asFloatD!

asFloatE
    ^Complex
	real: self real asFloatE
	imaginary: self imaginary asFloatE!

asFloatQ
    ^Complex
	real: self real asFloatQ
	imaginary: self imaginary asFloatQ!

asFraction
    ^Complex
	real: self real asFraction
	imaginary: self imaginary asFraction!

asExactFraction
    ^Complex
	real: self real asExactFraction
	imaginary: self imaginary asExactFraction!

floor
    ^Complex
	real: self real floor
	imaginary: self imaginary floor!

ceiling
    ^Complex
	real: self real ceiling
	imaginary: self imaginary ceiling!

truncated
    ^Complex
	real: self real truncated
	imaginary: self imaginary truncated!

rounded
    ^Complex
	real: self real rounded
	imaginary: self imaginary rounded! !

!Complex methodsFor: 'printing'!

printOn: aStream
    aStream
	nextPut: $(;
	print: self real;
	nextPut: $+;
	print: self imaginary;
	nextPut: $i;
	nextPut: $)!

storeOn: aStream
    aStream
	nextPut: $(;
	store: self real;
	nextPut: $+;
	store: self imaginary;
	nextPutAll: ' i)'!

!Complex methodsFor: 'creation/coercion'!

isComplex 
    ^true!

zero
    ^Zero!

one
    ^One!

generality
    ^re generality + 1000!

real
    ^re!

imaginary
    ^im!

coerce: aNumber
    aNumber isComplex
	ifFalse: [ ^Complex basicNew setReal: aNumber imaginary: aNumber zero ].

    ^Complex basicNew
	setReal: (re coerce: aNumber real)
	imaginary: (re coerce: aNumber imaginary)!

setReal: real imaginary: imag
    re := real.
    im := imag!

i
    "Return the receiver multiplied by the imaginary unit."
    ^Complex real: self imaginary negated imaginary: self real!

!Number methodsFor: 'accessing'!

real
    "Return the real part of the receiver."
    ^self
!

imaginary
    "Return the imaginary part of the receiver, which is zero."
    ^self zero
!

conjugate
    "Return the receiver, which is the same as its conjugate."
    ^self
!

isComplex 
    ^false!

absSquared
    "Return the square of the receiver, which is also the squared absolute
     value for real numbers."
    ^self squared
!

raisedTo: aNumber
    "Return the receiver, raised to aNumber.  This may answer a complex number
     if the receiver is negative."
    | log theta |
    aNumber isComplex ifFalse: [
	^Complex
	    rho: (self absSquared raisedTo: aNumber / 2)
	    theta: (self arg * aNumber) ].
    log := self abs ln.
    theta := self arg.
    ^Complex
	rho: ((aNumber real * log) - (aNumber imaginary * theta)) exp
	theta: (aNumber real * theta) + (aNumber imaginary * log)!

arg
    "Return the argument of the receiver."
    ^self >= 0 ifTrue: [ 0.0d ] ifFalse: [ FloatD pi ]
!

i
    "Return the receiver multiplied by the imaginary unit."
    ^Complex real: self zero imaginary: self
! !

!Float methodsFor: 'private'!

primLn
    "Answer the natural logarithm of the receiver"
    <primitive: VMpr_Float_ln>
    self primitiveFailed
!

primSqrt
    "Answer the square root of the receiver"
    <primitive: VMpr_Float_sqrt>
    self primitiveFailed
!

!Float methodsFor: 'transcendental functions'!

arg
    "Return the argument of the receiver."
    ^self >= 0 ifTrue: [ self zero ] ifFalse: [ self class pi ]
!

ln
    "Answer the natural logarithm of the receiver"
    self >= 0 ifTrue: [ ^self primLn ].
    ^Complex real: self negated primLn imaginary: self class pi
!

sqrt
    "Answer the square root of the receiver"
    self >= 0 ifTrue: [ ^self primSqrt ].
    ^Complex real: 0 imaginary: self negated primSqrt
! !

!Number methodsFor: 'transcendental functions'!

arcCos
    "Return the arc-cosine of the receiver."
    | z |
    z := (Complex real: self imaginary: ((1 - self squared) sqrt)) ln.
    ^Complex real: 0 imaginary: z negated!

arcSin
    "Return the arc-sine of the receiver."
    | z |
    z := (Complex real: ((1 - self squared) sqrt) imaginary: self) ln.
    ^Complex real: 0 imaginary: z negated! !

Float methodDictionary
    removeKey: #arcSin;
    removeKey: #arcCos!

Complex initialize!