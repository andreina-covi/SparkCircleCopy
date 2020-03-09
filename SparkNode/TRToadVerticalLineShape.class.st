Class {
	#name : #TRToadVerticalLineShape,
	#superclass : #TRLineShape,
	#instVars : [
		'topArc',
		'bottomArc',
		'gap',
		'arrow',
		'direction'
	],
	#category : #SparkNode
}

{ #category : #accessing }
TRToadVerticalLineShape >> arrowColor: anObject [
	arrow color: anObject.
]

{ #category : #drawing }
TRToadVerticalLineShape >> bottom [
	^ (from y < to y) ifTrue:[to] ifFalse:[from].
]

{ #category : #drawing }
TRToadVerticalLineShape >> color: aColor [
	super color: aColor.
	topArc color: aColor.
	bottomArc color: aColor.
	arrow color: aColor.
]

{ #category : #drawing }
TRToadVerticalLineShape >> computeArcs [
	(gap < 0) ifTrue:[
		topArc alphaAngle: 270 betaAngle: 360 innerRadius: gap externalRadius: (gap+1).
		bottomArc alphaAngle: 0 betaAngle: 90 innerRadius: gap externalRadius: (gap+1).
	] ifFalse:[
		topArc alphaAngle: 0 betaAngle: 90 innerRadius: gap externalRadius: (gap-1).
		bottomArc alphaAngle: 270 betaAngle: 360 innerRadius: gap externalRadius: (gap-1).
	].
	topArc position: (self top + (0@(gap abs))).
	bottomArc position: (self bottom + (0@(-1*gap abs))).
]

{ #category : #drawing }
TRToadVerticalLineShape >> computeArrow [
	|f|
	f := (gap < 0) ifTrue:[-1] ifFalse:[1].
	arrow from: self from.
	arrow to: self to.
	(gap < 0) ifTrue:[
		arrow from: (arrow to + ((-1*f*gap)@0)).
	] ifFalse:[
		arrow from: (arrow to + ((gap*f)@0)).
	].
	arrow canvas: self canvas.
	arrow computePath.
]

{ #category : #drawing }
TRToadVerticalLineShape >> computePath [
	"	gap := (from y - to y) abs/ (from y max: to y).
	gap := gap * direction."

	"self computeArcs."

	"self computeArrow."

	gap := 0.
	path := self athensCanvas
		createPath: [ :builder | 
			from x = to x
				ifTrue: [ from y < to y
						ifTrue: [ builder
								absolute;
								moveTo: from - (0 @ gap);
								lineTo: to + (0 @ gap) ]
						ifFalse: [ builder
								absolute;
								moveTo: from + (0 @ gap);
								lineTo: to - (0 @ gap) ] ]
				ifFalse: [ from x < to x
						ifTrue: [ builder
								absolute;
								moveTo: from - (0 @ gap);
								lineTo: from x @ to y + (0 @ gap);
								lineTo: to + (0 @ gap) ]
						ifFalse: [ builder
								absolute;
								moveTo: from + (0 @ gap);
								lineTo: to x @ from y + (0 @ gap);
								lineTo: to + (0 @ gap) ] ] ]
]

{ #category : #actions }
TRToadVerticalLineShape >> defaultSize [
	^ 5.
]

{ #category : #drawing }
TRToadVerticalLineShape >> drawOn: athensCanvas [
	athensCanvas pathTransform
		restoreAfter: [ athensCanvas setShape: self path.
			(athensCanvas setStrokePaint: color) width: width.
			athensCanvas draw ].
	topArc canvas: self canvas.
	topArc drawOn: athensCanvas.
	bottomArc canvas: self canvas.
	bottomArc drawOn: athensCanvas.
	"arrow canvas: self canvas.
	arrow drawOn: athensCanvas"
]

{ #category : #accessing }
TRToadVerticalLineShape >> gap [
	^ gap
]

{ #category : #accessing }
TRToadVerticalLineShape >> gap: anObject [
	gap := anObject.
	
]

{ #category : #initialization }
TRToadVerticalLineShape >> initialize [
	super initialize.
	topArc := TRArcShape new.
	bottomArc := TRArcShape new.
	arrow := TRFilledArrowHeadShape new.
	arrow size: 5.
	color := Color gray.
	gap :=0.
]

{ #category : #drawing }
TRToadVerticalLineShape >> left [
	^ from x < to x
		ifTrue: [ from ]
		ifFalse: [ to ]
]

{ #category : #drawing }
TRToadVerticalLineShape >> right [
	^ from x > to x
		ifTrue: [ from ]
		ifFalse: [ to ]
]

{ #category : #drawing }
TRToadVerticalLineShape >> top [
	^ (from y < to y) ifTrue:[from] ifFalse:[to]
]
