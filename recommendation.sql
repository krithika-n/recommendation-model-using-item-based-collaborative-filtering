CREATE TABLE Recommendations AS
    SELECT b.business_id, b.title
    FROM  business b, (SELECT top.not_rated,top.num / down.den AS P
                        FROM (SELECT not_rated, sum(prod) AS num
                                FROM( SELECT not_rated,(s.sim* useravgrating.average) AS prod                                                                                                                                                 FROM (SELECT   pair.not_rated, pair.rated, 1-((ABS(q1.average - q2.average))/5) AS sim
                                        FROM (SELECT b.business_id, b.title, avg(r.rating) AS average
                                                FROM business b, review r
                                                WHERE b.business_id = r.business_id
                                                GROUP BY(b.business_id)
                                            ) q1,
                                            (SELECT b.business_id, b.title, avg(r.rating) AS average
                                                FROM business b, review r
                                                WHERE b.business_id = r.business_id
                                                GROUP BY(b.business_id)
                                            ) q2,
                                            (SELECT i_biz.i_ids AS not_rated, L_biz.i_ids AS rated
                                                FROM ( SELECT r.business_id AS i_ids
                                                        FROM review r
                                                        WHERE r.user_id NOT LIKE 'ogAjjUdQWzE_zlAGZWMd0g'
                                                        GROUP BY (r.business_id)) i_biz,
                                                    ( SELECT r.business_id AS i_ids
                                                        FROM review r
                                                        WHERE r.user_id  LIKE 'ogAjjUdQWzE_zlAGZWMd0g'
                                                        GROUP BY (r.business_id)) L_biz
                                            ) pair
                                        WHERE pair.not_rated = q1.business_id AND pair.rated = q2.business_id
                                    ) s,                                                                                                                                                                                          (SELECT r.business_id, avg(r.rating) AS average                                                                                                                                                             FROM review r                                                                                                                                                                                               WHERE r.user_id LIKE 'ogAjjUdQWzE_zlAGZWMd0g'                                                                                                                                                               GROUP BY (r.business_id)) useravgrating                                                                                                                                                                     WHERE useravgrating.business_id = s.rated                                                                                                                                                                   Order by not_rated  ) p_table
                                    GROUP BY not_rated
                            ) top,
                            (SELECT s1.not_rated, SUM(s1.sim) AS den
                                            FROM (SELECT   pair.not_rated, pair.rated, 1-((ABS(q1.average - q2.average)) / 5) AS sim
                                                    FROM (SELECT b.business_id, b.title, avg(r.rating) AS average
                                                            FROM business b, review r
                                                            WHERE b.business_id = r.business_id
                                                            GROUP BY(b.business_id)
                                                        ) q1,
                                                        (SELECT b.business_id, b.title, avg(r.rating) AS average
                                                            FROM business b, review r
                                                            WHERE b.business_id = r.business_id
                                                            GROUP BY(b.business_id)
                                                        ) q2,
                                                        ( SELECT i_biz.i_ids AS not_rated, L_biz.i_ids AS rated
                                                            FROM (  SELECT r.business_id AS i_ids
                                                                    FROM review r
                                                                    WHERE r.user_id NOT LIKE 'ogAjjUdQWzE_zlAGZWMd0g'
                                                                    GROUP BY (r.business_id)
                                                                ) i_biz,
                                                                ( SELECT r.business_id AS i_ids
                                                                    FROM review r
                                                                    WHERE r.user_id  LIKE 'ogAjjUdQWzE_zlAGZWMd0g'
                                                                    GROUP BY (r.business_id)
                                                                    ) L_biz
                                                        ) pair
                                                WHERE pair.not_rated = q1.business_id AND pair.rated = q2.business_id
                                                ) s1
                            GROUP BY  s1.not_rated
                            )down
                        WHERE top.not_rated = down.not_rated
                        ) pob
    WHERE b.business_id = pob.not_rated AND pob.p > 4.33;
    
