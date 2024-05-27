
import {
  Pagination,
  PaginationContent,
  PaginationItem,
  PaginationLink,
  PaginationNext,
  PaginationPrevious,
} from "@/components/ui/pagination";

interface PaginatorProps {
  page: number;
  totalPages: number;
  hasNext: boolean;
  hasPrev: boolean;
  increasePage: () => void;
  decreasePage: () => void;
  goToPage: (pageNumber: number) => void;
}
const Paginator = ({
  page,
  totalPages,
  hasNext,
  hasPrev,
  increasePage,
  decreasePage,
  goToPage,
}: PaginatorProps) => {
  const handlePrevPage = () => {
    if (hasPrev) decreasePage();
  };

  const handleNextPage = () => {
    if (hasNext) increasePage();
  };

  const handlePageClick = (pageNumber: number) => {
    goToPage(pageNumber);
  };

  // Determine the previous and next page based on the current position
  const previousPage = page - 1;
  const nextPage = page + 1;

  // Determine the pagination items to display
  const pagesToDisplay = [];

  if (page > 1) {
    // Add the previous page if not on the first page
    pagesToDisplay.push(previousPage);
  }

  // Always show the current page in the primary color
  pagesToDisplay.push(page);

  if (page < totalPages) {
    // Add the next page if not on the last page
    pagesToDisplay.push(nextPage);
  }

  return (
    <Pagination>
      <PaginationContent>
        <PaginationItem>
          <PaginationPrevious
            onClick={handlePrevPage}
            className={`hover:bg-primary ${
              !hasPrev && "disabled opacity-40"
            } hover:text-white`}
          />
        </PaginationItem>

        {/* Show the calculated pages to display */}
        {pagesToDisplay.map((pageNum) => (
          <PaginationItem key={pageNum}>
            <PaginationLink
              onClick={() => handlePageClick(pageNum)}
              className={
                pageNum === page
                  ? "bg-primary text-white"
                  : "hover:bg-primary hover:text-white"
              }
            >
              {pageNum}
            </PaginationLink>
          </PaginationItem>
        ))}

        <PaginationItem>
          <PaginationNext
            onClick={handleNextPage}
            className={`hover:bg-primary ${
              !hasNext && "disabled opacity-40"
            } hover:text-white`}
          />
        </PaginationItem>
      </PaginationContent>
    </Pagination>
  );
};
export default Paginator;