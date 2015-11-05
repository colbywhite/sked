--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: leagues; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE leagues (
    id integer NOT NULL,
    name character varying NOT NULL,
    abbr character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: leagues_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE leagues_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: leagues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE leagues_id_seq OWNED BY leagues.id;


--
-- Name: nba2016_games; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE nba2016_games (
    id integer NOT NULL,
    "time" timestamp without time zone NOT NULL,
    away_id integer NOT NULL,
    home_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    home_score integer,
    away_score integer
);


--
-- Name: nba2016_away_records; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW nba2016_away_records AS
 SELECT nba2016_games.away_id,
    count(
        CASE
            WHEN (nba2016_games.home_score < nba2016_games.away_score) THEN 1
            ELSE NULL::integer
        END) AS wins,
    count(
        CASE
            WHEN (nba2016_games.home_score > nba2016_games.away_score) THEN 1
            ELSE NULL::integer
        END) AS losses,
    count(
        CASE
            WHEN (nba2016_games.home_score = nba2016_games.away_score) THEN 1
            ELSE NULL::integer
        END) AS ties,
    round((((count(
        CASE
            WHEN (nba2016_games.home_score < nba2016_games.away_score) THEN 1
            ELSE NULL::integer
        END))::numeric + ((count(
        CASE
            WHEN (nba2016_games.home_score = nba2016_games.away_score) THEN 1
            ELSE NULL::integer
        END))::numeric * 0.5)) / (count(*))::numeric), 3) AS percentage
   FROM nba2016_games
  WHERE ((nba2016_games.home_score IS NOT NULL) AND (nba2016_games.away_score IS NOT NULL))
  GROUP BY nba2016_games.away_id
  ORDER BY round((((count(
        CASE
            WHEN (nba2016_games.home_score < nba2016_games.away_score) THEN 1
            ELSE NULL::integer
        END))::numeric + ((count(
        CASE
            WHEN (nba2016_games.home_score = nba2016_games.away_score) THEN 1
            ELSE NULL::integer
        END))::numeric * 0.5)) / (count(*))::numeric), 3) DESC, count(
        CASE
            WHEN (nba2016_games.home_score < nba2016_games.away_score) THEN 1
            ELSE NULL::integer
        END) DESC;


--
-- Name: nba2016_games_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE nba2016_games_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: nba2016_games_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE nba2016_games_id_seq OWNED BY nba2016_games.id;


--
-- Name: nba2016_home_records; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW nba2016_home_records AS
 SELECT nba2016_games.home_id,
    count(
        CASE
            WHEN (nba2016_games.home_score > nba2016_games.away_score) THEN 1
            ELSE NULL::integer
        END) AS wins,
    count(
        CASE
            WHEN (nba2016_games.home_score < nba2016_games.away_score) THEN 1
            ELSE NULL::integer
        END) AS losses,
    count(
        CASE
            WHEN (nba2016_games.home_score = nba2016_games.away_score) THEN 1
            ELSE NULL::integer
        END) AS ties,
    round((((count(
        CASE
            WHEN (nba2016_games.home_score > nba2016_games.away_score) THEN 1
            ELSE NULL::integer
        END))::numeric + ((count(
        CASE
            WHEN (nba2016_games.home_score = nba2016_games.away_score) THEN 1
            ELSE NULL::integer
        END))::numeric * 0.5)) / (count(*))::numeric), 3) AS percentage
   FROM nba2016_games
  WHERE ((nba2016_games.home_score IS NOT NULL) AND (nba2016_games.away_score IS NOT NULL))
  GROUP BY nba2016_games.home_id
  ORDER BY round((((count(
        CASE
            WHEN (nba2016_games.home_score > nba2016_games.away_score) THEN 1
            ELSE NULL::integer
        END))::numeric + ((count(
        CASE
            WHEN (nba2016_games.home_score = nba2016_games.away_score) THEN 1
            ELSE NULL::integer
        END))::numeric * 0.5)) / (count(*))::numeric), 3) DESC, count(
        CASE
            WHEN (nba2016_games.home_score > nba2016_games.away_score) THEN 1
            ELSE NULL::integer
        END) DESC;


--
-- Name: nba2016_records; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW nba2016_records AS
 SELECT COALESCE(home.home_id, away.away_id) AS team_id,
    (COALESCE(home.wins, (0)::bigint) + COALESCE(away.wins, (0)::bigint)) AS wins,
    (COALESCE(home.losses, (0)::bigint) + COALESCE(away.losses, (0)::bigint)) AS losses,
    (COALESCE(home.ties, (0)::bigint) + COALESCE(away.ties, (0)::bigint)) AS ties,
    round(((((COALESCE(home.wins, (0)::bigint) + COALESCE(away.wins, (0)::bigint)))::numeric + (((COALESCE(home.ties, (0)::bigint) + COALESCE(away.ties, (0)::bigint)))::numeric * 0.5)) / ((((((COALESCE(home.wins, (0)::bigint) + COALESCE(away.wins, (0)::bigint)) + COALESCE(home.losses, (0)::bigint)) + COALESCE(away.losses, (0)::bigint)) + COALESCE(home.ties, (0)::bigint)) + COALESCE(away.ties, (0)::bigint)))::numeric), 3) AS percentage
   FROM (nba2016_home_records home
     FULL JOIN nba2016_away_records away ON ((home.home_id = away.away_id)))
  ORDER BY round(((((COALESCE(home.wins, (0)::bigint) + COALESCE(away.wins, (0)::bigint)))::numeric + (((COALESCE(home.ties, (0)::bigint) + COALESCE(away.ties, (0)::bigint)))::numeric * 0.5)) / ((((((COALESCE(home.wins, (0)::bigint) + COALESCE(away.wins, (0)::bigint)) + COALESCE(home.losses, (0)::bigint)) + COALESCE(away.losses, (0)::bigint)) + COALESCE(home.ties, (0)::bigint)) + COALESCE(away.ties, (0)::bigint)))::numeric), 3) DESC, (COALESCE(home.wins, (0)::bigint) + COALESCE(away.wins, (0)::bigint)) DESC;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: seasons; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE seasons (
    id integer NOT NULL,
    name character varying NOT NULL,
    short_name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    league_id integer NOT NULL
);


--
-- Name: seasons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE seasons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: seasons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE seasons_id_seq OWNED BY seasons.id;


--
-- Name: seasons_teams; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE seasons_teams (
    team_id integer,
    season_id integer
);


--
-- Name: teams; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE teams (
    id integer NOT NULL,
    name character varying NOT NULL,
    abbr character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE teams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE teams_id_seq OWNED BY teams.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY leagues ALTER COLUMN id SET DEFAULT nextval('leagues_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY nba2016_games ALTER COLUMN id SET DEFAULT nextval('nba2016_games_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY seasons ALTER COLUMN id SET DEFAULT nextval('seasons_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY teams ALTER COLUMN id SET DEFAULT nextval('teams_id_seq'::regclass);


--
-- Name: leagues_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY leagues
    ADD CONSTRAINT leagues_pkey PRIMARY KEY (id);


--
-- Name: nba2016_games_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY nba2016_games
    ADD CONSTRAINT nba2016_games_pkey PRIMARY KEY (id);


--
-- Name: seasons_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY seasons
    ADD CONSTRAINT seasons_pkey PRIMARY KEY (id);


--
-- Name: teams_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: index_leagues_on_abbr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_leagues_on_abbr ON leagues USING btree (abbr);


--
-- Name: index_nba2016_games_on_away_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_nba2016_games_on_away_id ON nba2016_games USING btree (away_id);


--
-- Name: index_nba2016_games_on_away_score; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_nba2016_games_on_away_score ON nba2016_games USING btree (away_score);


--
-- Name: index_nba2016_games_on_home_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_nba2016_games_on_home_id ON nba2016_games USING btree (home_id);


--
-- Name: index_nba2016_games_on_home_score; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_nba2016_games_on_home_score ON nba2016_games USING btree (home_score);


--
-- Name: index_seasons_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_seasons_on_name ON seasons USING btree (name);


--
-- Name: index_seasons_on_short_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_seasons_on_short_name ON seasons USING btree (short_name);


--
-- Name: index_seasons_teams_on_season_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_seasons_teams_on_season_id ON seasons_teams USING btree (season_id);


--
-- Name: index_seasons_teams_on_team_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_seasons_teams_on_team_id ON seasons_teams USING btree (team_id);


--
-- Name: index_teams_on_abbr; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_teams_on_abbr ON teams USING btree (abbr);


--
-- Name: index_teams_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_teams_on_name ON teams USING btree (name);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_392438f149; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY seasons_teams
    ADD CONSTRAINT fk_rails_392438f149 FOREIGN KEY (team_id) REFERENCES teams(id);


--
-- Name: fk_rails_7930902be5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY nba2016_games
    ADD CONSTRAINT fk_rails_7930902be5 FOREIGN KEY (away_id) REFERENCES teams(id);


--
-- Name: fk_rails_9ae86e9659; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY seasons
    ADD CONSTRAINT fk_rails_9ae86e9659 FOREIGN KEY (league_id) REFERENCES leagues(id);


--
-- Name: fk_rails_9b08d2abe8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY nba2016_games
    ADD CONSTRAINT fk_rails_9b08d2abe8 FOREIGN KEY (home_id) REFERENCES teams(id);


--
-- Name: fk_rails_ff6914eb1c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY seasons_teams
    ADD CONSTRAINT fk_rails_ff6914eb1c FOREIGN KEY (season_id) REFERENCES seasons(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20151025210802');

INSERT INTO schema_migrations (version) VALUES ('20151025222221');

INSERT INTO schema_migrations (version) VALUES ('20151025231506');

INSERT INTO schema_migrations (version) VALUES ('20151026031042');
