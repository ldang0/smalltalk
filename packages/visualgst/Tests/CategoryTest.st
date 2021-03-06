"======================================================================
|
| CategoryTest class definition
|
======================================================================"

"======================================================================
|
| Copyright (c) 2013
| Gwenael Casaccio <gwenael.casaccio@gmail.com>,
|
|
| This file is part of VisualGST.
|
| Permission is hereby granted, free of charge, to any person obtaining
| a copy of this software and associated documentation files (the
| 'Software'), to deal in the Software without restriction, including
| without limitation the rights to use, copy, modify, merge, publish,
| distribute, sublicense, and/or sell copies of the Software, and to
| permit persons to whom the Software is furnished to do so, subject to
| the following conditions:
|
| The above copyright notice and this permission notice shall be
| included in all copies or substantial portions of the Software.
|
| THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
| EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
| MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
| IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
| CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
| TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
| SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
|
======================================================================"

Smalltalk.Object subclass: CategoryA [
    <category: nil>
]

Smalltalk.Object subclass: CategoryB [
    <category: 'Language-Implementation'>
]

Smalltalk.Object subclass: CategoryC [
    <category: 'Foo-Bar'>
]

Smalltalk.TestCase subclass: CategoryTest [

    testExtraction [
	<category: 'testing'>

	| p |
	p := ClassCategory new.
	ClassCategory extractCategory: CategoryA for: p into: CategoryA environment.
        self assert: p categories isEmpty.
	ClassCategory extractCategory: CategoryB for: p into: CategoryB environment.
	self assert: (p categories includesKey: 'Language').
	self assert: (p at: 'Language') isCategory.
	self assert: (p at: 'Language') isNamespace not.
	self assert: ((p at: 'Language') classes isEmpty).
	self assert: ((p at: 'Language') categories includesKey: 'Implementation').
	self assert: ((p at: 'Language') at: 'Implementation') isCategory.
	self assert: ((p at: 'Language') at: 'Implementation') isNamespace not.
	self assert: (((p at: 'Language') at: 'Implementation') classes includes: CategoryB).
    ]

    testCategories [
	<category: 'testing'>

	| categories |
	categories := CategoryC environment categories.
	self assert: (categories at: 'Foo') isCategory.
	self assert: (categories at: 'Foo') isNamespace not.
	self assert: (categories at: 'Foo') name = 'Foo'.
	self assert: Smalltalk isNamespace.
	self assert: Smalltalk isCategory not.
	self assert: (categories at: 'Foo') category == (categories at: 'Foo').
	self assert: (categories at: 'Foo') subspaces isEmpty.
	self assert: (((categories at: 'Foo') at: 'Bar') classes includes: CategoryC).
	self assert: (((categories at: 'Foo') at: 'Bar') parent == (categories at: 'Foo')).
	self assert: (categories at: 'Foo') parent parent isNil.
    ]

    testNamespace [

	| categories |
	categories := CategoryC environment categories.
	self assert: categories namespace = CategoryC environment.
	self assert: (categories at: 'Foo') namespace = CategoryC environment.
    ]

    testCategoryOfClass [
	<category: 'testing'>

	| p |
	p := Object classCategory.
	self assert: p name = 'Implementation'.
	p := Kernel.Stat classCategory.
	self assert: p name isEmpty.
    ]

    testChangeCategory [
	<category: 'testing'>

	| p language implementation |
	p := ClassCategory new.
        ClassCategory extractCategory: CategoryB for: p into: CategoryB environment.
        ClassCategory extractCategory: CategoryC for: p into: CategoryC environment.
        (implementation := (language := p at: 'Language') at: 'Implementation') removeClass: CategoryB.
        self assert: implementation classes isEmpty.
        self assert: implementation parent isNil.
        self assert: language classes isEmpty.
        self assert: language parent isNil.
        self assert: (language categories includes: implementation) not.
        self assert: (p categories includes: language) not.
        self assert: (p categories includesKey: 'Foo').
    ]

    testUpdateCategory [
	<category: 'testing'>

	| p |
	p := CategoryC classCategory.
	self assert: (p classes includes: CategoryC).
	p removeClass: CategoryC.
	self assert: (p classes includes: CategoryC) not.
	self assert: p parent isNil.
        ClassCategory extractCategory: CategoryC for: CategoryC environment categories into: CategoryC environment.
	self assert: (((CategoryC environment categories at: 'Foo') at: 'Bar') classes includes: CategoryC)
    ]
]
