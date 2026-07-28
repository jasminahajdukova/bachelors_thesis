Program na automatizované generovanie repceptu pre nástroj Dataster. Nástroj sa pripojí k relačnej databáze, získa schému a vzorky dát. Následne pomocou lokálneho LLM vygeneruje YAML recept pre Dataster.

## Požiadavky
- **Python 3.10+**
- **Ollama**
- Základné modely (**qwen2.5:7b, qwen2.5:3b**) stiahnuté cez ```ollama pull```

    ```ollama pull qwen2.5:7b```

    ```ollama pull qwen2.5:3b```


- **DBMS**: MySQL/PostgreSQL 
- Program bol testovaný na tomto **hardvéri**: 
    - RTX 3070
    - 8 GB VRAM
    - 32 GB RAM


## Inštalácia

- ```pip install -r requirements.txt```
- **Vytvorenie modelov**:

    ```ollama create yaml-generator-types -f Modelfiles/Modelfile-types```
    ```ollama create yaml-generator-schema -f Modelfiles/Modelfile-schema```
    ```ollama create yaml-generator-generate -f Modelfiles/Modelfile-generate```
    ```ollama create yaml-generator-constraints -f Modelfiles/Modelfile-constraints```

    - Stiahnuté modely je možné skontrolovať cez ```ollama list```

## Spustenie

```usage: main.py [-h] --host HOST --user USER --db DB [--no-password] [--password PASSWORD] [--dbms DBMS] [--port PORT]```

- Povinné časti: ```--host``` ```user``` ```--db```
- pri prázdnom ```dbms``` sa použije MySQL
- ```--password``` povoľuje vloženie hesla k pripojenie na DBMS (inač je heslo vyžadované cez getpass)
- ```--no-password``` v prípade, že DBMS nemá heslo


- Príklad spustenia pre MySQL:

    ```python3 main.py  --host 127.0.0.1 --user root --db testdb   --password heslo --dbms mysql --port 3306```

- Príklad spustenia pre PostgreSQL:

    ```python3 main.py  --host 0.0.0.0 --user postgres --db testdb   --password heslo --dbms postgresql --port 5432```


## Výstup

Štyri súbory, pričom sú všetky uložené do priečinku ```results/```. Do každého súboru sa nové informácie pripisujú. Nestane sa, že bude súbor prepísaný.

- ```results/dataster/dataster_config-{db}.yaml``` finálny YAML súbor
- ```results/original_yaml/dataster_config-{db}.yaml``` pôvodný YAML súbor pred opravami
- ```results/csv/results-{db}.yaml``` nájdene chyby počas kontroly YAML (database, section, error_type, severity, detail)
    - severity sa rozlišuje medzi 1 až 2, kde 1 je vážna chyba, ktorú Dataster nepríjme a severity 2 je chyba, ktorú Dataster nechá prejsť
- ```results/csv/repair_stats-{db}.yaml``` počty opráv vykonané počas opáv (timestamp, repair_type, count)


## Obmedzenia
- tabuľky so zloženým kľučom a čistým M:N vzťahom sú mimo rozsah a generovanie receptu je pre teito časti preskočené
- prázdne tabuľky sa preskakujú
- cyklické FK závislosti spôsobia zastavenie generovania
- teplota a výber modelov sú pevne dané v kóde


## Štruktúra archívu

```
.
├── README.md
├── Modelfiles
│   ├── Modelfile-constraints
│   ├── Modelfile-generate
│   ├── Modelfile-schema
│   └── Modelfile-types
├── data_sampler.py
├── db_connector.py
├── llm_processor.py
├── logger_setup.py
├── main.py
├── prompts.py
├── requirements.txt
├── schema_extractor.py
├── to_run.txt
└── yaml_generator.py
```