Class {
	#name : #RTToadLine,
	#superclass : #RTLine,
	#instVars : [
		'gap',
		'arrowColor'
	],
	#category : #SparkNode
}

{ #category : #accessing }
RTToadLine >> arrowColor [
	^ arrowColor
]

{ #category : #accessing }
RTToadLine >> arrowColor: anObject [
	arrowColor := anObject
]

{ #category : #hooks }
RTToadLine >> arrowColorFor: anElement [
	"Return the width for the provided element"
	^ arrowColor rtValue: anElement
]

{ #category : #color }
RTToadLine >> color: aColor [
	super color: aColor.
	arrowColor := aColor.
]

{ #category : #accessing }
RTToadLine >> gap [
	^ gap
]

{ #category : #accessing }
RTToadLine >> gap: anObject [
	gap := anObject.
]

{ #category : #hooks }
RTToadLine >> gapFor: anElement [
	"Return the width for the provided element"
	^ gap rtValue: anElement
]

{ #category : #initalize }
RTToadLine >> initialize [
	super initialize.
	gap := 20.
	arrowColor := Color gray
]

{ #category : #hooks }
RTToadLine >> trachelShapeClass [
	^ TRToadVerticalLineShape

]

{ #category : #hooks }
RTToadLine >> updateFor: edge trachelShape: trachelShape [
	trachelShape from: (attachPoint startingPointOf: edge) to: (attachPoint endingPointOf: edge).
	trachelShape color: (self colorFor: edge).
	trachelShape width: (self widthFor: edge).
	trachelShape gap: (self gapFor: edge).
	trachelShape arrowColor: (self arrowColorFor: edge).
	trachelShape resetPath.

]
