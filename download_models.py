#!/usr/bin/env python
"""Download all required models for LayoutDIT training"""

import os
from transformers import BertModel, BertTokenizer, BertConfig, AutoModel, AutoTokenizer, AutoConfig

def download_model(name, model_class, tokenizer_class=None):
    """Download a model and its tokenizer"""
    print(f"\n{'='*60}")
    print(f"Downloading {name}...")
    print(f"{'='*60}")
    
    try:
        # Download config
        print(f"  - Downloading config...")
        config = model_class.from_pretrained(name)
        print(f"    ✅ Config downloaded")
        
        # Download tokenizer if provided
        if tokenizer_class:
            print(f"  - Downloading tokenizer...")
            tokenizer = tokenizer_class.from_pretrained(name)
            print(f"    ✅ Tokenizer downloaded")
        
        # Download model weights
        print(f"  - Downloading model weights...")
        model = model_class.from_pretrained(name)
        print(f"    ✅ Model weights downloaded")
        
        print(f"✅ {name} fully downloaded!")
        return True
    except Exception as e:
        print(f"❌ Error downloading {name}: {e}")
        return False

def main():
    print("Starting model downloads...")
    print(f"Cache directory: {os.path.expanduser('~/.cache/huggingface')}")
    
    models_to_download = [
        ("bert-base-uncased", BertModel, BertTokenizer),
        ("bert-base-chinese", BertModel, BertTokenizer),
        ("microsoft/layoutlm-base-uncased", AutoModel, AutoTokenizer),
    ]
    
    results = []
    for name, model_class, tokenizer_class in models_to_download:
        success = download_model(name, model_class, tokenizer_class)
        results.append((name, success))
    
    print(f"\n{'='*60}")
    print("Download Summary:")
    print(f"{'='*60}")
    for name, success in results:
        status = "✅ SUCCESS" if success else "❌ FAILED"
        print(f"  {name}: {status}")
    
    all_success = all(success for _, success in results)
    if all_success:
        print("\n✅ All models downloaded successfully!")
    else:
        print("\n⚠️  Some models failed to download")
    
    return 0 if all_success else 1

if __name__ == "__main__":
    import sys
    sys.exit(main())

