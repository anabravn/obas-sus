[QueryItem="Labels"]
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?p WHERE {
	?c rdfs:label "pessoa"@pt .
	?s rdfs:label "sexo biológico do paciente"@pt .

	?p a ?c ;
	?s "M" .
}
[QueryItem="Hábitos"]
PREFIX obas: <https://github.com/glaubernunes/ontology-for-bariatric-surgery/raw/main/ontology-for-bariatric-surgery.owl#OBAS_>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT  ?habito (COUNT(?pessoa) AS ?n) WHERE {
	?pessoa obas:0000173 ?h .
	?h rdfs:label ?habito .
} GROUP BY ?habito
[QueryItem="Comorbidades"]
PREFIX obas: <https://github.com/glaubernunes/ontology-for-bariatric-surgery/raw/main/ontology-for-bariatric-surgery.owl#OBAS_>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT  ?comorbidade (COUNT(?pessoa) AS ?n) WHERE {
	?pessoa  obas:0000172 ?c.
	?c rdfs:label ?comorbidade.
} GROUP BY ?comorbidade
[QueryGroup="Exemplos"] @collection [[
[QueryItem="Minus"]
PREFIX obas: <https://github.com/glaubernunes/ontology-for-bariatric-surgery/raw/main/ontology-for-bariatric-surgery.owl#OBAS_>

SELECT * WHERE {
	{?p obas:0000173 ?habito}
	MINUS
	{?p obas:0000172 ?comorbidade}
}
[QueryItem="Union"]
PREFIX obas: <https://github.com/glaubernunes/ontology-for-bariatric-surgery/raw/main/ontology-for-bariatric-surgery.owl#OBAS_>

SELECT * WHERE {
	{?p obas:0000173 ?habito}
	UNION
	{?p obas:0000172 ?comorbidade}
}
[QueryItem="Optional"]
PREFIX obas: <https://github.com/glaubernunes/ontology-for-bariatric-surgery/raw/main/ontology-for-bariatric-surgery.owl#OBAS_>

SELECT * WHERE {
	?pessoa obas:1000001 ?internacao .
	OPTIONAL {
		?pessoa obas:0000173 ?habito.
	}
}
[QueryItem="Filter"]
PREFIX obas: <https://github.com/glaubernunes/ontology-for-bariatric-surgery/raw/main/ontology-for-bariatric-surgery.owl#OBAS_>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?type ?cir  WHERE {
	?cir rdf:type ?type.
	?type rdfs:subClassOf obas:0000191.
	FILTER(!sameTerm(?type,obas:0000191) && !sameTerm(?type,obas:0000140) && !sameTerm(?type, obas:0000147))
}
[QueryItem="Basic"]
PREFIX obas: <https://github.com/glaubernunes/ontology-for-bariatric-surgery/raw/main/ontology-for-bariatric-surgery.owl#OBAS_>

SELECT ?p ?s WHERE {
	?p obas:0000177 ?s.
}
]]
[QueryItem="Pessoa Internação"]
PREFIX obas: <https://github.com/glaubernunes/ontology-for-bariatric-surgery/raw/main/ontology-for-bariatric-surgery.owl#OBAS_>

