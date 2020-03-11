Class {
	#name : #SNode,
	#superclass : #Object,
	#instVars : [
		'commit',
		'children',
		'sizeCache',
		'color',
		'metrics',
		'previous',
		'parents',
		'x'
	],
	#category : #SparkNode
}

{ #category : #comparing }
SNode >> = aSNode [
	^ commit = aSNode commit.
]

{ #category : #accessing }
SNode >> add: aSNode [
	self children add: aSNode.
	aSNode parents add: self.
]

{ #category : #accessing }
SNode >> ancestorIds [ 
	^ self commit ancestorIds.
]

{ #category : #accessing }
SNode >> children [
	^ children
]

{ #category : #accessing }
SNode >> children: anObject [
	children := anObject
]

{ #category : #accessing }
SNode >> color [
	^ color
]

{ #category : #accessing }
SNode >> color: anObject [
	color := anObject
]

{ #category : #accessing }
SNode >> commit [
	^ commit
]

{ #category : #accessing }
SNode >> commit: anObject [
	commit := anObject
]

{ #category : #accessing }
SNode >> compute [
	| xo |
	parents size >1 ifTrue:[
	x := [ (parents collect: [ :p | p x ]) min ]
		on: Error
		do: [ 100 ].].
	xo := x.
	children
		do: [ :node | 
			node x: xo.
			xo := xo + 30 ].
	children do: #compute
]

{ #category : #comparing }
SNode >> datetime [ 	
	^ self commit datetime.
]

{ #category : #accessing }
SNode >> firstLine [
	^ commit comment trim lines first.
]

{ #category : #comparing }
SNode >> hash [
	^ self commit hash.
]

{ #category : #accessing }
SNode >> id [
	^ self commit id.
]

{ #category : #accessing }
SNode >> initialize [
	super initialize.
	children := OrderedCollection new.
	metrics := Dictionary new.
	parents := OrderedCollection new.
	x := 100.
]

{ #category : #accessing }
SNode >> metrics [
	^ metrics
]

{ #category : #accessing }
SNode >> metrics: anObject [
	metrics := anObject
]

{ #category : #accessing }
SNode >> metricsAt: name [
	| value minChild res |
	minChild := (self children collect: [ :c | c metrics at: name ]) min.
	value := self metrics at: name.
	res := (value - minChild) / minChild.
	^ ((res min: 1) max: 0)*0.5 + 0.5
]

{ #category : #metrics }
SNode >> parent [
	children ifEmpty: [ ^ self ].
	^ children first.
]

{ #category : #accessing }
SNode >> parentInc [
	parents := parents +1.
]

{ #category : #metrics }
SNode >> parents [
	^ parents.
]

{ #category : #accessing }
SNode >> previous [
	^ children first.
]

{ #category : #accessing }
SNode >> size [
	sizeCache ifNotNil: [ ^ sizeCache ].
	children ifEmpty: [ ^ 5 ].
	sizeCache := (children collect: #size) sum.
	^ sizeCache
]

{ #category : #accessing }
SNode >> sizeCache [
	^ sizeCache
]

{ #category : #accessing }
SNode >> sizeCache: anObject [
	sizeCache := anObject
]

{ #category : #metrics }
SNode >> var: aMetricName [
	| ct ot var |
	(#(#TotalMethods) includes: aMetricName)
		ifTrue: [ ct := self metrics at: aMetricName.
			ct < 0
				ifTrue: [ ^ 0 ].
			ct <= 2
				ifTrue: [ ^ 0.25 ].
			ct <= 5
				ifTrue: [ ^ 0.5 ].
			ct <= 10
				ifTrue: [ ^ 0.75 ].
			^ 1 ]
		ifFalse: [ self previous ifNil: [ 0 ].
			ct := self metrics at: aMetricName.
			ot := self previous metrics at: aMetricName.
			var := (ct - ot) / ot.
			var := var min: 1.
			var := var max: -1.
			^ var sqrt ]
]

{ #category : #accessing }
SNode >> x [
	^ x
]

{ #category : #accessing }
SNode >> x: anObject [
	x := anObject
]
