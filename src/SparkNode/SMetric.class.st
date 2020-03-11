"
this is a metric of a sparkcircle
"
Class {
	#name : #SMetric,
	#superclass : #Object,
	#instVars : [
		'value',
		'oldValue',
		'color',
		'path',
		'signPath'
	],
	#category : #SparkNode
}

{ #category : #creation }
SMetric class >> value: anInteger color: aColor [
	|inst|
	inst := self new.
	inst value: anInteger.
	inst color: aColor.
	^ inst.
]

{ #category : #accessing }
SMetric >> color [
	^ color
]

{ #category : #accessing }
SMetric >> color: anObject [
	color := anObject
]

{ #category : #accessing }
SMetric >> oldValue [
	^ oldValue
]

{ #category : #accessing }
SMetric >> oldValue: anObject [
	oldValue := anObject
]

{ #category : #accessing }
SMetric >> path [
	^ path
]

{ #category : #accessing }
SMetric >> path: anObject [
	path := anObject
]

{ #category : #accessing }
SMetric >> signPath [
	^ signPath
]

{ #category : #accessing }
SMetric >> signPath: anObject [
	signPath := anObject
]

{ #category : #accessing }
SMetric >> value [
	^ value
]

{ #category : #accessing }
SMetric >> value: anObject [
	value := anObject
]
