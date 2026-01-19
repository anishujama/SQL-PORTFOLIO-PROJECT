
--total males and females


SELECT d.state,
       SUM(d.males)   AS total_males,
       SUM(d.females) AS total_females
FROM (
    SELECT c.district,
           c.state,
           ROUND((c.population / (c.sex_ratio + 1))::numeric, 0) AS males,
           ROUND(((c.population * c.sex_ratio) / (c.sex_ratio + 1))::numeric, 0) AS females
    FROM (
        SELECT a.district,
               a.state,
               a.sex_ratio / 1000.0 AS sex_ratio,
               b.population
        FROM dataset1 a
        INNER JOIN dataset2 b
        ON a.district = b.district
    ) c
) d
GROUP BY d.state;


-- total literacy rate


SELECT c.state,
       SUM(c.literate_people)   AS total_literate_pop,
       SUM(c.illiterate_people) AS total_illiterate_pop
FROM (
    SELECT d.district,
           d.state,
           ROUND((d.literacy_ratio * d.population)::numeric, 0) AS literate_people,
           ROUND(((1 - d.literacy_ratio) * d.population)::numeric, 0) AS illiterate_people
    FROM (
        SELECT a.district,
               a.state,
               a."literacy" / 100.0 AS literacy_ratio,
               b.population
        FROM dataset1 a
        INNER JOIN dataset2 b
        ON a.district = b.district
    ) d
) c
GROUP BY c.state;


-- population in previous census


SELECT SUM(m.previous_census_population) AS previous_census_population,
       SUM(m.current_census_population)  AS current_census_population
FROM (
    SELECT e.state,
           SUM(e.previous_census_population) AS previous_census_population,
           SUM(e.current_census_population)  AS current_census_population
    FROM (
        SELECT d.district,
               d.state,
               ROUND((d.population / (1 + d.growth))::numeric, 0) AS previous_census_population,
               d.population AS current_census_population
        FROM (
            SELECT a.district,
                   a.state,
                   a.growth,
                   b.population
            FROM dataset1 a
            INNER JOIN dataset2 b
            ON a.district = b.district
        ) d
    ) e
    GROUP BY e.state
) m;



-- population vs area




SELECT 
    (g.total_area / g.previous_census_population) AS previous_census_population_vs_area,
    (g.total_area / g.current_census_population)  AS current_census_population_vs_area
FROM (
    SELECT q.*, r.total_area
    FROM (
        SELECT '1' AS keyy, n.*
        FROM (
            SELECT 
                SUM(m.previous_census_population) AS previous_census_population,
                SUM(m.current_census_population)  AS current_census_population
            FROM (
                SELECT e.state,
                       SUM(e.previous_census_population) AS previous_census_population,
                       SUM(e.current_census_population)  AS current_census_population
                FROM (
                    SELECT d.district,
                           d.state,
                           ROUND((d.population / (1 + d.growth))::numeric, 0) AS previous_census_population,
                           d.population AS current_census_population
                    FROM (
                        SELECT a.district,
                               a.state,
                               a.growth,
                               b.population
                        FROM dataset1 a
                        INNER JOIN dataset2 b
                        ON a.district = b.district
                    ) d
                ) e
                GROUP BY e.state
            ) m
        ) n
    ) q
    INNER JOIN (
        SELECT '1' AS keyy, z.*
        FROM (
            SELECT SUM(REPLACE(area_km2, ',', '')::numeric) AS total_area
            FROM dataset2
        ) z
    ) r
    ON q.keyy = r.keyy
) g;


output top 3 districts from each state with highest literacy rate


select a.* from
(select district,state,literacy,rank() over(partition by state order by literacy desc) rnk from dataset1) a

where a.rnk in (1,2,3) order by state




