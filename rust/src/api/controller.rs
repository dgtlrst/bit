use std::collections::HashMap;
use std::sync::Mutex;
use std::{thread, time::Duration};

use crate::frb_generated::StreamSink;
use anyhow::{anyhow, bail, Ok, Result};
use flutter_rust_bridge::frb;
use rand::prelude::*;
use serialport::Error;
use std::sync::mpsc::{self, Receiver, Sender};
use std::thread::JoinHandle;
struct ThreadController {
    thread_id: u32,
    stream: StreamSink<String>,
    receiver: Receiver<String>,
}
impl ThreadController {
    fn new(thread_id: u32, stream: StreamSink<String>, receiver: Receiver<String>) -> Self {
        ThreadController {
            thread_id,
            stream,
            receiver,
        }
    }

    fn main(&self) {
        loop {
            let received_data = self.receiver.try_recv();
            match received_data {
                std::result::Result::Ok(data) => {
                    self.stream
                        .add(format!("Thread: {:?}, Echoing {:?}", self.thread_id, data));
                }
                Err(e) => match e {
                    std::sync::mpsc::TryRecvError::Empty => {}
                    std::sync::mpsc::TryRecvError::Disconnected => {
                        println!("Terminating Thread {:?}", self.thread_id);
                        break;
                    }
                },
            }
            self.stream
                .add(format!("Thread: {:?}: Tick", self.thread_id));
            std::thread::sleep(Duration::from_millis(1000))
        }
    }
}

#[flutter_rust_bridge::frb(opaque)]
pub struct Controller {
    temp_thread_id: u32,
    thread_handles: HashMap<u32, JoinHandle<()>>,
    thread_transmitters: HashMap<u32, Sender<String>>,
}

impl Controller {
    #[flutter_rust_bridge::frb(sync)]
    pub fn new() -> Self {
        let controller = Controller {
            temp_thread_id: 0,
            thread_handles: HashMap::new(),
            thread_transmitters: HashMap::new(),
        };
        return controller;
    }
    #[flutter_rust_bridge::frb(sync)]
    pub fn set_new_thread_id(&mut self, thread_id: u32) {
        self.temp_thread_id = thread_id;
    }
    #[flutter_rust_bridge::frb(sync)]
    pub fn push(&self, thread_id: u32, data: String) -> Result<()> {
        let tx = &self.thread_transmitters[&thread_id];
        match tx.send(data) {
            std::result::Result::Ok(_) => return Ok(()),
            Err(_) => return Err(anyhow!("Receiver disconnected!")),
        }
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn end_stream(mut self, thread_id: u32) {
        let channel = &self.thread_transmitters[&thread_id];
        drop(channel); // Drop channel, Should end the thread.
        let remove_channel_from_map = &self.thread_transmitters.remove(&thread_id);
        let thread_handle = self.thread_handles.remove(&thread_id);
        match thread_handle {
            Some(handle) => {
                handle.join();
            }
            None => {
                println!("Controller: end_stream -> Handle does not exist. This is a logical Error. Ignoring for stability.")
            }
        }
        let remove_thread_handle_from_map = &self.thread_handles.remove(&thread_id);
        // Remove transmitter
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn create_stream(&mut self, stream_sink: StreamSink<String>) {
        // Create stream should always be used in tandem with get_latest_thread_created
        let thread_closure =
            move |thread_id: u32, stream_sink: StreamSink<String>, rx: Receiver<String>| {
                let thread_controller = ThreadController::new(thread_id, stream_sink, rx);
                thread_controller.main();
            };

        let (tx, rx) = mpsc::channel();
        let thread_id = self.temp_thread_id;

        let handle = thread::spawn(move || thread_closure(thread_id, stream_sink, rx));
        self.thread_transmitters.insert(thread_id, tx);
        self.thread_handles.insert(thread_id, handle);
    }
}
