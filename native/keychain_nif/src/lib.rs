use keyring::{Entry, Error as KeyError};
use rustler::{Encoder, Env, Term};

mod atoms {
    rustler::atoms! {
        ok,
        error,
        not_found,
    }
}

fn entry<'a>(env: Env<'a>, service: &str, user: &str) -> Result<Entry, Term<'a>> {
    Entry::new(service, user).map_err(|e| (atoms::error(), e.to_string()).encode(env))
}

/// {:ok, password} | {:error, :not_found} | {:error, message}
#[rustler::nif(schedule = "DirtyIo")]
fn get_password<'a>(env: Env<'a>, service: String, user: String) -> Term<'a> {
    let entry = match entry(env, &service, &user) {
        Ok(e) => e,
        Err(t) => return t,
    };
    match entry.get_password() {
        Ok(pw) => (atoms::ok(), pw).encode(env),
        Err(KeyError::NoEntry) => (atoms::error(), atoms::not_found()).encode(env),
        Err(e) => (atoms::error(), e.to_string()).encode(env),
    }
}

/// :ok | {:error, message}
#[rustler::nif(schedule = "DirtyIo")]
fn set_password<'a>(env: Env<'a>, service: String, user: String, password: String) -> Term<'a> {
    let entry = match entry(env, &service, &user) {
        Ok(e) => e,
        Err(t) => return t,
    };
    match entry.set_password(&password) {
        Ok(()) => atoms::ok().encode(env),
        Err(e) => (atoms::error(), e.to_string()).encode(env),
    }
}

/// :ok | {:error, :not_found} | {:error, message}
#[rustler::nif(schedule = "DirtyIo")]
fn delete_password<'a>(env: Env<'a>, service: String, user: String) -> Term<'a> {
    let entry = match entry(env, &service, &user) {
        Ok(e) => e,
        Err(t) => return t,
    };
    match entry.delete_credential() {
        Ok(()) => atoms::ok().encode(env),
        Err(KeyError::NoEntry) => (atoms::error(), atoms::not_found()).encode(env),
        Err(e) => (atoms::error(), e.to_string()).encode(env),
    }
}

rustler::init!("Elixir.Keychain.Nif");