SELECT ?pessoa ?internacao ?valor ?data_inicio ?data_fim WHERE {
	?pessoa obas:1000001 ?internacao.
	?internacao obas:1000015 ?data_inicio;
	obas:1000016 ?data_fim;
	obas:1000030 ?valor.
}
[QueryItem="Idade"]
PREFIX obas: <https://github.com/glaubernunes/ontology-for-bariatric-surgery/raw/main/ontology-for-bariatric-surgery.owl#OBAS_>
PREFIX : <https://github.com/glaubernunes/ontology-for-bariatric-surgery/raw/main/ontology-for-bariatric-surgery.owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?sex (MAX(?age) as ?idade_max) (MIN(?age) as ?idade_min) WHERE {
	?p obas:1000001 ?internacao ;
	obas:0000178 ?age ;
	obas:0000177 ?sex .
} GROUP BY ?sex
[QueryItem="Cirurgia"]
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX obas: <https://github.com/glaubernunes/ontology-for-bariatric-surgery/raw/main/ontology-for-bariatric-surgery.owl#OBAS_>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?label (COUNT(?cir) AS ?count) WHERE {
	?cir rdf:type ?type.
	?type rdfs:label ?label; rdfs:subClassOf obas:0000191.
	FILTER(!sameTerm(?type,obas:0000191) && !sameTerm(?type,obas:0000140) && !sameTerm(?type, obas:0000147))
} GROUP BY ?label ORDER BY ?count
[QueryItem="Hábitos e Cirurgia"]
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX obas: <https://github.com/glaubernunes/ontology-for-bariatric-surgery/raw/main/ontology-for-bariatric-surgery.owl#OBAS_>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?habito ?cirurgia  (COUNT(?pessoa) AS ?count) WHERE {
	?pessoa  obas:1000014 ?cir.
	?cir rdf:type ?type.
	?type rdfs:subClassOf obas:0000140.
	?type rdfs:label ?cirurgia.

	?pessoa obas:0000173 ?h .
	?h rdfs:label ?habito.

	FILTER(!sameTerm(?type,obas:0000140))
} GROUP BY ?habito ?cirurgia
[QueryItem="Comorbidades Porcentagem"]
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX obas: <https://github.com/glaubernunes/ontology-for-bariatric-surgery/raw/main/ontology-for-bariatric-surgery.owl#OBAS_>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?comorbidade  (ROUND(?num*1000)/1000 AS ?percent) {
	{SELECT (COUNT(?p) AS ?total) {
		?p obas:0000172 ?x.
	}}

	{SELECT ?comorbidade (COUNT(?pessoa) AS ?count) WHERE {
		?pessoa obas:0000172 ?c.
		?c rdfs:label ?comorbidade.
	} GROUP BY ?comorbidade}

	BIND ((?count/?total) * 100 AS ?num)
} ORDER BY ?num
[QueryItem="Consultas"]
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX obas: <https://github.com/glaubernunes/ontology-for-bariatric-surgery/raw/main/ontology-for-bariatric-surgery.owl#OBAS_>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?pessoa ?data ?consultas WHERE {
	?pessoa  obas:1000014 ?cir.
	?cir obas:1000023  ?data.
	{SELECT ?pessoa (COUNT(?consulta) AS ?consultas) WHERE {
		?pessoa obas:0000174 ?consulta.
	} GROUP BY ?pessoa}
}
[QueryItem="Data da Cirurgia"]
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX obas: <https://github.com/glaubernunes/ontology-for-bariatric-surgery/raw/main/ontology-for-bariatric-surgery.owl#OBAS_>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?pessoa ?cir ?data WHERE {
	?pessoa  obas:1000014 ?cir.
	?cir obas:1000023  ?data.
}
[QueryItem="Data da Consulta"]
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX obas: <https://github.com/glaubernunes/ontology-for-bariatric-surgery/raw/main/ontology-for-bariatric-surgery.owl#OBAS_>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?pessoa ?consulta ?ano ?mes WHERE {
	?pessoa obas:0000174 ?consulta.
	?consulta obas:1000022 ?mes; obas:1000021 ?ano.
}
[QueryItem="Consultas por Cirurgia"]
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX obas: <https://github.com/glaubernunes/ontology-for-bariatric-surgery/raw/main/ontology-for-bariatric-surgery.owl#OBAS_>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?cirurgia (AVG(?consultas) AS ?avg) WHERE {
	?pessoa  obas:1000014 ?cir.
	?cir rdf:type ?type.
	?type rdfs:label ?cirurgia; rdfs:subClassOf obas:0000140.
	FILTER(!sameTerm(?type,obas:0000140))
	{SELECT ?pessoa (COUNT(?consulta) AS ?consultas) WHERE {
		?pessoa obas:0000174 ?consulta.
	} GROUP BY ?pessoa}
} GROUP BY ?cirurgia
[QueryItem="Medicamentos"]
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX obas: <https://github.com/glaubernunes/ontology-for-bariatric-surgery/raw/main/ontology-for-bariatric-surgery.owl#OBAS_>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?label (COUNT(?p) AS ?count) WHERE {
	?p obas:0000200 ?m.
	?m rdfs:label ?label.
} GROUP BY ?label
[QueryItem="Peso"]
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX obas: <https://github.com/glaubernunes/ontology-for-bariatric-surgery/raw/main/ontology-for-bariatric-surgery.owl#OBAS_>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?pessoa ?p WHERE {
	?pessoa obas:0000174 ?consulta.
	?consulta obas:1000037 ?p.
}
[QueryItem="Porcentagem de Comorbidades por Cirurgia"]
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX obas: <https://github.com/glaubernunes/ontology-for-bariatric-surgery/raw/main/ontology-for-bariatric-surgery.owl#OBAS_>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?cirurgia ?comorb ?num WHERE {
	{SELECT ?type (COUNT(?p) AS ?total) WHERE {
		?p  obas:1000014 ?cir.
		?cir rdf:type ?type.
		?type rdfs:subClassOf obas:0000140.
		FILTER(!sameTerm(?type,obas:0000140))
	} GROUP BY  ?type}

	{SELECT ?type ?c (COUNT(?pessoa) AS ?count)  WHERE {
		?pessoa  obas:1000014 ?cir.
		?cir rdf:type ?type.
		?pessoa obas:0000172 ?c .
	} GROUP BY ?type ?c}

	?c rdfs:label ?comorb.
	?type rdfs:label ?cirurgia.
	BIND ((?count/?total) * 100 AS ?num)
}