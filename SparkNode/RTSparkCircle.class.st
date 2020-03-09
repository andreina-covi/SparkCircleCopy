"
this is a roassal shape
"
Class {
	#name : #RTSparkCircle,
	#superclass : #RTEllipse,
	#instVars : [
		'percentBlock',
		'colorBlock',
		'namesBlock',
		'oldBlock'
	],
	#category : #SparkNode
}

{ #category : #accessing }
RTSparkCircle >> color: aBlock [
	colorBlock := aBlock
]

{ #category : #accessing }
RTSparkCircle >> colorBlock [
	^ colorBlock
]

{ #category : #initalize }
RTSparkCircle >> initialize [
	super initialize.
	namesBlock := [ :v | #() ].
	percentBlock := [ :model :metricName | 0 ].
	oldBlock := [ :model :metricName | 0.5 ].
	colorBlock := [ :model :metricName | Color white ]
]

{ #category : #accessing }
RTSparkCircle >> metric: aBlock [
	percentBlock := aBlock
]

{ #category : #hooks }
RTSparkCircle >> metricsOn: anElement [
	| names |
	names := self namesBlock value: anElement model.
	^ names
		collect: [ :name | 
			SMetric new
				value: (self percentBlock value: anElement model value: name);
				oldValue: (self oldBlock value: anElement model value: name);
				color: (self colorBlock value: anElement model value: name) ]
]

{ #category : #accessing }
RTSparkCircle >> names: aBlock [
	namesBlock := aBlock
]

{ #category : #accessing }
RTSparkCircle >> namesBlock [
	^ namesBlock
]

{ #category : #hooks }
RTSparkCircle >> oldBlock [
	^ oldBlock.
]

{ #category : #hooks }
RTSparkCircle >> oldMetric: aBlock [
	oldBlock := aBlock
]

{ #category : #accessing }
RTSparkCircle >> percent: aBlock [
	percentBlock := aBlock
]

{ #category : #accessing }
RTSparkCircle >> percentBlock [
	^ percentBlock
]

{ #category : #hooks }
RTSparkCircle >> trachelShapeClass [
	^ TRSparkCircleShape.

]

{ #category : #hooks }
RTSparkCircle >> updateFor: anElement trachelShape: trachelShape [
	| ex rec |
	trachelShape isNil
		ifTrue: [ ^ self ].
	ex := (self widthFor: anElement) @ (self heightFor: anElement).
	rec := anElement position - (ex / 2) extent: ex.
	trachelShape
		fromRectangle: rec color: (self colorFor: anElement);
		strokeWidth: (self borderWidthFor: anElement);
		strokePaint: (self borderColorFor: anElement);
		rotateByDegrees: (self rotationFor: anElement);
		scaleBy: (self scaleFor: anElement);
		metrics: (self metricsOn: anElement).
	^ trachelShape
]
