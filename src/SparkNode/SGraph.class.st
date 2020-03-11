"
this renders a git graph
"
Class {
	#name : #SGraph,
	#superclass : #Object,
	#instVars : [
		'graphName',
		'nodes',
		'commits',
		'sortedNodes',
		'array',
		'max',
		'x'
	],
	#category : #SparkNode
}

{ #category : #accessing }
SGraph >> createNodes [
	| last |
	sortedNodes := self repository allBranches
		flatCollect: [ :branch | 
			| color |
			color := Color random.
			branch newCommitWalk commits
				collect: [ :c | 
					SNode new
						commit: c;
						color: color;
						yourself ] ].
	sortedNodes := sortedNodes asSet.
	sortedNodes := sortedNodes asSortedCollection: [ :c1 :c2 | c1 datetime > c2 datetime ].
	sortedNodes := sortedNodes first: 100.
	sortedNodes do: [ :node | nodes at: node id put: node ].
	sortedNodes
		do: [ :node | 
			node ancestorIds
				do: [ :aid | nodes at: aid ifPresent: [ :nodeAnscetor | node add: nodeAnscetor ] ] ].
]

{ #category : #accessing }
SGraph >> fillMetrics [
	nodes
		do: [ :node | 
			| index |
			array
				detect: [ :e | e first = node id ]
				ifFound: [ :row | 
					index := 1.
					
					#(#id	#classes	#methods	#LOC	#tests #pass	#fail	#error #coverage	#timeAVG #MemoldAVG	#MemyoungAVG	#MemusedAVG	#MemfreeAVG	#GCfullAVG	#GCincrAVG 	#DeletedMethods	#NewMethods	#ModifiedMethods	#TotalMethods)
						do: [ :metric | 
							node metrics at: metric put: (row at: index).
							index := index + 1 ] ] ]
]

{ #category : #accessing }
SGraph >> graphName [
	^ graphName
]

{ #category : #accessing }
SGraph >> graphName: anObject [
	graphName := anObject
]

{ #category : #initalize }
SGraph >> initialize [
	super initialize.
	nodes := Dictionary new.
	sortedNodes := OrderedCollection new.
	max := Dictionary new.
]

{ #category : #accessing }
SGraph >> layoutOn: elements [
	| y xo |
	y := 100.
	xo := 100.
	elements
		do: [ :e | 
			e translateTo: xo @ y.
			e model x: xo.
			y := y + 35 ].
	elements first model compute.
	elements do: [ :e | e translateTo: e model x @ e position y ]
]

{ #category : #accessing }
SGraph >> loadMetrics [
	| size |
	array := Array
		streamContents: [ :out | 
			'/Users/juanpablo/IDE/metrics.csv' asFileReference
				readStreamDo: [ :input | 
					| reader |
					reader := NeoCSVReader on: (ZnBufferedReadStream on: input).
					reader
						skipHeader;
						addField.
					(1 to: 20)
						do: [ :e | 
							reader
								addFieldConverter: [ :string | 
									[ string asInteger ]
										on: Error
										do: [ :rr | 0 ] ] ].
					reader do: [ :each | out nextPut: each ] ] ]
]

{ #category : #accessing }
SGraph >> max: metric [
	^ max
		at: metric
		ifAbsentPut: [ 
			(nodes collect: [ :n | n metrics at: metric ifAbsent: [ 0 ] ]) max ]
]

{ #category : #accessing }
SGraph >> repository [
	^ IceRepository registry detect:[ :repo | repo name = graphName].
]

{ #category : #accessing }
SGraph >> view [
	| view es edges es2 maxH dic |
	self createNodes.
	self loadMetrics.
	self fillMetrics.
	dic := Dictionary new.
	dic at: #timeAVG put: RTPalette light second.
	"dic at: #tests put: RTPalette light second."
	dic at: #TotalMethods put: RTPalette light third.
	dic at: #fail put: RTPalette light fourth.
	view := RTView new.
	es := RTSparkCircle new
		size: 40;
		names: [ :node | #(#timeAVG #TotalMethods #fail) ];
		color: [ :node :metricName | dic at: metricName ];
		percent: [ :nodo :metricName | 
			[ nodo var: metricName ]
				on: Error
				do: [ :e | 0 ] ];
		elementsOn: sortedNodes.
	view addAll: es.
	edges := RTEdgeBuilder new
		view: view;
		objects: sortedNodes;
		shape:
			(RTToadLine new
				color: (Color purple alpha: 0.2);
				"vertical;"
					yourself);
		connectFrom: #yourself toAll: #children.
	edges do: [ :e | e trachelShape pushBack ].
	"RTGitTreeLayout new on: es."
	es2 := RTLabel new
		fontName: 'Arial';
		text: [ :m | m comment trim lines first ];
		elementsOn: (sortedNodes collect: #commit).
	view addAll: es2.
	self layoutOn: es.
	"layoute"
	maxH := (es collect: [ :e | e position x ]) max.
	es
		with: es2
		do: [ :e1 :e2 | 
			e1 translateTo: (maxH - e1 position x) @ e1 position y.
			e2 translateTo: (maxH / 2 + (e2 width / 2)) @ e1 position y ].
	view @ RTDraggableView.
	^ view
]
