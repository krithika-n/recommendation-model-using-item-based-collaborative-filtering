CREATE TABLE Recommendations AS
    Select b.business_id, b.title
    From  business b, (Select top.not_rated,top.num / down.den as P
                        From (Select not_rated, sum(prod) as num
                                From( Select not_rated,(s.sim* useravgrating.average) as prod                                                                                                                                                 From (Select   pair.not_rated, pair.rated, 1-((ABS(q1.average - q2.average))/5) as sim
                                        From (SELECT b.business_id, b.title, avg(r.rating) AS average
                                                FROM business b, review r
                                                WHERE b.business_id = r.business_id
                                                GROUP BY(b.business_id)
                                            ) q1,
                                            (SELECT b.business_id, b.title, avg(r.rating) AS average
                                                FROM business b, review r
                                                WHERE b.business_id = r.business_id
                                                GROUP BY(b.business_id)
                                            ) q2,
                                            (SELECT i_biz.i_ids as not_rated, L_biz.i_ids as rated
                                                FROM ( SELECT r.business_id as i_ids
                                                        FROM review r
                                                        WHERE r.user_id NOT LIKE 'ogAjjUdQWzE_zlAGZWMd0g'
                                                        GROUP BY (r.business_id)) i_biz,
                                                    ( SELECT r.business_id as i_ids
                                                        FROM review r
                                                        WHERE r.user_id  LIKE 'ogAjjUdQWzE_zlAGZWMd0g'
                                                        GROUP BY (r.business_id)) L_biz
                                            ) pair
                                        Where pair.not_rated = q1.business_id AND pair.rated=q2.business_id
                                    ) s,                                                                                                                                                                                          (SELECT r.business_id, avg(r.rating) as average                                                                                                                                                             FROM review r                                                                                                                                                                                               WHERE r.user_id LIKE 'ogAjjUdQWzE_zlAGZWMd0g'                                                                                                                                                               GROUP BY (r.business_id)) useravgrating                                                                                                                                                                     Where useravgrating.business_id = s.rated                                                                                                                                                                   Order by not_rated  ) p_table
                                    Group by not_rated
                            ) top,
                            (Select s1.not_rated, SUM(s1.sim) as den
                                            From (Select   pair.not_rated, pair.rated, 1-((ABS(q1.average - q2.average))/5) as sim
                                                    From (SELECT b.business_id, b.title, avg(r.rating) AS average
                                                            FROM business b, review r
                                                            WHERE b.business_id = r.business_id
                                                            GROUP BY(b.business_id)
                                                        ) q1,
                                                        (SELECT b.business_id, b.title, avg(r.rating) AS average
                                                            FROM business b, review r
                                                            WHERE b.business_id = r.business_id
                                                            GROUP BY(b.business_id)
                                                        ) q2,
                                                        ( SELECT i_biz.i_ids as not_rated, L_biz.i_ids as rated
                                                            FROM (  SELECT r.business_id as i_ids
                                                                    FROM review r
                                                                    WHERE r.user_id NOT LIKE 'ogAjjUdQWzE_zlAGZWMd0g'
                                                                    GROUP BY (r.business_id)
                                                                ) i_biz,
                                                                ( SELECT r.business_id as i_ids
                                                                    FROM review r
                                                                    WHERE r.user_id  LIKE 'ogAjjUdQWzE_zlAGZWMd0g'
                                                                    GROUP BY (r.business_id)
                                                                    ) L_biz
                                                        ) pair
                                                Where pair.not_rated = q1.business_id AND pair.rated=q2.business_id
                                                ) s1
                            Group By  s1.not_rated
                            )down
                        Where top.not_rated = down.not_rated
                        ) pob
    Where b.business_id=pob.not_rated AND pob.p>4.33;