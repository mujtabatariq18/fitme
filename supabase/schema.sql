-- =============================================================================
-- FitMe — Supabase Postgres Schema
-- =============================================================================
-- Run this script once against a fresh Supabase project:
--   supabase db push
--   or paste into the Supabase SQL editor.
--
-- All tables use Row Level Security (RLS).  Users can only read/write their
-- own rows.  The ai_config table is restricted to the service role only.
-- =============================================================================

-- ---------------------------------------------------------------------------
-- Extensions
-- ---------------------------------------------------------------------------
create extension if not exists "uuid-ossp";

-- ---------------------------------------------------------------------------
-- profiles
-- ---------------------------------------------------------------------------
-- One row per authenticated user, created during onboarding.
create table if not exists public.profiles (
    id                  uuid        primary key references auth.users (id) on delete cascade,
    name                text,
    gender              text,                          -- 'male' | 'female' | 'other'
    birth_year          smallint,
    height_cm           numeric(5,2),
    current_weight_kg   numeric(5,2),
    target_weight_kg    numeric(5,2),
    goal                text,                          -- 'lose' | 'maintain' | 'gain'
    activity_level      text,                          -- 'sedentary' | 'light' | 'moderate' | 'active' | 'very_active'
    diet_type           text,                          -- 'standard' | 'vegetarian' | 'vegan' | 'keto' | etc.
    problem_areas       text[],                        -- e.g. ['belly','arms']
    onboarding_complete boolean     not null default false,
    created_at          timestamptz not null default now(),
    updated_at          timestamptz not null default now()
);

alter table public.profiles enable row level security;

-- Users can view and manage only their own profile.
create policy "profiles: select own"
    on public.profiles for select
    using (id = auth.uid());

create policy "profiles: insert own"
    on public.profiles for insert
    with check (id = auth.uid());

create policy "profiles: update own"
    on public.profiles for update
    using (id = auth.uid())
    with check (id = auth.uid());

create policy "profiles: delete own"
    on public.profiles for delete
    using (id = auth.uid());

-- Automatically update updated_at on every row change.
create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
    new.updated_at = now();
    return new;
end;
$$;

create trigger profiles_set_updated_at
    before update on public.profiles
    for each row execute procedure public.set_updated_at();

-- ---------------------------------------------------------------------------
-- weight_logs
-- ---------------------------------------------------------------------------
-- Daily/weekly weight check-ins.
create table if not exists public.weight_logs (
    id          uuid        primary key default uuid_generate_v4(),
    user_id     uuid        not null references auth.users (id) on delete cascade,
    kg          numeric(5,2) not null,
    logged_at   timestamptz not null default now()
);

create index if not exists weight_logs_user_id_idx on public.weight_logs (user_id);
create index if not exists weight_logs_logged_at_idx on public.weight_logs (logged_at desc);

alter table public.weight_logs enable row level security;

create policy "weight_logs: select own"
    on public.weight_logs for select
    using (user_id = auth.uid());

create policy "weight_logs: insert own"
    on public.weight_logs for insert
    with check (user_id = auth.uid());

create policy "weight_logs: update own"
    on public.weight_logs for update
    using (user_id = auth.uid())
    with check (user_id = auth.uid());

create policy "weight_logs: delete own"
    on public.weight_logs for delete
    using (user_id = auth.uid());

-- ---------------------------------------------------------------------------
-- food_logs
-- ---------------------------------------------------------------------------
-- Individual food entries linked to a meal slot (breakfast / lunch / dinner / snack).
create table if not exists public.food_logs (
    id          uuid        primary key default uuid_generate_v4(),
    user_id     uuid        not null references auth.users (id) on delete cascade,
    name        text        not null,
    kcal        numeric(7,2),
    protein     numeric(6,2),  -- grams
    carbs       numeric(6,2),  -- grams
    fat         numeric(6,2),  -- grams
    meal        text,          -- 'breakfast' | 'lunch' | 'dinner' | 'snack'
    logged_at   timestamptz not null default now()
);

create index if not exists food_logs_user_id_idx on public.food_logs (user_id);
create index if not exists food_logs_logged_at_idx on public.food_logs (logged_at desc);

alter table public.food_logs enable row level security;

create policy "food_logs: select own"
    on public.food_logs for select
    using (user_id = auth.uid());

create policy "food_logs: insert own"
    on public.food_logs for insert
    with check (user_id = auth.uid());

create policy "food_logs: update own"
    on public.food_logs for update
    using (user_id = auth.uid())
    with check (user_id = auth.uid());

create policy "food_logs: delete own"
    on public.food_logs for delete
    using (user_id = auth.uid());

-- ---------------------------------------------------------------------------
-- ai_config
-- ---------------------------------------------------------------------------
-- Key/value store for server-side AI configuration (model names, feature flags,
-- system prompts, etc.).  Never exposed to end users — service role only.
create table if not exists public.ai_config (
    id      uuid    primary key default uuid_generate_v4(),
    key     text    not null unique,
    value   jsonb   not null
);

alter table public.ai_config enable row level security;

-- No policies for regular users; only the service role (bypasses RLS) may access this table.
-- To grant read access to your edge functions, use the service role key in Deno.env.
