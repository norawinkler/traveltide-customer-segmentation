-- 1. USERS
WITH
  active_users AS (
    SELECT
      user_id,
      COUNT(session_id) AS session_count
    FROM
      sessions
    WHERE
      session_start >= '2023-01-04'
    GROUP BY
      user_id
    HAVING
      COUNT(session_id) > 7
  )

SELECT
  *
FROM
  users
WHERE
  user_id IN (
    SELECT
      user_id
    FROM
      active_users
  )
ORDER BY
  user_id;



-- 2. SESSIONS
WITH
  active_users AS (
    SELECT
      user_id,
      COUNT(session_id) AS session_count
    FROM
      sessions
    WHERE
      session_start >= '2023-01-04'
    GROUP BY
      user_id
    HAVING
      COUNT(session_id) > 7
  )

SELECT
  *
FROM
  sessions
WHERE
  sessions.user_id IN (
    SELECT
      user_id
    FROM
      active_users
  )
  AND session_start >= DATE '2023-01-04'
ORDER BY
  session_start;



-- 3. FLIGHTS
WITH
  active_users AS (
    SELECT
      user_id,
      COUNT(session_id) AS session_count
    FROM
      sessions
    WHERE
      session_start >= '2023-01-04'
    GROUP BY
      user_id
    HAVING
      COUNT(session_id) > 7
  ),

  active_sessions AS (
    SELECT
      *
    FROM
      sessions
    WHERE
      sessions.user_id IN (
        SELECT
          user_id
        FROM
          active_users
      )
      AND session_start >= DATE '2023-01-04'
  )
  
SELECT
  *
FROM
  flights
WHERE
  flights.trip_id IN (
    SELECT DISTINCT
      trip_id
    FROM
      active_sessions
    WHERE
      trip_id IS NOT NULL
  )
ORDER BY
  trip_id;



-- 4. HOTELS
WITH
  active_users AS (
    SELECT
      user_id,
      COUNT(session_id) AS session_count
    FROM
      sessions
    WHERE
      session_start >= '2023-01-04'
    GROUP BY
      user_id
    HAVING
      COUNT(session_id) > 7
  ),

  active_sessions AS (
    SELECT
      *
    FROM
      sessions
    WHERE
      sessions.user_id IN (
        SELECT
          user_id
        FROM
          active_users
      )
      AND session_start >= DATE '2023-01-04'
  )
  
SELECT
  *
FROM
  hotels
WHERE
  hotels.trip_id IN (
    SELECT DISTINCT
      trip_id
    FROM
      active_sessions
    WHERE
      trip_id IS NOT NULL
  )
ORDER BY
  trip_id;