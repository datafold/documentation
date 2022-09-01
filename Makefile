PUBLISH_DIRS=assets getting-started/data-warehouses

public:
	for dir in $(PUBLISH_DIRS); do \
		echo "Publishing $$dir"; \
		mkdir -p public/$$dir; \
		cp $$dir/* public/$$dir; \
	done
