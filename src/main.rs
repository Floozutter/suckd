use rdev::{EventType, Key};
use std::collections::HashMap;

// neutral horizontal, absolute up
fn clean(raw: u8) -> u8 {
    let mut cleaned = raw;
    if cleaned & 0b0101u8 == 0b0101u8 { cleaned &= 0b1010u8; }
    if cleaned & 0b1000u8 == 0b1000u8 { cleaned &= 0b1101u8; }
    return cleaned;
}

fn send_key(key: Key, press: bool) {
    let event = if press { EventType::KeyPress(key) } else { EventType::KeyRelease(key) };
    match rdev::simulate(&event) {
        Ok(()) => (),
        Err(rdev::SimulateError) => {
            eprintln!("failed to simulate: {:?}", event);
        }
    }
}

fn suckd(
    input_key_directions: HashMap<Key, u8>,
    up: Key, left: Key, down: Key, right: Key,
) -> Result<(), rdev::ListenError> {
    let mut pressed = HashMap::<Key, u8>::new();
    let mut prev_cleaned = 0u8;
    rdev::listen(move |event| {
        match event.event_type {
            EventType::KeyPress(key) => {
                if let Some(d) = input_key_directions.get(&key) {
                    pressed.insert(key, *d);
                }
            }
            EventType::KeyRelease(key) => {
                pressed.remove(&key);
            }
            _ => return,
        }
        let raw = pressed.values().fold(0u8, |a, b| a | b);
        let cleaned = clean(raw);
        let xor = cleaned ^ prev_cleaned;
        if xor & 0b1000u8 != 0u8 {
            send_key(up, cleaned & 0b1000u8 != 0u8);
        }
        if xor & 0b0100u8 != 0u8 {
            send_key(left, cleaned & 0b0100u8 != 0u8);
        }
        if xor & 0b0010u8 != 0u8 {
            send_key(down, cleaned & 0b0010u8 != 0u8);
        }
        if xor & 0b0001u8 != 0u8 {
            send_key(right, cleaned & 0b0001u8 != 0u8);
        }
        prev_cleaned = cleaned;
    })
}

fn main() {
    let input_key_directions = HashMap::from([
        (Key::KeyW,  0b1000u8),
        (Key::KeyA,  0b0100u8),
        (Key::KeyS,  0b0010u8),
        (Key::KeyD,  0b0001u8),
        (Key::KeyN,  0b0100u8),
        (Key::KeyM,  0b0001u8),
        (Key::Comma, 0b1000u8),
        (Key::Dot,   0b0010u8),
        (Key::KeyZ,  0b0110u8),
        (Key::KeyC,  0b0011u8),
    ]);
    if let Err(error) = suckd(input_key_directions, Key::Num1, Key::Num2, Key::Num3, Key::Num4) {
        eprintln!("error: {:?}", error);
        std::process::exit(1);
    }
}
