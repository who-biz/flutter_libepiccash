use std::sync::Arc;
use std::sync::Arc as StdArc;
use std::sync::atomic::AtomicBool;

use epic_util::Mutex;
use epic_util::secp::SecretKey;
use epic_wallet_config::{EpicboxConfig, TorConfig};
use epic_wallet_impls::EpicboxListenChannel;
use ffi_helpers::task::CancellationToken;
use ffi_helpers::{Task, export_task};

use crate::wallet::Wallet;

#[derive(Debug, Clone)]
pub struct Listener {
    pub wallet_ptr_str: String,
    pub epicbox_config: String,
}

impl Task for Listener {
    type Output = usize;

    fn run(
        &self,
        cancel_tok: &CancellationToken,
    ) -> Result<Self::Output, anyhow::Error> {
        let (wlt, sek_key): (i64, Option<SecretKey>) =
            serde_json::from_str(&self.wallet_ptr_str)
                .map_err(|e| anyhow::anyhow!("Invalid wallet handle: {e}"))?;

        let epicbox_conf =
            serde_json::from_str::<EpicboxConfig>(&self.epicbox_config)
                .map_err(|e| anyhow::anyhow!("Invalid Epicbox config: {e}"))?;

        unsafe {
            crate::ensure_wallet!(wlt, wallet);

            if cancel_tok.cancelled() {
                return Ok(0);
            }

            let listener = EpicboxListenChannel::new()
                .map_err(|e| anyhow::anyhow!(
                    "Could not create Epicbox listener: {e}"
                ))?;

            let mut reconnections = 0;

            listener
                .listen(
                    wallet.clone(),
                    Arc::new(Mutex::new(sek_key)),
                    epicbox_conf,
                    &mut reconnections,

                    // This means "node is ready to process messages."
                    // It is not the listener cancellation flag.
                    StdArc::new(AtomicBool::new(true)),

                    TorConfig::default(),
                )
                .map_err(|e| anyhow::anyhow!(
                    "Epicbox listener error: {e}"
                ))?;
        }

        Ok(0)
    }
}

export_task! {
    Task: Listener;
    spawn: listener_spawn;
    wait: listener_wait;
    poll: listener_poll;
    cancel: listener_cancel;
    cancelled: listener_cancelled;
    handle_destroy: listener_handle_destroy;
    result_destroy: listener_result_destroy;
}
